package com.tengu.gui.controls.buttonbar
{
	import com.tengu.gui.controls.buttonbar.ButtonGroup;
	import com.tengu.gui.enum.HorizontalAlign;
	import com.tengu.gui.layouts.BaseLayout;
	import com.tengu.gui.layouts.VerticalLayout;
	
	public class RadioGroup extends ButtonGroup
	{
		public function RadioGroup()
		{
			super();
		}

		protected override function getLayout():BaseLayout
		{
			var vLayout:VerticalLayout = new VerticalLayout();
			vLayout.horizontalAlign = HorizontalAlign.LEFT;
			vLayout.gap = 5;
			return vLayout;
		}
	}
}