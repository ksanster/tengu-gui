package com.tengu.gui.layouts
{
	import com.tengu.gui.base.GUIComponent;
	import com.tengu.gui.containers.GUIContainer;
	
	import flash.display.DisplayObject;

	public class VerticalLayout extends BaseLayout
	{
		
		public function VerticalLayout()
		{
			super();
		}
		
		protected override function calculatePercentSizes(target:GUIContainer):void
		{
			var pixelToPercentWidth:Number 	= noPaddingWidth * .01;
			
			var clip:DisplayObject 		= null;
			var component:GUIComponent  = null;
			
			var i:int = 0;
			
			var inLayoutCount:uint 		= 0;
			var componentsHeight:uint 	= 0;
			var tmp:int 				= 0;
			
			var deltaGap:int			= 0;
			
			for (i = 0; i < numChildren; i++)
			{
				clip = target.getChildByIndex(i) || target.getChildAt(i);
				component = clip as GUIComponent;
				if (component != null)
				{
					if (!component.includeInLayout)
					{
						continue;
					}
					
					inLayoutCount++;

					if (component.percentWidth != 0)
					{
						component.width = component.percentWidth * pixelToPercentWidth;
					}
					
					contentWidth = Math.max(component.width, contentWidth);
					
					if (component.percentHeight != 0)
					{
						percentSizedClips[percentSizedClips.length] = component;
						continue;
					}
				}
				componentsHeight += clip.height;
			}
			
			deltaGap = Math.max(gap * (inLayoutCount - 1), 0); 
			
			for each (component in percentSizedClips)
			{
				component.height = (noPaddingHeight - deltaGap - componentsHeight) * component.percentHeight * .01;
				tmp += component.height;
			}
			componentsHeight += tmp;
			
			contentHeight = componentsHeight + tmp;
			setAlignParams(target, noPaddingWidth, noPaddingHeight);
			
			bounds.width  = contentWidth + paddingLeft + paddingRight;
			bounds.height = contentHeight + paddingTop + paddingBottom;
		}
		
		protected override function arrangeComponents(target:GUIContainer):void
		{
			var clip:DisplayObject;
			var component:GUIComponent;
			var yCoord:int;
			
			if (target.resizeByContent)
			{
				yCoord = paddingTop;
			}
			else
			{
				yCoord = verticalAlignStart + verticalAlignKoef * contentHeight;
			}
			
			for (var i:int = 0; i < numChildren; i++)
			{
				clip = target.getChildByIndex(i) || target.getChildAt(i);
				component = clip as GUIComponent;
				if (component != null && !component.includeInLayout)
				{
					continue;
				}
				clip.x = horizontalAlignStart + horizontalAlignKoef * clip.width;
				clip.y = yCoord;
				
				yCoord += ( clip.height + gap );
			}
		}
	}
}