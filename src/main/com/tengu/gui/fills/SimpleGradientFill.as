package com.tengu.gui.fills
{
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.geom.Matrix;

	public class SimpleGradientFill extends ShapeFill
	{
		private static const ALPHAS:Array = [1, 1];
		private static const RATIOS:Array = [0, 255];
		
		private var colors:Array = null;
		private var matrix:Matrix = null;
		
		private var angle:Number = 0;
		private var fillTX:int = 0;
		private var fillTY:int = 0;
		
		private var fillGradientType:String = GradientType.LINEAR;
		
		public function set gradientType (value:String):void
		{
			fillGradientType = value;
		}
		
		public function set tx(value:int):void 
		{
			fillTX = value;
		}
		
		public function set ty(value:int):void 
		{
			fillTY = value;
		}
		
		public function SimpleGradientFill(color1:uint, color2:uint, angle:Number)
		{
			super();
			this.angle = angle;
			colors = [color1, color2];
			matrix = new Matrix();
		}
		
		public override function apply(graphics:Graphics, width:uint, height:uint, clear:Boolean=true):void
		{
			if(clear)
			{
				graphics.clear();
			}
			matrix.identity();
			matrix.createGradientBox(width, height, angle, fillTX, fillTY);
			graphics.beginGradientFill(fillGradientType, colors, ALPHAS, RATIOS, matrix);
			graphics.drawRect(0, 0, width, height);
			graphics.endFill();
		}
	}
}