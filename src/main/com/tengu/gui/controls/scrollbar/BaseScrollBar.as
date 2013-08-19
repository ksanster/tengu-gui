package com.tengu.gui.controls.scrollbar
{
	import com.tengu.core.tengu_internal;
	import com.tengu.gui.base.GUIComponent;
	import com.tengu.gui.controls.buttons.BaseButton;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	
	[Style(name="prev_button")]
	[Style(name="next_button")]
	[Style(name="thumb_button")]
	[Style(name="track_button")]
	[Style(name="thumb_icon")]
	[Style(name="button_size")]
	public class BaseScrollBar extends GUIComponent
	{
		private var scrollStep:Number 	  = .01;
		
		private var inDragMode:Boolean = false;
		
		private var minValue:Number 	= 0;
		private var maxValue:Number 	= 1;
		private var currentValue:Number = 0;
		
		private var scrollTarget:IEventDispatcher = null;

		protected var dragCoord:Number   	= 0;
		protected var scrollPosition:Number = 0;
		protected var scrollPageSize:Number = .1;
		
		protected var prevButton:BaseButton  = null;
		protected var nextButton:BaseButton  = null;
		protected var trackButton:BaseButton = null;
		protected var thumbButton:BaseButton = null;
		protected var thumbButtonIcon:Bitmap = null;
		
		
		public function set enabled(value:Boolean):void 
		{
			prevButton.enabled = value;
			nextButton.enabled = value;
			trackButton.enabled = value;
			thumbButton.visible = value;
			thumbButtonIcon.visible = value;
		}
		
		public function set min(value:Number):void 
		{
			if (maxValue == minValue)
			{
				throw new ArgumentError("Min and max values cannot be equals"); 
			}
			minValue = value;
			updateThumbSize();
		}
		
		public function get min():Number 
		{
			return minValue;
		}
		
		public function set max(value:Number):void 
		{
			if (maxValue == minValue)
			{
				throw new ArgumentError("Min and max values cannot be equals"); 
			}
			maxValue = value;
			position = Math.min(maxValue, position);
			updateThumbSize();
		}
		
		public function get max():Number 
		{
			return maxValue;
		}
		
		public function set position(value:Number):void 
		{
			currentValue = value;
			scrollPosition = (currentValue - minValue) / (maxValue - minValue);
			updateThumbPosition();
			dispatchChange();
		}

		public function get position():Number 
		{
			return currentValue;
		}
		
		public function set pageSize(value:Number):void 
		{
			scrollPageSize = value;
			updateThumbSize();
		}
		
		public function get pageSize():Number 
		{
			return scrollPageSize;
		}
		
		public function set step(value:Number):void 
		{
			scrollStep = value;
		}
		
		public function set target(value : IEventDispatcher):void
		{
			if(scrollTarget != null)
			{
				scrollTarget.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			}
			scrollTarget = value;
			if(scrollTarget != null)
			{
				scrollTarget.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			}
		}
		
		public function get target():IEventDispatcher
		{
			return scrollTarget;
		}		

		public function BaseScrollBar()
		{
			super();
		}
		
		private function normalizeScroll ():void
		{
			if (scrollPosition < 0)
			{
				scrollPosition = 0;
			}
			else if (scrollPosition > 1)
			{
				scrollPosition = 1;
			}
		}
		
		private function dispatchChange ():void
		{
			if (hasEventListener(Event.CHANGE))
			{
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		private function calcCurrentValue ():void
		{
			currentValue = minValue + scrollPosition * (maxValue - minValue);
		}
		
		protected function updateThumbSize ():void
		{
			updateThumbIcon();
		}
		
		protected function updateThumbPosition ():void
		{
			updateThumbIcon();
		}
		
		protected function updateThumbIcon ():void
		{
			thumbButtonIcon.x = thumbButton.x + int((thumbButton.width - thumbButtonIcon.width) * .5);
			thumbButtonIcon.y = thumbButton.y + int((thumbButton.height - thumbButtonIcon.height) * .5);
		}
		
		protected override function createChildren():void
		{
			super.createChildren();
			
			prevButton = new BaseButton();
			prevButton.useHandCursor = false;
			prevButton.addEventListener(MouseEvent.CLICK, onClickPrevButton);
			addChild(prevButton);
			
			trackButton = new BaseButton();
			trackButton.useHandCursor = false;
			trackButton.addEventListener(MouseEvent.CLICK, onClickTrackButton);
			addChild(trackButton);
			
			nextButton = new BaseButton();
			nextButton.useHandCursor = false;
			nextButton.addEventListener(MouseEvent.CLICK, onClickNextButton);
			addChild(nextButton);
			
			thumbButton = new BaseButton();
			thumbButton.useHandCursor = false;
			thumbButton.addEventListener(MouseEvent.MOUSE_DOWN, onDownThumbButton);
			addChild(thumbButton);
			
			thumbButtonIcon = new Bitmap();
			addChild(thumbButtonIcon);
			
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
			addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		}
		
		protected override function updateDisplay():void
		{
			super.updateDisplay();
			updateThumbPosition();
		}
		
		protected override function dispose():void
		{
			prevButton.removeEventListener(MouseEvent.CLICK, onClickPrevButton);
			prevButton.finalize();
			prevButton = null;
			
			trackButton.removeEventListener(MouseEvent.CLICK, onClickTrackButton);
			trackButton.finalize();
			trackButton = null;
			
			nextButton.removeEventListener(MouseEvent.CLICK, onClickNextButton);
			nextButton.finalize();
			nextButton = null;
			
			thumbButton.removeEventListener(MouseEvent.MOUSE_DOWN, onDownThumbButton);
			thumbButton.finalize();
			thumbButton = null;
			
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
			removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			
			target = null;
			
			super.dispose();
		}
		
		protected override function setStyleSelector(styleName:String, styleValue:*):void
		{
			var size:uint = 0;
			if (styleName == "prev_button")
			{
				prevButton.tengu_internal::parseStyle(styleValue);
				return;
			}
			if (styleName == "next_button")
			{
				nextButton.tengu_internal::parseStyle(styleValue);
				return;
			}
			if (styleName == "track_button")
			{
				trackButton.tengu_internal::parseStyle(styleValue);
				return;
			}
			if (styleName == "thumb_button")
			{
				thumbButton.tengu_internal::parseStyle(styleValue);
				return;
			}
			if (styleName == "thumb_icon")
			{
				thumbButtonIcon.bitmapData = textureManager.getIcon(styleValue);
				return;
			}
			if (styleName == "button_size")
			{
				size = parseInt(String(styleValue));
				prevButton.setSize(size, size);
				nextButton.setSize(size, size);
				return;
			}
		}
		
		private function onRemoveFromStage(event:Event):void
		{
			if (inDragMode)
			{
				onStopDrag();
			}
		}
		
		private function onStopDrag(event:Event = null):void
		{
			inDragMode = false;
			stage.removeEventListener(Event.MOUSE_LEAVE, onStopDrag);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onStopDrag);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onDrag);
		}
		
		private function onClickPrevButton(event:MouseEvent):void
		{
			scrollPosition -= scrollStep / (maxValue - minValue);	
			normalizeScroll();
			calcCurrentValue();
			invalidateDisplay();
			dispatchChange();
		}
		
		private function onClickNextButton(event:MouseEvent):void
		{
			scrollPosition += scrollStep / (maxValue - minValue);	
			normalizeScroll();
			calcCurrentValue();
			invalidateDisplay();
			dispatchChange();
		}
		
		protected function onClickTrackButton(event:MouseEvent):void
		{
			normalizeScroll();
			calcCurrentValue();
			updateThumbPosition();
			dispatchChange();
		}
		
		protected function onDownThumbButton(event:MouseEvent):void
		{
			inDragMode = true;
			stage.addEventListener(Event.MOUSE_LEAVE, onStopDrag);
			stage.addEventListener(MouseEvent.MOUSE_UP, onStopDrag);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onDrag);
		}
		
		protected function onDrag(event:MouseEvent):void
		{
			calcCurrentValue();
			updateThumbPosition();			
			dispatchChange();
		}

		private function onMouseWheel(event : MouseEvent):void
		{
			var normalDelta : Number = event.delta / Math.abs(event.delta);
			scrollPosition +=  -normalDelta * scrollStep / (maxValue - minValue);	
			normalizeScroll();
			calcCurrentValue();
			invalidateDisplay();
			dispatchChange();
		}
	}
}