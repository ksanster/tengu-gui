package com.tengu.gui.events
{
	import flash.events.Event;
	
	public class GUIMenuEvent extends Event
	{
		public static const MENU_OPEN_START:String 		= "menuOpenStart";
		public static const MENU_OPEN_FINISH:String 	= "menuOpenFinish";
		public static const MENU_CLOSE_START:String 	= "menuCloseStart";
		public static const MENU_CLOSE_FINISH:String 	= "menuCloseFinish";
		
		public function GUIMenuEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public override function clone():Event
		{
			return new GUIMenuEvent(type, bubbles, cancelable);
		}
	}
}