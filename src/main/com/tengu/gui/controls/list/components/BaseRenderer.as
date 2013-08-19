package com.tengu.gui.controls.list.components
{
	import com.tengu.gui.base.GUIComponent;
	
	public class BaseRenderer extends GUIComponent implements IBaseRenderer
	{
		private var rendererData:Object = null;
		private var isSelected:Boolean 	= false;
		
		public function get data ():Object
		{
			return rendererData;
		}
		
		public function set data(value:Object):void 
		{
			if (rendererData == value)
			{
				return;
			}
			clear();
			rendererData = value;
			invalidate(VALIDATION_FLAG_DATA, VALIDATION_FLAG_LAYOUT, VALIDATION_FLAG_DISPLAY);
		}
		
		public function get selected():Boolean 
		{
			return isSelected;
		}
		
		public function set selected(value:Boolean):void 
		{
			if (isSelected == value)
			{
				return;
			}
			isSelected = value;
			invalidate(VALIDATION_FLAG_DISPLAY);
		}
		
		public function BaseRenderer()
		{
			super();
		}
		
		protected override function dispose():void
		{
			rendererData = null;
			super.dispose();
		}
		
		public function clear():void
		{
			
		}
	}
}