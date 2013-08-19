package com.tengu.gui.controls.text
{
	import com.tengu.core.tengu_internal;
	import com.tengu.gui.fills.ColorFloodFill;
	import com.tengu.gui.fills.ShapeFill;
	
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.text.TextFieldType;

	[Style(name="default_text")]
	[Style(name="focus_text")]
	[Style(name="normal_border")]
	[Style(name="focus_border")]
	[Style(name="background_fill")]
	public class InputText extends Text
	{
		private var border:Shape = null;
		private var normalTextStyle:String = null;
		private var focusTextStyle:String = null;
		private var defaultTextStyle:String  = null;
		
		private var normalBorderFill:ShapeFill = null;
		private var focusBorderFill:ShapeFill  = null;
		
		private var inFocus:Boolean = false;
		
		private var defaultCaptionText:String = "";
		private var isPassword:Boolean = false;
		
		protected override function get defaultStyle():Object
		{
			var result:Object = super.defaultStyle;
			result["default_text"] 	= result["text"];
			return result;
		}
		
		public override function get text():String 
		{
			if (textField.text == defaultCaptionText)
			{
				return "";
			}
			return textField.text;
		}
		
		public override function set text(value:String):void
		{
//			super.text = value;
			textFieldText = value;
			textField.text = (value == null || value.length == 0) ? defaultCaptionText : value;;
			if (inFocus)
			{
				return;
			}
			format = (value == defaultCaptionText) ? defaultTextStyle : normalTextStyle;
		}
		
		public function set defaultText(value:String):void 
		{
			defaultCaptionText = value;
			textField.text = (textFieldText == null || textFieldText.length == 0) ? defaultCaptionText : textFieldText;
		}
		
		public function set displayAsPassword(value:Boolean):void 
		{
			isPassword = value;
			textField.displayAsPassword = value && (textField.text != defaultCaptionText);
		}
		
		public function set restrict(value:String):void 
		{
			textField.restrict = value;
		}
		
		public function InputText(normalStyle:String = null, defaultStyle:String = null)
		{
			super("", normalStyle, false, true, true);
			this.normalTextStyle = normalStyle;
			this.defaultTextStyle = defaultStyle;
			
			textField.type = TextFieldType.INPUT;
			textField.addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			textField.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			textField.addEventListener(Event.CHANGE, onChangeText);
		}
		
		private function setTextFieldStyle():void
		{
			if (textField.text == defaultCaptionText)
			{
				format = defaultTextStyle;
			}
			else
			{
				format = inFocus ? focusTextStyle : normalTextStyle;
			}
			
			styleManager.applyTextStyle(textField, format);
			
			if (autoSize)
			{
//				setSize(textWidth, textHeight + 4);
			}
		}
		
		protected override function createChildren():void
		{
			super.createChildren();
			border = new Shape();
			addChildAt(border, 0);
		}
		
		protected override function dispose():void
		{
			textField.removeEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			textField.removeEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			
			super.dispose();
		}
		
		protected override function setStyleSelector(styleName:String, styleValue:*):void
		{
			if (styleName == "text")
			{
				normalTextStyle = styleValue;
				return;
			}
			if (styleName == "focus_text")
			{
				focusTextStyle = styleValue;
				return;
			}
			if (styleName == "default_text")
			{
				defaultTextStyle = styleValue;
				return;
			}
			if (styleName == "normal_border")
			{
				normalBorderFill = textureManager.getTexture(styleValue);
				return;
			}
			if (styleName == "focus_border")
			{
				focusBorderFill = textureManager.getTexture(styleValue);
				return;
			}
			if (styleName == "background_fill")
			{
				backgroundFill = textureManager.getTexture(styleValue);
				return;
			}
			super.setStyleSelector(styleName, styleValue);
		}
		
		protected override function updateStyle():void
		{
			styleObject ||= defaultStyle;
			
			if (styleObject == null)
			{
				return;
			}
			
			backgroundFill = null;
			normalBorderFill = null;
			focusBorderFill = null;
			normalTextStyle = null;
			focusTextStyle = null;
			defaultTextStyle = null;
			
			tengu_internal::parseStyle(styleObject);

			backgroundFill	 ||= new ColorFloodFill();
			normalBorderFill ||= new ColorFloodFill();
			focusBorderFill ||= normalBorderFill;
			
			normalTextStyle ||= styleManager.defaultTextStyle;
			focusTextStyle ||= normalTextStyle;
			defaultTextStyle ||= normalTextStyle;
			
			setTextFieldStyle();
		}
		
		protected override function updateDisplay():void
		{
			super.updateDisplay();
			if (inFocus)
			{
				focusBorderFill.apply(border.graphics, width, height);
			}
			else
			{
				normalBorderFill.apply(border.graphics, width, height);
			}

		}
			
		private function onFocusIn(event:FocusEvent):void
		{
			inFocus = true;
			format = focusTextStyle;
			if (textField.text == defaultCaptionText)
			{
//				textField.text = "";
			}
			textField.displayAsPassword = isPassword;
			focusBorderFill.apply(border.graphics, width, height);
		}
		
		private function onFocusOut(event:FocusEvent):void
		{
			inFocus = false;
			if (textField.text == null || textField.text.length == 0)
			{
				textField.text = defaultCaptionText;
				format = defaultTextStyle;
				textField.displayAsPassword = false;
			}
			else
			{
				format = normalTextStyle;
				textField.displayAsPassword = isPassword;
			}
			setTextFieldStyle();
			normalBorderFill.apply(border.graphics, width, height);
		}
		
		private function onChangeText(event:Event):void
		{
			trace(textField.text, textField.width);
		}		
	}
}