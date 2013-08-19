package com.tengu.gui.enum
{
	import com.tengu.core.errors.StaticClassConstructError;

	public class WindowPlacementType
	{
		public static const CENTER:String = "centered";
		public static const FLOW:String 	= "flow";

		public function WindowPlacementType()
		{
			throw new StaticClassConstructError(this);
		}
	}
}