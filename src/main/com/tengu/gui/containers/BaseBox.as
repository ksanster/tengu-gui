package com.tengu.gui.containers
{
	import com.tengu.gui.layouts.BaseLayout;
	
	public class BaseBox extends GUIContainer
	{
		public function BaseBox()
		{
			super();
		}
		
		//Abstract
		protected function getLayout ():BaseLayout
		{
			return null;
		}
		
		protected override function createChildren():void
		{
			super.createChildren();
			layout = getLayout();
		}

	}
}