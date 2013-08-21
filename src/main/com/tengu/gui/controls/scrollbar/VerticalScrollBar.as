package com.tengu.gui.controls.scrollbar
{
	import flash.events.MouseEvent;
	
	public class VerticalScrollBar extends BaseScrollBar
	{
		public function VerticalScrollBar()
		{
			super();
		}
		
		protected override function updateThumbSize ():void
		{
			thumbButton.height = pageSize / (max - min + pageSize) * trackButton.height;
			super.updateThumbIcon();
		}
		
		protected override function updateThumbPosition ():void
		{
			thumbButton.y = trackButton.y + scrollPosition * (trackButton.height - thumbButton.height);
			super.updateThumbPosition();
		}
		
		protected override function updateDisplay():void
		{
			nextButton.y = height - nextButton.height;
			trackButton.y = prevButton.height;
			super.updateDisplay();
		}
		
		protected override function updateSize():void
		{
			super.updateSize();
			trackButton.setSize(width, height - prevButton.height - nextButton.height);
			thumbButton.minHeight = width;
			thumbButton.width = width;
			updateThumbSize();
		}
		
		protected override function onClickTrackButton(event:MouseEvent):void
		{
			if (event.localY < (thumbButton.y - trackButton.y))
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
			dragCoord = event.stageY;
			super.onDownThumbButton(event);
		}
		
		protected override function onDrag(event:MouseEvent):void
		{
			var totalSize:Number = trackButton.height || 1;
			var coord:Number = event.stageY;
			var thumbCoord:Number = thumbButton.y + (coord - dragCoord) - trackButton.y;
			dragCoord = coord;
			if (thumbCoord < 0)
			{
				thumbCoord = 0;
			}
			else if (thumbCoord > totalSize - thumbButton.height)
			{
				thumbCoord = totalSize - thumbButton.height;
			}
			scrollPosition = thumbCoord / (totalSize - thumbButton.height);
			super.onDrag(event);
		}
	}
}