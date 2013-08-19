package com.tengu.gui.controls.buttonbar
{
	import com.tengu.core.tengu_internal;
	import com.tengu.gui.base.GUIComponent;
	import com.tengu.gui.containers.VBox;
	import com.tengu.gui.controls.buttons.BaseButton;
	import com.tengu.gui.controls.buttons.TextButton;
	import com.tengu.gui.events.SelectedIndexChangeEvent;
	
	[Style(name="button_bar")]
	public class TabNavigator extends VBox
	{
		private var tabActiveComponent:GUIComponent = null;

		protected var buttonBar:ButtonGroup = null;
		protected var labels:Vector.<String> 			= null;
		protected var components:Vector.<GUIComponent> 	= null;
		
		
		public function get activeComponent():GUIComponent 
		{
			return tabActiveComponent;
		}
		
		public function get barHeight():int 
		{
			return buttonBar.height;
		}
		
		public function set barHeight(value:int):void 
		{
			buttonBar.height = value;
			invalidateLayout();
		}
		
		public function set selectedIndex(value:int):void 
		{
			buttonBar.selectedIndex = value;
			changeActiveComponent(value);
		}
		
		public function get selectedIndex():int 
		{
			return buttonBar.selectedIndex;
		}
		
		public function TabNavigator()
		{
			super();
		}
		
		private function normalizeLength():void
		{
			var count:uint = components.length;
			if (labels.length > components.length)
			{
				labels.length = components.length;
			}
			for (var i:int = labels.length; i < count; i++)
			{
				labels[labels.length] = String(components[i]);
			}
		}
		
		protected function changeActiveComponent(selectedIndex:int):void
		{
			if (tabActiveComponent != null)
			{
				removeChild(tabActiveComponent);
				tabActiveComponent = null;
			}
			if (selectedIndex < 0 || selectedIndex >= components.length)
			{
				return;
			}
			tabActiveComponent = components[selectedIndex];
			tabActiveComponent.y = buttonBar.height;
			tabActiveComponent.setSize(width, height - buttonBar.height);
			addChild(tabActiveComponent);
		}
		
		protected function getButtonClass ():Class
		{
			return TextButton;
		}
		
		protected function getDividerClass ():Class
		{
			return null;
		}
		
		protected override function createChildren():void
		{
			super.createChildren();
			
			buttonBar = new ButtonGroup();
			buttonBar.percentWidth = 100;
			buttonBar.height = 15;
			buttonBar.addEventListener(SelectedIndexChangeEvent.SELECTED_INDEX_CHANGE, onChangeSelectedIndex);
			addChild(buttonBar);
			
			cropContent = false;
			
			components = new Vector.<GUIComponent>();
		}
		
		protected override function dispose():void
		{
			buttonBar.removeEventListener(SelectedIndexChangeEvent.SELECTED_INDEX_CHANGE, onChangeSelectedIndex);
			buttonBar.finalize();
			buttonBar = null;
			
			components.length = 0;
			labels.length = 0;
			
			tabActiveComponent = null;

			super.dispose();
		}
		
		protected override function updateSize(width:int, height:int):void
		{
			super.updateSize(width, height);
			if (tabActiveComponent != null)
			{
				tabActiveComponent.setSize(width, height - buttonBar.height);
			}
		}
		
		protected override function setStyleSelector(styleName:String, styleValue:*):void
		{
			if (styleName == "button_bar")
			{
				buttonBar.tengu_internal::parseStyle(styleValue);
				return;
			}
		}
		
		public function assignContent (labels:Vector.<String>, components:Vector.<GUIComponent>, selectedIndex:int = -1):void
		{
			this.labels = labels.slice();
			this.components = components.slice();
			normalizeLength();
			buttonBar.dataSource = labels;
			
			buttonBar.selectedIndex = selectedIndex;
			changeActiveComponent(selectedIndex);
		}
		
		public function clear ():void
		{
			buttonBar.clear();
			if (tabActiveComponent != null)
			{
				removeChild(tabActiveComponent);
				tabActiveComponent = null;
			}
			
			for each (var component:GUIComponent in components)
			{
				component.finalize();
			}
			
			labels.length = 0;
			components.length = 0;
		}
		
		public function add (button:BaseButton, content:GUIComponent):void
		{
			var index:int = buttonBar.selectedIndex;
			var needChange:Boolean = (components != null && index == components.length);
			buttonBar.add(button);
			components[components.length] = content;
			if (needChange)
			{
				changeActiveComponent(index);
			}
			invalidateLayout();
		}
		
		private function onChangeSelectedIndex(event:SelectedIndexChangeEvent):void
		{
			changeActiveComponent(event.selectedIndex);
		}
	}
}