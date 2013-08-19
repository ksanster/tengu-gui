package com.tengu.gui.controls.combobox
{
	import com.tengu.core.tengu_internal;
	import com.tengu.gui.base.GUIComponent;
	import com.tengu.gui.containers.GUIContainer;
	import com.tengu.gui.controls.text.Text;
	import com.tengu.gui.controls.buttons.BaseButton;
	import com.tengu.gui.controls.list.VerticalScrollPanel;
	import com.tengu.gui.controls.scrollbar.VerticalScrollBar;
	import com.tengu.gui.events.ScrollEvent;
	import com.tengu.gui.events.SelectedIndexChangeEvent;
	import com.tengu.gui.fills.ColorFloodFill;
	import com.tengu.gui.fills.ShapeFill;
	import com.tengu.gui.layouts.HorizontalLayout;
	import com.tengu.model.api.IList;
	import com.tengu.tween.Tween;
	import com.tengu.tween.TweenSystem;
	import com.tengu.tween.Tweener;
	import com.tengu.tween.easing.Quadratic;
	import com.tengu.tween.enum.TweenType;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	[Style(name="scroll_bar")]
	[Style(name="list")]
	[Style(name="border")]
	[Style(name="background_button")]
	
	[Event (name="selectedIndexChange", type="com.tengu.gui.events.SelectedIndexChangeEvent")]
	public class ComboBox extends GUIComponent
	{
		private static const BACKGROUND_FILL:ColorFloodFill = new ColorFloodFill();
		
		private var boxSelectedIndex:int = -1;
		
		private var borderFill:ShapeFill	= null;
		
		private var backgroundButton:BaseButton = null;
		private var label:Text					= null;
		private var list:VerticalScrollPanel 	= null;
		private var dropDownHolder:GUIContainer = null;
		private var scrollBar:VerticalScrollBar = null;
		
		private var rowsCount:uint				= 7;
		
		private var dropDownParam:uint = 0;
		
		private var inTween:Boolean = false;
		private var opened:Boolean = false;
		
		private var defaultLabelText:String = null;
		
		private var tweener:Tweener = null;
		
		
		public function get text():String 
		{
			return label.text == defaultLabelText ? "" : label.text;
		}
		
		public function set defaultText(value:String):void 
		{
			defaultLabelText = value || "";
			if (selectedIndex == -1)
			{
				label.text = defaultLabelText;
			}
		}
		
		public function set dropDownTweenParam(value:uint):void 
		{
			dropDownParam = value;
			dropDownHolder.scrollRect = new Rectangle(0, dropDownHolder.height - dropDownParam, dropDownHolder.width, dropDownParam);
		}
		
		public function get dropDownTweenParam():uint 
		{
			return dropDownParam;
		}
		
		public function set dataSource(value:IList):void 
		{
			if (list.dataSource == value)
			{
				return;
			}
			list.dataSource = value;
			scrollBar.enabled = value.size > rowsCount;
			scrollBar.max = value.size - rowsCount;
		}
		
		public function get dataSource():IList
		{
			return list.dataSource;
		}
		
		public function set selectedIndex(value:int):void 
		{
			if (boxSelectedIndex == value || list.dataSource == null || boxSelectedIndex >= list.dataSource.size)
			{
				return;
			}
			boxSelectedIndex = value;
			if (boxSelectedIndex >= 0)
			{
				label.text = list.dataSource[boxSelectedIndex] as String;
			}
			else if (defaultLabelText != null)
			{
				label.text = defaultLabelText;
			}

		}
		
		public function get selectedIndex():int 
		{
			return boxSelectedIndex;
		}
		
		public function ComboBox()
		{
			super();
		}
		
		protected override function measure():void
		{
			componentWidth  = 215;
			componentHeight = 20;
		}
		
		protected override function createChildren():void
		{
			super.createChildren();
			
			mouseEnabled = false;
			
			backgroundButton = new BaseButton();
			backgroundButton.setSize(componentWidth, componentHeight);
			backgroundButton.addEventListener(MouseEvent.CLICK, onClickBackground);
			addChild(backgroundButton);
			
			label = new Text("", null, false);
			label.mouseEnabled = false;
			label.setSize(componentWidth, componentHeight);
			addChild(label);
			
			list = new VerticalScrollPanel();
			list.addEventListener(ScrollEvent.SCROLL_SELECT, onListClick);
			list.percentWidth  = 100;
			list.percentHeight = 100;
			list.moveByWheel  = false;
			list.tengu_internal::parseStyle({renderer_class:ComboBoxRowRenderer});

			scrollBar = new VerticalScrollBar();
			scrollBar.width 			= 13;
			scrollBar.percentHeight 	= 100;
			scrollBar.enabled			= false;
			scrollBar.step				= 1;
			scrollBar.pageSize			= 7;
			scrollBar.addEventListener(Event.CHANGE, onChangeScroll);
			
			dropDownHolder = new GUIContainer();
			dropDownHolder.layout = new HorizontalLayout();
			dropDownHolder.layout.paddingRight = 2;
			dropDownHolder.setSize(componentWidth, rowsCount * list.rowHeight + 3);
			dropDownHolder.addChild(list);
			dropDownHolder.addChild(scrollBar);
			
			tweener = TweenSystem.getTweener(this);
		}
		
		protected override function dispose():void
		{
			tweener.removeAllTweens();
			tweener = null;
			
			backgroundButton.removeEventListener(MouseEvent.CLICK, onClickBackground);
			backgroundButton = null;
			
			label.finalize();
			label = null;
			
			list.finalize();
			list = null;
			
			scrollBar.removeEventListener(Event.CHANGE, onChangeScroll);
			scrollBar.finalize();
			scrollBar = null;
			
			dropDownHolder.finalize();
			dropDownHolder = null;

			super.dispose();
		}
		
		protected override function updateDisplay():void
		{
			super.updateDisplay();
			
			BACKGROUND_FILL.apply(backgroundButton.graphics, componentWidth, componentHeight);
			borderFill.apply(dropDownHolder.graphics, dropDownHolder.width - 1, dropDownHolder.height - 1);
			
			dropDownHolder.y = componentHeight;
			label.x = 1;
			label.y = (backgroundButton.height - label.height) * .5;
		}
		
		
		protected override function updateSize(width:int, height:int):void
		{
			super.updateSize(width, height);
			backgroundButton.setSize(componentWidth, componentHeight);
			label.setSize(componentWidth, componentHeight);
		}
		
		protected override function setStyleSelector(styleName:String, styleValue:*):void
		{
			if (styleName == "background_button")
			{
				backgroundButton.tengu_internal::parseStyle(styleValue);
				return;
			}
			if (styleName == "scroll_bar")
			{
				scrollBar.tengu_internal::parseStyle(styleValue);
				return;
			}
			if (styleName == "border")
			{
				borderFill = textureManager.getTexture(styleValue);
				return;
			}
			if (styleName == "list")
			{
				list.tengu_internal::parseStyle(styleValue);
				return;
			}
		}
		
		public function open ():void
		{
			if (inTween || opened)
			{
				return;
			}
			inTween = true;
			opened = true;
			dropDownTweenParam = 0;
			addChild(dropDownHolder);
			
			var tween:Tween = tweener.addTween(TweenType.PROPERTY, 10, {dropDownTweenParam:dropDownHolder.height, ease:Quadratic.easeOut});
			tween.addCompleteHandler(onCompleteTween, [tween]);
		}
		
		public function close ():void
		{
			if (inTween || !opened)
			{
				return;
			}
			inTween = true;
			opened = false;
			var tween:Tween = tweener.addTween(TweenType.PROPERTY, 10, {dropDownTweenParam:0, ease:Quadratic.easeOut});
			tween.addCompleteHandler(onCompleteTween, [tween]);
		}
		
		private function onCompleteTween (tween:Tween):void
		{
			tween.removeCompleteHandler(onCompleteTween);
			inTween = false;
			if (!opened)
			{
				removeChild(dropDownHolder);
			}
		}
		
		private function onClickBackground(event:MouseEvent):void
		{
			if (opened)
			{
				close();
			}
			else
			{
				open();
			}
		}		
		
		private function onChangeScroll(event:Event):void
		{
			list.moveTo(Math.round(scrollBar.position));
		}
		
		private function onListClick(event:ScrollEvent):void
		{
			var selectedItem:String = list.selectedItem as String;
			label.text = list.selectedItem as String;
			boxSelectedIndex = list.selectedIndex;
			if (hasEventListener(SelectedIndexChangeEvent.SELECTED_INDEX_CHANGE))
			{
				dispatchEvent(new SelectedIndexChangeEvent(SelectedIndexChangeEvent.SELECTED_INDEX_CHANGE, boxSelectedIndex));
			}
			close();
		}
		
	}
}