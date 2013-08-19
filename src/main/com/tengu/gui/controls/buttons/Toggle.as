package com.tengu.gui.controls.buttons
{
	import com.tengu.gui.base.GUIComponent;
	import com.tengu.gui.fills.ColorFloodFill;
	import com.tengu.gui.fills.ShapeFill;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import ru.mail.minigames.tween.TweenSystem;
	import ru.mail.minigames.tween.Tweener;
	
	[Style(name="track_on_fill")]
	[Style(name="track_off_fill")]
	[Style(name="thumb_button_style")]
	
	[Event(name="change", type="flash.events.Event")]
	public class Toggle extends GUIComponent
	{
		public static const TOGGLE_TIME:uint = 5;
		private static const shape:Shape = new Shape();
		private static const transparentFill:ColorFloodFill = new ColorFloodFill();
		
		private static const rect:Rectangle = new Rectangle();
		private static const point:Point = new Point();
		
		private var isSelected:Boolean;
		private var thumb:BaseButton = null;
		private var track:Bitmap = null;
		
		private var trackData:BitmapData = null;
		private var offTrackData:BitmapData = null;
		private var onTrackData:BitmapData = null;
		
		private var offTrackFill:ShapeFill = null;
		private var onTrackFill:ShapeFill = null;
		
		private var tweener:Tweener = null;
		
		public function set selected(value:Boolean):void 
		{
			isSelected = value;
			invalidate(VALIDATION_FLAG_DATA, VALIDATION_FLAG_DISPLAY);
		}
		
		public function get selected():Boolean 
		{
			return isSelected;
		}
		
		public function set thumbX(value:Number):void 
		{
			thumb.x = value;
			invalidate(VALIDATION_FLAG_DISPLAY);
		}
		
		public function get thumbX():Number 
		{
			return thumb.x;
		}
		
		public function Toggle()
		{
			super();
		}
		
		private function updateFills ():void
		{
			var graphix:Graphics = shape.graphics;
			
			offTrackData = new BitmapData(width, height, true, 0x00FFFFFF);
			onTrackData = new BitmapData(width, height, true, 0x00FFFFFF);
			trackData = new BitmapData(width, height, true, 0x00FFFFFF);
			
			track.bitmapData = trackData;
			
			offTrackFill.apply(graphix, width, height);
			offTrackData.draw(shape);
			
			onTrackFill.apply(graphix, width, height);
			onTrackData.draw(shape);
			
		}
		
		private function updateView():void
		{
			var dx:int = thumb.x + thumb.width * .5;
			trackData.fillRect(trackData.rect, 0x00FFFFFF);
			
			rect.x = 0;
			rect.width = dx;
			point.x = 0;
			trackData.copyPixels(onTrackData, rect, point);
			
			rect.x = dx;
			rect.width = offTrackData.width - dx;
			point.x = dx;
			trackData.copyPixels(offTrackData, rect, point);
		}
		
		protected override function measure():void
		{
			componentWidth  = 99;
			componentHeight = 46;
		}
		
		protected override function createChildren():void
		{
			super.createChildren();
			
			buttonMode = true;
			mouseEnabled = true;
			mouseChildren = false;
			
			hitArea = new Sprite();
			hitArea.mouseEnabled = false;
			transparentFill.apply(hitArea.graphics, width, height);
			addChild(hitArea);
			
			offTrackFill = new ShapeFill();
			onTrackFill = new ShapeFill();
			
			track = new Bitmap();
			addChild(track);
			
			thumb = new BaseButton();
			addChild(thumb);
			
			tweener = TweenSystem.getTweener(this);
			addEventListener(MouseEvent.CLICK, onClick);
		}
		
		protected override function dispose():void
		{
			TweenSystem.removeTweener(tweener);
			removeEventListener(MouseEvent.CLICK, onClick);
			
			tweener = null;
			thumb = null;
			track = null;
			offTrackFill = null;
			onTrackFill = null;
			offTrackData = null;
			onTrackData = null;
			super.dispose();
		}
		
		protected override function updateData():void
		{
			super.updateData();
			thumb.x = selected ? width - thumb.width : 0;
		}
		
		protected override function setStyleSelector(styleName:String, styleValue:*):void
		{
			if (styleName == "width")
			{
				width = parseInt(styleValue);
				return;
			}
			if (styleName == "height")
			{
				height = parseInt(styleValue);
				return;
			}
			if (styleName == "track_on_fill")
			{
				onTrackFill = textureManager.getTexture(styleValue);
				return;
			}
			if (styleName == "track_off_fill")
			{
				offTrackFill = textureManager.getTexture(styleValue);
				return;
			}
			if (styleName == "thumb_button_style")
			{
				thumb.style = styleValue;
				return;
			}
			super.setStyleSelector(styleName, styleValue);
		}
		
		protected override function updateStyle():void
		{
			super.updateStyle();
			rect.width = width;
			rect.height = height;
			updateFills();
			thumb.draw();
			thumb.y = (height - thumb.height) * .5;
		}
		
		protected override function updateSize():void
		{
			super.updateSize();
			rect.width = width;
			rect.height = height;
			transparentFill.apply(hitArea.graphics, width, height);
			thumb.y = (height - thumb.height) * .5;
			updateFills();
		}
		
		protected override function updateDisplay():void
		{
			super.updateDisplay();
			updateView();
		}
		
		private function onClick(event:MouseEvent):void
		{
			if (tweener.hasTweens())
			{
				return;
			}
			
			isSelected = !isSelected;
			var targetX:int = isSelected ? width - thumb.width : 0;
			
			tweener.addTween(TOGGLE_TIME, {thumbX:targetX});
			
			if (hasEventListener(Event.CHANGE))
			{
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
	}
}