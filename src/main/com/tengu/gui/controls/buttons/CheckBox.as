package com.tengu.gui.controls.buttons {
	import com.tengu.gui.enum.HorizontalAlign;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

	[Event(name = "change", type = "flash.events.Event")]
	public class CheckBox extends IconButton 
	{
		
		protected override function get defaultStyleName():String
		{
			return "CheckBox";
		}
		
		public function CheckBox() 
		{
			super();
		}
		
		protected override function createChildren():void 
		{
			super.createChildren();
            downDeltaY = 0;
			toggle = true;
			layout.horizontalAlign = HorizontalAlign.LEFT;
		}

		protected override function onMouseUp(event : MouseEvent):void 
		{
			super.onMouseUp(event);
			dispatchEvent(new Event(Event.CHANGE));
		}
	}
}
