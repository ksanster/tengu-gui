package com.tengu.gui.layouts
{
	import com.tengu.gui.containers.GUIContainer;
	import com.tengu.gui.enum.WindowPlacementType;
	import com.tengu.gui.windows.GUIWindow;
	
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;

	public class WindowLayout extends BaseLayout
	{
		public function WindowLayout()
		{
			super();
		}
		
		public override function arrange(target:GUIContainer):Rectangle
		{
			var targetWidth:int = target.width;
			var targetHeight:int = target.height;
			var count:uint = target.numChildren;
			var window:GUIWindow   = null;
			var clip:DisplayObject = null;
			var placement:String   = null;
			for (var i:int = 0; i < count; i++)
			{
				clip = target.getChildAt(i);
				window = clip as GUIWindow;
				placement = (window == null) ? WindowPlacementType.FLOW : window.placement;
				switch (placement)
				{
					case WindowPlacementType.CENTER:
					{
						clip.x = (targetWidth - clip.width) * .5;
						clip.y = (target.height - clip.height) * .5;
						break;
					}
				}
			}
			
			bounds.width = targetWidth;
			bounds.height = targetHeight;
			return bounds;
		}
	}
}