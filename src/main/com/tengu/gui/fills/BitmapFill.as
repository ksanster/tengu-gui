package com.tengu.gui.fills
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	//TODO: colls и rows перепутаны - поменять идентификаторы
	public class BitmapFill extends ShapeFill
	{
		private static const matrix:Matrix 	= new Matrix();
		private static const point:Point 	= new Point();
		private static const rect:Rectangle = new Rectangle();
		
		private var fillBitmapData:BitmapData 	= null;
		
		private var fillDefaultWidth:uint 		= 0;
		private var fillDefaultHeight:uint 		= 0;
		
		private var isStretch:Boolean 			= true;
		private var isRepeat:Boolean = false
		public function set stretch (value:Boolean):void
		{
			isStretch = value;
		}
		
		public function set bitmapData (value:BitmapData):void
		{
			fillBitmapData = value;
			if (value != null)
			{
				fillDefaultWidth = value.width;
				fillDefaultHeight = value.height;
			}
		}
		
		public function get defaultWidth ():uint
		{
			return fillDefaultWidth;
		}
		
		public function get defaultHeight ():uint
		{
			return fillDefaultHeight;
		}
		
		public function BitmapFill(bitmapData:BitmapData = null, stretch:Boolean = true, repeat : Boolean = false)
		{
			this.bitmapData = bitmapData;
			isStretch = stretch;
			isRepeat = repeat;
		}
		
		public override function apply (graphics:Graphics, width:uint, height:uint, clear:Boolean=true):void
		{
			if(clear)
			{
				graphics.clear();
			}
			
			if (fillBitmapData == null || width == 0 || height == 0)
			{
				return;
			}
			matrix.identity();
			if (!isStretch)
			{
				graphics.beginBitmapFill(fillBitmapData, matrix, false, true);
				graphics.drawRect(0, 0, fillBitmapData.width, fillBitmapData.height);
				graphics.endFill();
				return;
			}
			
			if(!isRepeat)
			{
				matrix.scale(width / defaultWidth, height / defaultHeight);	
			}
			graphics.beginBitmapFill(fillBitmapData, matrix, isRepeat, true);
			graphics.drawRect(0, 0, width, height);
			graphics.endFill();
		}
		
		public function finalize ():void
		{
			fillBitmapData.dispose();
		}
	}
}