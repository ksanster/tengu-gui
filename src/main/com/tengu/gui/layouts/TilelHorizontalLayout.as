package com.tengu.gui.layouts
{
	import com.tengu.gui.base.GUIComponent;
	import com.tengu.gui.containers.GUIContainer;
	
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;

	public class TilelHorizontalLayout extends BaseLayout
	{
		private var autoGap:Boolean = false;
		
		private var vPercentGap:int = 0;
		
		public function set verticalPercentGap(value:int):void 
		{
			vPercentGap = value;
		}
		
		public function set isAutoGap(value:Boolean):void 
		{
			autoGap = value;
		}
		
		public function TilelHorizontalLayout()
		{
			super();
		}
		
	}
}