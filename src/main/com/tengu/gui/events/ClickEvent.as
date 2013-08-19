package com.tengu.gui.events
{
	import flash.events.Event;
	
	public class ClickEvent extends Event
	{
		public static const CLICK:String = "guiClick";
		
		public function ClickEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public override function clone():Event
		{
			return new ClickEvent(type, bubbles, cancelable);
		}
	}
}