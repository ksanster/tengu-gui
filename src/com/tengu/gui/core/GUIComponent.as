package com.tengu.gui.core
{
	import com.tengu.gui.core.uid.UidGenerator;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	public class GUIComponent extends Sprite
	{
		private static const DEFAULT_WIDTH:uint			= 30;
		private static const DEFAULT_HEIGHT:uint		= 20;
		
		private var inCallLaterPhase:Boolean 			= false;
		private var callLaterMethods:Vector.<Function> 	= null;
		private var callLaterMethodHash:Dictionary 		= null;
		private var hasCallLater:Boolean 				= false;

		private var validated:Boolean 		= true;
		
		protected var componentWidth:uint 	= 0;
		protected var componentHeight:uint 	= 0;
		
		private var componentUid:String		= null;
		
		public override function get width():Number
		{
			return componentWidth;
		}
		
		public override function get height ():Number
		{
			return componentHeight;
		}
		
		public override function set width(value:Number):void
		{
			setSize(value, componentHeight);
		}
		
		public override function set height(value:Number):void
		{
			setSize(componentWidth, value);
		}
		
		public function get displayWidth ():Number
		{
			return super.width;
		}
		
		public function get displayHeight ():Number
		{
			return super.height;
		}
		
		public function get uid ():String
		{
			return componentUid;
		}
		
		public function GUIComponent()
		{
			super();
			componentUid = UidGenerator.createUID();
			measure();
			createChildren();
			update();
		}
		
		protected function createChildren ():void
		{
			callLaterMethods = new Vector.<Function>();
			callLaterMethodHash = new Dictionary();
		}
		
		protected function addContentElement (value:Sprite):void
		{
			addChild(value);
		}
		
		protected function dispose ():void
		{
			if (hasCallLater)
			{
				if (stage == null)
				{
					removeEventListener(Event.ADDED_TO_STAGE, onCallLater);
				}
				else
				{
					stage.removeEventListener(Event.RENDER, onCallLater);
				}
			}
		}
		
		protected function measure ():void
		{
			componentWidth 	= DEFAULT_WIDTH;
			componentHeight = DEFAULT_HEIGHT;
		}
		
		protected function update ():void
		{
			validated = true;
		}
		
		protected final function invalidate ():void
		{
			validated = false;
			callLater(update);
		}
		
		protected final function callLater (method:Function):void
		{
			if (callLaterMethodHash[method] || inCallLaterPhase)
			{
				return;
			}
			callLaterMethods[callLaterMethods.length] = method;
			callLaterMethodHash[method] = true;
			if (hasCallLater)
			{
				return;
			}
			hasCallLater = true;
			if (stage == null)
			{
				addEventListener(Event.ADDED_TO_STAGE, onCallLater);
			}
			else
			{
				stage.addEventListener(Event.RENDER, onCallLater);
				stage.invalidate();
			}
		}

		public final function setSize (width:uint, height:uint):void
		{
			if (componentWidth == width && componentHeight == height)
			{
				return;
			}
			componentWidth 	= width;
			componentHeight = height;
			invalidate();
		}
		
		public final function finalize ():void
		{
			dispose();
		}
		
		private function onCallLater (event:Event):void
		{
			if (event.type == Event.ADDED_TO_STAGE)
			{
				removeEventListener(Event.ADDED_TO_STAGE, onCallLater);
				stage.addEventListener(Event.RENDER, onCallLater);
				stage.invalidate();
				return;
			}
			stage.removeEventListener(Event.RENDER, onCallLater);
			if (stage == null)
			{
				addEventListener(Event.ADDED_TO_STAGE, onCallLater);
				return;
			}
			inCallLaterPhase = true;
			var tmpList:Vector.<Function> = callLaterMethods.slice();
			for each (var method:Function in tmpList) 
			{
				delete callLaterMethodHash[method];
				method();
			}
			callLaterMethods.length = 0;
			inCallLaterPhase = false;
			hasCallLater = false;
		}
	}
}