package com.tengu.gui.enum
{
	import com.tengu.core.errors.StaticClassConstructError;

	public class FillType
	{
		public static const BORDER_FILL:String 		= "border";
		public static const GRADIENT_FILL:String 	= "gradient";
		public static const COLOR_FLOOD_FILL:String = "flood";

		public static const BITMAP_FILL:String 			= "bitmap";
		public static const SCALE3_BITMAP_FILL:String 	= "scale3_bitmap";
		public static const SCALE9_BITMAP_FILL:String 	= "scale9_bitmap";
		public function FillType()
		{
			throw new StaticClassConstructError(this);
		}
	}
}