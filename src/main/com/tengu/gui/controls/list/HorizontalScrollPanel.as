package com.tengu.gui.controls.list
{
	import com.tengu.gui.base.GUIComponent;
	import com.tengu.gui.controls.list.components.IBaseRenderer;
	import com.tengu.tween.Tweeny;
	import com.tengu.tween.plugins.DisplayCoordsTween;
	
	import flash.display.DisplayObject;

	[Style(name="column_width")]
	public class HorizontalScrollPanel extends ScrollPanel
	{
		public function HorizontalScrollPanel()
		{
			super();
		}
		
		protected function getScreenRenderer (index:int):IBaseRenderer
		{
			var renderer:IBaseRenderer = renderersOnScreen[index];
			if (renderer == null)
			{
				renderer = getRenderer();
				renderersOnScreen[index] = renderer;
				innerContainer.addChild(renderer as DisplayObject);
			}
			return renderer;
		}
		
		protected function renderFromTo (startIndex:uint, count:uint, xCoord:int = 0):void
		{
			var i:int = 0;
			var index:String = null;
			var data:Object = null;
			var renderer:IBaseRenderer = null;
			var rendererView:GUIComponent = null;
			
			endSourceIndex = startIndex + count;
			
			if (endSourceIndex > panelDataSource.size)
			{
				endSourceIndex = panelDataSource.size;
			}
			
			for (index in renderersOnScreen)
			{
				i = int(index);
				if (i < startIndex || i >= endSourceIndex)
				{
					renderer = renderersOnScreen[index];
					renderer.data = null;
					renderCache[renderCache.length] = renderer;
					innerContainer.removeChild(renderer as DisplayObject);
					delete renderersOnScreen[index];
				}
			}
			
			for (i = startIndex; i < endSourceIndex; i++)
			{
				renderer = getScreenRenderer(i);
				rendererView = renderer as GUIComponent;
				rendererView.x = xCoord;
				rendererView.setSize(elementWidth, height);
				
				xCoord += elementWidth;
				xCoord += panelGap;
				
				renderer.selected = (i == panelSelectedIndex);				
				renderer.data = (i < elementsCount) ? panelDataSource.getAt(i) : null;
			}
		}
		
		protected override function getRenderer():IBaseRenderer
		{
			var renderer:IBaseRenderer = super.getRenderer();
			(renderer as GUIComponent).setSize(elementWidth, height);
			return renderer;
		}
		
		protected override function updateSize():void
		{
			super.updateSize();
			visibleElementsCount = width / elementWidth;
			updateScroll();
		}
		
		protected override function renderElements ():void
		{
			if (panelDataSource == null)
			{
				return;
			}
			innerContainer.y = 0;
			startSourceIndex = normalizeStartIndex(startSourceIndex);
			renderFromTo(startSourceIndex, visibleElementsCount);
		}
		
		protected override function getIndexUnderMouse():int
		{
			var indexRowUnderMouse:int = startSourceIndex + innerContainer.mouseX / elementWidth;
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
			
			selectorShape.x = (renderer as DisplayObject).x;
			selectorShapeFill.apply(selectorShape.graphics, width, elementHeight + 1);
		}
		
		public override function tweenTo(index:int):void
		{
			var startX:int = 0;
			var renderCount:uint  = 0;
			
			if (cannotMoveToIndex(index) || inTweenMode)
			{
				return;
			}
			
			index = normalizeStartIndex(index);
			inTweenMode = true;
			
			startX = (startSourceIndex - index) * (elementWidth + panelGap);
			renderCount = Math.abs(startSourceIndex - index) + visibleElementsCount;
			
			renderFromTo(Math.min(index, startSourceIndex), renderCount, Math.min(0, startX));
			
			innerContainer.x = - startX;
			
			Tweeny.create(innerContainer, DisplayCoordsTween.create).
					during(TWEEN_TIME).
					to({x: 0}).
					onComplete(onCompleteTween).
					start();

			
			startSourceIndex = index;
			selectorShape.visible = false;
		}
		
		protected override function setStyleSelector(styleName:String, styleValue:*):void
		{
			if (styleName == "column_width")
			{
				elementWidth = parseInt(String(styleValue)) || 1;
				invalidateScroll();
				return;
			}
			super.setStyleSelector(styleName, styleValue);
		}
		
		protected function onCompleteTween ():void
		{
			selectorShape.visible = true;
			updateSelection();
			inTweenMode = false;
		}

	}
}