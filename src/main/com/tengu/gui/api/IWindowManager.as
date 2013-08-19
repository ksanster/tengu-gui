package com.tengu.gui.api
{
	import com.tengu.gui.windows.GUIWindow;
	import com.tengu.gui.windows.IWindowData;

	public interface IWindowManager
	{
		function hasWindow (windowId:String):Boolean;
		function getWindowById (id:String):GUIWindow;
		
		function openWindow (data:IWindowData):GUIWindow;
		function closeWindow (windowId:String):GUIWindow;
		
		function setSize (width:int, height:int):void;
	}
}