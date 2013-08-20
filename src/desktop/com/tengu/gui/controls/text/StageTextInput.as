package com.tengu.gui.controls.text
{
	import com.tengu.core.tengu_internal;
	import com.tengu.gui.base.GUIComponent;
	import com.tengu.gui.fills.ColorFloodFill;
	import com.tengu.gui.fills.ShapeFill;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.SoftKeyboardEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.StageText;
	import flash.text.StageTextInitOptions;
	import flash.text.TextFormat;
	import flash.text.engine.FontWeight;
	
	import ru.mail.minigames.utils.parseBool;
	
	[Style(name="focus_text")]
	[Style(name="normal_border")]
	[Style(name="focus_border")]
	[Style(name="background_fill")]

	[Event(name="change", type="flash.events.Event")]
	[Event(name="focusIn", type="flash.events.FocusEvent")]
	[Event(name="focusOut", type="flash.events.FocusEvent")]
	[Event(name="keyDown", type="flash.events.KeyboardEvent")]
	[Event(name="softKeyboardActivate", type="flash.events.SoftKeyboardEvent")]
	[Event(name="softKeyboardActivating", type="flash.events.SoftKeyboardEvent")]
	[Event(name="softKeyboardDeactivate", type="flash.events.SoftKeyboardEvent")]
	
	public class StageTextInput extends GUIComponent
	{
		private const helperPoint:Point = new Point();
		
		private var border:Shape = null;
		
		private var normalBorderFill:ShapeFill = null;
		private var focusBorderFill:ShapeFill  = null;
		private var textFormat:TextFormat 	= null;
		private var isMultiline:Boolean 	= false;
		private var oldVisibleState:Boolean = false;
		
		private var snapshotChanged:Boolean = true;
		private var viewportChanged:Boolean = true;
		
		protected var snapshot:Bitmap = null;
		protected var snapshotData:BitmapData = null;
		
		protected var viewportRectangle:Rectangle = null;

		protected var hasFocus:Boolean = false;
		protected var keyboardActive:Boolean = false;
		
		protected var textFieldText:String 	= "";
		protected var stageText:StageText 	= null;
		
		protected var normalTextStyle:String = null;
		protected var focusTextStyle:String = null;
		protected var defaultTextStyle:String  = null;
		
		[Inject]
		public var eventBus:IEventDispatcher = null;

		public function set autoCapitalize(autoCapitalize:String):void
		{
			stageText.autoCapitalize = autoCapitalize;
		}
		
		public function set autoCorrect(autoCorrect:Boolean):void
		{
			stageText.autoCorrect = autoCorrect;
		}
		
		public function set color(color:uint):void
		{
			stageText.color = color;
		}
		
		public function set displayAsPassword(value:Boolean):void
		{
			stageText.displayAsPassword = value;
		}
		
		public function set editable(editable:Boolean):void
		{
			stageText.editable = editable;
		}
		
		public function set fontPosture(fontPosture:String):void
		{
			stageText.fontPosture = fontPosture;
		}
		
		public function set locale(locale:String):void
		{
			stageText.locale = locale;
		}
		
		public function get multiline():Boolean
		{
			return stageText.multiline;
		}

		public function set maxChars(maxChars:int):void
		{
			stageText.maxChars = maxChars;
		}
		
		public function set restrict(restrict:String):void
		{
			stageText.restrict = restrict;
		}
		
		public function set returnKeyLabel(returnKeyLabel:String):void
		{
			stageText.returnKeyLabel = returnKeyLabel;
		}
		
		public function get selectionActiveIndex():int
		{
			return stageText.selectionActiveIndex;
		}
		
		public function get selectionAnchorIndex():int
		{
			return stageText.selectionAnchorIndex;
		}
		
		public function set softKeyboardType(softKeyboardType:String):void
		{
			stageText.softKeyboardType = softKeyboardType;
		}
		
		public function set text(value:String):void
		{
			value = value || "";
			if (textFieldText == value)
			{
				return;
			}
			textFieldText = value;
			snapshotChanged = true;
			invalidate(VALIDATION_FLAG_DATA, VALIDATION_FLAG_DISPLAY);
			if (hasEventListener(Event.CHANGE))
			{
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		public function get text():String 
		{
			return textFieldText;
		}
		
		public function set textAlign(textAlign:String):void
		{
			stageText.textAlign = textAlign;
		}
		
		public override function set visible(visible:Boolean):void
		{
			super.visible = visible;
			stageText.visible = visible && keyboardActive;
		}
		
		public function get enabled():Boolean 
		{
			return stageText.editable;
		}
		
		public function set enabled(value:Boolean):void 
		{
			stageText.editable = value;
			mouseEnabled = value;
			mouseChildren = value;
		}
		
		public function StageTextInput(multiline:Boolean = false)
		{
			this.isMultiline = multiline;
			super();
		}
		
		private function updateViewport ():void
		{
			if (stage == null)
			{
				return;
			}
			var point:Point = localToGlobal(helperPoint);
			viewportRectangle.x = int(point.x);
			viewportRectangle.y = int(point.y);
			viewportRectangle.width = int(Math.max(width - componentPaddingLeft - componentPaddingRight, 1));
			viewportRectangle.height = int(Math.max(height - componentPaddingTop - componentPaddingBottom, 1));
			
			stageText.viewPort = viewportRectangle;
			viewportChanged = false;
		}
		
		private function updateSnapshot ():void
		{
			if (stage == null || viewportRectangle.width == 0 || viewportRectangle.height == 0)
			{
				return;
			}
			if (snapshotData == null || snapshotData.width != viewportRectangle.width || snapshotData.height != viewportRectangle.height)
			{
				if (snapshotData != null)
				{
					snapshotData.dispose();
				}
				snapshotData = new BitmapData(viewportRectangle.width, viewportRectangle.height, true, 0x00FFFFFF);
				snapshot.bitmapData = snapshotData;
				snapshot.smoothing = true;
			}
			snapshotData.fillRect(snapshotData.rect, 0x00FFFFFF);
			stageText.drawViewPortToBitmapData(snapshotData);
			snapshotChanged = false;
		}
		
		private function updateStageTextFormat ():void
		{
			if (textFormat == null)
			{
				return;
			}
			stageText.fontFamily = textFormat.font;
			stageText.fontSize = parseInt(String(textFormat.size));
			stageText.color = parseInt(String(textFormat.color));
			stageText.fontWeight = parseBool(textFormat.bold) ? FontWeight.BOLD : FontWeight.NORMAL;
		}

		protected override function createChildren():void
		{
			super.createChildren();
			viewportRectangle = new Rectangle(0, 0, width, height);
			
			var stio:StageTextInitOptions = new StageTextInitOptions(isMultiline);
			stageText = new StageText(stio);
			stageText.visible = false;
			stageText.addEventListener(Event.COMPLETE, onComplete);
			stageText.addEventListener(Event.CHANGE, onTextChange);
			stageText.addEventListener(KeyboardEvent.KEY_DOWN, onTextKeyDown);
			stageText.addEventListener(FocusEvent.FOCUS_IN, onTextFocusIn);
			stageText.addEventListener(FocusEvent.FOCUS_OUT, onTextFocusOut);
			stageText.addEventListener(Event.COMPLETE, onTextComplete);
			stageText.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATE, onKeyboardActivate);
			stageText.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE, onKeyboardDeactivate);
			
			stageText.locale = "en";
			
			snapshot = new Bitmap();
			snapshot.visible = false;
			addChild(snapshot);
			
			border = new Shape();
			addChildAt(border, 0);
			
			enabled = true;

			addEventListener(MouseEvent.CLICK, onClick);
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		protected override function dispose():void
		{
			if (eventBus != null)
			{
				eventBus.removeEventListener( Event.ACTIVATE, onActivateDeactivate );
				eventBus.removeEventListener( Event.DEACTIVATE, onActivateDeactivate );
				eventBus = null;
			}
			
			removeEventListener(MouseEvent.CLICK, onClick);
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);

			stageText.removeEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATE, onKeyboardActivate);
			stageText.removeEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE, onKeyboardDeactivate);
			stageText.removeEventListener(Event.CHANGE, onTextChange);
			stageText.removeEventListener(KeyboardEvent.KEY_DOWN, onTextKeyDown);
			stageText.removeEventListener(FocusEvent.FOCUS_IN, onTextFocusIn);
			stageText.removeEventListener(FocusEvent.FOCUS_OUT, onTextFocusOut);
			stageText.removeEventListener(Event.COMPLETE, onTextComplete);
			stageText.dispose();
			stageText = null;
			super.dispose();
		}
		
		protected override function updateData():void
		{
			super.updateData();
			stageText.text = textFieldText;
			snapshotChanged = true;
		}
		
		protected override function updateStyle():void
		{
			styleObject ||= defaultStyle;
			
			backgroundFill = null;
			normalBorderFill = null;
			focusBorderFill = null;
			normalTextStyle = null;
			focusTextStyle = null;
			defaultTextStyle = null;

			tengu_internal::parseStyle(styleObject);
			
			backgroundFill	 ||= new ColorFloodFill();
			normalBorderFill ||= new ColorFloodFill();
			focusBorderFill ||= normalBorderFill;
			
			normalTextStyle ||= styleManager.defaultTextStyle;
			focusTextStyle ||= normalTextStyle;
			defaultTextStyle ||= normalTextStyle;

			textFormat = styleManager.getTextFormat(normalTextStyle);
			updateStageTextFormat();
			
			helperPoint.x = componentPaddingLeft;
			helperPoint.y = componentPaddingRight;
		}
		
		protected override function updateSize():void
		{
			super.updateSize();
			snapshotChanged = true;
			viewportChanged = true;
		}

		protected override function updateDisplay():void
		{
			super.updateDisplay();
			
			if (hasFocus)
			{
				focusBorderFill.apply(border.graphics, width, height);
			}
			else
			{
				normalBorderFill.apply(border.graphics, width, height);
			}
			
			if (viewportChanged)
			{
				updateViewport();
			}

			if (snapshotChanged)
			{
				updateSnapshot();
			}
			snapshot.x = (width - snapshot.width) * .5;
			snapshot.y = (height - snapshot.height) * .5;
			snapshot.x = componentPaddingLeft;
			snapshot.y = componentPaddingRight;
			
			snapshot.visible = !keyboardActive;
			stageText.visible = keyboardActive;
		}
		
		protected override function setStyleSelector(styleName:String, styleValue:*):void
		{
			if (styleName == "text")
			{
				normalTextStyle = styleValue;
				return;
			}
			if (styleName == "focus_text")
			{
				focusTextStyle = styleValue;
				return;
			}
			if (styleName == "normal_border")
			{
				normalBorderFill = textureManager.getTexture(styleValue);
				return;
			}
			if (styleName == "focus_border")
			{
				focusBorderFill = textureManager.getTexture(styleValue);
				return;
			}
			if (styleName == "background_fill")
			{
				backgroundFill = textureManager.getTexture(styleValue);
				return;
			}
			super.setStyleSelector(styleName, styleValue);
		}
		
		[PostConstruct]
		public function configure ():void
		{
			eventBus.addEventListener( Event.ACTIVATE, onActivateDeactivate );
			eventBus.addEventListener( Event.DEACTIVATE, onActivateDeactivate );
		}

		
		public function assignFocus():void
		{
			stageText.assignFocus();
		}
		
		public function selectRange(anchorIndex:int, activeIndex:int):void
		{
			stageText.selectRange(anchorIndex, activeIndex);
		}
		
		private function onAddedToStage(event:Event):void
		{
			stageText.stage = stage;
			callLater(invalidate, VALIDATION_FLAG_DISPLAY);
		}
		
		private function onRemovedFromStage(event:Event):void
		{
		}
		
		private function onComplete(event:Event):void
		{
			snapshotChanged = true;
			invalidate(VALIDATION_FLAG_DISPLAY);
		}
		
		private function onActivateDeactivate(event:Event):void
		{
			if (stageText == null)
			{
				return;
			}
			if ( event.type == Event.DEACTIVATE )
			{
				oldVisibleState = stageText.visible;
				stageText.visible = false;
			}
			else if ( event.type == Event.ACTIVATE )
			{
				stageText.visible = oldVisibleState;
			}
		}

		protected function onTextChange(event:Event):void
		{
			textFieldText = stageText.text;		
			if (textFieldText.length > 0)
			{
				snapshotChanged = true;
				invalidate(VALIDATION_FLAG_DISPLAY);
			}
		}
		
		protected function onTextKeyDown(event:KeyboardEvent):void
		{
			if(hasEventListener(KeyboardEvent.KEY_DOWN))
			{
				dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN));
			}
		}
		
		protected function onTextFocusIn(event:FocusEvent):void
		{
			hasFocus = true;
			invalidate(VALIDATION_FLAG_DISPLAY);
			updateDisplay();
			
			if (hasEventListener(FocusEvent.FOCUS_IN))
			{
				dispatchEvent(new FocusEvent(FocusEvent.FOCUS_IN));
			}
		}
		
		protected function onTextFocusOut(event:FocusEvent):void
		{
			hasFocus = false;
			invalidate(VALIDATION_FLAG_DATA, VALIDATION_FLAG_DISPLAY);
			if (hasEventListener(FocusEvent.FOCUS_OUT))
			{
				dispatchEvent(new FocusEvent(FocusEvent.FOCUS_OUT));
			}
		}
		
		protected function onTextComplete(event:Event):void
		{
			//Empty
		}
		
		
		protected function onClick(event:MouseEvent):void
		{
			stageText.assignFocus();
		}

		
		protected function onKeyboardActivate(event:SoftKeyboardEvent):void
		{
			keyboardActive = true;
			viewportChanged = true;
			invalidate(VALIDATION_FLAG_DISPLAY);
			if (hasEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATE))
			{
				dispatchEvent(event);
			}
		}
		
		protected function onKeyboardDeactivate(event:SoftKeyboardEvent):void
		{
			keyboardActive = false;
			snapshotChanged = true;
			invalidate(VALIDATION_FLAG_DISPLAY);
			if (hasEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE))
			{
				dispatchEvent(event);
			}
		}

	}
}