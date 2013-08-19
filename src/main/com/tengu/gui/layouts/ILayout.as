package com.tengu.gui.layouts
{
	import com.tengu.gui.containers.GUIContainer;
	
	import flash.geom.Rectangle;

	public interface ILayout
	{
		function set horizontalAlign (value:String):void;
		function get horizontalAlign():String;
		
		function set verticalAlign (value:String):void;
		function get verticalAlign():String;
		
		function get gap ():int;
		function set gap (value:int):void;
		
		function arrange (target:GUIContainer):Rectangle;
	}
}