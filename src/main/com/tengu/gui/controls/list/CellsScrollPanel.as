package com.tengu.gui.controls.list
{
	import com.tengu.core.funcs.removeAllChildren;
	import com.tengu.gui.base.GUIComponent;
	import com.tengu.gui.controls.list.components.IBaseRenderer;
	import com.tengu.tween.Tweeny;
	import com.tengu.tween.api.ITween;
	import com.tengu.tween.plugins.DisplayCoordsTween;

	[Style(name="cell_width")]
	[Style(name="cell_height")]
	public class CellsScrollPanel extends ScrollPanel
	{
		private var panelPageIndex:int = 0;

		private var rowsCount:int = 0;
		private var colsCount:int = 0;
		
		public function get pageIndex():int 
		{
			return panelPageIndex;
		}
		
		public function get pagesCount ():uint
		{
			if (dataSource == null)
			{
				return 0;
			}
			return Math.round(dataSource.size / visibleElementsCount);
		}
		
		public function CellsScrollPanel()
		{
			super();
		}
		
		private function getPageIndex (index:int):int
		{
			var result:int = 0;
			if (visibleElementsCount == 0 || dataSource.size == 0)
			{
				return result;
			}
			result = index / visibleElementsCount;
			if (result < 0)
			{
				result = 0;
			}
			if (result >= pagesCount)
			{
				result = pagesCount - 1;
			}
			return result;
		}
		
		private function updateColsAndRows():void
		{
			if (elementWidth == 0 || elementWidth == 0)
			{
				return;
			}
			rowsCount = height / elementHeight;
			colsCount = width / elementWidth;
			visibleElementsCount = rowsCount * colsCount;
		}

		private function renderPage (pageIndex:uint, xCoord:int = 0, yCoord:int = 0):void
		{
			var contentWidth:int  = width;
			var contentHeight:int = height;
			
			var index:int = pageIndex * visibleElementsCount;
			var elementsCount:uint = dataSource.size;

			var i:uint = 0;
			var j:uint = 0;
			var startX:int = xCoord;
			var startY:int = yCoord;
			
			var renderer:IBaseRenderer = null;
			var rendererView:GUIComponent = null;

			for (i = 0; i < rowsCount; i++)
			{
				for (j = 0; j < colsCount; j++)
				{
					if (index >= elementsCount)
					{
						return;
					}
					renderer = getRenderer();
					renderer.data = dataSource.getAt(index);
					rendererView = renderer as GUIComponent;
					rendererView.setSize(elementWidth, elementHeight);
					rendererView.x = xCoord;
					rendererView.y = yCoord;
					innerContainer.addChild(rendererView);

					index++;
					
					xCoord += elementWidth;
				}
				xCoord = startX;
				yCoord += elementHeight;
			}
		}
		
		//Навигация только по страницам
		protected override function cannotMoveToIndex(index:int):Boolean
		{
			return true;
		}
		
		protected function cannotMoveToPage (index:int):Boolean
		{
			var result:Boolean = (panelDataSource != null);
			result = result && (index < pagesCount);
			result = result && (index != pageIndex);
			result = result && (index >=0);
			return !result;
		}
		
		protected override function setStyleSelector(styleName:String, styleValue:*):void
		{
			if (styleName == "cell_width")
			{
				elementWidth = parseInt(String(styleValue)) || 1;
				invalidateScroll();
				return;
			}
			if (styleName == "cell_height")
			{
				elementHeight = parseInt(String(styleValue)) || 1;
				invalidateScroll();
				return;
			}
			super.setStyleSelector(styleName, styleValue);
		}
		
		protected override function updateSize():void
		{
			super.updateSize();
			updateColsAndRows();
			updateScroll();
		}
		
		protected override function renderElements ():void
		{
			if (panelDataSource == null)
			{
				return;
			}
			innerContainer.y = 0;
			renderPage(getPageIndex(startSourceIndex));
		}
		
		protected override function updateStyle():void
		{
			super.updateStyle();
			updateColsAndRows();
		}
		
		protected override function clear():void
		{
			removeAllChildren(innerContainer, disposeRenderer);
		}
		
		private function disposeRenderer(renderer:IBaseRenderer):void
		{
			renderer.data = null;
			renderCache[renderCache.length] = renderer;
		}
		
		public function moveToPageHorizontally (index:int):ITween
		{
			if (cannotMoveToPage(index) || inTweenMode)
			{
				return null;
			}
			
			clear();
			
			var fromPage:int = Math.min(index, panelPageIndex);
			var pagesCount:uint = Math.abs(index - panelPageIndex);
			var toPage:int = fromPage + pagesCount;
			
			var pageX:int = 0;
			var containerX:int = 0;
			
			if (index < panelPageIndex)
			{
				pageX = 0;
				containerX = -1 * pagesCount* width;
			}
			else
			{
				pageX = -1 * pagesCount * width; 
				containerX = pagesCount * width;
			}
			
			innerContainer.x = containerX;
			for (var idx:int = fromPage; idx <= toPage; idx++)
			{
				renderPage(idx, pageX);
				pageX += width;
			}
			
			panelPageIndex = index;
			
			inTweenMode = true;

			return Tweeny.create(innerContainer, DisplayCoordsTween.create).
							during(TWEEN_TIME).
							to({x: 0}).
							onComplete(onCompleteTween).
							start();
		}
		
		public function moveToPageVertically (index:int):void
		{
			
		}
		
		
		protected function onCompleteTween ():void
		{
			selectorShape.visible = true;
			clear();
			renderPage(pageIndex);
			inTweenMode = false;
		}

	}
}