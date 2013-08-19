package com.tengu.gui.events
{
	import flash.events.Event;
	
	public class SelectedIndexChangeEvent extends Event
	{
		public static const SELECTED_INDEX_CHANGE:String = "selectedIndexChange";
		
		public var selectedIndex:int = -1;
		public function SelectedIndexChangeEvent(type:String, selectedIndex:int, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.selectedIndex = selectedIndex;
		}
		
		public override function clone():Event
		{
			return new SelectedIndexChangeEvent(type, selectedIndex, bubbles, cancelable);
		}
	}
}