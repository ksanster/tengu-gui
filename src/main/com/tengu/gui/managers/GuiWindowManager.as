package com.tengu.gui.managers
{
	import com.tengu.gui.api.IWindowManager;
	import com.tengu.gui.containers.GUIContainer;
	import com.tengu.gui.enum.WindowPlacementType;
	import com.tengu.gui.layouts.WindowLayout;
	import com.tengu.gui.windows.GUIWindow;
	import com.tengu.gui.windows.IWindowData;
	import com.tengu.gui.windows.tweens.CloseWindowTween;
	import com.tengu.gui.windows.tweens.OpenWindowTween;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.filters.GlowFilter;
	
	import ru.mail.minigames.tween.Tween;
	import ru.mail.minigames.tween.TweenSystem;
	import ru.mail.minigames.tween.Tweener;

	public class GuiWindowManager extends GUIContainer implements IWindowManager
	{
		private static const BLUR:BlurFilter 		= new BlurFilter();
		private static const SHADOW:GlowFilter 		= new GlowFilter(0x000000, .3, 15, 15, 2, 3);
		private static const BLUR_FILTERS:Array 	= [];
		private static const SHADOW_FILTERS:Array 	= [];
		private static const CURSOR_GAP:uint = 20;
		
		private static const SHADOW_ALPHA:Number = .85;
		
		private var windows:Object = null;
		
		private var stageCenterX:uint = 0;
		private var stageCenterY:uint = 0;
		
		private var draggedWindow:GUIWindow = null;
		private var startX:int = 0;
		private var startY:int = 0;
		
		private var shadow:Sprite = null;
		private var windowCount:int = 0;
		
		public function GuiWindowManager()
		{
			super();
		}
		
		private function addListeners (window:GUIWindow):void
		{
			window.addEventListener(Event.CLOSE, onCloseWindow, false, int.MIN_VALUE);
			if (window.dragable)
			{
//				window.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownWindowBar);
			}
		}
		
		private function removeListeners (window:GUIWindow):void
		{
			window.removeEventListener(Event.CLOSE, onCloseWindow);
			if (window.dragable)
			{
//				window.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDownWindowBar);
			}
			if (draggedWindow == window)
			{
				stopDragWindow();
			}
		}
		
		private function stopDragWindow ():void
		{
			if (draggedWindow == null)
			{
				return;
			}
			draggedWindow.removeEventListener(MouseEvent.MOUSE_UP, onStopDrag);
			stage.removeEventListener(Event.MOUSE_LEAVE, onStopDrag);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			draggedWindow = null;
		}
		
		//TODO: написать лучше
		private function placeWindowNearCursor(window:DisplayObject):void
		{
			var windowX:uint = 0;
			var windowY:uint = 0;
			if (mouseX < stageCenterX && mouseY < stageCenterY)
			{
				windowX = mouseX + CURSOR_GAP;
				windowY = mouseY + CURSOR_GAP;
			}
			else if (mouseX >= stageCenterX && mouseY >= stageCenterY)
			{
				windowX = mouseX - window.width - CURSOR_GAP;
				windowY = mouseY - window.height - CURSOR_GAP;
			}
			else if (mouseX >= stageCenterX && mouseY < stageCenterY)
			{
				windowX = mouseX - window.width - CURSOR_GAP;
				windowY = mouseY + CURSOR_GAP;
			}
			else
			{
				windowX = mouseX + CURSOR_GAP;
				windowY = mouseY - window.height - CURSOR_GAP;
			}
			window.x = windowX;
			window.y = windowY;
		}
		
		private function animateOpen (window:GUIWindow):void
		{
			var tweener:Tweener = null;
			var tween:Tween 	= null;
			if (!window.animated || window.placement != WindowPlacementType.CENTER)
			{
				window.filters = SHADOW_FILTERS;
				return;
			}
			tweener = TweenSystem.getTweener(window);
			tweener.removeAllTweens();
			tween = tweener.addTween(18, {}, OpenWindowTween.OPEN_WINDOW_TWEEN);
			tween.addCompleteHandler(onCompleteOpen, [tween]);
		}
		
		private function onCompleteOpen (tween:Tween):void
		{
			var window:GUIWindow = tween.target as GUIWindow;
			tween.removeCompleteHandler(onCompleteOpen);
			window.filters = SHADOW_FILTERS;
		}
		
		private function animateClose (window:GUIWindow):void
		{
			var tweener:Tweener = null;
			var tween:Tween 	= null;
			if (!window.animated || window.placement != WindowPlacementType.CENTER)
			{
				removeChild(window);
				window.finalize();
				return;
			}
			tweener = TweenSystem.getTweener(window);
			tweener.removeAllTweens();
			tween = tweener.addTween(18, {}, CloseWindowTween.CLOSE_WINDOW_TWEEN);
			tween.addCompleteHandler(onCompleteClose, [tween]);
		}
		
		private function onCompleteClose (tween:Tween):void
		{
			var window:GUIWindow = tween.target as GUIWindow;
			tween.removeCompleteHandler(onCompleteClose);
			removeChild(window);
			window.finalize();
		}
		
		private function updateShadowVisibility ():void
		{
			shadow.visible = (windowCount > 0);
		}
		
		protected override function initialize():void
		{
			super.initialize();
			windows = {};
			layout = new WindowLayout();
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			mouseEnabled = false;
		}
		
		protected override function createChildren():void
		{
			super.createChildren();
			shadow = new Sprite();
			shadow.visible = false;
			addChild(shadow);
		}
		
		protected override function measure():void
		{
			percentWidth = 100;
			percentHeight = 100;
			
			minWidth  = 100;
			minHeight = 100;
			
			stageCenterX = width * .5;
			stageCenterY = height * .5;
		}
		
		protected override function updateSize():void
		{
			super.updateSize();
			var graphix:Graphics = shadow.graphics;
			graphix.clear();
			graphix.beginFill(0x000000, SHADOW_ALPHA);
			graphix.drawRect(0, 0, width, height);
			graphix.endFill();
			stageCenterX = width * .5;
			stageCenterY = height * .5;
		}
		
		
		public final function hasWindow (windowId:String):Boolean
		{
			return (windows[windowId] != null);
		}
		
		public final function openWindow (data:IWindowData):GUIWindow
		{
			var windowClass:Class = data.windowClass;
			var window:GUIWindow = windows[data.windowId];
			if (window == null)
			{
				window = new windowClass() as GUIWindow;
				window.id = data.windowId;
				windows[window.id] = window;
				addChild(window);
				
				animateOpen(window);
				
				if (window.placement != WindowPlacementType.FLOW)
				{
					invalidate(VALIDATION_FLAG_LAYOUT);
				}
				else
				{
					placeWindowNearCursor(window);
				}
				
				windowCount++;
				updateShadowVisibility();
			}
			setChildIndex(window, numChildren - 1);
			
			window.update(data);
			data.finalize();
			
			addListeners(window);
			
			return window;
		}
		
		public function closeWindow (windowId:String):GUIWindow
		{
			var window:GUIWindow = windows[windowId];
			delete windows[windowId];
			if (window == null)
			{
				return null;
			}
			if (contains(window))
			{
				animateClose(window);
				windowCount--;
				updateShadowVisibility();
			}
			removeListeners(window);
			
			return window;
		}
		
		public final function getWindowById (id:String):GUIWindow
		{
			return windows[id];
		}

		private function onCloseWindow(event:Event):void
		{
			var window:GUIWindow = event.target as GUIWindow;
			closeWindow(window.id);
		}
		
		private function onStopDragWindow(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			draggedWindow = null;
		}
		
		private function onMouseMove(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
			var xCoord:int = event.stageX;
			var yCoord:int = event.stageY;
			var windowX:int = draggedWindow.x + xCoord - startX;
			var windowY:int = draggedWindow.y + yCoord - startY;
				
			if (windowX < 0)
			{
				windowX = 0;
			}
			else if (windowX + draggedWindow.width > width)
			{
				windowX = width - draggedWindow.width;
			}
			
			if (windowY < 0)
			{
				windowY = 0;
			}
			else if (windowY + draggedWindow.height > height)
			{
				windowY = height - draggedWindow.height;
			}
			
			draggedWindow.x = windowX;
			draggedWindow.y = windowY;
				
			startX = xCoord;
			startY = yCoord;
			
			event.updateAfterEvent();
		}
		
		private function onMouseDownWindowBar(event:MouseEvent):void
		{
			stopDragWindow();
			draggedWindow = event.target.parent as GUIWindow;
			if (draggedWindow == null)
			{
				return;
			}
			stage.addEventListener(MouseEvent.MOUSE_UP, onStopDrag);
			stage.addEventListener(Event.MOUSE_LEAVE, onStopDrag);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			
			draggedWindow.placement = WindowPlacementType.FLOW;
			
			startX = event.stageX;
			startY = event.stageY;
		}
		
		private function onStopDrag(event:Event):void
		{
			stopDragWindow();
		}
		
		protected override function updateLayout():void
		{
			super.updateLayout();
		}
		
		
		private function onAddedToStage(event:Event):void
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, onClickStage, true);
		}
		
		private function onClickStage(event:MouseEvent):void
		{
			if (windowCount == 0)
			{
				return;
			}
			var topWindow:DisplayObject = getChildAt(numChildren - 1);
			if (topWindow.hitTestPoint(event.stageX, event.stageY) || !(topWindow is GUIWindow) || !(topWindow as GUIWindow).closingByOuterClick)
			{
				return;
			}
			event.stopImmediatePropagation();
			(topWindow as GUIWindow).close();
		}
	}
}