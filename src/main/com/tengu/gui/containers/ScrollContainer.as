package com.tengu.gui.containers
{
	import com.tengu.gui.base.GUIComponent;
	import com.tengu.gui.enum.ScrollPolicy;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import ru.mail.minigames.tween.TweenSystem;
	import ru.mail.minigames.tween.Tweener;
	
	[Event(name="change", type="flash.events.Event")]
	public class ScrollContainer extends GUIComponent
	{
		private static const MIN_TOUCH_TIME:uint = 30;
		private static const POINT:Point = new Point();
		
		private static const DEFAULT_OFFBOUND:int = 40;
		private static const MIN_FREE_SLIDE_VALUE:uint = 3;
		
		protected static const EASING:Number = .75;
		protected static const EASE_TIME:uint = 7;
		
		private var rectangle:Rectangle = new Rectangle();
		
		private var inFreeSlide:Boolean = false;
		
		private var touchStartTime:uint = 0;
		
		private var startX:Number = 0;
		private var startY:Number = 0;
		private var tweenX:Number = 0;
		private var tweenY:Number = 0;
		
		private var policy:String	 = null;
		private var canMoveX:Boolean = true;
		private var canMoveY:Boolean = true;
		
		private var inDrag:Boolean = false;
		
		protected var offBound:int = 0;
		
		protected var tweener:Tweener = null;
		protected var sViewport:DisplayObject = null;

		
		public function set viewport(value:DisplayObject):void 
		{
			if (sViewport != null)
			{
				TweenSystem.removeTweener(sViewport);
				endDrag();
				removeChild(sViewport);
			}
			sViewport = value;
			viewportX = preventOutOfXBound(sViewport.x, false);
			viewportY = preventOutOfYBound(sViewport.y, false);
			addChild(sViewport);
		}
		
		public function set scrollPolicy(value:String):void 
		{
			policy = value;
			invalidate(VALIDATION_FLAG_DATA);
		}
		
		public function get viewport():DisplayObject 
		{
			return sViewport;
		}
		
		public function set viewportX(value:Number):void 
		{
			sViewport.x = value + componentPaddingLeft;
		}
		
		public function get viewportX():Number 
		{
			return sViewport.x - componentPaddingLeft;
		}
		
		public function set viewportY(value:Number):void 
		{
			sViewport.y = value + componentPaddingTop;
		}
		
		public function get viewportY():Number 
		{
			return sViewport.y - componentPaddingTop;
		}
		
		public function ScrollContainer()
		{
			super();
		}
		
		private function containsTouch(xCoord:int, yCoord:int):Boolean
		{
			var point:Point = localToGlobal(POINT);
			rectangle.x = point.x;
			rectangle.y = point.y;
			rectangle.width = width;
			rectangle.height = height;
			return rectangle.contains(xCoord, yCoord)
		}

		protected function endDrag():void
		{
			if (!inDrag)
			{
				return;
			}

			inDrag = false;
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onTouchMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onTouchEnd);
		}
		
		protected function endFreeSlide():void
		{
			if (!inFreeSlide)
			{
				return;
			}
			inFreeSlide = false;
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		protected function finalizeDrag():void
		{
			if (!returnToBounds())
			{
				inFreeSlide = true;
				addEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
		}		
		
		protected function returnToBounds():Boolean
		{
			var targetX:int = preventOutOfXBound(viewportX, false);
			var targetY:int = preventOutOfYBound(viewportY, false);
			
			if (targetX != viewportX || targetY != viewportY)
			{
				tweener.removeAllTweens();
				tweener.addTween(EASE_TIME, {viewportX:targetX, viewportY:targetY});
				return true;
			}
			return false;
		}
		
		protected function preventOutOfXBound(targetX:int, usePaddings:Boolean):int
		{
			var lpadding:int = usePaddings ? offBound : 0;
			var rpadding:int = usePaddings ? - offBound : 0;
			if (policy == ScrollPolicy.VERTICAL)
			{
				targetX = (width - sViewport.width) * .5;
			}
			else if (width >= sViewport.width)
			{
				targetX = 0;
			}
			else if (targetX > lpadding)
			{
				targetX = lpadding;
			}
			else if (targetX < (width + rpadding - sViewport.width - componentPaddingRight))
			{
				targetX = width + rpadding - sViewport.width - componentPaddingRight;
			}
			
			return targetX;
		}		
		
		protected function preventOutOfYBound(targetY:int, usePaddings:Boolean):int
		{
			var tpadding:int = usePaddings ? offBound : 0;
			var bpadding:int = usePaddings ? - offBound : 0;
			if (policy == ScrollPolicy.HORIZONTAL)
			{
				targetY = (height - sViewport.height) * .5;
			}
			else if (height >= sViewport.height)
			{
				targetY = 0;
			}
			else if (targetY > tpadding)
			{
				targetY = tpadding;
			}
			else if (targetY < (height + bpadding - sViewport.height))
			{
				targetY = height + bpadding - sViewport.height;
			}
			return targetY;
		}		
		
		protected override function createChildren():void
		{
			super.createChildren();
			
			offBound = DEFAULT_OFFBOUND;
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			
			tweener = TweenSystem.getTweener(this);
		}
		
		protected override function dispose():void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			tweener.removeAllTweens();
			
			if (inFreeSlide)
			{
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
			if (sViewport != null)
			{
				TweenSystem.removeTweener(this);
				tweener = null;
				sViewport = null;
			}
			super.dispose();
		}
		
		protected override function updateData():void
		{
			super.updateData();
			switch (policy)
			{
				case ScrollPolicy.HORIZONTAL:
					canMoveX = true;
					canMoveY = false;
					break;
				case ScrollPolicy.VERTICAL:
					canMoveX = false;
					canMoveY = true;
					break;
				case ScrollPolicy.NONE:
					canMoveX = false;
					canMoveY = false;
					break;
				default:
					canMoveX = true;
					canMoveY = true;
					break;
			}
		}
		
		protected override function updateSize():void
		{
			super.updateSize();
			if (sViewport != null)
			{
				viewportX = preventOutOfXBound(sViewport.x, false);
				viewportY = preventOutOfYBound(sViewport.y, false);
			}
		}
		
		public function stopScroll ():void
		{
			endDrag();
		}
		
		protected function onTouchBegin(event:MouseEvent):void
		{
			var xCoord:uint = event.stageX;
			var yCoord:uint = event.stageY;
			if (sViewport == null || inDrag || !containsTouch(xCoord, yCoord))
			{
				return;
			}
			
			touchStartTime = getTimer();
			
			tweener.removeAllTweens();
			endFreeSlide();
			
			inDrag = true;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onTouchMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onTouchEnd);
			
			startX = xCoord;
			startY = yCoord;
		}
		
		protected function onTouchMove(event:MouseEvent):void
		{
			var xCoord:uint = event.stageX;
			var yCoord:uint = event.stageY;

			if (canMoveX)
			{
				viewportX = preventOutOfXBound(viewportX + tweenX, true);
				tweenX = xCoord - startX;
				startX = xCoord;
			}
			if (canMoveY)
			{
				viewportY = preventOutOfYBound(viewportY + tweenY, true);
				tweenY = yCoord - startY;
				startY = yCoord;
			}
			
		}
		
		protected function onTouchEnd(event:MouseEvent):void
		{
			endDrag();
			if ((getTimer() - touchStartTime) < MIN_TOUCH_TIME)
			{
				return;
			}
			finalizeDrag();
		}
		
		private function onAddedToStage(event:Event):void
		{
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onTouchBegin);
			
		}
		
		private function onRemovedFromStage(event:Event):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, onTouchBegin);
			endDrag();
		}
		
		private function onEnterFrame(event:Event):void
		{
			var newX:int = viewportX + tweenX;
			var newY:int = viewportY + tweenY;
			var inBoundsX:int = preventOutOfXBound(newX, false);
			var inBoundsY:int = preventOutOfYBound(newY, false);
			
			viewportX = inBoundsX;
			viewportY = inBoundsY;
			if (newX != inBoundsX)
			{
				tweenX = 0;
			}
			
			if (newY != inBoundsY)
			{
				tweenY = 0;				
			}
			
			tweenX *= EASING;
			tweenY *= EASING;
			
			if (isZero(tweenX) && isZero(tweenY))
			{
				inFreeSlide = false;
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				returnToBounds();
			}
		}
		
		private function isZero(value:Number):Boolean
		{
			if (value < 0)
			{
				value = - value;
			}
			return value < .01;
		}
	}
}