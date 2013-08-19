package com.tengu.gui.controls.panels
{
	
	public class CellsPageNavigator extends PageNavigator
	{
		public function CellsPageNavigator(rows:uint, cols:uint)
		{
			super(new CellsPanel(rows, cols));
		}
	}
}