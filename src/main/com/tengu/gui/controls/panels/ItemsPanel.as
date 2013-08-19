package com.tengu.gui.controls.panels
{
	import com.tengu.core.funcs.removeAllChildren;
	import com.tengu.gui.containers.GUIContainer;
	import com.tengu.gui.controls.list.components.IBaseRenderer;
	import com.tengu.gui.layouts.BaseLayout;
	import com.tengu.gui.layouts.VerticalLayout;
	import com.tengu.model.api.ICollection;
	import com.tengu.model.api.IList;
	
	import flash.display.DisplayObject;
	
	public class ItemsPanel extends GUIContainer
	{
		private var defaultItemsOnPage:uint = 0;
		protected var source:IList 	= null;
		protected var index:uint 		 	= 0;
		
		protected var elementsCount:uint 	= 0;
		protected var panelPagesCount:uint 	= 0;
		protected var itemsOnPage:uint 		= 0;
		
		protected var panelRendererClass:Class 	= null;
		
		public function set rendererClass(value:Class):void 
		{
			panelRendererClass = value;
			update();
		}
		
		public function set dataSource (value:IList):void
		{
			if (source == value)
			{
				return;
			}
			clear();
			source = value;
			if (source == null)
			{
				return;
			}
			elementsCount = source.size;
			itemsOnPage = getItemsOnPage();
			panelPagesCount = Math.ceil(elementsCount / itemsOnPage);
			index = 0;
			update();
		}
		
		public function set pageIndex (value:uint):void
		{
			if (index == value)
			{
				return;
			}
			index = value;
			update();
		}
		
		public function get pageIndex():uint 
		{
			return index;
		}

		public function get pagesCount():uint 
		{
			return panelPagesCount;
		}
		
		public override function get displayWidth ():Number
		{
			return getBounds(this).width;
		}
		
		public override function get displayHeight ():Number
		{
			return getBounds(this).height;
		}
		
		public function ItemsPanel(defaultItemsOnPage:uint = 1)
		{
			super();
			this.defaultItemsOnPage = defaultItemsOnPage;
		}
		
		//*** protected ***//
		protected function getDataSource():ICollection
		{
			return source;
		}
		
		protected function getLayout ():BaseLayout
		{
			return new VerticalLayout();
		}

		protected function getItemsOnPage ():uint
		{
			return defaultItemsOnPage;
		}
		
		protected function update ():void
		{
			var startIndex:uint = index * itemsOnPage;
			var lastIndex:uint = startIndex + itemsOnPage;
			var view:IBaseRenderer = null;
			
			removeAllChildren(this, disposeComponent);
			if (source == null)
			{
				return;
			}
			for (var i:int = startIndex; i <  lastIndex; i++)
			{
				if (i >= elementsCount)
				{
					break;
				}
				view = new panelRendererClass();
				view.data = source.getAt(i);
				addChild(view as DisplayObject);
			}
		}
		
		protected override function createChildren():void
		{
			super.createChildren();
			layout = getLayout();
		}
		
		protected override function dispose():void
		{
			clear();
			super.dispose();
		}
		
		public function clear ():void
		{
			source = null;
			removeAllChildren(this, disposeComponent);
		}
	}
}