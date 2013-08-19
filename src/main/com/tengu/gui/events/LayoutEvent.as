package com.tengu.gui.events
{
	import flash.events.Event;
	
	public class LayoutEvent extends Event
	{
		public static const LAYOUT_CHANGE:String = "layoutChange";
		
		public function LayoutEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public override function clone():Event
		{
			return new LayoutEvent(type, bubbles, cancelable);
		}
	}
}