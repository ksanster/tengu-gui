package com.tengu.gui.core.text
{
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class Text extends TextField
	{
		private var textStyle:String = null;
		
		public function set style (value:String):void
		{
			if (textStyle == value)
			{
				return;
			}
			textStyle = value;
			TextStyleFormat.applyStyle(this, value);
		}
		
		public function get style():String 
		{
			return textStyle;
		}
		
		public function set label (value:String):void
		{
			if (text == value)
			{
				return;
			}
			text = value;
			cacheAsBitmap = true;
		}
		
		public function Text(label:String = "", style:String = null, autoSize:Boolean = true, multiline:Boolean = false, selectable:Boolean = false)
		{
			super();
			this.text = label;
			this.autoSize = autoSize ? TextFieldAutoSize.LEFT : TextFieldAutoSize.NONE;
			this.multiline = multiline;
			this.wordWrap = multiline;
			this.selectable = selectable;
			this.mouseEnabled = selectable;
			
			this.style = style;
			
			cacheAsBitmap = true;
		}
	}
}