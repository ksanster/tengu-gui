package com.tengu.gui.controls
{
	import com.tengu.gui.base.GUIComponent;
	import com.tengu.gui.controls.text.Text;
	
	[Style(name="label_text")]
	[Style(name="value_text")]
	[Style(name="gap")]
	public class LabelValue extends GUIComponent
	{
		private var labelField:Text = null;
		private var valueField:Text = null;
		
		private var gap:int = 0;
		private var labelStyle:String = null;
		private var valueStyle:String = null;
		
		public function set label (value:String):void
		{
			labelField.text = value;
			invalidate(VALIDATION_FLAG_LAYOUT);
		}
		
		public function set value(value:String):void 
		{
			valueField.text = value;
			invalidate(VALIDATION_FLAG_LAYOUT);
		}
		
		public function LabelValue(labelStyle:String, valueStyle:String = null, gap:int = 5)
		{
			this.labelStyle = labelStyle;
			this.valueStyle = valueStyle || labelStyle;
			this.gap = gap;
			super();
		}
		
		protected override function createChildren():void
		{
			super.createChildren();
			mouseEnabled = false;
			mouseChildren = false;
			
			labelField = new Text();
            labelField.style = labelStyle;
			addChild(labelField);
			
			valueField = new Text();
            valueField.style = valueStyle;
			addChild(valueField);
		}
		
		protected override function dispose():void
		{
			labelField.finalize();
			labelField = null;
			
			valueField.finalize();
			valueField = null;

			super.dispose();
		}
		
		protected override function updateLayout():void
		{
			super.updateLayout();
			valueField.x = Math.max(labelField.x + labelField.width, gap);
			
			if (labelField.height < valueField.height)
			{
				valueField.y = 0;
				labelField.y = valueField.height - labelField.height;
			}
			else
			{
				labelField.y = 0;
				valueField.y = labelField.height - valueField.height;
			}
		}
		
		protected override function setStyleSelector(styleName:String, styleValue:*):void
		{
			if (styleName == "label_text" && labelStyle != styleValue)
			{
				labelStyle       = styleValue;
				labelField.style = styleValue;
				return;
			}
			if (styleName == "value_text" && valueStyle != styleValue)
			{
				valueStyle       = styleValue;
				valueField.style = styleValue;
				return;
			}
			if (styleName == "gap")
			{
				gap = parseInt(String(styleValue));
				return;
			}
		}
		
	}
}