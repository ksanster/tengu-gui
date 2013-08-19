package com.tengu.gui.controls
{
	import com.tengu.gui.base.GUIComponent;
	import com.tengu.gui.controls.text.Text;
	import com.tengu.gui.enum.IconPosition;
	
	import flash.display.Bitmap;
	import flash.text.TextField;
	
	[Style(name="gap")]
	[Style(name="icon")]
	[Style(name="text")]
	[Style(name="icon_pos")]
	
	public class IconLabel extends GUIComponent
	{
		private var iIcon:Bitmap = null;
		private var textField:Text = null;
		
		private var iIconName:String = null;
		private var iLabel:String = null;
		private var iStyle:String = null;
		private var iAutosize:Boolean = false;
		
		private var gap:int = 0;
		
		private var iconPos:String = IconPosition.ICON_LEFT;
		
		public function set text(value:String):void 
		{
			textField.text = value;
			invalidate(VALIDATION_FLAG_LAYOUT);
		}
		
		public function set selectable(value:Boolean):void 
		{
			textField.selectable = value;
			mouseEnabled 		 = value;
			mouseChildren 		 = value;
		}
		
		public function get icon():Bitmap 
		{
			return iIcon;
		}
		
		public function get field():Text 
		{
			return textField;
		}
		
		public function get autoSize():Boolean 
		{
			return iAutosize;
		}
		
		public function set autoSize(value:Boolean):void 
		{
			iAutosize = value;
			invalidate(VALIDATION_FLAG_LAYOUT);
		}
		
		public function IconLabel(label:String = "", style:String = null, iconName:String = null)
		{
			iIconName = iconName;
			iLabel = label;
			iStyle = style;
			super();
		}
		
		protected function getGap():int
		{
			return 2;
		}

		protected override function initialize():void
		{
			super.initialize();
			mouseEnabled  = false;
			mouseChildren = false;
		}
	
		protected override function createChildren():void
		{
			super.createChildren();
			
			gap = getGap();
			
			iIcon = new Bitmap();
			iIcon.bitmapData = textureManager.getIcon(iIconName);
			addChild(iIcon);
			
			textField = new Text(iLabel, iStyle);
			addChild(textField);
		}
		
		protected override function updateLayout():void
		{
			super.updateLayout();
			textField.draw();
			var h:int = Math.max(iIcon.height, textField.textHeight, height);
			iIcon.y = int((h - iIcon.height) * .5);
			textField.y = (h - textField.textHeight) * .5 ;
			
			if (iconPos == IconPosition.ICON_LEFT)
			{
				iIcon.x = 0;
				textField.x = iIcon.width + gap;
			}
			else if (iconPos == IconPosition.ICON_RIGHT)
			{
				textField.x = 0;
				iIcon.x = textField.width + gap;
			}
			
			if (iAutosize)
			{
				setSize(iIcon.width + gap + textField.textWidth, h);
			}
		}

		protected override function setStyleSelector(styleName:String, styleValue:*):void
		{
			if (styleName == "icon" && iIconName != styleValue)
			{
				iIconName = styleValue;
				iIcon.bitmapData = textureManager.getIcon(styleValue);
				return;
			}
			if (styleName == "text" && textField.format != styleValue)
			{
				textField.format = styleValue;
				return;
			}
			if (styleName == "icon_pos" && iconPos != styleValue)
			{
				iconPos = styleValue;
				return;
			}
			if (styleName == "gap")
			{
				gap = parseInt(String(styleValue));
				return;
			}
		}
		
		protected override function dispose():void
		{
			textField.finalize();
			textField = null;

			super.dispose();
		}
	}
}