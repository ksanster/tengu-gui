package com.tengu.gui.layouts
{
	import com.tengu.gui.base.GUIComponent;
	import com.tengu.gui.containers.GUIContainer;
	import com.tengu.gui.enum.HorizontalAlign;
	import com.tengu.gui.enum.VerticalAlign;
	
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	public class BaseLayout implements ILayout
	{
		protected var hAlign:String = HorizontalAlign.CENTER;
		protected var vAlign:String   = VerticalAlign.TOP;
		
		protected var layoutGap:int = 0;

		protected var verticalAlignKoef:Number = 0;
		protected var verticalAlignStart:int = 0;

		protected var horizontalAlignKoef:Number = 0;
		protected var horizontalAlignStart:int = 0;

		protected var bounds:Rectangle 		 = null;

		protected var paddingLeft:int;
		protected var paddingRight:int;
		protected var paddingTop:int;
		protected var paddingBottom:int;
		
		protected var numChildren:uint;
		
		protected var noPaddingWidth:int;
		protected var noPaddingHeight:int;
		protected var pixelToPercentWidth:Number;
		
		protected var contentWidth:uint;
		protected var contentHeight:uint;
		
		protected var percentSizedClips:Vector.<GUIComponent> = null;
		
		
		public function get gap():int
		{
			return layoutGap;
		}

		public function set gap(value:int):void
		{
			layoutGap = value;
		}

		public function get verticalAlign():String
		{
			return vAlign;
		}

		public function set verticalAlign(value:String):void
		{
			vAlign = value;
		}

		public function get horizontalAlign():String
		{
			return hAlign;
		}

		public function set horizontalAlign(value:String):void
		{
			hAlign = value;
		}
		
		public function BaseLayout()
		{
			initialize();
		}

		private function initialize():void
		{
			bounds = new Rectangle();
			percentSizedClips = new Vector.<GUIComponent>();
		}
		
		protected function setAlignParams (target:GUIComponent, noPaddingWidth:uint, noPaddingHeight:uint):void
		{
			switch (horizontalAlign)
			{
				case HorizontalAlign.CENTER:
				{
					horizontalAlignStart = target.paddingLeft + .5 * noPaddingWidth;
					horizontalAlignKoef = - .5;
					break;
				}
				case HorizontalAlign.RIGHT:
				{
					horizontalAlignStart = target.paddingLeft + noPaddingWidth;
					horizontalAlignKoef = - 1;
					break;
				}
				default:
				{
					horizontalAlignStart = target.paddingLeft;
					horizontalAlignKoef = 0;
					break;
				}
			}

			switch (verticalAlign)
			{
				case VerticalAlign.BOTTOM:
				{
					verticalAlignStart = target.paddingTop + noPaddingHeight;
					verticalAlignKoef = - 1;
					break;
				}
				case VerticalAlign.MIDDLE:
				{
					verticalAlignStart = target.paddingTop + .5 * noPaddingHeight;
					verticalAlignKoef = - .5;
					break;
				}
				default:
				{
					verticalAlignStart = target.paddingTop;
					verticalAlignKoef = 0;
					break;
				}
			}
		}
		
		protected function prepare (target:GUIContainer):void
		{
			percentSizedClips.length = 0;
			
			numChildren		= target.numChildren;
			
			paddingLeft 	= target.paddingLeft;
			paddingRight 	= target.paddingRight;
			paddingTop 		= target.paddingTop;
			paddingBottom 	= target.paddingBottom;
			
			noPaddingWidth	= target.width - paddingLeft - paddingRight;
			noPaddingHeight = target.height - paddingTop - paddingBottom;
			
			contentWidth  = 0;
			contentHeight = 0;
		}
		
		protected function calculatePercentSizes (target:GUIContainer):void
		{
			//Must be overriden
		}
		
		
		protected function arrangeComponents (target:GUIContainer):void
		{
			//Must be overriden
		}
		
		public final function arrange (target:GUIContainer):Rectangle
		{
			prepare(target);
			calculatePercentSizes(target);
			arrangeComponents(target);
			
			return bounds;
		}
	}
}