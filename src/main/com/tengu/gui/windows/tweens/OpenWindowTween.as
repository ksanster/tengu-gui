package com.tengu.gui.windows.tweens
{
	import com.tengu.gui.windows.GUIWindow;
	
	import ru.mail.minigames.tween.Tween;
	import ru.mail.minigames.tween.easing.Elastic;
	
	public class OpenWindowTween extends Tween
	{
		private static const tweens:Vector.<OpenWindowTween> = new Vector.<OpenWindowTween>();
		public static const OPEN_WINDOW_TWEEN:String = "openWindowTween";

		public static function create (duration:uint):OpenWindowTween
		{
			var tween:OpenWindowTween = null;
			if (tweens.length == 0)
			{
				tween = new OpenWindowTween(duration);
			}
			else
			{
				tween = tweens.shift();
				tween.duration = duration;
			}
			return tween; 
		}
		
		private var window:GUIWindow = null;
		private var endWidth:uint = 0;
		private var endHeight:uint = 0;

		public function OpenWindowTween(duration:uint)
		{
			super(duration);
		}
		
		protected override function parse(params:Object):void
		{
			window = target as GUIWindow;
			endWidth = window.width;
			endHeight = window.height;
			window.setSize(0, 0);
			ease = Elastic.easeOut;
		}
		
		public override function tick():Boolean
		{
			currentTick++;
			ratio = ease(currentTick / duration);
			if (currentTick == duration)
			{
				window.setSize(endWidth, endHeight);
				window.alpha = 1;
				return true;
			}
			window.setSize(endWidth * ratio, endHeight * ratio);
			window.alpha = ratio;
			return false;
		}
		
		public override function finalize():void
		{
			super.finalize();
			window = null;
			tweens[tweens.length] = this;
		}

	}
}