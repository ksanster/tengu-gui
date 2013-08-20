package com.tengu.gui.layouts
{
    import com.tengu.gui.base.GUIComponent;

    import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	import com.tengu.gui.containers.GUIContainer;

	public class CellsLayout extends BaseLayout
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

		public function CellsLayout()
		{
			super();
		}

        override protected function arrangeComponents (target:GUIContainer):void
        {
        }
	}
}