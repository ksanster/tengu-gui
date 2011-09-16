package com.tengu.gui.core.uid
{
	import com.tengu.core.errors.StaticClassConstructError;
	
	import flash.utils.Dictionary;

	public class UidGenerator
	{
		private static const ALPHA_CHAR_CODES:Array = [48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 65, 66, 67, 68, 69, 70];
		private static const uidDictionary:Dictionary = new Dictionary(true);
		private static const MINUS_CHAR_CODE:uint = String("-").charCodeAt(0);

		public function UidGenerator()
		{
			throw new StaticClassConstructError(this);
		}
		
		public static function createUID():String
		{
			var uid:Array = new Array(36);
			var index:int = 0;
			
			var i:int;
			var j:int;
			
			for (i = 0; i < 8; i++)
			{
				uid[index++] = ALPHA_CHAR_CODES[Math.floor(Math.random() *  16)];
			}
			
			for (i = 0; i < 3; i++)
			{
				uid[index++] = MINUS_CHAR_CODE;
				
				for (j = 0; j < 4; j++)
				{
					uid[index++] = ALPHA_CHAR_CODES[Math.floor(Math.random() *  16)];
				}
			}
			
			uid[index++] = MINUS_CHAR_CODE;
			
			var time:Number = new Date().getTime();
			var timeString:String = ("0000000" + time.toString(16).toUpperCase()).substr(-8);
			
			for (i = 0; i < 8; i++)
			{
				uid[index++] = timeString.charCodeAt(i);
			}
			
			for (i = 0; i < 4; i++)
			{
				uid[index++] = ALPHA_CHAR_CODES[Math.floor(Math.random() *  16)];
			}
			
			return String.fromCharCode.apply(null, uid);
		}

	}
}