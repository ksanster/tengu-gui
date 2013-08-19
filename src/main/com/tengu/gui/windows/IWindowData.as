package com.tengu.gui.windows
{
	public interface IWindowData
	{
		function get windowClass ():Class;
		function get windowId ():String;
		
		function finalize ():void;
	}
}