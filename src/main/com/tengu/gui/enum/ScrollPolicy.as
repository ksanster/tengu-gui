package com.tengu.gui.enum
{
	import com.tengu.core.errors.StaticClassConstructError;

	public class ScrollPolicy
	{
		public static const HORIZONTAL:String 	= "horizontal";
		public static const VERTICAL:String 	= "vertical";
		public static const BOTH:String 		= "both";
		public static const NONE:String 		= "none";
		
		public function ScrollPolicy()
		{
			throw new StaticClassConstructError(this);
		}
	}
}