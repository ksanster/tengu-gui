package com.tengu.gui.api
{
	import flash.text.TextField;
	import flash.text.TextFormat;

	public interface IStyleManager
	{
		function set scaleFactor (value:Number):void;
		
		function set defaultTextStyle(value:String):void;
		function get defaultTextStyle():String;
		
		function registerStyle (name:String, value:Object):void;
		
		function getStyle (name:String):Object;
		
		function getTextFormat (styleName:String):TextFormat;
		
		function applyTextStyle (field:TextField, styleName:String):void;
		
		function configure (...listOfCSS):void;
	}
}