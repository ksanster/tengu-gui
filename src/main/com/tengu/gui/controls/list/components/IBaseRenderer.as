package com.tengu.gui.controls.list.components
{
	public interface IBaseRenderer
	{
		function set selected(value:Boolean):void;
		function get selected():Boolean;
		
		function set data (value:Object):void;
		function get data ():Object;
			
	}
}