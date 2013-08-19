package com.tengu.gui.resources.text
{
	import com.tengu.core.errors.StaticClassConstructError;

	public class StyleProtocol
	{
		public static const FORMATS:String 	= "formats";
		public static const FILTERS:String 	= "filters";
		public static const CSS:String 		= "css";
		
		public static const TYPE:String 		= "type";

		public static const NAME:String 		= "name";
		public static const FONT_NAME:String 	= "font";
		public static const SIZE:String 		= "size";
		public static const BOLD:String 		= "bold";
		public static const COLOR:String 		= "color";
		public static const ALIGN:String 		= "align";
		
		public static const DROP_SHADOW:String 	= "drop_shadow";
		public static const GLOW:String 		= "glow";
		public static const DISTANCE:String 	= "distance";
		public static const ANGLE:String 		= "angle";
		public static const ALPHA:String 		= "alpha";
		public static const BLUR_X:String 		= "blur_x";
		public static const BLUR_Y:String 		= "blur_y";
		public static const STRENGTH:String 	= "strength";
		public static const QUALITY:String 		= "quality";
		
		public static const TEXT_FORMAT_PREFIX:String 	= "format";
		public static const TEXT_CSS_PREFIX:String 		= "css";
		public static const FILTER_PREFIX:String 		= "filter";
        public static const DEFAULT_PREFIX:String       = "default"

		public function StyleProtocol()
		{
			throw new StaticClassConstructError(this);
		}
	}
}