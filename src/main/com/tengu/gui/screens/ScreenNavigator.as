package com.tengu.gui.screens
{
	import com.tengu.core.funcs.removeAllChildren;
	import com.tengu.gui.base.GUIComponent;
	import com.tengu.tween.Tween;
	import com.tengu.tween.Tweeny;
	import com.tengu.tween.api.ITween;
	import com.tengu.tween.plugins.DisplayCoordsTween;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class ScreenNavigator extends GUIComponent
	{
		private static const TWEEN_TIME:uint = 7;

		private var holder:Sprite = null;
		private var activeScreen:GUIComponent = null;
		
		private var screenClasses:Object 	= null;
		private var activeScreenId:String	= null;
		private var screenParams:Object 	= null;
		private var screenHash:Object		= null;
		
		private var screenToReturn:String 	= null;
		private var directionToReturn:String = null;
		
		public function get currentScreenId():String 
		{
			return activeScreenId;
		}
		
		public function ScreenNavigator()
		{
			super();
		}
		
		private function createScreen (id:String):GUIComponent
		{
			if (screenClasses[id] == null)
			{
				throw new Error("Screen with id=" + id + "not registered");
			}
			var screen:GUIComponent = screenHash[id];
			if (screen == null)
			{
				var screenClass:Class = screenClasses[id];
				var params:Object = screenParams[id];
				screen = new screenClass();
				screen.addEventListener(ScreenNavigatorEvent.INVOKE_SCREEN, onInvokeScreen);
				screen.addEventListener(ScreenNavigatorEvent.RETURN_TO_PREVIOUS, onInvokePreviousScreen);
				screen.setSize(width, height);
				for (var key:String in params)
				{
					if (screen.hasOwnProperty(key))
					{
						screen[key] = params[key];
					}
				}
				screenHash[id] = screen;
			}
			screen.x = 0;
			screen.y = 0;
			return screen;
		}
		
		protected override function createChildren():void
		{
			super.createChildren();
			holder = new Sprite();
			holder.mouseEnabled = false;
			addChild(holder);
			
			screenClasses 	= {};
			screenHash		= {};
			screenParams	= {};
		}	
		
		protected override function dispose():void
		{
			for each (var screen:GUIComponent in screenHash)
			{
				screen.removeEventListener(ScreenNavigatorEvent.INVOKE_SCREEN, onInvokeScreen);
				screen.removeEventListener(ScreenNavigatorEvent.RETURN_TO_PREVIOUS, onInvokePreviousScreen);
				screen.finalize();
			}
			
			Tweeny.killOf(holder);

			activeScreen 	= null;
			screenClasses 	= null;
			screenParams 	= null;
			screenHash 		= null;
			
			super.dispose();
		}
		
		protected override function updateSize():void
		{
			super.updateSize();
			if (activeScreen != null)
			{
				activeScreen.setSize(width, height);
			}
		}
		
		public function registerScreen (id:String, screenClass:Class, params:Object = null):void
		{
			screenClasses[id] = screenClass;
			screenParams[id] = params;
		}
		
		public function flipToScreen (id:String, direction:String = null):void
		{
			if (direction == null || activeScreen == null)
			{
				setActiveScreen(id);
				return;
			}
			
			screenToReturn = activeScreenId;
			activeScreenId = id;
			directionToReturn = ScreenFlipDirection.inverse(direction);

			Tweeny.killOf(holder);
			removeAllChildren(holder);

			var screen:GUIComponent = createScreen(id);
			switch(direction)
			{
				case ScreenFlipDirection.BOTTOM:
					activeScreen.y = height;
					holder.y = -height;
					holder.x = 0;
					break;
				case ScreenFlipDirection.TOP:
					activeScreen.y = - height;
					holder.y = height;
					holder.x = 0;
					break;
				case ScreenFlipDirection.LEFT:
					activeScreen.x = - width;
					holder.x = width;
					holder.y = 0;
					break;
				default:
					activeScreen.x = width;
					holder.x = - width;
					holder.y = 0;
					break;
			}
			
			holder.addChild(screen);
			holder.addChild(activeScreen);
			Tweeny.create(holder, DisplayCoordsTween.create).
					during(TWEEN_TIME).
					to({x:0, y:0}).
					onComplete(onCompleteTween, screen).
					start();
		}
		
		public function setActiveScreen (id:String):void
		{
			screenToReturn = activeScreenId;
			activeScreenId = id;
			directionToReturn = null;
			
			Tweeny.killOf(holder);
			removeAllChildren(holder);
			activeScreen = createScreen(id);
			activeScreen.draw();
			holder.addChild(activeScreen);
		}
		
		public function getActiveScreen ():GUIComponent
		{
			return activeScreen;
		}
		
		public function removeActiveScreen():void
		{
			if (activeScreen != null)
			{
				holder.removeChild(activeScreen);
				activeScreen = null;
			}
		}
		
		private function onCompleteTween(screen:GUIComponent):void
		{
			holder.removeChild(activeScreen);
			activeScreen = screen;
		}

		private function onInvokeScreen(event:ScreenNavigatorEvent):void
		{
			if (Tweeny.hasTween(holder))
			{
				return;
			}
			flipToScreen(event.screenId, event.direction);
		}
		
		private function onInvokePreviousScreen(event:Event):void
		{
			flipToScreen(screenToReturn, directionToReturn);
		}
	}
}