package com.tengu.gui.resources.text
{
	import com.tengu.core.errors.StaticClassConstructError;
	
	public class CSSStyleName
	{
		public static const BODY:String 	= "body";
		public static const BOLD:String 	= "b";
		public static const REF:String 		= "a";
		
		public static const USERNAME:String = ".username";
		public static const PRIVATE:String 	= ".private";
		public static const BLUE:String 	= ".blue";
		public static const COUNTER:String  = ".counter"
		
		public function CSSStyleName()
		{
			throw new StaticClassConstructError(this);
		}
	}
}