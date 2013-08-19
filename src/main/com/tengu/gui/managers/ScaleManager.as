package com.tengu.gui.managers
{
	import com.tengu.gui.api.IScaleManager;
	
	public class ScaleManager implements IScaleManager
	{
		private var defaultWidth:uint = 1;
		private var defaultHeight:uint = 1;
		private var width:uint = 1;
		private var height:uint = 1;
		
		private var _scaleX:Number 		= 1;
		private var _scaleY:Number 		= 1;
		private var _scale:Number 		= 1;
		private var _lodFactor:Number	= 1;
		
		public function ScaleManager()
		{
		}
		
		public function get scaleX():Number
		{
			return _scaleX;
		}
		
		public function get scaleY():Number
		{
			return _scaleY;
		}
		
		public function get scale():Number
		{
//			return 1;
			return _scale;
		}
		
		public function get lodFactor ():Number
		{
			return _lodFactor;
		}
		
		public function setDefaultSize(width:uint, height:uint):void
		{
			defaultWidth = width || 1;
			defaultHeight = height || 1;
			updateScale();
		}

		public function setScreenSize(width:uint, height:uint):void
		{
			this.width = width;
			this.height = height;
			updateScale();
		}
		
		private function updateScale():void
		{
			updateDefaultSize();
			_scaleX = width / defaultWidth;
			_scaleY = height / defaultHeight;
			_scale = Math.min(_scaleX, _scaleY);
		}
		
		private function updateDefaultSize():void
		{
			if (width <= 480)
			{
				defaultWidth  = 480;
				defaultHeight = 300;
				_lodFactor	  = .375;	
			}
			else if (width <= 960)
			{
				defaultWidth  = 800;
				defaultHeight = 500;
				_lodFactor	  = .625;
			}
			else
			{
				defaultWidth  = 1280;
				defaultHeight = 800;
				_lodFactor	  = 1;
			}
		}
	}
}