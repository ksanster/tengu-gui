package com.tengu.gui.api
{
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public interface ITextFormatManager
	{
		function get defaultTextStyle():String;
		function getTextFormat (styleName:String):TextFormat;
		
		function configureFromXML (config:XML):void;
			
		function registerStyle (name:String, format:TextFormat, filters:Array = null):void;
		function registerCSSStyle (name:String, css:StyleSheet, filters:Array = null):void;
		
		function applyStyle (field:TextField, styleName:String):void;
		
	}
}