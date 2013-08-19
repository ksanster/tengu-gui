package com.tengu.gui.containers
{
	import com.tengu.gui.layouts.BaseLayout;
	import com.tengu.gui.layouts.VerticalLayout;
	
	public class VBox extends BaseBox
	{
		public function VBox()
		{
			super();
		}
		
		protected override function getLayout():BaseLayout
		{
			return new VerticalLayout();
		}
	}
}