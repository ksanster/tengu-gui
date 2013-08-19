package com.tengu.gui.controls.buttons
{
	import flash.display.Bitmap;
	import flash.events.MouseEvent;

	public class IconOnlyButton extends BaseButton
	{
		private var iconSkins:Object;
		private var selectedIconSkins:Object;
		
		private var icon:Bitmap;
		private var downDeltaY:int = 1;

		public function IconOnlyButton()
		{
			super();
		}
		
		protected override function createChildren():void
		{
			super.createChildren();
			icon = new Bitmap();
			addChild(icon);
			iconSkins = {};
			selectedIconSkins = {};
		}
		
		protected override function setState(state:String):void
		{
			super.setState(state);
			if (selected && toggle)
			{
				icon.bitmapData = selectedIconSkins[state];
			}
			else
			{
				icon.bitmapData = iconSkins[state];
			}
		}

		protected override function setStyleSelector(styleName:String, styleValue:*):void
		{
			if (styleName == "icon")
			{
				iconSkins[STATE_UP] = textureManager.getIcon(styleValue);
				return;
			}
			if (styleName == "over_icon")
			{
				iconSkins[STATE_OVER] = textureManager.getIcon(styleValue);
				return;
			}
			if (styleName == "down_icon")
			{
				iconSkins[STATE_DOWN] = textureManager.getIcon(styleValue);
				return;
			}
			if (styleName == "disabled_icon")
			{
				iconSkins[STATE_DISABLED] = textureManager.getIcon(styleValue);
				return;
			}
			if (styleName == "selected_icon")
			{
				selectedIconSkins[STATE_UP] = textureManager.getIcon(styleValue);
				return;
			}
			if (styleName == "selected_over_icon")
			{
				selectedIconSkins[STATE_OVER] = textureManager.getIcon(styleValue);
				return;
			}
			if (styleName == "selected_down_icon")
			{
				selectedIconSkins[STATE_DOWN] = textureManager.getIcon(styleValue);
				return;
			}
			if (styleName == "selected_disabled_icon")
			{
				selectedIconSkins[STATE_DISABLED] = textureManager.getIcon(styleValue);
				return;
			}
			if (styleName == "y_offset_down_state")
			{
				downDeltaY = parseInt(String(styleValue));
				return;
			}
			super.setStyleSelector(styleName, styleValue);
		}
		
		protected override function preUpdateStyle():void
		{
			super.preUpdateStyle();
			iconSkins = {};
			selectedIconSkins = {};
		}
		
		protected override function postUpdateStyle():void
		{
			super.postUpdateStyle();
			iconSkins[STATE_OVER] 	  ||= iconSkins[STATE_UP];
			iconSkins[STATE_DOWN] 	  ||= iconSkins[STATE_UP];
			iconSkins[STATE_DISABLED] ||= iconSkins[STATE_UP];
			
			selectedIconSkins[STATE_UP]			||= iconSkins[STATE_UP];
			selectedIconSkins[STATE_OVER]		||= selectedIconSkins[STATE_UP];
			selectedIconSkins[STATE_DOWN]		||= selectedIconSkins[STATE_UP];
			selectedIconSkins[STATE_DISABLED]	||= selectedIconSkins[STATE_UP];
		}
		
		protected override function updateDisplay():void
		{
			super.updateDisplay();
			var iconY:int = (height - icon.height) * .5;
			icon.x = (width - icon.width) * .5;
			if (activeState == BaseButton.STATE_DOWN)
			{
				iconY += downDeltaY;
			}
			icon.y = iconY;
		}
		
		protected override function onMouseOut (event:MouseEvent):void
		{
			setState(STATE_UP);
		}
		
		public override function setSize(width:int, height:int):void
		{
			super.setSize(width, height);
		}

	}
}