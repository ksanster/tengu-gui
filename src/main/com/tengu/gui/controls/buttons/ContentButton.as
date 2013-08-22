package com.tengu.gui.controls.buttons
{
	import com.tengu.core.funcs.removeAllChildren;
	import com.tengu.gui.containers.GUIContainer;
	import com.tengu.gui.enum.HorizontalAlign;
	import com.tengu.gui.enum.VerticalAlign;
	import com.tengu.gui.layouts.BaseLayout;
	import com.tengu.gui.layouts.HorizontalLayout;
	import com.tengu.gui.layouts.ILayout;

	[Style(name="horizontal_align")]
	[Style(name="vertical_align")]
	[Style(name="gap")]
	[Style(name="y_offset_up_state")]
	[Style(name="y_offset_down_state")]
	public class ContentButton extends BaseButton
	{
		protected var contentHolder:GUIContainer = null;
		protected var downDeltaY:int = 1;
		protected var upDeltaY:int   = 0;
		
		public function set layout(value:ILayout):void 
		{
			contentHolder.layout = value;
			contentHolder.invalidate(VALIDATION_FLAG_LAYOUT);
		}
		
		public function get layout():ILayout 
		{
			return contentHolder.layout;
		}
		
		public override function set paddingLeft(value:int):void
		{
			super.paddingLeft = value;
			contentHolder.paddingLeft = value;
		}
		
		public override function set paddingRight(value:int):void
		{
			super.paddingRight = value;
			contentHolder.paddingRight = value;
		}
		
		public override function set paddingTop(value:int):void
		{
			super.paddingTop = value;
			contentHolder.paddingTop = value;
		}
		
		public override function set paddingBottom(value:int):void
		{
			super.paddingBottom = value;
			contentHolder.paddingBottom = value;
		}
		
		public function ContentButton()
		{
			super();
		}
		
		protected function createContentLayout ():BaseLayout
		{
			var layout:HorizontalLayout = new HorizontalLayout();
			layout.horizontalAlign = HorizontalAlign.CENTER;
			layout.verticalAlign = VerticalAlign.MIDDLE;
			layout.gap = 5;
			return layout;
		}
		
		protected override function createChildren():void
		{
			super.createChildren();
			contentHolder = new GUIContainer();
			contentHolder.cropContent = false;
			contentHolder.setSize(componentWidth, componentHeight);
			contentHolder.layout = createContentLayout();
			contentHolder.y = upDeltaY;
			addChild(contentHolder);
		}
		
		protected override function dispose():void
		{
			removeAllChildren(contentHolder, disposeComponent);
			contentHolder.finalize();
			contentHolder = null;
			super.dispose();
		}
		
		protected override function updateStyle():void
		{
			super.updateStyle();
			contentHolder.invalidate(VALIDATION_FLAG_LAYOUT);
		}
		
		protected override function updateSize():void
		{
			super.updateSize();
			contentHolder.setSize(width, height);
			contentHolder.invalidate(VALIDATION_FLAG_SIZE);
		}
		
		protected override function updateLayout():void
		{
			super.updateLayout();
			contentHolder.invalidate(VALIDATION_FLAG_LAYOUT)
			contentHolder.draw();
		}
		
		protected override function setState(state:String):void
		{
			super.setState(state);
			if (activeState == BaseButton.STATE_DOWN)
			{
				contentHolder.y = downDeltaY;
			}
			else
			{
				contentHolder.y = upDeltaY;
			}
		}
		
		protected override function setStyleSelector(styleName:String, styleValue:*):void
		{
			var layout:BaseLayout = contentHolder.layout as BaseLayout;
			if (styleName == "gap")
			{
				layout.gap = parseInt(String(styleValue)) * scaleManager.scale;
				return;
			}
			if (styleName == "horizontal_align")
			{
				layout.horizontalAlign = String(styleValue);
				return;
			}
			if (styleName == "vertical_align")
			{
				layout.verticalAlign = String(styleValue);
				return;
			}
			if (styleName == "y_offset_up_state")
			{
				upDeltaY = parseInt(String(styleValue));
				return;
			}
			if (styleName == "y_offset_down_state")
			{
				downDeltaY = parseInt(String(styleValue));
				return;
			}
			super.setStyleSelector(styleName, styleValue);
		}
		
		//Смещение при нажатии
		public function setContentOffset (upStateOffset:int, downStateOffset:int):void
		{
			upDeltaY = upStateOffset;
			downDeltaY = downStateOffset;
			setState(activeState);
		}
	}
}