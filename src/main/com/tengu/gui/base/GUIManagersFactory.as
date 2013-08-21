package com.tengu.gui.base
{
	import com.tengu.calllater.api.ICallLaterManager;
	import com.tengu.core.tengu_internal;
	import com.tengu.core.errors.StaticClassConstructError;
	import com.tengu.gui.api.IScaleManager;
	import com.tengu.gui.api.IStyleManager;
	import com.tengu.gui.api.ITexturesManager;
	import com.tengu.gui.api.IWindowManager;
	import com.tengu.gui.markup.api.IMarkupBuilderFactory;

	public class GUIManagersFactory
	{
		private static var callLaterManagerClass:Class 	= null;
		private static var texturesManagerClass:Class 	= null;
		private static var windowManagerClass:Class		= null;
		private static var styleManagerClass:Class		= null;
		private static var scaleManagerClass:Class		= null;
		private static var markupFactoryClass:Class		= null;
		
		
		private static var callLaterManager:ICallLaterManager 	= null;
		private static var texturesManager:ITexturesManager 	= null;
		private static var windowManager:IWindowManager			= null;
		private static var styleManager:IStyleManager 			= null;
		private static var scaleManager:IScaleManager 			= null;
		private static var markupFactory:IMarkupBuilderFactory  = null; 
		
		public function GUIManagersFactory()
		{
			throw new StaticClassConstructError(this);
		}
		
		tengu_internal static function registerScaleManager (value:Class):void
		{
			scaleManagerClass = value;
		}
		
		tengu_internal static function registerCallLaterManager (value:Class):void
		{
			callLaterManagerClass = value;
		}
		
		tengu_internal static function registerTexturesManager (value:Class):void
		{
			texturesManagerClass = value;
		}
		
		tengu_internal static function registerWindowManager (value:Class):void
		{
			windowManagerClass = value;
		}
		
		tengu_internal static function registerStyleManager (value:Class):void
		{
			styleManagerClass = value;
		}
		
		tengu_internal static function registerMarkupFactory (value:Class):void
		{
			markupFactoryClass = value;
		}
		
		private static function getManagerInstance (managerClass:Class):*
		{
			if (managerClass == null)
			{
				throw new Error("GUIManagersFactory is not configured!");
			}
			return new managerClass();
		}
		
		public static function getScaleManager ():IScaleManager
		{
			if (scaleManager == null)
			{
				scaleManager = getManagerInstance(scaleManagerClass) as IScaleManager;
			}
			return scaleManager;
		}
		
		public static function getCallLaterManager ():ICallLaterManager
		{
			if (callLaterManager == null)
			{
				callLaterManager = getManagerInstance(callLaterManagerClass) as ICallLaterManager;
			}
			return callLaterManager;
		}
		
		public static function getTexturesManager ():ITexturesManager
		{
			if (texturesManager == null)
			{
				texturesManager = getManagerInstance(texturesManagerClass) as ITexturesManager;
			}
			return texturesManager;
		}
		
		public static function getWindowManager ():IWindowManager
		{
			if (windowManager == null)
			{
				windowManager = getManagerInstance(windowManagerClass) as IWindowManager;
			}
			return windowManager;
		}
		
		public static function getStyleManager ():IStyleManager
		{
			if (styleManager == null)
			{
				styleManager = getManagerInstance(styleManagerClass) as IStyleManager;
			}
			return styleManager;
		}
		
		public static function getMarkupFactory():IMarkupBuilderFactory
		{
			if (markupFactory == null)
			{
				markupFactory = getManagerInstance(markupFactoryClass) as IMarkupBuilderFactory;
			}
			return markupFactory;
		}
	}
}