package com.tengu.gui.controls.scrollbar
{
	import flash.events.MouseEvent;

	public class HorizontalScrollBar extends BaseScrollBar
	{
		public function HorizontalScrollBar()
		{
			super();
		}
		
		protected override function updateThumbSize ():void
		{
			thumbButton.width = pageSize / (max - min + pageSize) * trackButton.width;
			super.updateThumbIcon();
		}
		
		protected override function updateThumbPosition ():void
		{
			thumbButton.x = trackButton.x + scrollPosition * (trackButton.width - thumbButton.width);
			super.updateThumbPosition();
		}
		
		protected override function updateDisplay():void
		{
			super.updateDisplay();
			nextButton.x = width - nextButton.width;
			trackButton.x = prevButton.width;
		}
		
		protected override function updateSize():void
		{
			super.updateSize();
			trackButton.setSize(width - prevButton.width - nextButton.width, height);
			thumbButton.setSize(scrollPageSize * trackButton.width, height);
			thumbButton.minWidth = height;
		}
		
		protected override function onClickTrackButton(event:MouseEvent):void
		{
			if (event.localX < (thumbButton.x - trackButton.x))
			{
				scrollPosition -= scrollPageSize / (max - min);
			}
			else
			{
				scrollPosition += scrollPageSize / (max - min);
			}
			super.onClickTrackButton(event);
		}
		
		protected override function onDownThumbButton(event:MouseEvent):void
		{
			dragCoord = event.stageX;
			super.onDownThumbButton(event);
		}
		
		protected override function onDrag(event:MouseEvent):void
		{
			var coord:Number = event.stageX;
			var thumbCoord:Number = thumbButton.x + (coord - dragCoord) - trackButton.x;
			var totalSize:Number = trackButton.width || 1;
			if (thumbCoord < 0)
			{
				thumbCoord = 0;
			}
			else if (thumbCoord > totalSize - thumbButton.width)
			{
				thumbCoord = totalSize - thumbButton.width;
			}
			scrollPosition = thumbCoord / (totalSize - thumbButton.height);
			super.onDrag(event);
		}
	}
}