package com.tengu.gui.controls.buttons
{
	import com.tengu.gui.controls.text.Text;

	[Style(name="text")]
	[Style(name="over_text")]
	[Style(name="down_text")]
	[Style(name="disabled_text")]
	[Style(name="selected_text")]
	[Style(name="selected_over_text")]
	[Style(name="selected_down_text")]
	[Style(name="selected_disabled_text")]
	public class TextButton extends ContentButton
	{
		private static const DEFAULT_WIDTH:uint = 70;
		private static const DEFAULT_HEIGHT:uint = 20;

		private var upLabelStyle:String = null;
		
		protected var text:Text 				 = null;
		protected var labelStyles:Object 		 = null;
		protected var selectedLabelStyles:Object = null;
		
		protected override function get defaultStyleName():String
		{
			return "TextButton";
		}
		
		public function get label():String
		{
			return  text.text;
		}
		
		public function set label(value:String):void 
		{
			if (text.text == value)
			{
				return;
			}
			text.text = value;
			invalidate(VALIDATION_FLAG_LAYOUT);
		}
		
		public function set htmlLabel(value:String):void 
		{
			text.htmlText = value;
			invalidate(VALIDATION_FLAG_LAYOUT);
		}
		
		public function set multiline (value:Boolean):void
		{
			text.multiline = value;
			invalidate(VALIDATION_FLAG_LAYOUT);
		}
		
		public function get multiline():Boolean 
		{
			return text.multiline;
		}
		
		public function TextButton()
		{
			super();
		}
		
		protected override function measure():void
		{
			componentWidth 	= DEFAULT_WIDTH;
			componentHeight = DEFAULT_HEIGHT;
		}
		
		protected override function createChildren():void
		{
			super.createChildren();
			text = new Text("label", null, true);
			text.mouseEnabled = false;
			contentHolder.addChild(text);

			labelStyles = {};
			selectedLabelStyles = {};
		}
		
		protected override function setState(state:String):void
		{
			super.setState(state);
			text.format = selected ? selectedLabelStyles[state] : labelStyles[state];
			contentHolder.invalidate(VALIDATION_FLAG_LAYOUT);
		}
		
		protected override function dispose():void
		{
			text.finalize();
			text = null;
			
			labelStyles = null;
			super.dispose();
		}
		
		protected override function setStyleSelector(styleName:String, styleValue:*):void
		{
			if (styleName == "text")
			{
				labelStyles[STATE_UP] = styleValue;
				return;
			}
			if (styleName == "over_text")
			{
				labelStyles[STATE_OVER] = styleValue;
				return;
			}
			if (styleName == "down_text")
			{
				labelStyles[STATE_DOWN] = styleValue;
				return;
			}
			if (styleName == "disabled_text")
			{
				labelStyles[STATE_DISABLED] = styleValue;
				return;
			}
			if (styleName == "selected_text")
			{
				selectedLabelStyles[STATE_UP] = styleValue;
				return;
			}
			if (styleName == "selected_over_text")
			{
				selectedLabelStyles[STATE_OVER] = styleValue;
				return;
			}
			if (styleName == "selected_down_text")
			{
				selectedLabelStyles[STATE_DOWN] = styleValue;
				return;
			}
			if (styleName == "selected_disabled_text")
			{
				selectedLabelStyles[STATE_DISABLED] = styleValue;
				return;
			}
			super.setStyleSelector(styleName, styleValue);
		}
		
		protected override function preUpdateStyle():void
		{
			super.preUpdateStyle();
			labelStyles = {};
			selectedLabelStyles = {};
		}
		
		protected override function postUpdateStyle():void
		{
			super.postUpdateStyle();
			labelStyles[STATE_OVER] 	||= labelStyles[STATE_UP]; 
			labelStyles[STATE_DOWN] 	||= labelStyles[STATE_UP]; 
			labelStyles[STATE_DISABLED] ||= labelStyles[STATE_UP]; 
			
			selectedLabelStyles[STATE_UP] 		||= labelStyles[STATE_UP]; 
			selectedLabelStyles[STATE_OVER] 	||= selectedLabelStyles[STATE_UP]; 
			selectedLabelStyles[STATE_DOWN] 	||= selectedLabelStyles[STATE_UP]; 
			selectedLabelStyles[STATE_DISABLED] ||= selectedLabelStyles[STATE_UP]; 
		}
		
	}
}