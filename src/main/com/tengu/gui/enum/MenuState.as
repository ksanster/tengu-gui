package com.tengu.gui.enum
{
	import com.tengu.core.errors.StaticClassConstructError;

	public class MenuState
	{
		public static const OPENED:String = "opened";
		public static const CLOSED:String = "closed";
		
		public function MenuState()
		{
			throw new StaticClassConstructError(this);
		}
	}
}