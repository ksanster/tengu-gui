package com.tengu.gui.screens
{
	import com.tengu.core.errors.StaticClassConstructError;

	public class ScreenFlipDirection
	{
		public static const TOP:String 		= "top";
		public static const BOTTOM:String 	= "bottom";
		public static const LEFT:String 	= "left";
		public static const RIGHT:String 	= "right";
		
		public static function inverse (direction:String):String
		{
			var result:String = null;
			switch (direction)
			{
				case TOP:
					result = BOTTOM;
					break;
				case BOTTOM:
					result = TOP;
					break;
				case LEFT:
					result = RIGHT;
					break;
				case RIGHT:
					result = LEFT;
					break;
			}
			return result;
		}
		
		public function ScreenFlipDirection()
		{
			throw new StaticClassConstructError(this);
		}
	}
}