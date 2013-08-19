package com.tengu.gui.events
{
	import flash.events.Event;
	
	public final class PageNavigatorEvent extends Event
	{
		
		static public const PAGE_UP : String = "on PageUp";
		static public const PAGE_DOWN : String = "on PageDown";
		
		public function PageNavigatorEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}