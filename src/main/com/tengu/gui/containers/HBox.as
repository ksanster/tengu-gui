package com.tengu.gui.containers
{
	import com.tengu.gui.layouts.BaseLayout;
	import com.tengu.gui.layouts.HorizontalLayout;
	
	public class HBox extends BaseBox
	{
		public function HBox()
		{
			super();
		}
		
		protected override function getLayout ():BaseLayout
		{
			return new HorizontalLayout();
		}
	}
}