package com.tengu.gui.core
{
	import flash.display.Sprite;

	public class GUIContainer extends GUIComponent
	{
		private var contentList:Array = null;
		
		public final function get content ():Array
		{
			return contentList;
		}
		
		public final function set content (value:Array):void
		{
			if (content != null || !(value is Array))
			{
				return;
			}
			contentList = value;
			for each (var contentElement:Sprite in contentList)
			{
				addContentElement(contentElement);
			}
			updateContent();
		}
		
		public function GUIContainer()
		{
			super();
		}
		
		protected override function dispose():void
		{
			super.dispose();
			
			for each (var contentElement:Sprite in contentList)
			{
				if (contentElement is GUIComponent)
				{
					(contentElement as GUIComponent).finalize();
				}
			}
			contentList = null;
		}
		
		protected function updateContent():void
		{
			//Empty
		}
	}
}