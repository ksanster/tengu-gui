package com.tengu.gui.controls.text
{
    import com.tengu.core.tengu_internal;
    import com.tengu.gui.base.GUIComponent;
	
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	
	[Style(name="text")]
	public class Text extends GUIComponent
	{

		private var isAutoSize:Boolean 		= false;
		private var isMultiline:Boolean 	= false;
		private var isSelectable:Boolean 	= false;
		private var isLinkEnabled:Boolean 	= false;

        protected var htmlTextValue:String  = null;
		protected var textValue:String      = null;

        protected var textField:TextField   = null;
		
		private function get isLabel ():Boolean
		{
			return (!isAutoSize && !isMultiline);
		}
		
		protected override function get defaultStyleName():String
		{
			return "Text";
		}
		
		public function get textWidth ():int
		{
			return textField.textWidth + 4;;
		}	
		
		public function get textHeight ():int
		{
			return textField.textHeight + 4;
		}
		
		public function get text():String 
		{
			return textValue;
		}
		
		public function set text(value:String):void 
		{
			value = value || "";
			if (textValue == value)
			{
				return;
			}
			textValue  = value;
			htmlTextValue = null;
			invalidate(VALIDATION_FLAG_DATA, VALIDATION_FLAG_DISPLAY, VALIDATION_FLAG_SIZE);
		}
		
		public function get htmlText():String 
		{
			return htmlTextValue;
		}
		
		public function set htmlText(value:String):void 
		{
			value = value || "";
			if (htmlTextValue == value)
			{
				return;
			}
			htmlTextValue = value;
			textValue = null;
			invalidate(VALIDATION_FLAG_DATA, VALIDATION_FLAG_DISPLAY, VALIDATION_FLAG_SIZE);
		}
		
		public function get multiline():Boolean
		{
			return isMultiline;
		}
		
		public function set multiline(value:Boolean):void 
		{
			if (isMultiline == value)
			{
				return;
			}
			isMultiline = value;
			textField.multiline 	= isMultiline;
			textField.wordWrap 		= isMultiline;
			invalidate(VALIDATION_FLAG_LAYOUT, VALIDATION_FLAG_SIZE);
		}
		
		public function get autoSize():Boolean 
		{
			return isAutoSize;
		}
		
		public function set autoSize(value:Boolean):void 
		{
			if (isAutoSize == value)
			{
				return;
			}
			isAutoSize = value;
			invalidate(VALIDATION_FLAG_LAYOUT, VALIDATION_FLAG_SIZE);
		}
		
		public function get selectable():Boolean 
		{
			return isSelectable;
		}
		
		public function set selectable(value:Boolean):void 
		{
			if (isSelectable == value)
			{
				return;
			}
			isSelectable = value;
			
			textField.selectable 	= isSelectable;
			mouseChildren 			= isSelectable || isLinkEnabled;
			textField.mouseEnabled  = isSelectable || isLinkEnabled;
		}
		
		public function set enableHTMLLinks(value:Boolean):void 
		{
			isLinkEnabled = value;
			mouseChildren 			= value || isSelectable;
			textField.mouseEnabled 	= value || isSelectable;
		}
		
		public function get field():TextField 
		{
			return textField;
		}
		
		public function Text(text:String = "", autoSize:Boolean = true, selectable:Boolean = false, multiline:Boolean = false)
		{
			isAutoSize      = autoSize;
			isMultiline     = multiline;
			isSelectable    = selectable;
			textValue       = text;
			super();
			
		}
		
		private function truncateText ():void
		{
			if (textValue == null || textValue.length == 0)
			{
				return;
			}
			var index:int = 0;
			var tmpString:String = textValue;
			textField.text = tmpString;
			if (width < textField.textWidth)
			{
				index = textField.getCharIndexAtPoint(width - 15, textField.textHeight * .5);
				if (index != -1)
				{
					textField.text = tmpString.substr(0, index) + "...";
				}
			}
		}
		
		protected override function createChildren():void
		{
			super.createChildren();
			mouseEnabled = false;
			
			textField = new TextField();
			textField.embedFonts = true;
			textField.type = TextFieldType.DYNAMIC;
			textField.gridFitType = GridFitType.PIXEL;
			textField.antiAliasType = AntiAliasType.ADVANCED;
			
			addChild(textField);
		}
		
		protected override function updateData():void
		{
			super.updateData();

            textField.autoSize = 	isAutoSize ? TextFieldAutoSize.LEFT : TextFieldAutoSize.NONE;
            textField.multiline 	= isMultiline;
            textField.wordWrap 		= isMultiline;
            textField.selectable 	= isSelectable;

            mouseChildren 			= isSelectable;
            textField.mouseEnabled  = isSelectable;

            if (textValue != null)
			{
				textField.text = textValue;
			} 
			else
			{
				textField.htmlText = htmlTextValue;
			}
			if (isLabel)
			{
				truncateText();
			}
			if (autoSize)
			{
				setSize(textWidth, textHeight + 4);
			}
		}
		
		protected override function updateSize():void
		{
			super.updateSize();
            if (!autoSize)
            {
                textField.width = width - componentPaddingRight - componentPaddingLeft;
                textField.height = height - componentPaddingTop - componentPaddingBottom;
            }

			if (isLabel)
			{
				truncateText();
			}
		}
		
		protected override function updateDisplay():void
		{
			super.updateDisplay();
			textField.x = componentPaddingLeft;
			textField.y = componentPaddingTop;
		}

        override protected function updateStyle ():void
        {
            var format:String;
            styleObject ||= defaultStyle;
            if (styleObject == null)
            {
                return;
            }
            format = styleObject.hasOwnProperty("text") ? styleObject["text"] : styleName;
            styleManager.applyTextStyle(textField, format);

            tengu_internal::parseStyle(styleObject);
        }
	}
}