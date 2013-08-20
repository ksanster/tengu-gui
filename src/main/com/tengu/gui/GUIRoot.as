package com.tengu.gui
{
	import com.tengu.calllater.impl.CallLaterManager;
	import com.tengu.core.tengu_internal;
	import com.tengu.di.api.IInjector;
	import com.tengu.gui.base.GUIComponent;
	import com.tengu.gui.base.GUIManagersFactory;
	import com.tengu.gui.managers.GuiWindowManager;
	import com.tengu.gui.managers.ScaleManager;
	import com.tengu.gui.managers.StyleManager;
	import com.tengu.gui.managers.TexturesManager;
	import com.tengu.gui.markup.MarkupBuilderFactory;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class GUIRoot extends GUIComponent
	{
		private var componentsContainer:Sprite = null;
		
		[Inject]
		public var injector:IInjector = null;
		
		public function get container():DisplayObjectContainer	 
		{
			return componentsContainer;
		}
		
		public function GUIRoot()
		{
			super();
		}
		
		private function configure():void
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedComponentToStage, true);
			
			mouseEnabled = false;
			
			componentWidth 	= stage.fullScreenWidth;
			componentHeight = stage.fullScreenHeight;

			stage.addEventListener(Event.RESIZE, onResize);
			
			componentsContainer = new Sprite();
			componentsContainer.mouseEnabled = false;
			addChild(componentsContainer);
			
			initializeManagers();
			initializeGUI();
			updateSize();
		}
		
		protected override function initialize():void
		{
			//Empty
		}
		
		protected function initializeManagers ():void
		{
			GUIManagersFactory.tengu_internal::registerCallLaterManager(CallLaterManager);
			GUIManagersFactory.tengu_internal::registerTexturesManager(TexturesManager);
			GUIManagersFactory.tengu_internal::registerWindowManager(GuiWindowManager);
			GUIManagersFactory.tengu_internal::registerStyleManager(StyleManager);
			GUIManagersFactory.tengu_internal::registerScaleManager(ScaleManager);
			GUIManagersFactory.tengu_internal::registerMarkupFactory(MarkupBuilderFactory);
			
			GUIManagersFactory.getCallLaterManager().stage = stage;
			
			(windowManager as GUIComponent).setSize(stage.stageWidth, stage.stageHeight);
			addChild(windowManager as GUIComponent);
		}
		
		protected function initializeGUI ():void
		{
			//Abstract
		}
		
		protected override function updateSize():void
		{
			scaleManager.setScreenSize(width, height);
			windowManager.setSize(width, height);
		}
		
		protected override function onAddedToStage(event:Event):void
		{
            super.onAddedToStage(event);
			configure();
		}		
		
		private function onResize(event:Event):void
		{
			componentWidth 	= stage.fullScreenWidth;
			componentHeight = stage.fullScreenHeight;
			updateSize();
		}
		
		private function onAddedComponentToStage(event:Event):void
		{
			var component:GUIComponent = event.target as GUIComponent;
			if (component != null && injector != null)
			{
				injector.injectInto(component);
			}
		}
	}
}