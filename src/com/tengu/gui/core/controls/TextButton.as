package com.tengu.gui.core.controls
{
	import com.tengu.gui.core.text.Text;
	
	import flash.display.BitmapData;
	import flash.geom.Rectangle;

	public class TextButton extends BaseButton
	{
		private static const DEFAULT_WIDTH:uint = 70;
		private static const DEFAULT_HEIGHT:int = 20;
		private static const DEFAULT_SKIN:BitmapData = function ():BitmapData
		{
			var result:BitmapData = new BitmapData(DEFAULT_WIDTH, DEFAULT_HEIGHT, true, 0x00FFFFFF);
			result.fillRect(new Rectangle(0, 0, DEFAULT_WIDTH, DEFAULT_HEIGHT), 0xFF3399CC);
			return result;
		}();
		
		private var text:Text 			= null;
		private var defaultLabelY:int 	= 0;
		
		public function set label(value:String):void 
		{
			text.label = value;
			invalidate();
		}
		
		public function set labelStyle (value:String):void
		{
			text.style = value;
			invalidate();
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
			addChild(text);
			setSkin(DEFAULT_SKIN);
		}
			
		
		protected override function update():void
		{
			super.update();
			
			text.x = int( (componentWidth - text.width) * .5);
			defaultLabelY = int( (componentHeight - text.height) * .5);
			text.y = defaultLabelY;
		}
		
		protected override function setState(state:String):void
		{
			super.setState(state);
			text.y = (state == BaseButton.STATE_DOWN) ? defaultLabelY + 1 : defaultLabelY;
		}
	}
}