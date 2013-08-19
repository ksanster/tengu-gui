package com.tengu.gui.enum
{
	import com.tengu.core.errors.StaticClassConstructError;

	public class VerticalAlign
	{
		public static const TOP:String 	  = "top";
		public static const MIDDLE:String = "middle";
		public static const BOTTOM:String = "bottom";
		
		public function VerticalAlign()
		{
			throw new StaticClassConstructError(this);
		}
	}
}