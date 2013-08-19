package com.tengu.gui.windows.tweens
{
	import com.tengu.gui.windows.GUIWindow;
	
	import ru.mail.minigames.tween.Tween;
	import ru.mail.minigames.tween.easing.Elastic;
	
	public class CloseWindowTween extends Tween
	{
		private static const tweens:Vector.<CloseWindowTween> = new Vector.<CloseWindowTween>();
		public static const CLOSE_WINDOW_TWEEN:String = "closeWindowTween";
		
		public static function create (duration:uint):CloseWindowTween
		{
			var tween:CloseWindowTween = null;
			if (tweens.length == 0)
			{
				tween = new CloseWindowTween(duration);
			}
			else
			{
				tween = tweens.shift();
				tween.duration = duration;
			}
			return tween; 
		}
		
		private var window:GUIWindow = null;
		
		private var startWidth:uint  = 0;
		private var startHeight:uint = 0;

		public function CloseWindowTween(duration:uint)
		{
			super(duration);
		}
		
		protected override function parse(params:Object):void
		{
			window = target as GUIWindow;
			ease = Elastic.easeOut;
			startWidth  = window.width;
			startHeight = window.height;
		}
		
		public override function tick():Boolean
		{
			var inverseRatio:Number = 0;
			currentTick++;
			ratio = ease(currentTick / duration);
			inverseRatio = (1 - ratio);
			
			if (currentTick == duration)
			{
				window.setSize(0, 0);
				window.alpha = 0;
				return true;
			}
			window.setSize(startWidth * inverseRatio, startHeight * inverseRatio);
			window.alpha = inverseRatio;
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