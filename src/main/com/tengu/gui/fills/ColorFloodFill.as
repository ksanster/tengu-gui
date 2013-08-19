package com.tengu.gui.fills
{
	import flash.display.Graphics;

	public class ColorFloodFill extends ShapeFill
	{
		private var color:uint = 0xFFFFFF;
		private var alpha:Number = 1;
		
		public function ColorFloodFill(color:uint = 0xFFFFFF, alpha:Number = 0)
		{
			this.color = color;
			this.alpha = alpha;
		}
		
		public override function apply(graphics:Graphics, width:uint, height:uint, clear:Boolean=true):void
		{
			if(clear)
			{
				graphics.clear();
			}
			graphics.beginFill(color, alpha);
			graphics.drawRect(0, 0, width, height);
			graphics.endFill();
		}
	}
}