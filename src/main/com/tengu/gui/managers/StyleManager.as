package com.tengu.gui.managers
{
	import com.tengu.gui.api.IStyleManager;
	import com.tengu.gui.resources.text.StyleProtocol;
	
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class StyleManager implements IStyleManager
	{
        public static const INHERITS_TAG:String = "inherits";
		
		private var styles:Object 				= null;
		private var textStyler:TextStyleManager = null;

		private var subRegisterMethods:Object = null;
		
		private var defaultText:String = "DefaultText"; 
		
		public function get defaultTextStyle():String 
		{
			return defaultText;
		}
		
		public function set defaultTextStyle(value:String):void 
		{
			defaultText = value;
		}
		
		public function set scaleFactor(value:Number):void 
		{
			textStyler.scaleFactor = value;
		}
		
		public function StyleManager()
		{
			textStyler = new TextStyleManager();
			styles 	= {};
			
			subRegisterMethods = {};
			subRegisterMethods[StyleProtocol.SELECTOR_TYPE_TEXT_FORMAT] = textStyler.registerFormat;
			subRegisterMethods[StyleProtocol.SELECTOR_TYPE_CSS_FORMAT] = textStyler.registerCSSStyle;
			subRegisterMethods[StyleProtocol.SELECTOR_TYPE_FILTER] = textStyler.registerFilter;
		}
		
		public function registerStyle(name:String, value:Object):void
		{
			styles[name] = value;
		}

		public function getStyle(name:String):Object
		{
			return styles[name];
		}
		
		public function getTextFormat (styleName:String):TextFormat
		{
			return textStyler.getTextFormat(styleName);
		}
		
		public function applyTextStyle (field:TextField, styleName:String):void
		{
			textStyler.applyStyle(field, styleName);
		}
		
		public function configure (...listOfCSS):void
		{
			for each (var css:String in listOfCSS)
			{
				parseCSS(css);
			}
            fillInheritedStyles();
		}
		
		private function parseCSS(css:String):void
		{
			var blocks:Array;
			var parts:Array;
			var pairs:Array;
			var prefix:String;
			var suffix:String;
			var selector:Object;
			var subRegisterMethod:Function;
			var selectorType:String;
			
			css = css.replace(/\s*([@{}:;,]|\)\s|\s\()\s*|\/\*([^*\\\\]|\*(?!\/))+\*\/|[\'\"\n\r\t]|(px)/g, '$1');
			blocks = css.match(/[^{]*\{([^}]*)*}/g);
			
			for each (var block:String in blocks)
			{
				if (!block)
				{
					continue;
				}
				parts = block.split('{');
				checkFormat(parts);
				prefix = parts.shift();
				suffix = parts.pop().split('}')[0];
				
				selector = {};
				
				pairs = suffix.split(";");
				for each (var pair:String in pairs)
				{
					if (!pair)
					{
						continue;
					}
					parts = pair.split(':');
					checkFormat(parts);
					selector[parts.shift()] = parts.pop();
				}
				
				if (selector.hasOwnProperty(StyleProtocol.SELECTOR_TYPE))
				{
					selectorType = selector[StyleProtocol.SELECTOR_TYPE];
					delete selector[StyleProtocol.SELECTOR_TYPE];
					subRegisterMethod = subRegisterMethods[ selectorType ];
					subRegisterMethod(prefix, selector);
				}
				registerStyle(prefix, selector);
			}
		}

        private function fillInheritedStyles ():void
        {
            var parentStyle:Object;
            for each (var style:Object in styles)
            {
                mergeHash(style, getParentStyleObject(style));
            }
        }

        private function getParentStyleObject (style:Object):Object
        {
            if (style == null || !style.hasOwnProperty(INHERITS_TAG))
            {
                return null;
            }
            const parentStyle:String = style[INHERITS_TAG];
            return mergeHash(styles[parentStyle], getParentStyleObject(parentStyle));
        }

        private function mergeHash (toHash:Object, ...hashes):Object
        {
            toHash ||= {};
            for each (var hash:Object in hashes)
            {
                if (hash != null)
                {
                    for (var key:String in hash)
                    {
                        if (toHash[key] == null)
                        {
                            toHash[key] = hash[key];
                        }
                    }
                }
            }
            return toHash;
        }
		
		private function checkFormat (pairs:Array):void
		{
			if (pairs.length != 2 || pairs[1] == null || pairs[1].length == 0)
			{
				throw new Error("Cannot parse css. Bad pair format. [" + pairs + "]");
			}
		}
	}
}