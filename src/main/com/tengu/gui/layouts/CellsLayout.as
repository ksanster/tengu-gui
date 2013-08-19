package com.tengu.gui.layouts
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	import com.tengu.gui.containers.GUIContainer;

	public class CellsLayout extends BaseLayout
	{
		public var rowsCount:uint = 0;
		public var colsCount:uint = 0;
		
		public var cellWidth:int = 0;
		public var cellHeight:int = 0;
		
		public function CellsLayout(colsCount:uint = 1, rowsCount:uint = 1, cellWidth:int = 0, cellHeight:int = 0)
		{
			super();
			this.rowsCount = rowsCount;
			this.colsCount = colsCount;
			this.cellWidth = cellWidth;
			this.cellHeight = cellHeight;
		}
		
		public override function arrange(target:GUIContainer):Rectangle
		{
			var contentWidth:int  = target.width - paddingLeft - paddingRight;
			var contentHeight:int = target.height - paddingTop - paddingBottom;
			
			var index:int = 0;
			var i:uint = 0;
			var j:uint = 0;
			var x:int = paddingLeft;
			var y:int = paddingTop;
			
			var clip:DisplayObject = null;
			
			bounds.width = cellWidth * colsCount;
			bounds.height = cellHeight * rowsCount;
			
			for (i = 0; i < rowsCount; i++)
			{
				for (j = 0; j < colsCount; j++)
				{
					if (index >= target.numChildren)
					{
						return bounds;
					}
					clip = target.getChildAt(index);
					index++;
					clip.x = x + (cellWidth - clip.width) * .5;
					clip.y = y + (cellHeight - clip.height) * .5;
					
					x += cellWidth;
				}
				x = paddingLeft;
				y += cellHeight;
			}
			return bounds;

		}
	}
}