package com.tengu.gui.fills
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	//TODO: colls и rows перепутаны - поменять идентификаторы
	public class Scale9BitmapFill extends ShapeFill
	{
		private static const matrix:Matrix 	= new Matrix();
		private static const point:Point 	= new Point();
		private static const rect:Rectangle = new Rectangle();
		
		private var fillBitmapData:BitmapData 	= null;
		
		private var fillScaleGrid:Rectangle		= null;
		
		private var fillDefaultWidth:uint 		= 0;
		private var fillDefaultHeight:uint 		= 0;
		
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
		
		public function set scaleGrid (value:Rectangle):void
		{
			if (value != null && (value.x < 0 || value.y < 0 || value.right > defaultWidth || value.bottom > defaultHeight))
			{
				throw new ArgumentError("Grid points must be in bitmap");
			}
			fillScaleGrid = value;
			updateScaleGrid();
		}
		
		public function Scale9BitmapFill(bitmapData:BitmapData = null, scaleGrid:Rectangle = null)
		{
			cells = new Vector.<BitmapData>();
			this.bitmapData = bitmapData;
			this.scaleGrid = scaleGrid;
		}
		
		private function updateScaleGrid ():void
		{
			var cell:BitmapData = null;
			for each (cell in cells)
			{
				cell.dispose();
			}
			cells.length = 0;
			
			if (fillScaleGrid == null || fillBitmapData == null)
			{
				return;
			}
			var cols:Vector.<int> = new <int>[0, fillScaleGrid.left, fillScaleGrid.width + fillScaleGrid.left, defaultWidth];
			var rows:Vector.<int> = new <int>[0, fillScaleGrid.top, fillScaleGrid.height + fillScaleGrid.top, defaultHeight];
			
			for (var col:int = 0; col < 3; col++)
			{
				for (var row:int = 0; row < 3; row++)
				{
					rect.x 		= cols[col];
					rect.y 		= rows[row];
					rect.width 	= cols[col + 1] - rect.x;
					rect.height = rows[row + 1] - rect.y;
					cell = new BitmapData(rect.width, rect.height, true, 0x00FFFFFF);
					cell.copyPixels(fillBitmapData, rect, point);
					cells[cells.length] = cell;
				}
			}
		}
		
		public override function apply (graphics:Graphics, width:uint, height:uint, clear:Boolean=true):void
		{
			var cols:Vector.<int> 	= null;
			var rows:Vector.<int> 	= null;
			var cell:BitmapData		= null;
			
			var x:int 			= 0;
			var y:int 			= 0;
			var cellWidth:int 	= 0;
			var cellHeight:int 	= 0;
			var right:int 		= 0;
			var bottom:int 		= 0;
			
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
			
			right = defaultWidth - fillScaleGrid.width - fillScaleGrid.left;
			bottom = defaultHeight - fillScaleGrid.height - fillScaleGrid.top;
			cols = new <int>[0, fillScaleGrid.left, width - right, width];
			rows = new <int>[0, fillScaleGrid.top, height - bottom, height];
			
			for (var col:int = 0; col < 3; col++)
			{
				for (var row:int = 0; row < 3; row++)
				{
					cell = cells[col * 3 + row];
					
					x 			= cols[col];
					y 			= rows[row];
					cellWidth 	= cols[col + 1] - x;
					cellHeight 	= rows[row + 1] - y;
					if ((col % 2) != 0 || (row % 2) != 0)
					{
						matrix.identity();
						matrix.scale(cellWidth / cell.width, cellHeight / cell.height);
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
			graphics.beginBitmapFill(newBitmapData, null, true, true);
			graphics.drawRect(0, 0, width, height);
			graphics.endFill();
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