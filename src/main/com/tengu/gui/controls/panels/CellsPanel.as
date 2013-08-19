package com.tengu.gui.controls.panels
{
	import com.tengu.gui.layouts.BaseLayout;
	import com.tengu.gui.layouts.CellsLayout;

	public class CellsPanel extends ItemsPanel
	{
		protected var rowsCount:uint = 0;
		protected var colsCount:uint = 0;
		
		public function CellsPanel(rows:uint, cols:uint)
		{
			this.rowsCount = rows;
			this.colsCount = cols;
			super();
		}
		
		protected override function getLayout ():BaseLayout
		{
			return new CellsLayout(rowsCount, colsCount, 5, 15);
		}
		
		protected override function getItemsOnPage():uint
		{
			return rowsCount * colsCount;
		}
	}
}