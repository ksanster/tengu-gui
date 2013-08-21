package com.tengu.gui.enum
{
	import com.tengu.core.errors.StaticClassConstructError;

	public class IconPosition
	{
		public static const ICON_LEFT:String  = "left";
		public static const ICON_RIGHT:String = "right";
		
		public function IconPosition()
		{
			throw new StaticClassConstructError(this);
		}
	}
}