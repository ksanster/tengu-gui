package com.tengu.gui.fills
{
	import flash.display.Graphics;

	public class BorderFill extends ShapeFill
	{
		private var topColor:uint 		= 0;
		private var bottomColor:uint 	= 0;
		private var leftColor:uint 		= 0;
		private var rightColor:uint 	= 0;
		private var thickness:Number 	= 1;
		
		private var fillColor:uint		= 0;
		private var fillAlpha:Number 	= 1; 
		
		public function BorderFill(topColor:uint, bottomColor:uint, leftColor:uint, rightColor:uint, thickness:Number = 1, fillColor:uint = 0xFFFFFF, fillAlpha:Number = 0)
		{
			super();
			this.topColor = topColor;
			this.bottomColor = bottomColor;
			this.leftColor = leftColor;
			this.rightColor = rightColor;
			this.thickness = thickness;
			
			this.fillColor = fillColor;
			this.fillAlpha = fillAlpha;
		}
		
		public override function apply(graphics:Graphics, width:uint, height:uint, clear:Boolean=true):void
		{
			if(clear)
			{
				graphics.clear();
			}
			graphics.lineStyle(thickness, topColor);
			graphics.beginFill(fillColor, fillAlpha);
			graphics.lineTo(width, 0);
			graphics.lineStyle(thickness, rightColor);
			graphics.lineTo(width, height);
			graphics.lineStyle(thickness, bottomColor);
			graphics.lineTo(0, height);
			graphics.lineStyle(thickness, leftColor);
			graphics.lineTo(0, 0);
			graphics.endFill();
		}
	}
}