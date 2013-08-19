package com.tengu.gui.enum
{
	import com.tengu.core.errors.StaticClassConstructError;

	public class Direction
	{
		public static const HORIZONTAL:String 	= "horizontal";
		public static const VERTICAL:String 	= "vertical";
		public function Direction()
		{
			throw new StaticClassConstructError(this);
		}
	}
}