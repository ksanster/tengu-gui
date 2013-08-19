package com.tengu.gui.enum
{
	import com.tengu.core.errors.StaticClassConstructError;

	public class IconPosition
	{
		public static const ICON_LEFT:String  = "iconLeft";
		public static const ICON_RIGHT:String = "iconRight";
		
		public function IconPosition()
		{
			throw new StaticClassConstructError(this);
		}
	}
}