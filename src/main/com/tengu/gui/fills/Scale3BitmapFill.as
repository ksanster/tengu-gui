package com.tengu.gui.fills
{
	import com.tengu.gui.enum.Direction;
	
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	//TODO: colls и rows перепутаны - поменять идентификаторы
	public class Scale3BitmapFill extends ShapeFill
	{
		private static const matrix:Matrix 	= new Matrix();
		private static const point:Point 	= new Point();
		private static const rect:Rectangle = new Rectangle();
		
		private var fillBitmapData:BitmapData 	= null;
		
		private var fillDefaultWidth:uint 		= 0;
		private var fillDefaultHeight:uint 		= 0;
		
		private var stretchStart:uint = 0;
		private var stretchSize:uint = 0;
		
		private var direction:String = null;
		
		private var cells:Vector.<BitmapData> 	= null;
		
		public function set bitmapData (value:BitmapData):void
		{
			fillBitmapData = value;
			if (value != null)
			{
				fillDefaultWidth = value.width;
				fillDefaultHeight = value.height;
			}
			updateScaleGrid();
		}
		
		public function get defaultWidth ():uint
		{
			return fillDefaultWidth;
		}
		
		public function get defaultHeight ():uint
		{
			return fillDefaultHeight;
		}
		
		public function Scale3BitmapFill(bitmapData:BitmapData = null, stretchStart:uint = 1, stretchSize:uint = 1, direction:String = "horizontal")
		{
			cells = new Vector.<BitmapData>();
			this.stretchStart = stretchStart;
			this.stretchSize = stretchSize;
			this.direction = direction;
			this.bitmapData = bitmapData;
		}
		
		private function updateScaleGrid ():void
		{
			var col:int = 0;
			var cell:BitmapData = null;
			for each (cell in cells)
			{
				cell.dispose();
			}
			cells.length = 0;
			
			if (fillBitmapData == null)
			{
				return;
			}
			var cols:Vector.<int> = new <int>[0, stretchStart, stretchStart + stretchSize, defaultWidth];
			
			if (direction == Direction.HORIZONTAL)
			{
				for (col = 0; col < 3; col++)
				{
					rect.x 		= cols[col];
					rect.y 		= 0;
					rect.width 	= cols[col + 1] - rect.x;
					rect.height = defaultHeight;
					cell = new BitmapData(rect.width, rect.height, true, 0x00FFFFFF);
					cell.copyPixels(fillBitmapData, rect, point);
					cells[cells.length] = cell;
				}
			}
			else
			{
				for (col = 0; col < 3; col++)
				{
					rect.x 		= 0;
					rect.y 		= cols[col];
					rect.width 	= defaultWidth;
					rect.height = cols[col + 1] - rect.y;
					cell = new BitmapData(rect.width, rect.height, true, 0x00FFFFFF);
					cell.copyPixels(fillBitmapData, rect, point);
					cells[cells.length] = cell;
				}
			}
		}
		
		public override function apply (graphics:Graphics, width:uint, height:uint, clear:Boolean=true):void
		{
			var newBitmapData:BitmapData = null;
			
			if(clear)
			{
				graphics.clear();
			}
			
			if (fillBitmapData == null || width == 0 || height == 0)
			{
				return;
			}
			matrix.identity();
			
			newBitmapData = new BitmapData(width, height, true, 0x00FFFFFF);
			
			if (direction == Direction.HORIZONTAL)
			{
				hApply(newBitmapData, width);
			}
			else
			{
				vApply(newBitmapData, height);
			}
				
			
			graphics.beginBitmapFill(newBitmapData, null, true, true);
			graphics.drawRect(0, 0, width, height);
			graphics.endFill();
		}
		
		private function vApply(newBitmapData:BitmapData, height:uint):void
		{
			var rows:Vector.<int> 	= null;
			var cell:BitmapData		= null;
			
			var x:int 			= 0;
			var y:int 			= 0;
			var cellHeight:int 	= 0;
			var bottom:int 		= 0;
			
			bottom = defaultHeight - stretchSize - stretchStart;
			rows = new <int>[0, stretchStart, height - bottom, height];
			
			for (var row:int = 0; row < 3; row++)
			{
				cell = cells[row];
				
				x 			= 0;
				y 			= rows[row];
				cellHeight 	= rows[row + 1] - x;
				if ((row % 2) != 0)
				{
					matrix.identity();
					matrix.scale(1, cellHeight / cell.height);
					matrix.translate(x, y);
					newBitmapData.draw(cell, matrix);
				}
				else
				{
					point.x = x;
					point.y = y;
					newBitmapData.copyPixels(cell, cell.rect, point);
				}
			}
		}
		
		private function hApply(newBitmapData:BitmapData, width:uint):void
		{
			var cols:Vector.<int> 	= null;
			var cell:BitmapData		= null;

			var x:int 			= 0;
			var y:int 			= 0;
			var cellWidth:int 	= 0;
			var right:int 		= 0;
			
			right = defaultWidth - stretchSize - stretchStart;
			cols = new <int>[0, stretchStart, width - right, width];
			
			for (var col:int = 0; col < 3; col++)
			{
				cell = cells[col];
				
				x 			= cols[col];
				y 			= 0;
				cellWidth 	= cols[col + 1] - x;
				if ((col % 2) != 0)
				{
					matrix.identity();
					matrix.scale(cellWidth / cell.width, 1);
					matrix.translate(x, y);
					newBitmapData.draw(cell, matrix);
				}
				else
				{
					point.x = x;
					point.y = y;
					newBitmapData.copyPixels(cell, cell.rect, point);
				}
			}
		}
		
		public function finalize ():void
		{
			for each (var bitmapData:BitmapData in cells)
			{
				bitmapData.dispose();
			}
		}
	}
}