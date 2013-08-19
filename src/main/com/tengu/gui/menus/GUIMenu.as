package com.tengu.gui.menus
{
	import com.tengu.gui.base.GUIComponent;
	import com.tengu.gui.enum.MenuState;
	import com.tengu.gui.events.GUIMenuEvent;
	import com.tengu.tween.Tween;
	import com.tengu.tween.TweenSystem;
	import com.tengu.tween.enum.TweenType;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	[Event(name="menuOpenStart",  	type="com.tengu.gui.events.GUIMenuEvent")]
	[Event(name="menuOpenFinish",  	type="com.tengu.gui.events.GUIMenuEvent")]
	[Event(name="menuCloseStart",  	type="com.tengu.gui.events.GUIMenuEvent")]
	[Event(name="menuCloseFinish", 	type="com.tengu.gui.events.GUIMenuEvent")]
	public class GUIMenu extends GUIComponent
	{
		private var menuState:String = null;
		private var scrollRectY:Number = 0;
		
		private var closeTimer:Timer = null;
		
		private var hasStageListener:Boolean = false;

		protected function get minRectSize():Number 
		{
			return 0;
		}
		
		protected function get maxRectSize():Number 
		{
			return componentHeight;
		}
		
		public function set scrollY(value:Number):void 
		{
			scrollRectY = value;
			scrollRect = new Rectangle(0, value, componentWidth, componentHeight);
		}
		
		public function get scrollY():Number 
		{
			return scrollRectY;
		}
		
		public function set state(value:String):void 
		{
			menuState = value;
		}
		
		public function get state():String 
		{
			return menuState;
		}
		
		public function GUIMenu()
		{
			super();
		}
		
		protected function dispatchMenuEvent(type:String):void
		{
			if (hasEventListener(type))
			{
				dispatchEvent(new GUIMenuEvent(type));
			}
		}
		
		protected function mouseOnMenu ():Boolean
		{
			if (stage == null)
			{
				return false;
			}
			return getBounds(stage).contains(stage.mouseX, stage.mouseY);
		}
		
		protected override function createChildren():void
		{
			super.createChildren();
			menuState = MenuState.CLOSED;

			closeTimer = new Timer(0);
			closeTimer.addEventListener(TimerEvent.TIMER, onCloseByTimer);
			
			addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			
			scrollY = maxRectSize;
		}
		
		protected override function dispose ():void
		{
			closeTimer.reset();
			closeTimer.removeEventListener(TimerEvent.TIMER, onCloseByTimer);

			removeEventListener(MouseEvent.ROLL_OVER, onRollOver);
			TweenSystem.getTweener(this).removeAllTweens();
			
			if (hasStageListener)
			{
				stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				stage.removeEventListener(Event.MOUSE_LEAVE, onMouseLeave);
				hasStageListener = false;
			}

			super.dispose();
		}
		
		public function open (closeTimeout:uint = 0):void
		{
			var tween:Tween = null;
			state = MenuState.OPENED;
			dispatchMenuEvent(GUIMenuEvent.MENU_OPEN_START);
			if (parent == null)
			{
				scrollY = 0;
				return;
			}
			closeTimer.delay = closeTimeout;
			TweenSystem.getTweener(this).removeAllTweens();
			tween = TweenSystem.getTweener(this).addTween(TweenType.PROPERTY, 18, {scrollY: minRectSize});
			tween.addCompleteHandler(onCompleteTween, [tween]);
		}
		
		public function close ():void
		{
			var tween:Tween = null;
			closeTimer.reset();
			state = MenuState.CLOSED;
			dispatchMenuEvent(GUIMenuEvent.MENU_CLOSE_START);
			if (hasStageListener)
			{
				stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				stage.removeEventListener(Event.MOUSE_LEAVE, onMouseLeave);
				hasStageListener = false;
			}

			if (parent == null)
			{
				scrollY = componentHeight;
				return;
			}
			TweenSystem.getTweener(this).removeAllTweens();
			tween = TweenSystem.getTweener(this).addTween(TweenType.PROPERTY, 18, {scrollY: maxRectSize});
			tween.addCompleteHandler(onCompleteTween, [tween]);
		}
		
		
		private function onRollOver(event:MouseEvent):void
		{
			if (state == MenuState.CLOSED)
			{
				open();
			}
		}
		
		private function onMouseUp(event:MouseEvent):void
		{
			if (!mouseOnMenu())
			{
				close();
			}
		}
		
		private function onMouseLeave (event:Event):void
		{
			close();
		}
		
		private function onCompleteTween(tween:Tween):void
		{
			TweenSystem.getTweener(this).removeTween(tween);
			if (!hasStageListener)
			{
				stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				stage.addEventListener(Event.MOUSE_LEAVE, onMouseLeave);
				hasStageListener = true;
			}

			if (closeTimer.delay > 0)
			{
				closeTimer.reset();
				closeTimer.start();
			}
			
			if (state == MenuState.CLOSED)
			{
				dispatchMenuEvent(GUIMenuEvent.MENU_CLOSE_FINISH);
				return;
			}
			else
			{
				dispatchMenuEvent(GUIMenuEvent.MENU_OPEN_FINISH);
			}
		}
		
		private function onCloseByTimer(event:TimerEvent):void
		{
			closeTimer.reset();
			if (!mouseOnMenu())
			{
				close();
			}
			else
			{
				closeTimer.start();
			}
		}
	}
}