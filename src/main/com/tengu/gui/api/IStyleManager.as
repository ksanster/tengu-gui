package com.tengu.gui.api
{
	import com.tengu.gui.base.GUIComponent;
	
	import flash.text.TextField;
	import flash.text.TextFormat;

	public interface IStyleManager
	{
		function set scaleFactor (value:Number):void;
		
		function registerStyle (name:String, value:Object):void;
		
		function getDefaultStyle (component:GUIComponent):Object;
		function getStyle (name:String):Object;
		
		function get defaultTextStyle():String;
		function getTextFormat (styleName:String):TextFormat;
		
		function applyTextStyle (field:TextField, styleName:String):void;
		
		function configure (...listOfCSS):void;
		
	}
}