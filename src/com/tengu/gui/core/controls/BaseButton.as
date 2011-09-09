package com.tengu.gui.core.controls
{
	import com.tengu.gui.core.GUIComponent;
	import com.tengu.gui.core.fills.BitmapFill;
	
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	public class BaseButton extends GUIComponent
	{
		protected static const STATE_UP:String 			= "up";
		protected static const STATE_OVER:String 		= "over";
		protected static const STATE_DOWN:String 		= "down";
		protected static const STATE_DISABLED:String 	= "disabled";
		
		private var background:Shape 				= null;
		private var upStateBitmap:BitmapData 		= null;
		private var overStateBitmap:BitmapData 		= null;
		private var downStateBitmap:BitmapData 		= null;
		private var disabledStateBitmap:BitmapData 	= null;
		
		private var fills:Object					= null;
		private var activeFill:BitmapFill			= null;
		
		protected var activeState:String			= null;
		
		public function get enabled ():Boolean
		{
			return mouseEnabled;
		}
		
		public function set enabled (value:Boolean):void
		{
			mouseEnabled = value;
			var state:String = value ? STATE_UP : STATE_DISABLED;
			setState(state);
		}
		
		public function set scaleGrid (value:Rectangle):void
		{
			for each (var fill:BitmapFill in fills)
			{
				fill.scaleGrid = value;
			}
			invalidate();
		}

		public function BaseButton()
		{
			super();
			setState(STATE_UP);
		}
		
		protected override function createChildren():void
		{
			super.createChildren();
			
			fills = {};
			fills[STATE_UP] 		= new BitmapFill();
			fills[STATE_OVER] 		= new BitmapFill();
			fills[STATE_DOWN] 		= new BitmapFill();
			fills[STATE_DISABLED] 	= new BitmapFill();

			background = new Shape();
			addChild(background);

			buttonMode = true;
			mouseEnabled = true;
			mouseChildren = false;
			useHandCursor = false;
			
			addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			addEventListener(MouseEvent.ROLL_OUT, onMouseUp);
			
		}
		
		protected override function dispose():void
		{
			super.dispose();
			removeEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			removeEventListener(MouseEvent.ROLL_OUT, onMouseUp);

		}
		
		protected override function update():void
		{
			super.update();
			if (activeFill != null)
			{
				activeFill.apply(background.graphics, componentWidth, componentHeight);
			}
		}
		
		protected function setState (state:String):void
		{
			activeFill = fills[state];
			activeFill.apply(background.graphics, componentWidth, componentHeight);
			activeState = state;
		}
		
		protected function onMouseUp (event:MouseEvent):void
		{
			setState(STATE_UP);
		}
		
		protected function onMouseOver (event:MouseEvent):void
		{
			setState(STATE_OVER);
		}
		
		protected function onMouseDown (event:MouseEvent):void
		{
			setState(STATE_DOWN);
		}
		
		public function setSkin (upStateBitmap:BitmapData, overStateBitmap:BitmapData = null, downStateBitmap:BitmapData = null, disabledStateBitmap:BitmapData = null):void
		{
			var fill:BitmapFill = null;
			fill = fills[STATE_UP];
			fill.bitmapData = upStateBitmap;
			fill = fills[STATE_OVER];
			fill.bitmapData = overStateBitmap == null ? upStateBitmap : overStateBitmap;
			fill = fills[STATE_DOWN];
			fill.bitmapData = downStateBitmap == null ? upStateBitmap : downStateBitmap;
			fill = fills[STATE_DISABLED];
			fill.bitmapData = disabledStateBitmap == null ? upStateBitmap : disabledStateBitmap;
			invalidate();
		}
	}
}