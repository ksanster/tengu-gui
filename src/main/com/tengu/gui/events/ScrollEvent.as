package com.tengu.gui.events
{
	import flash.events.Event;
	
	public class ScrollEvent extends Event
	{
		public static const SCROLL_SELECT:String 		= "scrollSelect";
		public static const DATASOURCE_CHANGED:String 	= "datasourceChanged";
		
		public var selectedItem:Object = null;
		
		public function ScrollEvent(type:String, selectedItem:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.selectedItem = selectedItem;
		}
		
		public override function clone():Event
		{
			return new ScrollEvent(type, selectedItem, bubbles, cancelable);
		}
	}
}