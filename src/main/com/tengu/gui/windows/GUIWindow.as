package com.tengu.gui.windows
{
	import com.tengu.gui.containers.GUIContainer;
	import com.tengu.gui.controls.buttons.BaseButton;
	import com.tengu.gui.controls.text.Text;
	import com.tengu.gui.enum.WindowPlacementType;
	import com.tengu.gui.events.ClickEvent;
	import com.tengu.gui.events.LayoutEvent;
	import com.tengu.gui.fills.ColorFloodFill;
	import com.tengu.gui.fills.ShapeFill;
	
	import flash.display.Bitmap;
	import flash.display.InteractiveObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	[Style(name="title")]
	[Style(name="close_button")]
	[Style(name="background_fill")]
	[Style(name="bar_fill")]
	[Style(name="bar_blik")]
	[Style(name="bar_height")]
	
	[Event(name="close", type="flash.events.Event")]
	
	public class GUIWindow extends GUIContainer
	{
		private static const AUTOCLOSE_TIMEOUT:uint = 3500;
		
		private static const DEFAULT_BAR_HEIGHT:uint = 25;
		private static const TRANSPARENT_FILL:ColorFloodFill = new ColorFloodFill();
		
		private var windowId:String = null;
		private var windowBar:Sprite = null;
		private var windowPlacement:String 		= null;
		
		protected var barFill:ShapeFill = null;
		protected var barBlick:Bitmap = null;
		
		private var isDragable:Boolean = true;
		private var isClosingByOuterClick:Boolean = true;
		
		private var barShadow:Shape 			= null;
		
		protected var titleLabel:Text 			= null;
		
		protected var windowBarHeight:uint 		= DEFAULT_BAR_HEIGHT;
		protected var closeButton:BaseButton  	= null;
		protected var windowTitle:String 		= null;
		
		protected var windowAnimated:Boolean 	= false;
		
		protected var closeTimer:Timer 			= null;

		protected function get bottomMargin():uint
		{
			return 12;
		}
		
		public function set dragable(value:Boolean):void 
		{
			isDragable = value;
		}
		
		public function get dragable():Boolean 
		{
			return isDragable;
		}

		
		public function set closingByOuterClick(value:Boolean):void 
		{
			isClosingByOuterClick = value;
		}
		
		public function get closingByOuterClick():Boolean 
		{
			return isClosingByOuterClick;
		}

		public function set animated(value:Boolean):void 
		{
			windowAnimated = value;
		}
		
		public function get animated():Boolean 
		{
			return windowAnimated;
		}
		
		public function get bar ():InteractiveObject
		{
			return windowBar;
		}
		
		public function get title ():String
		{
			return windowTitle;
		}
		
		public function set title(value:String):void 
		{
			if (windowTitle == value)
			{
				return;
			}
			windowTitle = value;
			invalidate(VALIDATION_FLAG_DATA);
		}
		
		public function get placement():String 
		{
			return windowPlacement;
		}
		
		public function set placement(value:String):void 
		{
			windowPlacement = value;
			dispatchEvent(new LayoutEvent(LayoutEvent.LAYOUT_CHANGE));
		}
		
		public function get id():String 
		{
			return windowId;
		}
		
		public function set id(value:String):void 
		{
			windowId = value;
		}
		
		public function GUIWindow()
		{
			super();
		}
		
		protected override function createChildren():void
		{
			super.createChildren();
			
			mouseEnabled = true;
			
			windowBar = new Sprite();
			addChildAt(windowBar, 0);
			
			titleLabel = new Text(getWindowTitle());
			titleLabel.mouseEnabled = false;
			addChildAt(titleLabel, 1);
			
			closeButton = new BaseButton();
			closeButton.addEventListener(ClickEvent.CLICK, onClickCloseButton);
			addChildAt(closeButton, 2);
			
			barShadow = new Shape();
			addChildAt(barShadow, 3);
			
			barBlick = new Bitmap();
			barBlick.alpha = .5;
			addChildAt(barBlick, 4);
			
			closeTimer = new Timer(getCloseTimeout());
			closeTimer.addEventListener(TimerEvent.TIMER, onCloseByTimer);
			
			placement = WindowPlacementType.CENTER;
			dragable = false;
		}
		
		
		protected override function dispose():void
		{
			closeButton.removeEventListener(ClickEvent.CLICK, onClickCloseButton);
			closeButton.finalize();
			closeButton = null;
			
			titleLabel.finalize();
			titleLabel = null;
			
			closeTimer.reset();
			closeTimer.removeEventListener(TimerEvent.TIMER, onCloseByTimer);
			windowBar = null;
			barBlick  = null;
			barShadow = null;
			
			
			super.dispose();
		}
		
		protected function getBackgroundFill ():ShapeFill
		{
			return new ColorFloodFill(0xFFFFFF, 1);
		}
		
		protected function getWindowTitle ():String
		{
			return "";
		}
		
		protected function getCloseTimeout ():uint
		{
			return AUTOCLOSE_TIMEOUT;
		}
		
		protected function getBarHeight ():uint
		{
			return DEFAULT_BAR_HEIGHT;
		}
		
		protected override function updateData():void
		{
			super.updateData();
			titleLabel.text = windowTitle;
		}
		
		protected override function updateDisplay():void
		{
			super.updateDisplay();
			TRANSPARENT_FILL.apply(windowBar.graphics, width, windowBarHeight);
			
			if (barFill != null)
			{
				barFill.apply(barShadow.graphics, width, height - windowBarHeight);
			}
			
			barShadow.y = windowBarHeight;
			barBlick.y = windowBarHeight;
			barBlick.width = width;
			
			closeButton.x = width - closeButton.width * .5;
			closeButton.y =  - closeButton.height * .5;
			
			titleLabel.x = 8;
			titleLabel.y = (windowBarHeight - titleLabel.textHeight) * .5 - 1;
		}
		
		protected override function setStyleSelector(styleName:String, styleValue:*):void
		{
			if (styleName == "title")
			{
				titleLabel.format = styleValue;
				return;
			}
			if (styleName == "close_button")
			{
				closeButton.style = styleValue;
				closeButton.draw();
				return;
			}
			if (styleName == "background_fill")
			{
				backgroundFill = textureManager.getTexture(styleValue);
				return;
			}
			if (styleName == "bar_fill")
			{
				barFill = textureManager.getTexture(styleValue);
				return;
			}
			if (styleName == "bar_blik")
			{
				barBlick.bitmapData = textureManager.getIcon(styleValue);
				return;
			}
			if (styleName == "bar_height")
			{
				windowBarHeight = parseInt(styleValue);
				return;
			}
		}
		
		public function update (windowData:IWindowData):void
		{
			//Abstract
		}
		
		public function close ():void
		{
			dispatchEvent(new Event(Event.CLOSE));
		}
		
		private function onClickCloseButton(event:ClickEvent):void
		{
			close();
		}
		
		private function onCloseByTimer(event:TimerEvent):void
		{
			closeTimer.reset();
			close();
		}
	}
}