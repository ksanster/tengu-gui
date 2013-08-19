package com.tengu.gui.tools
{
	import com.tengu.gui.base.GUIComponent;
    import com.tengu.gui.containers.GUIContainer;
    import com.tengu.gui.containers.HBox;
    import com.tengu.gui.containers.ScrollContainer;
    import com.tengu.gui.containers.VBox;
    import com.tengu.gui.controls.IconLabel;
    import com.tengu.gui.controls.PageIndicator;
    import com.tengu.gui.controls.buttonbar.ButtonGroup;
    import com.tengu.gui.controls.buttonbar.TabNavigator;
    import com.tengu.gui.controls.buttons.BaseButton;
    import com.tengu.gui.controls.buttons.CheckBox;
    import com.tengu.gui.controls.buttons.IconButton;
    import com.tengu.gui.controls.buttons.RadioButton;
    import com.tengu.gui.controls.buttons.TextButton;
    import com.tengu.gui.controls.buttons.Toggle;
    import com.tengu.gui.controls.combobox.ComboBox;
    import com.tengu.gui.controls.list.HorizontalScrollPanel;
    import com.tengu.gui.controls.list.VerticalScrollPanel;
    import com.tengu.gui.controls.scrollbar.HorizontalScrollBar;
    import com.tengu.gui.controls.scrollbar.VerticalScrollBar;
    import com.tengu.gui.controls.text.StageTextInput;
    import com.tengu.gui.controls.text.StageTextInputWithPropmt;
    import com.tengu.gui.controls.text.Text;
    import com.tengu.gui.layouts.CellsLayout;
    import com.tengu.gui.layouts.HorizontalLayout;
    import com.tengu.gui.layouts.TilelLayout;
    import com.tengu.gui.layouts.VerticalLayout;
    import com.tengu.gui.screens.ScreenNavigator;

    public class MarkupParser
	{
        private static const ALIASES:Object = function ():Object
        {
            var result:Object = {};
            result["Component"] = GUIComponent;
            result["Container"] = GUIContainer;
            result["VBox"]      = VBox;
            result["HBox"]      = HBox;
            result["Scroll"]    = ScrollContainer;

            result["IconLabel"]     = IconLabel;
            result["PageIndicator"] = PageIndicator;

            result["Text"]      = Text;
            result["InputText"] = StageTextInputWithPropmt;

            result["Button"]     = BaseButton;
            result["TextButton"] = TextButton;
            result["IconButton"] = IconButton;
            result["CheckBox"]   = CheckBox;
            result["Radio"]      = RadioButton;
            result["Toggle"]     = Toggle;

            result["ButtonGroup"]   = ButtonGroup;
            result["TabNavigator"]  = TabNavigator;

            result["Combo"]     = ComboBox;
            result["VScroll"]   = VerticalScrollPanel;
            result["HScroll"]   = HorizontalScrollPanel;

            result["HScrollBar"] = HorizontalScrollBar;
            result["VScrollBar"] = VerticalScrollBar;

            result["ScreenNavigator"] = ScreenNavigator;

            result["HorizontalLayout"]  = HorizontalLayout;
            result["VerticalLayout"]    = VerticalLayout;
            result["CellsLayout"]       = CellsLayout;
            result["TileLayout"]        = TilelLayout;

            return result;
        }();

        private static const FACTORY_METHOD_NAME:String = "createFromMarkup";

		private var components:Object   = null; 
		private var target:GUIComponent = null;
		
		public function MarkupParser(target:GUIComponent)
		{
			this.target = target;
			components = {};
		}
		
		public function parse (xml:XML):void
		{
			if (xml == null)
			{
				return;
			}

            const factoryClassName:String = String(xml.localName());
            const factoryClass:Class = ALIASES[factoryClassName];

            if (factoryClass == null)
            {
                return;
            }

            const factoryMethod:Function = factoryClass[FACTORY_METHOD_NAME] || GUIComponent.createFromMarkup;

            factoryMethod(xml);
		}
		
		public function getComponentById (id:String):GUIComponent
		{
			return components[id];
		}
		
		public function finalize ():void
		{
			target = null;
			components = null;
		}
	}
}