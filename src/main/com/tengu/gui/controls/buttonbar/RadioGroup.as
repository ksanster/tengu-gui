package com.tengu.gui.controls.buttonbar
{
    import com.tengu.gui.containers.VBox;
    import com.tengu.gui.controls.buttons.BaseButton;
    import com.tengu.gui.enum.HorizontalAlign;
    import com.tengu.gui.layouts.BaseLayout;
    import com.tengu.gui.layouts.VerticalLayout;

    import flash.display.DisplayObject;
    import flash.events.Event;
    import flash.events.MouseEvent;

    [Style(name="button_style")]

    [Event(name="change", type="flash.events.Event")]
    public class RadioGroup extends VBox
	{
        private var buttonStyle:Object;

        private var _selectedIndex:int = -1;

        public function get selectedIndex ():int
        {
            return _selectedIndex;
        }

        public function set selectedIndex (value:int):void
        {
            if (_selectedIndex == value)
            {
                return;
            }
            _selectedIndex = value;
            updateButtonState();
            dispatchEvent(new Event(Event.CHANGE));
        }

		public function RadioGroup()
		{
			super();
		}

        private function updateButtonState ():void
        {
            var button:BaseButton;
            for (var i:int = 0; i < numChildren; i++)
            {
                button = getChildAt(i) as BaseButton;
                button.selected = (i == _selectedIndex);
                button.mouseEnabled = !button.selected;
            }
        }

        private function addButton (button:BaseButton, index:int):void
        {
            if (button == null)
            {
                return;
            }
            button.style = buttonStyle;

            button.addEventListener(MouseEvent.CLICK, onCLickButton);

            button.selected = (index == _selectedIndex);
            button.mouseEnabled = !button.selected;
        }

        private function removeButton (button:BaseButton):void
        {
            if (button == null)
            {
                return;
            }
            button.removeEventListener(MouseEvent.CLICK, onCLickButton);
            button.finalize();
            if (_selectedIndex >= numChildren)
            {
                _selectedIndex = numChildren - 1;
            }
        }

		protected override function getLayout():BaseLayout
		{
			var vLayout:VerticalLayout = new VerticalLayout();
			vLayout.horizontalAlign = HorizontalAlign.LEFT;
			vLayout.gap = 5;
			return vLayout;
		}
        protected override function setStyleSelector(styleName:String, styleValue:*):void
        {
            var button:BaseButton;
            if (styleName == "button_style")
            {
                buttonStyle = styleValue;
                for (var i:int = 0; i < numChildren; i++)
                {
                    button = getChildAt(i) as BaseButton;
                    if (button != null)
                    {
                        button.style = buttonStyle;
                    }
                }
                return;
            }
            if (styleName == "gap")
            {
                layout.gap = parseInt(styleValue);
                return;
            }
            super.setStyleSelector(styleName, styleValue);
        }

        override public function addChild (child:DisplayObject):DisplayObject
        {
            var result:DisplayObject = super.addChild(child);
            addButton(child as BaseButton, getChildIndex(result));

            return result;
        }

        override public function addChildAt (child:DisplayObject, index:int):DisplayObject
        {
            var result:DisplayObject = super.addChildAt(child, index);
            addButton(child as BaseButton, index);

            return result;
        }


        override public function removeChild (child:DisplayObject):DisplayObject
        {
            var result:DisplayObject =  super.removeChild(child);
            removeButton(result as BaseButton);

            return result;
        }

        override public function removeChildAt (index:int):DisplayObject
        {
            var result:DisplayObject =  super.removeChildAt(index);
            removeButton(result as BaseButton);

            return result;
        }

        private function onCLickButton (event:MouseEvent):void
        {
            var button:BaseButton = event.target as BaseButton;
            selectedIndex = getChildIndex(button);
        }
    }
}