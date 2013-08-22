package com.tengu.gui.layouts
{
	import com.tengu.gui.base.GUIComponent;
	import com.tengu.gui.containers.GUIContainer;
	
	import flash.display.DisplayObject;

	public class HorizontalLayout extends BaseLayout
	{
		public function HorizontalLayout()
		{
			super();
		}
		
		protected override function calculatePercentSizes(target:GUIContainer):void
		{
			var pixelToPercentHeight:Number = noPaddingHeight * .01;
			
			var clip:DisplayObject 		= null;
			var component:GUIComponent  = null;
			
			var i:int = 0;
			
			var inLayoutCount:uint 		= 0;
			var componentsWidth:uint 	= 0;
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
					
					if (component.percentHeight != 0)
					{
						component.height = component.percentHeight * pixelToPercentHeight;
					}
					
					contentHeight = Math.max(component.height, contentHeight);
					
					if (component.percentWidth != 0)
					{
						percentSizedClips[percentSizedClips.length] = component;
						continue;
					}
				}
				componentsWidth += clip.width;
			}
			
			deltaGap = Math.max(gap * (inLayoutCount - 1), 0); 
			
			for each (component in percentSizedClips)
			{
				component.width = (noPaddingWidth - deltaGap - componentsWidth) * component.percentWidth * .01;
				tmp += component.height;
			}
			componentsWidth += tmp;
			
			contentWidth = componentsWidth + tmp;
			setAlignParams(target, noPaddingWidth, noPaddingHeight);
			
			bounds.width  = contentWidth + paddingLeft + paddingRight;
			bounds.height = contentHeight + paddingTop + paddingBottom;
		}
		
		protected override function arrangeComponents(target:GUIContainer):void
		{
			var clip:DisplayObject;
			var component:GUIComponent;
			var xCoord:int;
			
			if (target.resizeByContent)
			{
				xCoord = paddingLeft;
			}
			else
			{
				xCoord = horizontalAlignStart + horizontalAlignKoef * contentWidth;
			}
			
			for (var i:int = 0; i < numChildren; i++)
			{
				clip = target.getChildByIndex(i) || target.getChildAt(i);
				component = clip as GUIComponent;
				if (component != null && !component.includeInLayout)
				{
					continue;
				}
				clip.y = verticalAlignStart + verticalAlignKoef * clip.height;
				clip.x = xCoord;
				
				xCoord += ( clip.width + gap );
			}
		}

	}
}