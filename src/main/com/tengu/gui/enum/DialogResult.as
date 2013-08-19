package com.tengu.gui.enum
{
	import com.tengu.core.errors.StaticClassConstructError;

	public class DialogResult
	{
		public static const YES:int = 1;
		public static const NO:int  = 0;
		
		public static const REASON1:int = 1;
		public static const REASON5:int = 5;
		public static const REASON9:int = 9;
		
		
		public function DialogResult()
		{
			throw new StaticClassConstructError(this);
		}
	}
}