package com.tengu.gui.screens
{
	import flash.events.Event;
	
	public class ScreenNavigatorEvent extends Event
	{
		public static const INVOKE_SCREEN:String = "invokeScreen";
		public static const RETURN_TO_PREVIOUS:String = "returnToPrevious";
		
		public var screenId:String = null;
		public var direction:String = null;
		public function ScreenNavigatorEvent(type:String, screenId:String = null, direction:String = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.screenId = screenId;
			this.direction = direction;
		}
		
		public override function clone():Event
		{
			return new ScreenNavigatorEvent(type, screenId, direction, bubbles, cancelable);
		}
	}
}