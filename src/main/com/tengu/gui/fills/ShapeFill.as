package com.tengu.gui.fills
{
	import flash.display.Graphics;

	public class ShapeFill
	{
		public function ShapeFill()
		{
			//Empty
		}
		
		public function apply (graphics:Graphics, width:uint, height:uint, clear:Boolean=true):void
		{
			if(clear)
			{
				graphics.clear();
			}
		}
	}
}