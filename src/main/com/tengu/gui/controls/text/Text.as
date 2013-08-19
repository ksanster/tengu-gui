package com.tengu.gui.controls.text
{
	import com.tengu.gui.base.GUIComponent;
	
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	
	[Style(name="text")]
	public class Text extends GUIComponent
	{
		protected static const VALIDATION_FLAG_FORMAT:String = "validateTextFormat";
		
		private var textFieldHTMLText:String = null;
		
		private var textFormat:String 		= null;
		private var isAutoSize:Boolean 		= false;
		private var isMultiline:Boolean 	= false;
		private var isSelectable:Boolean 	= false;
		private var isLinkEnabled:Boolean 	= false;
		
		protected var textFieldText:String = null;
		protected var textField:TextField = null;
		
		private function get isLabel ():Boolean
		{
			return (!isAutoSize && !isMultiline);
		}
		
		protected override function get defaultStyle():Object
		{
			var object:Object = super.defaultStyle || {};
			object["text"] = textFormat || styleManager.defaultTextStyle;
			return object;
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
			return textFieldText;
		}
		
		public function set text(value:String):void 
		{
			value = value || "";
			if (textFieldText == value)
			{
				return;
			}
			textFieldText  = value;
			textFieldHTMLText = null;
			invalidate(VALIDATION_FLAG_DATA, VALIDATION_FLAG_DISPLAY, VALIDATION_FLAG_SIZE);
		}
		
		public function get htmlText():String 
		{
			return textFieldHTMLText;
		}
		
		public function set htmlText(value:String):void 
		{
			value = value || "";
			if (textFieldHTMLText == value)
			{
				return;
			}
			textFieldHTMLText = value;
			textFieldText = null;
			invalidate(VALIDATION_FLAG_DATA, VALIDATION_FLAG_DISPLAY, VALIDATION_FLAG_SIZE);
		}
		
		public function get format():String 
		{
			return textFormat;
		}
		
		public function set format(value:String):void 
		{
			if (value == textFormat || value == null)
			{
				return;
			}
			textFormat = value;
			invalidate(VALIDATION_FLAG_FORMAT);
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
		
		public function Text(text:String = "", style:String = null, autoSize:Boolean = true, selectable:Boolean = false, multiline:Boolean = false)
		{
			isAutoSize = autoSize;
			isMultiline = multiline;
			isSelectable = selectable;
			textFormat = style;
			textFieldText = text;
			super();
			
		}
		
		private function truncateText ():void
		{
			if (textFieldText == null || textFieldText.length == 0)
			{
				return;
			}
			var index:int = 0;
			var tmpString:String = textFieldText;
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
		
		protected override function initialize():void
		{
			super.initialize();
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
			if (textFieldText != null)
			{
				textField.text = textFieldText;
			} 
			else
			{
				textField.htmlText = textFieldHTMLText;
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
		
		protected override function validate():void
		{
			textField.autoSize = 	isAutoSize ? TextFieldAutoSize.LEFT : TextFieldAutoSize.NONE;
			textField.multiline 	= isMultiline;
			textField.wordWrap 		= isMultiline;
			textField.selectable 	= isSelectable;
			
			mouseChildren 			= isSelectable;
			textField.mouseEnabled  = isSelectable;

			if (isInvalid(VALIDATION_FLAG_FORMAT))
			{
				updateFormat();
			}

			super.validate();
		}
			
		protected function updateFormat():void
		{
			styleManager.applyTextStyle(textField, textFormat);
			if (autoSize)
			{
				setSize(textWidth, textHeight + 4);
			}
		}
		
		protected override function updateSize():void
		{
			super.updateSize();
			textField.width = width - componentPaddingRight - componentPaddingLeft;
			textField.height = height - componentPaddingTop - componentPaddingBottom;
			
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
		
		protected override function setStyleSelector(styleName:String, styleValue:*):void
		{
			if (styleName == "text" && textFormat != styleValue)
			{
				textFormat = styleValue;
				return;
			}
			super.setStyleSelector(styleName, styleValue);
		}
	}
}