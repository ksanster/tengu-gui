package com.tengu.gui.controls.text
{
	import flash.events.SoftKeyboardEvent;
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;

	[Style(name="default_text")]
	public class StageTextInputWithPropmt extends StageTextInput
	{
		private var defaultTextValue:String = "";
		private var defaultTextChanged:Boolean = true;
		private var defaultTextLabel:TextField = null;		
		

		public function set defaultText (value:String):void
		{
			if (defaultTextValue == value)
			{
				return;
			}
			defaultTextValue = value || "";
			defaultTextChanged = true;
			invalidate(VALIDATION_FLAG_DATA, VALIDATION_FLAG_DISPLAY);
		}
		
		public function get defaultText():String 
		{
			return defaultTextValue;
		}
		
		public override function get text():String
		{
			return (textFieldText == defaultTextValue) ? "" : textFieldText;
		}
		
		public function StageTextInputWithPropmt(defaultText:String = "", multiline:Boolean=false)
		{
			defaultTextValue = defaultText || "";
			super(multiline);
		}
		
		protected override function createChildren():void
		{
			super.createChildren();
			defaultTextLabel = new TextField();
			defaultTextLabel.embedFonts = true;
			defaultTextLabel.type = TextFieldType.DYNAMIC;
			defaultTextLabel.gridFitType = GridFitType.PIXEL;
			defaultTextLabel.antiAliasType = AntiAliasType.ADVANCED;
			defaultTextLabel.autoSize = TextFieldAutoSize.LEFT;
			defaultTextLabel.mouseEnabled = false;
			defaultTextLabel.visible = false;
			addChild(defaultTextLabel);
		}
		
		protected override function dispose():void
		{
			defaultTextLabel = null;
			super.dispose();
		}
		
		protected override function updateData():void
		{
			super.updateData();
			if (defaultTextChanged)
			{
				defaultTextLabel.text = defaultTextValue;
				defaultTextChanged = false;
			}
		}
		
		protected override function updateDisplay():void
		{
			super.updateDisplay();
			defaultTextLabel.x = componentPaddingLeft;
			defaultTextLabel.y = (height - defaultTextLabel.textHeight) * .5;
			
			defaultTextLabel.visible = !keyboardActive && (textFieldText == null || textFieldText.length == 0 || textFieldText == defaultTextValue);
			snapshot.visible =  !keyboardActive && !defaultTextLabel.visible;
		}
		
		protected override function updateStyle():void
		{
			super.updateStyle();
			styleManager.applyTextStyle(defaultTextLabel, defaultTextStyle);
		}
		
		protected override function setStyleSelector(styleName:String, styleValue:*):void
		{
			if (styleName == "default_text")
			{
				defaultTextStyle = styleValue;
				return;
			}
			super.setStyleSelector(styleName, styleValue);
		}
		
		protected override function onKeyboardActivate(event:SoftKeyboardEvent):void
		{
			if (stageText.text == defaultTextValue)
			{
				stageText.text = "";
			}
			else if (stageText.text.length > 0)
			{
				stageText.selectRange(0, stageText.text.length);
			}
			super.onKeyboardActivate(event);
		}
		
	}
	
}