package com.tengu.gui.controls.list
{
	import com.tengu.core.funcs.parseBoolean;
	import com.tengu.core.funcs.removeAllChildren;
	import com.tengu.gui.base.GUIComponent;
	import com.tengu.gui.containers.GUIContainer;
	import com.tengu.gui.controls.list.components.BaseRenderer;
	import com.tengu.gui.controls.list.components.IBaseRenderer;
	import com.tengu.gui.events.ScrollEvent;
	import com.tengu.gui.fills.ColorFloodFill;
	import com.tengu.gui.fills.ShapeFill;
	import com.tengu.model.api.IList;
	import com.tengu.model.enum.ModelEventKind;
	import com.tengu.model.events.ModelEvent;
	import com.tengu.tween.TweenSystem;
	import com.tengu.tween.Tweener;
	
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	[Style(name="gap")]
	[Style(name="renderer_class")]
	[Style(name="show_selector")]
	[Style(name="selector_fill")]
	[Style(name="background_fill")]
	
	[Event(name="scrollSelect", type="com.tengu.gui.events.ScrollEvent")]
	public class ScrollPanel extends GUIComponent
	{
		private static const TRANSPARENT_FILL:ColorFloodFill = new ColorFloodFill();
		
		private var dataSourceChanged:Boolean	= false;
		protected var showSelector:Boolean		= true;
		private var moveByWheelFlag:Boolean		= true;
		
		protected var panelGap:int = 0;

		protected var innerContainer:GUIContainer 	= null;
		
		protected var panelDataSource:IList   = null;
		protected var elementsCount:uint 			= 0;
		protected var panelSelectedIndex:int		= -1;
		protected var panelSelectedItem:Object		= -1;
		
		protected var renderCache:Vector.<IBaseRenderer> = null;
		protected var renderersOnScreen:Object			= null;
		
		protected var panelRendererClass:Class			= null;
		
		protected var elementWidth:uint  = 1;
		protected var elementHeight:uint = 1;
		
		protected var startSourceIndex:int 		= 0;
		protected var endSourceIndex:int 		= 0;
		protected var visibleElementsCount:uint = 0; 
		
		protected var innerScrollRect:Rectangle = null;
		
		protected var selectorShape:Shape = null;
		protected var selectorShapeFill:ShapeFill = null;
		protected var backgroundShapeFill:ShapeFill = null;
		
		protected var inTweenMode:Boolean = false;
		
		protected var tweener:Tweener = null;
		
		public function set moveByWheel(value:Boolean):void 
		{
			moveByWheelFlag = value;
		}
		
		public function get moveByWheel():Boolean 
		{
			return moveByWheelFlag;
		}
		
		public function set dataSource (value:IList):void
		{
			if (panelDataSource == value)
			{
				return;
			}
			if (panelDataSource != null)
			{
				panelDataSource.removeEventListener(ModelEvent.MODEL_CHANGE, onChangeModel);
			}
			panelDataSource = value;
			if (panelDataSource != null)
			{
				panelDataSource.addEventListener(ModelEvent.MODEL_CHANGE, onChangeModel);
			}
			updateDataSource();
		}
		
		public function get dataSource():IList
		{
			return panelDataSource;
		}
		
		public function get enabled():Boolean 
		{
			return innerContainer.mouseEnabled;
		}
		
		public function set enabled (value:Boolean):void
		{
			innerContainer.mouseEnabled = value;
			innerContainer.mouseChildren = value;
		}
		
		public function get selectedIndex():int 
		{
			return panelSelectedIndex;
		}
		
		public function get selectedItem ():Object
		{
			return panelSelectedItem;
		}
		
		public function get startIndex():int 
		{
			return startSourceIndex;
		}
		
		public function get visibleCount():uint 
		{
			return visibleElementsCount;
		}
		
		public function ScrollPanel()
		{
			super();
		}
		
		private function updateDataSource ():void
		{
			elementsCount = panelDataSource == null ? 0 : panelDataSource.size;
			startSourceIndex = 0;
			dataSourceChanged = true;
			updateScroll();
		}
		
		protected function normalizeStartIndex (index:int):int
		{
			if (index + visibleElementsCount > dataSource.size)
			{
				index = dataSource.size - visibleElementsCount;
			}
			if (index < 0)
			{
				index = 0;
			}
			return index;
		}
		
		protected final function invalidateScroll ():void
		{
			callLater(updateScroll);
		}

		protected function updateScroll ():void
		{
			if (dataSourceChanged)
			{
				panelSelectedIndex = -1;
				dataSourceChanged = false;
				
				clear();
			}
			renderElements();
		}
		
		protected function clear ():void
		{
			renderersOnScreen = {};
			removeAllChildren(innerContainer, disposeComponent);
			
			for each (var renderer:IBaseRenderer in  renderCache)
			{
				disposeComponent(renderer as GUIComponent);
			}
			renderCache.length = 0;
		}
		
		
		protected function getRenderer ():IBaseRenderer
		{
			var renderer:IBaseRenderer = null;
			if (renderCache.length == 0)
			{
				renderer = new panelRendererClass() as IBaseRenderer;
			}
			else
			{
				renderer = renderCache.pop();
			}
			return renderer;
		}
		
		protected function renderElements ():void
		{
			//Override
		}
			
		protected function updateSelection ():void
		{
			//Override
		}
		
		protected override function initialize():void
		{
			super.initialize();
			mouseEnabled = false;
		}
		
		protected override function createChildren():void
		{
			super.createChildren();
			
			renderCache   = new Vector.<IBaseRenderer>();
			panelRendererClass = BaseRenderer;
			renderersOnScreen  = {};
			
			selectorShape = new Shape();
			selectorShape.alpha = .5;
			//			selectorShape.blendMode = BlendMode.DIFFERENCE;
			addChild(selectorShape);
			
			innerContainer = new GUIContainer();
			innerContainer.addEventListener(MouseEvent.CLICK, 		onClickInnerContainer);
			innerContainer.addEventListener(MouseEvent.MOUSE_MOVE, 	onMouseMove);
			innerContainer.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			innerContainer.addEventListener(MouseEvent.ROLL_OVER, 	onRollOver);
			innerContainer.addEventListener(MouseEvent.ROLL_OUT, 	onRollOut);
			innerContainer.mouseEnabled = true;
			addChild (innerContainer);
			
			selectorShapeFill = new ColorFloodFill(0xFFFFFF, .3);
			backgroundShapeFill = new ColorFloodFill();
			
			innerScrollRect = new Rectangle(0, 0, componentWidth, componentHeight);
			scrollRect = innerScrollRect;
			
			tweener = TweenSystem.getTweener(innerContainer);
		}
		
		protected override function dispose():void
		{
			clear();
			
			if (panelDataSource != null)
			{
				panelDataSource.removeEventListener(ModelEvent.MODEL_CHANGE, onChangeModel);
			}
			
			tweener.removeAllTweens();
			tweener = null;
			
			innerContainer.removeEventListener(MouseEvent.CLICK, 		onClickInnerContainer);
			innerContainer.removeEventListener(MouseEvent.MOUSE_MOVE, 	onMouseMove);
			innerContainer.removeEventListener(MouseEvent.MOUSE_WHEEL, 	onMouseWheel);
			innerContainer.removeEventListener(MouseEvent.MOUSE_OUT, 	onRollOut);
			innerContainer.finalize();
			innerContainer = null;
			
			panelRendererClass 	= null;
			panelDataSource = null;
			panelSelectedItem = null;
			renderersOnScreen = null;

			super.dispose();
		}
		
		protected override function updateDisplay():void
		{
			super.updateDisplay();
			backgroundShapeFill.apply(graphics, width, height);
			TRANSPARENT_FILL.apply(innerContainer.graphics, width, height);
		}
		
		protected override function updateSize(width:int, height:int):void
		{
			super.updateSize(width, height);
			innerContainer.setSize(width, height);
			
			innerScrollRect.width  = width;
			innerScrollRect.height = height;
			this.scrollRect = innerScrollRect;
		}
		
		protected override function setStyleSelector(styleName:String, styleValue:*):void
		{
			if (styleName == "gap")
			{
				panelGap = parseInt(String(styleValue));
				return;
			}
			if (styleName == "renderer_class")
			{
				panelRendererClass = styleValue as Class;
				invalidateScroll();
				return;
			}
			if (styleName == "show_selector")
			{
				selectorShape.graphics.clear();
				showSelector = parseBoolean(styleValue);
				updateSelection();
				return;
			}
			if (styleName == "selector_fill")
			{
				selectorShapeFill = textureManager.getTexture(styleValue);
				return;
			}
			if (styleName == "background_fill")
			{
				backgroundShapeFill = textureManager.getTexture(styleValue);
				return;
			}
		}
		
		protected function cannotMoveToIndex (index:int):Boolean
		{
			return (dataSource == null || index == startSourceIndex);
		}
		
		protected function getIndexUnderMouse():int
		{
			return -1;
		}
		
		public final function moveTo (index:int):void
		{
			if (cannotMoveToIndex(index))
			{
				return;
			}
			startSourceIndex = normalizeStartIndex(index);
			renderElements();
		}
		
		public function tweenTo (index:int):void
		{
			
		}
		
		private function onClickInnerContainer(event:MouseEvent):void
		{
			var element:IBaseRenderer = event.target as IBaseRenderer;
			var renderer:IBaseRenderer = renderersOnScreen[panelSelectedIndex];
			
			var index:int = getIndexUnderMouse();
			if (index == -1)
			{
				return;
			}
			if (panelSelectedIndex != -1 && renderersOnScreen[panelSelectedIndex] != null)
			{
				renderer = renderersOnScreen[panelSelectedIndex];
				renderer.selected = false;
			}
			
			panelSelectedIndex = index;
			panelSelectedItem = dataSource[index];
			renderer = renderersOnScreen[panelSelectedIndex];
			if (renderer != null)
			{
				renderer.selected = false;
			}
			if (hasEventListener(ScrollEvent.SCROLL_SELECT))
			{
				dispatchEvent(new ScrollEvent(ScrollEvent.SCROLL_SELECT, panelSelectedItem));
			}
		}
		
		private function onMouseWheel(event:MouseEvent):void
		{
			if (!moveByWheelFlag || panelDataSource == null)
			{
				return;
			}
			var index:int = startSourceIndex - event.delta;
			if (index < 0)
			{
				index = 0;
			}
			if (index >= panelDataSource.size)
			{
				index = panelDataSource.size - 1;
			}
			moveTo(index);
			updateSelection();
		}
		
		private function onMouseMove(event:MouseEvent):void
		{
			updateSelection();
		}
		
		private function onRollOver(event:MouseEvent):void
		{
			updateSelection();
		}
		
		private function onRollOut(event:MouseEvent):void
		{
			selectorShape.graphics.clear();
		}
		
		private function onChangeModel (event:ModelEvent):void
		{
			var item:Object = event.item;
			switch (event.kind)
			{
				case ModelEventKind.ITEM_CHANGED:
				{
					for each (var renderer:BaseRenderer in renderersOnScreen)
					{
						if (renderer.data == item)
						{
							renderer.data = item;
							break;
						}
					}
					break;
				}
				default:
				{
					updateDataSource();
					break;	
				}
			}
		}
	}
}