package com.tengu.gui.base
{
    import com.tengu.calllater.api.IDeferredCaller;
    import com.tengu.core.tengu_internal;
    import com.tengu.core.funcs.removeAllChildren;
    import com.tengu.gui.api.IScaleManager;
    import com.tengu.gui.api.IStyleManager;
    import com.tengu.gui.api.ITexturesManager;
    import com.tengu.gui.api.IWindowManager;
    import com.tengu.gui.events.ClickEvent;
    import com.tengu.gui.fills.ShapeFill;
    import com.tengu.gui.markup.api.IMarkable;
    import com.tengu.gui.markup.api.IMarkupBuilderFactory;
    
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Point;

    [Style(name="padding_left")]
	[Style(name="padding_right")]
	[Style(name="padding_top")]
	[Style(name="padding_bottom")]
	[Style(name="background_fill")]

	[Style(name="width")]
	[Style(name="height")]
	[Style(name="unscaled_width")]
	[Style(name="unscaled_height")]
	
	[Event(name="resize", type="flash.events.Event")]
	[Event(name="layoutChange", type="com.tengu.gui.events.LayoutEvent")]
	[Event(name="guiClick", type="com.tengu.gui.events.ClickEvent")]
	
	public class GUIComponent extends Sprite implements IDeferredCaller, IMarkable
	{
		private static const CLICK_POSITION_SQUARED_TRESHOLD:uint = 900;

		private static const DEFAULT_WIDTH:uint			= 10;
		private static const DEFAULT_HEIGHT:uint		= 10;

		public static const VALIDATION_FLAG_ALL:uint 		= 0xFF;
		public static const VALIDATION_FLAG_DATA:uint 	    = 0x10;
		public static const VALIDATION_FLAG_STYLE:uint 	    = 0x8;
		public static const VALIDATION_FLAG_SIZE:uint 	    = 0x4;
		public static const VALIDATION_FLAG_LAYOUT:uint 	= 0x2;
		public static const VALIDATION_FLAG_DISPLAY:uint 	= 0x1;

		tengu_internal var finalized:Boolean 		= false;

        private var mouseDownPos:Point			= null;
		private var layouted:Boolean    = true;
        private var validating:Boolean  = false;

		protected var backgroundFill:ShapeFill 	= null;

		protected var styleObject:Object			= null;
        protected var styleName:String              = null;
		protected var validationFlags:uint		    = 0;
		
		protected var componentPaddingLeft:int 		= 0;
		protected var componentPaddingRight:int 	= 0;
		protected var componentPaddingTop:int 		= 0;
		protected var componentPaddingBottom:int 	= 0;
		
		protected var componentMinWidth:uint  = 0;
		protected var componentMinHeight:uint = 0;
		
		protected var componentPercentWidth:int  = 0;
		protected var componentPercentHeight:int = 0;
		
		protected var componentWidth:int 	= 0;
		protected var componentHeight:int 	= 0;
		
		protected final function get textureManager ():ITexturesManager
		{
			return GUIManagersFactory.getTexturesManager();
		}
		
		protected final function get styleManager ():IStyleManager
		{
			return GUIManagersFactory.getStyleManager();
		}
		
		protected final function get windowManager ():IWindowManager
		{
			return GUIManagersFactory.getWindowManager();
		}
		
		protected final function get scaleManager ():IScaleManager
		{
			return GUIManagersFactory.getScaleManager();
		}
		
		protected final function get markupFactory ():IMarkupBuilderFactory
		{
			return GUIManagersFactory.getMarkupFactory();
		}
		
		protected final function get defaultStyle ():Object
		{
			return styleManager.getStyle(defaultStyleName);
		}
		
		protected function get defaultStyleName ():String
		{
			return null;
		}
		
		public function get minWidth ():uint
		{
			return componentMinWidth;
		}
		
		public function set minWidth(value:uint):void 
		{
			componentMinWidth = value;
		}
		
		public function get minHeight():uint 
		{
			return componentMinHeight;
		}
		
		public function set minHeight(value:uint):void 
		{
			componentMinHeight = value;
		}
		
		public function get percentWidth ():int
		{
			return componentPercentWidth;
		}
		
		public function set percentWidth(value:int):void 
		{
			componentPercentWidth = value;
		}
		
		public function get percentHeight():int 
		{
			return componentPercentHeight;
		}
		
		public function set percentHeight(value:int):void 
		{
			componentPercentHeight = value;
		}
		
		public function get displayWidth ():Number
		{
			return super.width;
		}
		
		public function get displayHeight ():Number
		{
			return super.height;
		}
		
		public override function set x (value:Number):void
		{
			super.x = Math.round(value);
		}
		
		public override function set y (value:Number):void
		{
			super.y = Math.round(value);
		}
		
		public override function get width():Number
		{
			return componentWidth;
		}
		
		public override function set width(value:Number):void
		{
			setSize(value, componentHeight);
		}
		
		public override function get height ():Number
		{
			return componentHeight;
		}
		
		public override function set height(value:Number):void
		{
			setSize(componentWidth, value);
		}
		
		public function get style():Object 
		{
			return styleObject;
		}
		
		public function set style(value:Object):void 
		{
            var newStyle:Object;
            if (value is String)
            {
                styleName = String(value);
                newStyle = styleManager.getStyle(styleName);
            }
            else
            {
                newStyle = value;
            }
			if (styleObject == newStyle)
			{
				return;
			}
			styleObject = newStyle;
			invalidate(VALIDATION_FLAG_STYLE);
		}
		
		public function set includeInLayout (value:Boolean):void
		{
			layouted = value;
		}
		
		public function get includeInLayout ():Boolean
		{
			return layouted;
		}
		
		public function get paddingTop():int 
		{
			return componentPaddingTop;
		}
		
		public function set paddingTop(value:int):void 
		{
			if (value == componentPaddingTop)
			{
				return;
			}
			componentPaddingTop = value;
			invalidate(VALIDATION_FLAG_SIZE);
		}
		
		public function get paddingBottom():int 
		{
			return componentPaddingBottom;
		}
		
		public function set paddingBottom(value:int):void 
		{
			if (value == componentPaddingBottom)
			{
				return;
			}
			componentPaddingBottom = value;
			invalidate(VALIDATION_FLAG_SIZE);
		}
		
		public function get paddingLeft():int 
		{
			return componentPaddingLeft;
		}
		
		public function set paddingLeft(value:int):void 
		{
			if (value == componentPaddingLeft)
			{
				return;
			}
			componentPaddingLeft = value;
			invalidate(VALIDATION_FLAG_SIZE);
		}
		
		public function get paddingRight():int 
		{
			return componentPaddingRight;
		}
		
		public function set paddingRight(value:int):void 
		{
			if (value == componentPaddingRight)
			{
				return;
			}
			componentPaddingRight = value;
			invalidate(VALIDATION_FLAG_SIZE);
		}
		
		public function get canApplyDeferredCalls():Boolean 
		{
			return !tengu_internal::finalized;
		}
		
		public function GUIComponent()
		{
			super();
			initialize();
		}
		
		protected function initialize ():void
		{
			measure();
			createChildren();
			invalidate();
			draw();
		}

		//Служебный метод для удаления детей через removeAllChildren
		protected function disposeComponent (component:DisplayObject):void
		{
			if (component is GUIComponent)
			{
				(component as GUIComponent).finalize();
			}
		}
		
		protected function createChildren ():void
		{
			mouseEnabled = false;
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(MouseEvent.MOUSE_UP, onMouseUp, false, int.MIN_VALUE);
		}
		
		protected function dispose ():void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			removeAllChildren(this, disposeComponent);
			validationFlags = null;
		}
		
		protected function measure ():void
		{
			componentMinWidth  = DEFAULT_WIDTH;
			componentMinHeight = DEFAULT_HEIGHT;
			componentWidth 	   = DEFAULT_WIDTH;
			componentHeight    = DEFAULT_HEIGHT;
		}
		
		protected function validate ():void
		{
			const dataInvalid:Boolean 	    = isInvalid(VALIDATION_FLAG_DATA);
            const displayInvalid:Boolean 	= isInvalid(VALIDATION_FLAG_DISPLAY);
            const layoutInvalid:Boolean     = isInvalid(VALIDATION_FLAG_LAYOUT);
            const sizeInvalid:Boolean 	    = isInvalid(VALIDATION_FLAG_SIZE);
            const styleInvalid:Boolean 	    = isInvalid(VALIDATION_FLAG_STYLE);
			
			if (dataInvalid)
			{
				updateData();
                unsetValidationFlag(VALIDATION_FLAG_DATA);
			}
			
			if (styleInvalid)
			{
				updateStyle();
                unsetValidationFlag(VALIDATION_FLAG_STYLE);
			}
			
			if (sizeInvalid)
			{
				updateSize();
                unsetValidationFlag(VALIDATION_FLAG_SIZE);
			}
			
			if (layoutInvalid || sizeInvalid )
			{
				updateLayout();
                unsetValidationFlag(VALIDATION_FLAG_LAYOUT);
			}
			
			if (displayInvalid || sizeInvalid || styleInvalid)
			{
				updateDisplay();
                unsetValidationFlag(VALIDATION_FLAG_DISPLAY);
			}
		}
		
		protected function updateData ():void
		{
			//Abstracts
		}
		
		protected function updateLayout ():void
		{
			//Abstracts
		}
		
		protected function updateDisplay ():void
		{
			if (backgroundFill != null)
			{
				backgroundFill.apply(graphics, width, height);
			}
		}
		
		protected function updateSize ():void
		{
			var component:GUIComponent;
			var i:int = numChildren - 1;
			while (i >= 0)
			{
				component = getChildAt(i) as GUIComponent;
				i--;
				if (component == null)
				{
					continue;
				}
				if (component.percentWidth != 0)
				{
					component.width = component.percentWidth * width / 100;
				}
				if (component.percentHeight != 0)
				{
					component.height = component.percentHeight * height / 100;
				}
			}
		}
		
		protected function updateStyle ():void
		{
			styleObject ||= defaultStyle;
			if (styleObject == null)
			{
				return;
			}
			tengu_internal::parseStyle(styleObject);
		}
		
		tengu_internal final function parseStyle (styleObject:Object):void
		{
			for (var styleName:String in styleObject)
			{
				setStyleSelector(styleName, styleObject[styleName]);
			}
		}
		
		protected function setStyleSelector (styleName:String, styleValue:*):void
		{
			var tmpStr:String = null;
			if (styleName == "background_fill")
			{
				if (styleValue is ShapeFill)
				{
					backgroundFill = styleValue as ShapeFill;
				}
				else
				{
					backgroundFill = textureManager.getTexture(styleValue);
				}
				return;
			}
			if (styleName == "padding_left")
			{
				componentPaddingLeft = parseInt(String(styleValue));
				return;
			}
			if (styleName == "padding_right")
			{
				componentPaddingRight = parseInt(String(styleValue));
				return;
			}
			if (styleName == "padding_top")
			{
				componentPaddingTop = parseInt(String(styleValue));
				return;
			}
			if (styleName == "padding_bottom")
			{
				componentPaddingBottom = parseInt(String(styleValue));
				return;
			}
			if (styleName == "width")
			{
				tmpStr = String(styleValue);
				if (tmpStr.indexOf("%") != -1)
				{
					percentWidth = parseInt(tmpStr);
				}
				else
				{
					width = parseInt(tmpStr);
				}
				return;
			}
			if (styleName == "height")
			{
				tmpStr = String(styleValue);
				if (tmpStr.indexOf("%") != -1)
				{
					percentHeight = parseInt(tmpStr);
				}
				else
				{
					height = parseInt(tmpStr);
				}
				return;
			}
			if (styleName == "unscaled_width")
			{
				width = scaleManager.lodFactor * parseInt(styleValue);
				return;
			}
			if (styleName == "unscaled_height")
			{
				height = scaleManager.lodFactor * parseInt(styleValue);
				return;
			}
		}

        protected final function isInvalid(flag:uint):Boolean
        {
            return (validationFlags & flag) != 0;
        }

        protected final function setValidationFlag (flag:uint):void
        {
            if (flag & VALIDATION_FLAG_SIZE)
            {
                flag = flag | VALIDATION_FLAG_LAYOUT;
            }
            if ((flag & VALIDATION_FLAG_STYLE) || (flag & VALIDATION_FLAG_LAYOUT) || (flag & VALIDATION_FLAG_DATA))
            {
                flag = flag | VALIDATION_FLAG_DISPLAY;
            }
            validationFlags = validationFlags | flag;
        }

        protected final function unsetValidationFlag (flag:uint):void
        {
            validationFlags = validationFlags & ~flag;
        }

        public final function callLater (method:Function, ...params):void
		{
			GUIManagersFactory.getCallLaterManager().callLater(this, method, params);
		}
		
		public function invalidate (...flags):void
		{
            var drawLater:Boolean = false;
			if (flags.length == 0)
			{
				flags[flags.length] = VALIDATION_FLAG_ALL;
			}

            for each (var flag:uint in flags)
            {
                if (!validating || !isInvalid(flag))
                {
                    drawLater = true;
                    setValidationFlag(flag);
                }
            }
            if (drawLater)
            {
			    callLater(draw);
            }
		}

		public final function setUnscaledSize (width:int, height:int, onlyLod:Boolean = false):void
		{
			var kf:Number = scaleManager.lodFactor;
			if (!onlyLod)
			{
				kf = kf * scaleManager.scale;
			}
			setSize(width * kf, height * kf);
		}
		
		public  function setSize (width:int, height:int):void
		{
			if (width < minWidth)
			{
				width = minWidth;
			}
			if (height < minHeight)
			{
				height = minHeight;
			}
			
			if (componentWidth == width && componentHeight == height)
			{
				return;
			}
			
			componentWidth 	= width;
			componentHeight = height;
			invalidate(VALIDATION_FLAG_SIZE);
			
			if (hasEventListener(Event.RESIZE))
			{
				dispatchEvent(new Event(Event.RESIZE));	
			}
		}
		
		public final function draw ():void
		{
            validating = true;
			validate();
            validationFlags = 0;
            validating = false;
		}
		
		public final function finalize ():void
		{
			if (tengu_internal::finalized)
			{
				return;
			}
			tengu_internal::finalized = true;
			dispose();
		}
		
		private function onMouseDown(event:MouseEvent):void
		{
			mouseDownPos = new Point(event.stageX, event.stageY);			
		}
		
		private function onMouseUp (event:MouseEvent):void
		{
			if (mouseDownPos != null)
			{
				var dx:Number = (event.stageX - mouseDownPos.x);
				var dy:Number = (event.stageY - mouseDownPos.y);
				var squaredLength:Number =  dx * dx + dy * dy;
				
				if (squaredLength <= CLICK_POSITION_SQUARED_TRESHOLD)
				{
					dispatchEvent(new ClickEvent(ClickEvent.CLICK));
				}
				
				mouseDownPos = null;
			}
		}
		
		protected function onAddedToStage(event:Event):void
		{
			if (percentWidth != 0)
			{
				width = parent.width * percentWidth / 100;
			}
			if (percentHeight != 0)
			{
				height = parent.height * percentHeight / 100;
			}
		}
		
		protected function onRemovedFromStage(event:Event):void
		{
			//Abstract
		}

	}
}

