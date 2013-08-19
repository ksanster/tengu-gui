package com.tengu.gui.controls.buttonbar
{
	import com.tengu.core.funcs.removeAllChildren;
	import com.tengu.gui.containers.BaseBox;
	import com.tengu.gui.controls.buttons.BaseButton;
	import com.tengu.gui.controls.buttons.TextButton;
	import com.tengu.gui.enum.HorizontalAlign;
	import com.tengu.gui.layouts.BaseLayout;
	import com.tengu.gui.layouts.HorizontalLayout;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.ApplicationDomain;
	
	[Style(name="button_class")]
	[Style(name="button_style")]
	[Style(name="gap")]
	[Style(name="first_button_style")]
	[Style(name="last_button_style")]
	[Style(name="divider_class")]
	[Style(name="background_fill")]
	[Style(name="button_width")]
	
	[Event(name="change", type="flash.events.Event")]
	public class ButtonBar extends BaseBox
	{
		private var buttonFactoryMethod:Function = null;
		private var buttonFactoryClass:Class = null;
		private var dividerFactoryClass:Class = null;
		private var buttonDefaultWidth:uint  = 0;
		private var needsButtonUpdate:Boolean = false;
		private var source:Vector.<String> = null;

		private var buttonStyle:String = null;
		private var firstButtonStyle:String = null;
		private var lastButtonStyle:String = null;
		
		private var barSelectedIndex:int = -1;
		private var barButtons:Vector.<BaseButton> = null;
		private var buttonsCount:uint = 0;
		
		private var needsClear:Boolean = false;
		
		private var childsByIndex:Vector.<DisplayObject> = null;
		
		public function set buttonFactory(value:Function):void 
		{
			buttonFactoryMethod = value;
			needsClear = true;
			invalidate(VALIDATION_FLAG_DATA);
		}
		
		public function set dataSource (value:Vector.<String>):void
		{
			if (source == value)
			{
				return;
			}
			needsClear = true;
			source = value;
			invalidate(VALIDATION_FLAG_DATA, VALIDATION_FLAG_STYLE);
		}
		
		public function get dataSource ():Vector.<String>
		{
			return source;
		}
		
		public function set selectedIndex(value:int):void 
		{
			barSelectedIndex = value;
			if (value >= buttonsCount)
			{
				return;
			}
			updateSelection();
		}
		
		public function get selectedIndex():int 
		{
			return barSelectedIndex;
		}
		
		public function get buttons():Vector.<BaseButton>
		{
			return barButtons;
		} 
		
		public function ButtonBar()
		{
			super();
		}
		
		private function createButton (index:uint, max:uint):BaseButton
		{
			var button:BaseButton = new buttonFactoryClass();
			var buttonWidth:uint = (buttonDefaultWidth == 0) ? width / buttonsCount : buttonDefaultWidth;
			button.useHandCursor = false;
			button.buttonMode = false;
			button.toggle = true;
			button.setSize(buttonWidth, height);
			return button;
		}

		private function createButtons ():void
		{
			var label:String = null;
			var button:BaseButton = null;
			var divider:DisplayObject = null;
			var bStyle:String = null;
			var factory:Function = buttonFactoryMethod || createButton; 			
			
			buttonsCount = source.length;
			buttonFactoryClass ||= TextButton;
			
			for (var i:int = 0; i < buttonsCount; i++)
			{
				label = source[i];
				button = factory(i, buttonsCount);
				button.style = getButtonStyle(i); 
				if (button is TextButton)
				{
					(button as TextButton).label = label;
				}
				barButtons[barButtons.length] = button;
				
				addChild(button);
				childsByIndex[childsByIndex.length] = button;
				if (dividerFactoryClass != null && i < buttonsCount - 1)
				{
					divider = new dividerFactoryClass();
					addChild(divider);
					childsByIndex[childsByIndex.length] = divider;
				}
			}
			
		}
		
		private function updateButtons ():void
		{
			var button:TextButton = null;
			var baseButton:BaseButton = null;
			var sourceSize:uint = 0;			
			
			if (source == null)
			{
				return;
			}
			
			sourceSize = source.length;
			for (var i:uint = 0; i < buttonsCount; i++)
			{
				baseButton = barButtons[i];
				baseButton.style = getButtonStyle(i); 
				button = baseButton as TextButton;
				if (button == null)
				{
					continue;
				}
				button.selected = (i == barSelectedIndex);
				button.mouseEnabled = !button.selected;
				button.label = source[i]; 
			}

		}
		
		private function getButtonStyle(i:uint):String
		{
			var result:String = (i == 0) ? firstButtonStyle : (i == buttonsCount - 1) ? lastButtonStyle : buttonStyle;
			result ||= buttonStyle;
			return result;
		}
		
		private function updateSelection ():void
		{
			var button:BaseButton = null;
			for (var i:uint = 0; i < buttonsCount; i++)
			{
				button = barButtons[i];
				if (i == barSelectedIndex)
				{
					button.selected = true;
					button.enabled = false;
					addChildAt(button, numChildren - 1);
				}
				else
				{
					button.selected = false;
					button.enabled = true;
				}
				button.selected = (i == barSelectedIndex);
				button.mouseEnabled = !button.selected;
			}
		}
		
		protected override function getLayout():BaseLayout
		{
			var hLayout:HorizontalLayout = new HorizontalLayout();
			hLayout.horizontalAlign = HorizontalAlign.LEFT;
			hLayout.gap = 0;
			return hLayout;
		}
		
		protected override function createChildren():void
		{
			super.createChildren();
			cropContent = false;
			
			childsByIndex = new Vector.<DisplayObject>();
			barButtons = new Vector.<BaseButton>();
			buttonFactoryClass = TextButton;
			
			addEventListener(MouseEvent.CLICK, onClick);

		}
		
		protected override function dispose():void
		{
			clear();
			buttonFactoryClass  = null;
			dividerFactoryClass = null;
			childsByIndex 		= null;
			removeEventListener(MouseEvent.CLICK, onClick);

			super.dispose();
		}
		
		protected override function updateData():void
		{
			super.updateData();
			
			if (needsClear)
			{
				removeAllChildren(this, disposeComponent);
				buttonsCount = 0;
				barButtons.length = 0;
				childsByIndex.length = 0;
				needsClear = false;
			}
			if (source == null)
			{
				return;
			}
			if (buttonsCount == 0)
			{
				createButtons();
				updateSelection();
			}
		}
		
//		protected override function updateSize():void
//		{
//			super.updateSize();
//			if (buttonsCount == 0)
//			{
//				return;
//			}
//			var buttonWidth:uint = buttonDefaultWidth || width / buttonsCount;
//			for each (var button:BaseButton in barButtons)
//			{
//				button.width = buttonWidth;
//			}
//		}
//		
		protected override function setStyleSelector(styleName:String, styleValue:*):void
		{
			if (styleName == "button_class")
			{
				if (styleValue is Class)
				{
					buttonFactoryClass = styleValue as Class;
				}
				else 
				{
					buttonFactoryClass = ApplicationDomain.currentDomain.getDefinition(styleValue) as Class;
				}
				needsButtonUpdate = true;
				needsClear = true;
				return;
			}
			if (styleName == "button_style")
			{
				buttonStyle = styleValue;
				needsButtonUpdate = true;
				return;
			}
			if (styleName == "first_button_style")
			{
				firstButtonStyle = styleValue;
				needsButtonUpdate = true;
				return;
			}
			if (styleName == "last_button_style")
			{
				lastButtonStyle = styleValue;
				needsButtonUpdate = true;
				return;
			}
			if (styleName == "divider_class")
			{
				dividerFactoryClass = styleValue;
				needsButtonUpdate = true;
				needsClear = true;
				return;
			}
			if (styleName == "button_width")
			{
				 buttonDefaultWidth = parseInt(String(styleValue));
				 needsButtonUpdate = true;
				 needsClear = true;
				 return;
			}
			if (styleName == "gap")
			{
				layout.gap = parseInt(styleValue);
				needsButtonUpdate = true;
				needsClear = true;
				return;
			}
			super.setStyleSelector(styleName, styleValue);
		}
		
		protected override function updateStyle():void
		{
			super.updateStyle();
			if (needsButtonUpdate)
			{
				updateData();
				needsButtonUpdate = false;
			}
		}
		
		protected override function updateDisplay():void
		{
			super.updateDisplay();
			updateButtons();
		}
		
		public function clear ():void
		{
			buttonsCount = 0;
			barButtons.length = 0;
			childsByIndex.length = 0;
			removeAllChildren(this, disposeComponent);
			barSelectedIndex = -1;
			needsClear = false;
		}
		
		public override function getChildByIndex(index:int):DisplayObject
		{
			if (index < 0 || index >= childsByIndex.length)
			{
				return null;
			}
			return childsByIndex[index];
		}
		
		private function onClick(event:MouseEvent):void
		{
			var tmpButton:BaseButton = null;
			var button:BaseButton = event.target as BaseButton;
			if (button == null)
			{
				return;
			}
			var newIndex:int = barButtons.indexOf(button);
			if (newIndex != barSelectedIndex)
			{
				barSelectedIndex = newIndex;
				if (hasEventListener(Event.CHANGE))
				{
					dispatchEvent(new Event(Event.CHANGE));
				}
			}
			updateSelection();
		}
	}
}