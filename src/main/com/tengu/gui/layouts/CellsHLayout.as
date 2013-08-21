package com.tengu.gui.layouts
{
    import com.tengu.gui.base.GUIComponent;
    import com.tengu.gui.containers.GUIContainer;
    
    import flash.display.DisplayObject;

	public class CellsHLayout extends BaseLayout
	{
		private var cellW:int = 0;
        private var cellH:int = 0;

        private var numCols:int = 0;
        private var numRows:int = 0;

        public function set cellWidth (value:int):void
        {
            cellW = value;
        }

        public function set cellHeight (value:int):void
        {
            cellH = value;
        }

		public function CellsHLayout()
		{
			super();
		}
		
		protected override function prepare(target:GUIContainer):void
		{
			super.prepare(target);
			numChildren = getNumChildren(target);
			if (numChildren == 0)
			{
				return;
			}
			cellW ||= 1;
			cellH ||= 1;
			
			numCols = noPaddingWidth / cellW;
			if (numCols < numChildren)
			{
				numRows = Math.round(numChildren / numCols);
			}
			else
			{
				numRows = 1;
			}
			contentWidth = numCols * cellW;
			contentHeight = numRows * cellH;
			
			setAlignParams(target, noPaddingWidth, noPaddingHeight);
		}

        protected override function arrangeComponents (target:GUIContainer):void
        {
			var clip:DisplayObject;
			var component:GUIComponent;
			var startX:int = horizontalAlignStart + horizontalAlignKoef * contentWidth;
			var xCoord:int = startX;
			var yCoord:int = verticalAlignStart + verticalAlignKoef * contentHeight;
			
			var colCount:int = 0;
			
			for (var i:int = 0; i < numChildren; i++)
			{
				clip = target.getChildByIndex(i) || target.getChildAt(i);
				component = clip as GUIComponent;
				if (component != null && !component.includeInLayout)
				{
					continue;
				}
				clip.x = xCoord + (cellW - clip.width) * .5;
				clip.y = yCoord + (cellH - clip.height) * .5;
				
				xCoord += cellW;
				colCount++;
				if (colCount >= numCols)
				{
					xCoord = startX;
					yCoord += cellH;
				}
			}
        }
	}
}