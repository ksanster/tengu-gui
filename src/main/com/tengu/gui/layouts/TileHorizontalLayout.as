package com.tengu.gui.layouts
{
	import com.tengu.gui.base.GUIComponent;
	import com.tengu.gui.containers.GUIContainer;
	
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;

	public class TileHorizontalLayout extends BaseLayout
	{
		private var autoGap:Boolean = false;
		
		private var vPercentGap:int = 0;
		
		public function set verticalPercentGap(value:int):void 
		{
			vPercentGap = value;
		}
		
		public function set isAutoGap(value:Boolean):void 
		{
			autoGap = value;
		}
		
		public function TileHorizontalLayout()
		{
			super();
		}
		
		public override function arrange(target:GUIContainer):Rectangle
		{
			var clip:DisplayObject 		= null;
			var component:GUIComponent  = null;
			
			var clipWidth:int = 0;
			var xCoord:int = 0;
			var yCoord:int = 0;
			
			var numChildren:uint = target.numChildren;
			var i:int = 0;
			var count:int = 0;
			
			var noPaddingWidth:int = target.width - target.paddingLeft - target.paddingRight;
			var noPaddingHeight:int = target.height - target.paddingTop - target.paddingBottom;
			
			var maxWidth:uint = 0;
			var maxHeight:uint = 0;
			
			var alignStartX:int  = 0;
			var alignKoef:Number = 0;
			
			var hGap:int = gap;
			var vGap:int = gap;
			
			for (i = 0; i < numChildren; i++)
			{
				clip = target.getChildAt(i);
				maxWidth = Math.max(maxWidth, clip.width);
				maxHeight = Math.max(maxHeight, clip.height);
			}

			if (autoGap)
			{
				count = target.width / maxWidth;
				if (count > 1)
				{
					hGap = (target.width - count * maxWidth) / (count - 1);
				}
			}
			
			vGap = vPercentGap * maxHeight / 100;
			
			
			xCoord = 0;	
			yCoord = target.paddingTop;

			for (i = 0; i < numChildren; i++)
			{
				if (i > 0 && (i % count) == 0)
				{
					xCoord = 0;
					yCoord += (maxHeight + vGap);
				}

				clip = target.getChildAt(i);

				clip.x = xCoord;
				clip.y = yCoord;
				
				xCoord += clip.width;
				xCoord += hGap;
			}
			
			bounds.width = maxWidth * count + hGap * (count - 1);
			bounds.height = yCoord + target.paddingBottom;
			
			return bounds;
		}
	}
}