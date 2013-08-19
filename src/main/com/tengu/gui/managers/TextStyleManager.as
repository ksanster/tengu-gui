package com.tengu.gui.managers
{
    import com.tengu.core.funcs.parseBoolean;
    import com.tengu.gui.resources.text.StyleProtocol;
    import com.tengu.log.LogFactory;

    import flash.display.DisplayObject;
    import flash.filters.DropShadowFilter;
    import flash.filters.GlowFilter;
    import flash.text.StyleSheet;
    import flash.text.TextField;
    import flash.text.TextFormat;

    internal class TextStyleManager
	{
		private static function setAttribute (container:Object, attrName:String, attrValue:*):void
		{
			if (attrName == StyleProtocol.NAME || attrName == StyleProtocol.TYPE)
			{
				return;
			}
			
			if (attrName == StyleProtocol.BOLD)
			{
				container[attrName] = parseBoolean(attrValue);
				return;
			}
			
			if (!isNaN(Number(attrValue)))
			{
				container[attrName] = Number(attrValue);
				return;
			}
			container[attrName] = attrValue;
		}
		
		private var filterClasses:Object 	= {};
		private var styles:Object 			= {};
		private var filters:Object 			= {};
		private var scale:Number			= 1;
		
		public function set scaleFactor(value:Number):void 
		{
			scale = value;
		}

		public function TextStyleManager()
		{
			filterClasses[StyleProtocol.DROP_SHADOW] = DropShadowFilter;
			filterClasses[StyleProtocol.GLOW] = GlowFilter;
		}
		
		public function registerFormat(name:String, raw:Object):void
		{
			var size:Number;
			var filters:Array;
			var format:TextFormat = new TextFormat();
			for (var attrName:String in raw)
			{
				if (attrName == StyleProtocol.FILTERS)
				{
					filters = String(raw[attrName]).split(",");
					continue;
				}
				setAttribute(format, attrName, raw[attrName]);
			}
			size = parseInt(String(format.size));
			if (size > 0)
			{
				format.size = size * scale;
			}
			styles[name] = new TextStyle(format, filters);
		}
		
		public function registerCSSStyle(name:String, raw:Object):void
		{
			var size:Number;
			var filters:Array;
			var parts:Array = name.split(" ");
			
			var styleName:String 	= parts[0];
			var selectorName:String = parts[1];
			
			var css:TextCSSStyle = styles[styleName];
			
			var selector:Object = {};
			var styleSheet:StyleSheet = (css == null) ? new StyleSheet() : css.styleSheet;
			for (var attrName:String in raw)
			{
				if (attrName == StyleProtocol.FILTERS)
				{
					filters = String(raw[attrName]).split(",");
					continue;
				}
				setAttribute(selector, attrName, raw[attrName]);
			}
			size = parseInt(String(selector.size));
			if (size > 0)
			{
				selector.size = size * scale;
			}

			styleSheet.setStyle(selectorName, selector);
			
			if (css == null)
			{
				styles[styleName] = new TextCSSStyle(styleSheet, filters);
			}
			else
			{
				css.filters ||= filters;
			}
		}
		
		public function registerFilter (name:String, raw:Object):void
		{
			var filter:*;
			var filterName:String = raw[StyleProtocol.TYPE];
			var filterClass:Class = filterClasses[filterName];
			
			if (filterClass == null)
			{
				//TODO:Log error
				return;
			}
			filter = new filterClass();
			for (var attrName:String in raw)
			{
				setAttribute(filter, attrName, raw[attrName]);
			}
			filters[name] = filter;
		}
		
		public function getTextFormat (name:String):TextFormat
		{
			if (styles[name] == null)
			{
				return null;
			}
			return (styles[name] as TextStyle).format;
		}
		
		public function applyStyle(field:TextField, styleName:String):void
		{
			var style:TextStyle  = null;
			var css:TextCSSStyle = null;
			var filterList:Array = null;
			var text:String = null;
			
			if (styleName == null)
			{
				return;
			}
			
			if (styles[styleName] == null)
			{
                LogFactory.getLogger(TextStyleManager).error("Format not set: ", String(styleName));
				styleName = "defaultStyle";
			}
			if (styles[styleName] is TextStyle)
			{
				style = styles[styleName];
				field.defaultTextFormat = style.format;
				field.setTextFormat(style.format);
				filterList = style.filters;
			}
			else
			{
				css = styles[styleName];
				filterList = css.filters;
				field.styleSheet = css.styleSheet;
			}
			
			applyFilters (field, filterList);
		}
		
		public function applyFilters(target:DisplayObject, filterList:Array):void
		{
			var filter:Object;
			var list:Array = new Array();
			for each (var filterName:String in filterList)
			{
				filter = filters[filterName];
				if (filter != null)
				{
					list[list.length] = filter;
				}
			}
			target.filters = list;
		}
	}
}

import flash.text.StyleSheet;
import flash.text.TextFormat;

internal class TextStyle
{
	public var format:TextFormat = null;
	public var filters:Array = null;
	
	public function TextStyle (format:TextFormat, filters:Array = null)
	{
		this.format = format;
		this.filters = filters;
	}
}

internal class TextCSSStyle
{
	public var styleSheet:StyleSheet = null;
	public var filters:Array		 = null;
	
	public function TextCSSStyle (styleSheet:StyleSheet, filters:Array = null)
	{
		this.styleSheet = styleSheet;
		this.filters = filters;
	}
}