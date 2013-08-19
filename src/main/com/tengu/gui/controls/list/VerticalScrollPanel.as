package com.tengu.gui.controls.list
{
	import com.tengu.gui.base.GUIComponent;
	import com.tengu.gui.controls.list.components.IBaseRenderer;
	import com.tengu.tween.Tween;
	import com.tengu.tween.enum.TweenType;
	
	import flash.display.DisplayObject;

	[Style(name="row_height")]
	public class VerticalScrollPanel extends ScrollPanel
	{
		public function get scrollY ():int
		{
			return 0;
		}
		
		public function get rowHeight():uint 
		{
			return elementHeight;
		}
		
		public function VerticalScrollPanel()
		{
			super();
		}
		
		private function renderFromTo (startIndex:uint, count:uint, yCoord:int = 0):void
		{
			var i:int = 0;
			var index:String = null;
			var data:Object = null;
			var renderer:IBaseRenderer = null;
			var rendererView:GUIComponent = null;
			var endIndex:uint = startIndex + count;
			
			if (endIndex > panelDataSource.size)
			{
				endIndex = panelDataSource.size;
			}
			
			for (index in renderersOnScreen)
			{
				i = int(index);
				if (i < startIndex || i >= endIndex)
				{
					renderer = renderersOnScreen[index];
					renderer.data = null;
					renderCache[renderCache.length] = renderer;
					innerContainer.removeChild(renderer as DisplayObject);
					delete renderersOnScreen[index];
				}
			}
			
			for (i = startIndex; i < endIndex; i++)
			{
				renderer = renderersOnScreen[i];
				if (renderer == null)
				{
					renderer = getRenderer();
					renderersOnScreen[i] = renderer;
					innerContainer.addChild(renderer as DisplayObject);
				}
				rendererView = renderer as GUIComponent;
				rendererView.y = yCoord;
				rendererView.setSize(width, elementHeight);
				
				yCoord += elementHeight;
				
				renderer.selected = (i == panelSelectedIndex);				
				renderer.data = (i <= elementsCount) ? panelDataSource.getAt(i) : null;
			}
		}
		
		protected override function getRenderer():IBaseRenderer
		{
			var renderer:IBaseRenderer = super.getRenderer();
			(renderer as GUIComponent).setSize(width, elementHeight);
			return renderer;
		}
		
		protected override function updateSize(width:int, height:int):void
		{
			super.updateSize(width, height);
			visibleElementsCount = height / elementHeight;
			updateScroll();
		}
		
		protected override function renderElements ():void
		{
			if (panelDataSource == null)
			{
				return;
			}
			innerContainer.y = 0;
			renderFromTo(startSourceIndex, visibleElementsCount);
		}
		
		protected override function getIndexUnderMouse():int
		{
			var indexRowUnderMouse:int = startSourceIndex + innerContainer.mouseY / elementHeight;
			if (panelDataSource == null || indexRowUnderMouse < 0 || indexRowUnderMouse >= panelDataSource.size)
			{
				return -1;
			}
			return indexRowUnderMouse;
		}
		
		protected override function updateSelection():void
		{
			selectorShape.graphics.clear();
			if (!showSelector)
			{
				return;
			}
			var renderer:IBaseRenderer = null;
			var indexRowUnderMouse:int = getIndexUnderMouse();
			if (indexRowUnderMouse == -1)
			{
				return;
			}
			renderer = renderersOnScreen[indexRowUnderMouse];
			if (renderer == null)
			{
				return;
			}
			
			selectorShape.y = (renderer as DisplayObject).y;
			selectorShapeFill.apply(selectorShape.graphics, width, elementHeight + 1);
		}
		
		protected override function setStyleSelector(styleName:String, styleValue:*):void
		{
			if (styleName == "row_height")
			{
				elementHeight = parseInt(String(styleValue)) || 1;
				invalidateScroll();
				return;
			}
			super.setStyleSelector(styleName, styleValue);
		}
		
		public override function tweenTo(index:int):void
		{
			var startY:int = 0;
			var renderCount:uint  = 0;
			var tween:Tween = null;

			if (cannotMoveToIndex(index) || inTweenMode)
			{
				return;
			}
			inTweenMode = true;
			
			startY = (startSourceIndex - index) * elementHeight;
			renderCount = Math.abs(startSourceIndex - index) + visibleElementsCount;
			
			renderFromTo(Math.min(index, startSourceIndex), renderCount, Math.min(0, startY));
			
			innerContainer.y = - startY;
			
			tween = tweener.addTween(TweenType.DISPLAY_OBJECT, 15, {y:0});
			tween.addCompleteHandler(onCompleteTween, [tween]);

			startSourceIndex = index;
			selectorShape.visible = false;
		}
		
		private function onCompleteTween (tween:Tween):void
		{
			tween.removeCompleteHandler(onCompleteTween);
			selectorShape.visible = true;
			updateSelection();
			inTweenMode = false;
		}
	}
}