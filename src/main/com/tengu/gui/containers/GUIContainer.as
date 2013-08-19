package com.tengu.gui.containers
{
	import com.tengu.gui.base.GUIComponent;
	import com.tengu.gui.events.LayoutEvent;
	import com.tengu.gui.layouts.ILayout;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Rectangle;

	public class GUIContainer extends GUIComponent
	{
		private var containerLayout:ILayout 		= null;
		private var inLayoutValidatePhase:Boolean 	= false;
		
		private var boundsRectangle:Rectangle = null;
		
		private var resizeByContentFlag:Boolean = false;
		private var cropContentFlag:Boolean 	= true;
		
		protected var cContentWidth:int  = 0;
		protected var cContentHeight:int = 0;
		
		public function get contentWidth():int 
		{
			return cContentWidth;
		}
		
		public function get contentHeight():int 
		{
			return cContentHeight;
		}
		
		public function set resizeByContent (value:Boolean):void 
		{
			resizeByContentFlag = value;
			if (value)
			{
				percentWidth  = 0;
				percentHeight = 0;
			}
		}
		
		public function get resizeByContent ():Boolean 
		{
			return resizeByContentFlag;
		}
		
		public function set cropContent(value:Boolean):void 
		{
			cropContentFlag = value;
			if (!value)
			{
				scrollRect = null;
			}
		}
		
		public function get cropContent():Boolean 
		{
			return cropContentFlag;
		}
		
		public function set layout (value:ILayout):void
		{
			containerLayout = value;
			invalidate(VALIDATION_FLAG_LAYOUT);
		}
		
		public function get layout ():ILayout
		{
			return containerLayout;
		}
		
		public override function set percentWidth(value:int):void
		{
			if (resizeByContent)
			{
				return;
			}
			super.percentWidth = value;
		}
		
		public override function set percentHeight(value:int):void
		{
			if (resizeByContent)
			{
				return;
			}
			super.percentHeight = value;
		}
		
		public function GUIContainer()
		{
			super();
		}
		
		protected override function initialize():void
		{
			boundsRectangle = new Rectangle(0, 0, width, height);
			super.initialize();
			boundsRectangle.width = width;
			boundsRectangle.height = height;
		}
		
		protected override function dispose():void
		{
			var child:DisplayObject = null;
			for (var i:int = 0; i < numChildren; i++)
			{
				child = getChildAt(i);
				child.removeEventListener(Event.RESIZE, onChildChanged);
				child.removeEventListener(LayoutEvent.LAYOUT_CHANGE, onChildChanged);
			}
			super.dispose();
		}
		
		protected override function updateSize():void
		{
			super.updateSize();
			boundsRectangle.width = width;
			boundsRectangle.height = height;
		}
		
		protected override function updateLayout ():void
		{
			if (layout == null)
			{
				return;
			}
			inLayoutValidatePhase = true;
			var rectangle:Rectangle = layout.arrange(this);
			inLayoutValidatePhase = false;
			
			cContentWidth  = rectangle.width;
			cContentHeight = rectangle.height;
			
			if (resizeByContent)
			{
				setSize(cContentWidth, cContentHeight);
			}
			else
			{
				scrollRect = cropContent ? boundsRectangle : null;
			}
		}

		//Для того, чтобы в лейаутах можно было использовать порядок, отличный от порядка добавления
		public function getChildByIndex (index:int):DisplayObject
		{
			return null;
		}
		
		public override function addChild(child:DisplayObject):DisplayObject
		{
			var result:DisplayObject = super.addChild(child);
			result.addEventListener(Event.RESIZE, onChildChanged);
			result.addEventListener(LayoutEvent.LAYOUT_CHANGE, onChildChanged);
			invalidate(VALIDATION_FLAG_LAYOUT);
			return result;
		}
		
		public override function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			var result:DisplayObject = super.addChildAt(child, index);
			result.addEventListener(Event.RESIZE, onChildChanged);
			result.addEventListener(LayoutEvent.LAYOUT_CHANGE, onChildChanged);
			invalidate(VALIDATION_FLAG_LAYOUT);
			return result;
		}
		
		public override function removeChild(child:DisplayObject):DisplayObject
		{
			var result:DisplayObject = super.removeChild(child);
			result.removeEventListener(Event.RESIZE, onChildChanged);
			result.removeEventListener(LayoutEvent.LAYOUT_CHANGE, onChildChanged);
			invalidate(VALIDATION_FLAG_LAYOUT);
			return result;
		}
		
		public override function removeChildAt(index:int):DisplayObject
		{
			var result:DisplayObject = super.removeChildAt(index);
			result.removeEventListener(Event.RESIZE, onChildChanged);
			result.removeEventListener(LayoutEvent.LAYOUT_CHANGE, onChildChanged);
			invalidate(VALIDATION_FLAG_LAYOUT);
			return result;
		}
		
		private function onChildChanged(event:Event):void
		{
			invalidate(VALIDATION_FLAG_LAYOUT);
		}
	}
}