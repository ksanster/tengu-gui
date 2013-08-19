package com.tengu.gui
{
	import com.tengu.calllater.impl.CallLaterManager;
	import com.tengu.core.tengu_internal;
	import com.tengu.di.api.IInjector;
	import com.tengu.gui.base.GUIComponent;
	import com.tengu.gui.base.GUIManagersFactory;
	import com.tengu.gui.managers.GuiWindowManager;
	import com.tengu.gui.managers.MarkupManager;
	import com.tengu.gui.managers.ScaleManager;
	import com.tengu.gui.managers.StyleManager;
	import com.tengu.gui.managers.TexturesManager;
	import com.tengu.gui.windows.tweens.CloseWindowTween;
	import com.tengu.gui.windows.tweens.OpenWindowTween;
	import com.tengu.tween.TweenSystem;
	
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
			if (stage != null)
			{
				configure();
			}
			else
			{
				addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			}
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
			initializeTweener();
			initializeGUI();
			updateSize();
		}
		
		protected override function initialize():void
		{
			//Empty
		}
		
		protected function initializeTweener ():void
		{
			TweenSystem.registerTween(OpenWindowTween.OPEN_WINDOW_TWEEN, OpenWindowTween.create);
			TweenSystem.registerTween(CloseWindowTween.CLOSE_WINDOW_TWEEN, CloseWindowTween.create);
		}
		
		protected function initializeManagers ():void
		{
			GUIManagersFactory.tengu_internal::registerCallLaterManager(CallLaterManager);
			GUIManagersFactory.tengu_internal::registerTexturesManager(TexturesManager);
			GUIManagersFactory.tengu_internal::registerWindowManager(GuiWindowManager);
			GUIManagersFactory.tengu_internal::registerStyleManager(StyleManager);
			GUIManagersFactory.tengu_internal::registerScaleManager(ScaleManager);
			
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
		
		private function onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
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