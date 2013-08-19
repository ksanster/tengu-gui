package com.tengu.gui.api
{
	import com.tengu.gui.fills.ShapeFill;
	
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.system.ApplicationDomain;

	public interface ITexturesManager
	{
		function set library(value:ApplicationDomain):void;
		function set scaleFactor(value:Number):void;
		
		function registerBitmap (name:String, stretch:Boolean = true, isRepeat:Boolean=false):void
		function registerScale9Bitmap(name:String, scaleGrid:Rectangle):void
		function registerScale3Bitmap(name:String, stretchStart:uint = 1, stretchSize:uint = 1, direction:String = "horizontal"):void;

		function registerFloodFillTexture (name:String, color:uint, alpha:Number = 1):void;	
		
		function getTexture (name:String):ShapeFill;
		function getIcon (name:String, scaled:Boolean = true):BitmapData;
		
		function configure (config:XML):void;
	}
}