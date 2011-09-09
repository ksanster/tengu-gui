package com.tengu.gui.core.text
{
	import com.tengu.core.errors.StaticClassConstructError;
	
	import flash.text.TextFormat;

	public class TextStyleFormat
	{
		private static const styles:Object = {};
		
		public function TextStyleFormat()
		{
			throw (new StaticClassConstructError(this));
		}
		
		public static function parse (descriptor:XML):void
		{
			
		}
		
		public static function addStyle (styleName:String, textFormat:TextFormat, filters:Array = null):void
		{
			styles[styleName] = new TextStyleInfo(textFormat, filters);
		}
			
		
		public static function applyStyle (field:Text, styleName:String):void
		{
			var textStyleInfo:TextStyleInfo = styles[styleName];
			if (textStyleInfo == null)
			{
				return;
			}
			
			field.setTextFormat(textStyleInfo.textFormat);
			field.defaultTextFormat = textStyleInfo.textFormat;
			field.filters = textStyleInfo.filters;
			
			field.cacheAsBitmap = true;
		}
	}
}
import flash.text.TextFormat;

internal class TextStyleInfo
{
	public var textFormat:TextFormat 	= null;
	public var filters:Array			= null;
	
	public function TextStyleInfo (textFormat:TextFormat, filters:Array)
	{
		this.textFormat = textFormat;
		this.filters 	= filters;
	}
}