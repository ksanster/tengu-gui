package com.tengu.gui.layouts
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	import com.tengu.gui.base.GUIComponent;
	import com.tengu.gui.containers.GUIContainer;

	public class SimpleStretchLayout extends BaseLayout
	{
		public function SimpleStretchLayout()
		{
			super();
		}
		
		public override function arrange(target:GUIContainer):Rectangle
		{
			var clip:DisplayObject 		= null;
			var component:GUIComponent  = null;
			
			var numChildren:uint = target.numChildren;
			var i:int = 0;
			
			var contentWidth:int  = target.width - paddingLeft - paddingRight;
			var contentHeight:int = target.height - paddingTop - paddingBottom;
			
			var pixelInPercentWidth:Number  = 0;
			var pixelInPercentHeight:Number = 0;
			
			var checkWidth:Boolean = true;
			var checkHeight:Boolean = true;
			
			if (target.resizeByContent)
			{
				for (i = 0; i < numChildren; i++)
				{
					clip = target.getChildAt(i);
					component = clip as GUIComponent;
					if (component == null)
					{
						checkWidth = true;
						checkHeight = true;
					}
					else
					{
						checkWidth = (component.percentWidth == 0);
						checkHeight = (component.percentHeight == 0);
					}
					if (checkWidth)
					{
						contentWidth = Math.max(contentWidth, clip.width);
					}
					if (checkHeight)
					{
						contentWidth = Math.max(contentWidth, clip.height);
					}
				}
			}
			
			pixelInPercentWidth = contentWidth * .01;
			pixelInPercentHeight = contentHeight * .01;
			
			setAlignParams(contentWidth, contentHeight);
			
			for (i = 0; i < numChildren; i++)
			{
				clip = target.getChildAt(i);
				component = clip as GUIComponent;
				
				if (component != null)
				{
					if (component.percentWidth != 0)
					{
						component.width = component.percentWidth * pixelInPercentWidth;
					}
					if (component.percentHeight != 0)
					{
						component.height = component.percentHeight * pixelInPercentHeight;
					}
				}
				
				clip.x = horizontalAlignStart + horizontalAlignKoef * contentWidth;
				clip.y = verticalAlignStart + verticalAlignKoef * contentHeight;
			}
			
			bounds.width = contentWidth + paddingLeft + paddingRight;
			bounds.height = contentHeight + paddingTop + paddingBottom;
			
			return bounds;
		}

	}
}