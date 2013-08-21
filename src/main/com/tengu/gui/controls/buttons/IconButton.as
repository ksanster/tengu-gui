package com.tengu.gui.controls.buttons
{
	import com.tengu.gui.enum.IconPosition;
	
	import flash.display.Bitmap;
	import flash.events.MouseEvent;

	[Style(name="icon")]
	[Style(name="icon_pos")]
	[Style(name="over_icon")]
	[Style(name="down_icon")]
	[Style(name="disabled_icon")]
	[Style(name="selected_icon")]
	[Style(name="selected_over_icon")]
	[Style(name="selected_down_icon")]
	[Style(name="selected_disabled_icon")]
	public class IconButton extends TextButton
	{
		private var iconSkin:String = null;
		private var iconSkins:Object;
		private var selectedIconSkins:Object;
		
		private var selectedLabelText:String;
		private var labelText:String;

		protected var iconPos:String;
		protected var iconBitmap:Bitmap;
		
		protected override function get defaultStyleName():String
		{
			return "IconButton";
		}
		
		public function set icon(value:String):void 
		{
			if (iconSkin == value)
			{
				return;
			}
			iconSkin = value;
			invalidate(VALIDATION_FLAG_STYLE);
		}
		
		public function set selectedLabel(value:String):void 
		{
			selectedLabelText = value;
		}
		
		public override function set label(value:String):void
		{
			labelText = value;
			super.label = value;
		}
		
		public function IconButton()
		{
			super();
		}
		
		private function updateIconSkins():void
		{
			iconSkins[STATE_UP] 	  ||= textureManager.getIcon(iconSkin);	
			iconSkins[STATE_OVER] 	  ||= iconSkins[STATE_UP];
			iconSkins[STATE_DOWN] 	  ||= iconSkins[STATE_UP];
			iconSkins[STATE_DISABLED] ||= iconSkins[STATE_UP];
			
			selectedIconSkins[STATE_UP]			||= iconSkins[STATE_UP];
			selectedIconSkins[STATE_OVER]		||= selectedIconSkins[STATE_UP];
			selectedIconSkins[STATE_DOWN]		||= selectedIconSkins[STATE_UP];
			selectedIconSkins[STATE_DISABLED]	||= selectedIconSkins[STATE_UP];
		}
		
		protected override function createChildren():void
		{
			super.createChildren();
			iconBitmap = new Bitmap();
			contentHolder.addChildAt(iconBitmap, 0);
			
			iconSkins = {};
			selectedIconSkins = {};
			
			iconPos = IconPosition.ICON_LEFT;
		}
		
		protected override function setState(state:String):void
		{
			super.setState(state);
			if (selected && toggle)
			{
				iconBitmap.bitmapData = selectedIconSkins[state];
				if (selectedLabelText != null)
				{
					text.text = selectedLabelText;
				}
			}
			else
			{
				iconBitmap.bitmapData = iconSkins[state];
				if (selectedLabelText != null)
				{
					text.text = labelText;
				}
			}
			contentHolder.invalidate(VALIDATION_FLAG_LAYOUT);
		}
		
		protected override function setStyleSelector(styleName:String, styleValue:*):void
		{
			if (styleName == "icon_pos")
			{
				iconPos = styleValue;
				contentHolder.removeChild(iconBitmap);
				if (iconPos == IconPosition.ICON_LEFT)
				{
					contentHolder.addChildAt(iconBitmap, 0);
				}
				else
				{
					contentHolder.addChild(iconBitmap);
				}
				contentHolder.invalidate(VALIDATION_FLAG_LAYOUT);
				return;
			}
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
			updateIconSkins();
			contentHolder.invalidate();
		}
		
		protected override function onMouseOut (event:MouseEvent):void
		{
			setState(STATE_UP);
		}
	}
}