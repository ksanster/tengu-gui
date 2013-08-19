package com.tengu.gui.controls.buttons {
	import com.tengu.gui.enum.HorizontalAlign;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

	[Event(name = "change", type = "flash.events.Event")]
	public class CheckBox extends IconButton 
	{
		public function CheckBox() 
		{
			super();
		}
		
		protected override function createChildren():void 
		{
			super.createChildren();
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
