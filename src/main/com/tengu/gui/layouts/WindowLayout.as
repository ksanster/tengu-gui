package com.tengu.gui.layouts
{
    import com.tengu.gui.containers.GUIContainer;
    import com.tengu.gui.enum.WindowPlacementType;
    import com.tengu.gui.windows.GUIWindow;

    import flash.display.DisplayObject;

    public class WindowLayout extends BaseLayout
	{
		public function WindowLayout()
		{
			super();
		}

        override protected function arrangeComponents (target:GUIContainer):void
        {
            var window:GUIWindow   = null;
            var clip:DisplayObject = null;
            var placement:String   = null;
            for (var i:int = 0; i < numChildren; i++)
            {
                clip = target.getChildByIndex(i) || target.getChildAt(i);
                window = clip as GUIWindow;
                placement = (window == null) ? WindowPlacementType.FLOW : window.placement;
                switch (placement)
                {
                    case WindowPlacementType.CENTER:
                    {
                        clip.x = (noPaddingWidth - clip.width) * .5;
                        clip.y = (noPaddingHeight - clip.height) * .5;
                        break;
                    }
                }
            }
        }

	}
}