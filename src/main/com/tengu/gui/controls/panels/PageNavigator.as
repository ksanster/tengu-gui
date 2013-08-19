package com.tengu.gui.controls.panels
{
	import com.tengu.core.tengu_internal;
	import com.tengu.gui.base.GUIComponent;
	import com.tengu.gui.controls.text.Text;
	import com.tengu.gui.controls.buttons.BaseButton;
	import com.tengu.gui.events.PageNavigatorEvent;
	import com.tengu.model.api.IList;
	
	import flash.events.MouseEvent;
	
	[Style(name="prev_button")]
	[Style(name="next_button")]
	[Style(name="text")]
	public class PageNavigator extends GUIComponent
	{
		private var innerPanel:ItemsPanel = null;

		private var prevButton:BaseButton		= null;
		private var nextButton:BaseButton 		= null;
		private var pageLabel:Text		  		= null;
		
		public function get panel():ItemsPanel 
		{
			return innerPanel;
		}
		
		public function PageNavigator(value:ItemsPanel)
		{
			super();
			innerPanel = value;
			innerPanel.cropContent = false;
			addChild(innerPanel);
			invalidateDisplay();
			updateButtonState();
		}
		
		private function updateButtonState ():void
		{
			if (innerPanel.pagesCount < 2)
			{
				prevButton.visible = false;
				nextButton.visible = false;
				pageLabel.text = "";
				return;
			}
			var pageText:String = String(innerPanel.pageIndex + 1) + "/" + String(innerPanel.pagesCount);
			
			prevButton.visible = true;
			nextButton.visible = true;
			
			prevButton.enabled = innerPanel.pageIndex > 0;
			nextButton.enabled = innerPanel.pageIndex < (innerPanel.pagesCount - 1);
		}
		
		protected function createPrevButton ():BaseButton
		{
			var result:BaseButton = new BaseButton();
			result.setSize(8, 15);
			return result;
		}
		
		protected function createNextButton ():BaseButton
		{
			var result:BaseButton = new BaseButton();
			result.setSize(8, 15);
			return result;
		}
		
		protected function createPageLabel ():Text
		{
			var result:Text = new Text("", null, false);
			result.setSize(100, 20);
			return result;
		}
		
		protected override function createChildren():void
		{
			super.createChildren();
			
			prevButton = createPrevButton();
			prevButton.addEventListener(MouseEvent.CLICK, onClickPrev);
			addChild(prevButton);
			
			nextButton = createNextButton();
			nextButton.addEventListener(MouseEvent.CLICK, onClickNext);
			addChild(nextButton);
			
			pageLabel = createPageLabel();
			addChild(pageLabel);
			
		}

		protected override function dispose():void
		{
			innerPanel.finalize();
			innerPanel = null;
			
			prevButton.removeEventListener(MouseEvent.CLICK, onClickPrev);
			prevButton.finalize();
			prevButton = null;
			
			nextButton.removeEventListener(MouseEvent.CLICK, onClickPrev);
			nextButton.finalize();
			nextButton = null;
			
			pageLabel.finalize();
			pageLabel = null;

			super.dispose();
		}
		
		protected override function updateDisplay():void
		{
			super.updateDisplay();
			
			var yCoord:uint = height - prevButton.height - 5;
			
			prevButton.x = (width - prevButton.width - nextButton.width - pageLabel.width) * .5;
			prevButton.y = yCoord;
			
			pageLabel.x = prevButton.x + prevButton.width;
			pageLabel.y = yCoord - (pageLabel.height - prevButton.height) * .5;
			
			nextButton.x = pageLabel.x + pageLabel.width;
			nextButton.y = yCoord;
		}
		
		protected override function updateSize(width:int, height:int):void
		{
			super.updateSize(width, height);
			innerPanel.setSize(width, height - prevButton.height - 10);
		}
		
		protected override function setStyleSelector(styleName:String, styleValue:*):void
		{
			if (styleName == "prev_button")
			{
				prevButton.tengu_internal::parseStyle(styleValue);
				return;
			}
			if (styleName == "next_button")
			{
				nextButton.tengu_internal::parseStyle(styleValue);
				return;
			}
			if (styleName == "text")
			{
				pageLabel.format = styleValue;
				return;
			}
		}
		
		public function clear ():void
		{
			innerPanel.clear();
			updateButtonState();
		}
		
		public function update (dataSource:IList):void
		{
			innerPanel.dataSource = dataSource;
			updateButtonState();
		}
		
		private function onClickPrev(event:MouseEvent):void
		{
			if (innerPanel.pageIndex == 0)
			{
				return;
			}
			innerPanel.pageIndex--;
			updateButtonState();
			
			dispatchEvent( new PageNavigatorEvent( PageNavigatorEvent.PAGE_UP ) );
		}
		
		private function onClickNext(event:MouseEvent):void
		{
			if (innerPanel.pageIndex == innerPanel.pagesCount - 1)
			{
				return;
			}
			innerPanel.pageIndex++;
			updateButtonState();
			
			dispatchEvent( new PageNavigatorEvent( PageNavigatorEvent.PAGE_DOWN ) );
		}

	}
}