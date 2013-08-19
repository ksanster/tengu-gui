package com.tengu.gui.enum
{
	import com.tengu.core.errors.StaticClassConstructError;

	public class HorizontalAlign
	{
		public static const LEFT:String   = "left";
		public static const CENTER:String = "center";
		public static const RIGHT:String  = "right";
		
		public function HorizontalAlign()
		{
			throw new StaticClassConstructError(this);
		}
	}
}