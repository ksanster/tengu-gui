package com.tengu.gui.controls
{
	import com.tengu.core.funcs.removeAllChildren;
	import com.tengu.gui.containers.GUIContainer;
	import com.tengu.gui.controls.buttons.BaseButton;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	[Style(name="button_style")]
	[Event(name="select", type="flash.events.Event")]
	public class PageIndicator extends GUIContainer
	{
		private var pageButtonStyle:String = null;
		
		protected var numberOfPages:uint = 0;
		protected var sIndex:int 		 = -1;
		
		public function set selectedIndex(value:int):void 
		{
			if (value > numberOfPages - 1)
			{
				value = numberOfPages - 1;
			}
			if (sIndex == value)
			{
				return;
			}
			sIndex = value;
			invalidate(VALIDATION_FLAG_DISPLAY);
		}
		
		public function get selectedIndex():int 
		{
			return sIndex;
		}
		
		public function set numPages(value:uint):void 
		{
			if (numberOfPages == value)
			{
				return;
			}
			numberOfPages = value;
			invalidate(VALIDATION_FLAG_DATA, VALIDATION_FLAG_LAYOUT);
		}
		
		public function get numPages():uint 
		{
			return numberOfPages;
		}
		
		public function PageIndicator()
		{
			super();
		}
		
		private function updateButtonStyle():void
		{
			for (var i:int = 0; i < numChildren; i++)
			{
				var button:BaseButton = getChildAt(i) as BaseButton;
				button.style = pageButtonStyle;
			}
		}		
		
		protected override function createChildren():void
		{
			super.createChildren();
			mouseEnabled = false;
			addEventListener(MouseEvent.CLICK, onClick);
		}
		
		protected override function dispose():void
		{
			removeEventListener(MouseEvent.CLICK, onClick);
			super.dispose();
		}
		
		protected override function setStyleSelector(styleName:String, styleValue:*):void
		{
			if (styleName == "button_style")
			{
				pageButtonStyle = styleValue;
				updateButtonStyle();
				return;
			}
			super.setStyleSelector(styleName, styleValue);
		}
		
		protected override function updateData():void
		{
			super.updateData();
			var button:BaseButton = null;
			removeAllChildren(this, disposeComponent);
			for (var i:int = 0; i < numberOfPages; i++)
			{
				button = new BaseButton();
				button.toggle = true;
				button.style = pageButtonStyle;
				addChild(button);
			}
		}
		
		protected override function updateDisplay():void
		{
			super.updateDisplay();
			var button:BaseButton = null;
			for (var i:int = 0; i < numChildren; i++)
			{
				button = getChildAt(i) as BaseButton;
				button.selected = (i == sIndex);
				button.enabled = !button.selected;
			}
			
		}
		
		private function onClick(event:MouseEvent):void
		{
			var button:BaseButton = (event.target as BaseButton);
			if (button == null)
			{
				return;
			}
			button.enabled = false;
			selectedIndex = getChildIndex(button);
			if (hasEventListener(Event.SELECT))
			{
				dispatchEvent(new Event(Event.SELECT));
			}
		}
		
	}
}