package com.tengu.gui.themes
{
	import com.tengu.gui.themes.api.ITheme;
	import com.tengu.log.LogFactory;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;

	[Event(name="init", type="flash.events.Event")]
	public class SimpleTheme extends EventDispatcher implements ITheme
	{
		[Embed(	source="/../../assets/fonts/arial.TTF",
				fontName="Verdana", fontFamily="Verdana", fontStyle="regular",
				mimeType="application/x-font-truetype", embedAsCFF="false", fontWeight="normal",
				unicodeRange="U+0020-U+007e,U+0400-U+0457")]
		public static var fontRegular:Class;
		
		
		[Embed(	source="/../../assets/fonts/arialbd.TTF",
				fontName="Verdana", fontFamily="Verdana", fontStyle="bold",
				mimeType="application/x-font-truetype", embedAsCFF="false", fontWeight="bold",
				unicodeRange="U+0020-U+007e,U+0400-U+0457")]
		public static var fontBold:Class;
		
		[Embed(source="/../../assets/assets.swf",mimeType="application/octet-stream")]
		public static const assetsClass:Class;

		[Embed(source="/../../assets/styles.css",mimeType="application/octet-stream")]
		public static const stylesClass:Class;

		[Embed(source="/../../assets/fills.xml",mimeType="application/octet-stream")]
		public static const fillsClass:Class;
		
		private var loader:Loader = null;
		private var libraryDomain:ApplicationDomain = new ApplicationDomain();
		
		public function SimpleTheme()
		{
			initialize();
		}
		
		private function initialize():void
		{
			const bytes:ByteArray = new assetsClass(); 
			const context:LoaderContext = new LoaderContext(false, libraryDomain);
			context.allowCodeImport = true;
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			
			loader.loadBytes(bytes, context);
		}
		
		public function get fonts():Vector.<Class>
		{
			return new <Class>[fontRegular, fontBold];
		}
		
		public function get css():String
		{
			const bytes:ByteArray = new stylesClass(); 
			return bytes.readUTFBytes(bytes.bytesAvailable);
		}
		
		public function get fills():XML
		{
			const bytes:ByteArray = new fillsClass(); 
			const xml:XML = new XML(bytes.readUTFBytes(bytes.bytesAvailable));
			return xml;
		}
		
		public function get library():ApplicationDomain
		{
			return libraryDomain;
		}
		
		protected function onComplete(event:Event):void
		{
			dispatchEvent(new Event(Event.INIT));			
		}
		
		protected function onIOError(event:IOErrorEvent):void
		{
			LogFactory.getLogger(this).error("Cannot initialize theme");
		}
	}
}