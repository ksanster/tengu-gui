package com.tengu.gui.tools
{
	import com.tengu.gui.base.GUIComponent;

	public class MarkupParser
	{
		private var components:Object   = null; 
		private var target:GUIComponent = null;
		
		public function MarkupParser(target:GUIComponent)
		{
			this.target = target;
			components = {};
		}
		
		public function parse (xml:XML):void
		{
			if (xml == null)
			{
				return;
			}
		}
		
		public function getComponentById (id:String):GUIComponent
		{
			return components[id];
		}
		
		public function finalize ():void
		{
			target = null;
			components = null;
		}
	}
}