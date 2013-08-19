package com.tengu.gui.controls.buttons
{
	import com.tengu.core.tengu_internal;
	import com.tengu.gui.base.GUIComponent;
	import com.tengu.gui.events.ClickEvent;
	import com.tengu.gui.fills.ColorFloodFill;
	import com.tengu.gui.fills.ShapeFill;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	[Style(name="up_skin")]
	[Style(name="over_skin")]
	[Style(name="down_skin")]
	[Style(name="disabled_skin")]
	[Style(name="selected_up_skin")]
	[Style(name="selected_over_skin")]
	[Style(name="selected_down_skin")]
	[Style(name="selected_disabled_skin")]
	[Style(name="width")]
	[Style(name="height")]
	
	
	[Event(name="change", type="flash.events.Event")]
	public class BaseButton extends GUIComponent
	{
		private static const TRANSPARENT_FILL:ColorFloodFill = new ColorFloodFill();
		private static const DEFAULT_FILL:ColorFloodFill = new ColorFloodFill(0xFF, .3);
		
		protected static const STATE_UP:String 			= "up";
		protected static const STATE_OVER:String 		= "over";
		protected static const STATE_DOWN:String 		= "down";
		protected static const STATE_DISABLED:String 	= "disabled";
		
		private var fills:Object					= null;
		private var selectedFills:Object			= null;
		private var activeFill:ShapeFill			= null;
		
		private var isToggle:Boolean				= false;
		private var isSelected:Boolean				= false;
		
		protected var background:Shape 				= null;
		protected var activeState:String			= null;
		
		
		public function get selected():Boolean 
		{
			return isSelected;
		}
		
		public function set selected(value:Boolean):void 
		{
			if(isSelected == value)
			{
				return;
			}
			isSelected = value;
			setState(activeState);
			invalidate(VALIDATION_FLAG_DISPLAY);
			if (hasEventListener(Event.CHANGE))
			{
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		public function get toggle():Boolean 
		{
			return isToggle;
		}
		
		public function set toggle(value:Boolean):void 
		{
			isToggle = value;
		}
		
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
		
		public function BaseButton()
		{
			super();
		}
		
		private function updateFills():void
		{
			fills[STATE_UP]					||= DEFAULT_FILL;
			fills[STATE_OVER] 				||= fills[STATE_UP];
			fills[STATE_DOWN] 				||= fills[STATE_UP];
			fills[STATE_DISABLED] 			||= fills[STATE_UP];
			selectedFills[STATE_UP] 		||= fills[STATE_UP];
			selectedFills[STATE_OVER] 		||= selectedFills[STATE_UP];
			selectedFills[STATE_DOWN] 		||= selectedFills[STATE_UP];
			selectedFills[STATE_DISABLED] 	||= selectedFills[STATE_UP];
		}

		protected override function initialize():void
		{
			super.initialize();
			setState(STATE_UP);
		}
		
		protected override function createChildren():void
		{
			super.createChildren();
			
			hitArea = new Sprite();
			hitArea.mouseEnabled = false;
			addChildAt(hitArea, 0);
			
			fills 		  = {};
			selectedFills = {};
			
			background = new Shape();
			addChildAt(background, 1);
			
			buttonMode = true;
			mouseEnabled = true;
			mouseChildren = false;
			useHandCursor = false;
			
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			addEventListener(ClickEvent.CLICK, onMouseClick);
			
			updateFills();
			
			useHandCursor = true;
			buttonMode = true;
		}
		
		protected override function dispose():void
		{
			removeEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			removeEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			removeEventListener(MouseEvent.MOUSE_UP, onMouseOut);
			removeEventListener(ClickEvent.CLICK, onMouseClick);
			
			fills = null;
			super.dispose();
		}
		
		protected override function updateDisplay():void
		{
			super.updateDisplay();
			
			hitArea.x = - width  * .1;
			hitArea.y = - height * .1;
			TRANSPARENT_FILL.apply(hitArea.graphics, width * 1.2, height * 1.2);
			
			activeFill = isSelected ? selectedFills[activeState] : fills[activeState];
			if (activeFill != null)
			{
				activeFill.apply(background.graphics, width, height);
			}
		}
		
		protected function setState (state:String):void
		{
			activeState = state;
			invalidate(VALIDATION_FLAG_DISPLAY);
		}
		
		protected override function setStyleSelector(styleName:String, styleValue:*):void
		{
			if (styleName == "up_skin")
			{
				fills[STATE_UP] = textureManager.getTexture(styleValue);
				return;
			}
			if (styleName == "over_skin")
			{
				fills[STATE_OVER] = textureManager.getTexture(styleValue);
				return;
			}
			if (styleName == "down_skin")
			{
				fills[STATE_DOWN] = textureManager.getTexture(styleValue);
				return;
			}
			if (styleName == "disabled_skin")
			{
				fills[STATE_DISABLED] = textureManager.getTexture(styleValue);
				return;
			}
			if (styleName == "selected_up_skin")
			{
				selectedFills[STATE_UP] = textureManager.getTexture(styleValue);
				return;
			}
			if (styleName == "selected_over_skin")
			{
				selectedFills[STATE_OVER] = textureManager.getTexture(styleValue);
				return;
			}
			if (styleName == "selected_down_skin")
			{
				selectedFills[STATE_DOWN] = textureManager.getTexture(styleValue);
				return;
			}
			if (styleName == "selected_disabled_skin")
			{
				selectedFills[STATE_DISABLED] = textureManager.getTexture(styleValue);
				return;
			}
			if (styleName == "width")
			{
				width = parseInt(String(styleValue));
				return;
			}
			if (styleName == "height")
			{
				height = parseInt(String(styleValue));
				return;
			}
			super.setStyleSelector(styleName, styleValue);
		}
		
		protected function preUpdateStyle ():void
		{
			fills = {};
			selectedFills = {};
		}
		
		protected function postUpdateStyle ():void
		{
			updateFills();
		}
		
		protected override function updateStyle():void
		{
			preUpdateStyle();
			super.updateStyle();
			postUpdateStyle();
			setState(activeState);
		}
		
		protected function onMouseClick (event:ClickEvent):void
		{
			if (toggle)
			{
				isSelected = !isSelected;
			}
			setState(STATE_OVER);
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		tengu_internal function freeze ():void
		{
			enabled = false;
			setState(STATE_DOWN);
		}
		
		tengu_internal function unfreeze ():void
		{
			enabled = true;
			setState(STATE_UP);
		}
		
		protected function onMouseUp (event:MouseEvent):void
		{
			setState(STATE_UP);
		}
		
		protected function onMouseDown (event:MouseEvent):void
		{
			setState(STATE_DOWN);
		}
		
		protected function onMouseOut (event:MouseEvent):void
		{
			setState(STATE_UP);
		}
		
		protected function onMouseOver (event:MouseEvent):void
		{
			setState(STATE_OVER);
		}
	}
}