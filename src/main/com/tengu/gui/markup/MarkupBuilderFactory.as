package com.tengu.gui.markup
{
	import com.tengu.gui.base.GUIComponent;
    import com.tengu.gui.containers.GUIContainer;
    import com.tengu.gui.containers.HBox;
    import com.tengu.gui.containers.VBox;
    import com.tengu.gui.controls.buttonbar.ButtonGroup;
    import com.tengu.gui.controls.buttonbar.RadioGroup;
    import com.tengu.gui.controls.buttons.BaseButton;
    import com.tengu.gui.controls.buttons.CheckBox;
    import com.tengu.gui.controls.buttons.IconButton;
    import com.tengu.gui.controls.buttons.RadioButton;
    import com.tengu.gui.controls.buttons.TextButton;
    import com.tengu.gui.controls.text.Text;
    import com.tengu.gui.layouts.HorizontalLayout;
    import com.tengu.gui.layouts.VerticalLayout;
    import com.tengu.gui.markup.api.IMarkable;
	import com.tengu.gui.markup.api.IMarkupBuilder;
	import com.tengu.gui.markup.api.IMarkupBuilderFactory;
    import com.tengu.gui.markup.api.IMarkupParser;
    import com.tengu.gui.markup.builders.BaseMarkupBuilder;
    import com.tengu.gui.markup.builders.ComponentBuilder;
    import com.tengu.gui.markup.builders.ContainerBuilder;
    import com.tengu.log.LogFactory;
	
	public class MarkupBuilderFactory implements IMarkupBuilderFactory
	{
        internal const parsers:Vector.<IMarkupParser> = new Vector.<IMarkupParser>();

		private var classes:Object;
		private var builders:Object;
		
		public function MarkupBuilderFactory()
		{
			initialize();
		}
		
		private function initialize():void
		{
            const baseBuilder:IMarkupBuilder      = new BaseMarkupBuilder();
            const componentBuilder:IMarkupBuilder = new ComponentBuilder();
            const containerBuilder:IMarkupBuilder = new ContainerBuilder();
			classes  = {};
			builders = {};
			registerBuilder(componentBuilder, GUIComponent, "Component");
            registerBuilder(containerBuilder, GUIContainer, "Container");
            registerBuilder(containerBuilder, RadioGroup, "ButtonGroup");
            registerBuilder(containerBuilder, VBox, "VBox");
            registerBuilder(containerBuilder, HBox, "HBox");
            registerBuilder(componentBuilder, Text, "Text");
            registerBuilder(componentBuilder, BaseButton, "BaseButton");
            registerBuilder(componentBuilder, TextButton, "Button");
            registerBuilder(componentBuilder, IconButton, "IconButton");
            registerBuilder(componentBuilder, CheckBox,   "CheckBox");
            registerBuilder(componentBuilder, RadioButton, "Radio");
            registerBuilder(baseBuilder, HorizontalLayout, "HorizontalLayout");
            registerBuilder(baseBuilder, VerticalLayout, "VerticalLayout");

//			result["Component"] = GUIComponent;
//			result["Container"] = GUIContainer;
//			result["VBox"]      = VBox;
//			result["HBox"]      = HBox;
//			result["Scroll"]    = ScrollContainer;
//			
//			result["IconLabel"]     = IconLabel;
//			result["PageIndicator"] = PageIndicator;
//			
//			result["Text"]      = Text;
//			result["InputText"] = StageTextInputWithPropmt;
//			
//			result["BaseButton"]     = BaseButton;
//			result["TextButton"] = TextButton;
//			result["IconButton"] = IconButton;
//			result["CheckBox"]   = CheckBox;
//			result["Radio"]      = RadioButton;
//			result["Toggle"]     = Toggle;
//			
//			result["ButtonGroup"]   = ButtonGroup;
//			result["TabNavigator"]  = TabNavigator;
//			
//			result["Combo"]     = ComboBox;
//			result["VScroll"]   = VerticalScrollPanel;
//			result["HScroll"]   = HorizontalScrollPanel;
//			
//			result["HScrollBar"] = HorizontalScrollBar;
//			result["VScrollBar"] = VerticalScrollBar;
//			
//			result["ScreenNavigator"] = ScreenNavigator;
//			
//			result["HorizontalLayout"]  = HorizontalLayout;
//			result["VerticalLayout"]    = VerticalLayout;
//			result["CellsLayout"]       = CellsLayout;
//			result["TileLayout"]        = TilelHorizontalLayout;

		}
		
		public function registerBuilder(builder:IMarkupBuilder, targetClass:Class, alias:String):void
		{
			builders[alias] = builder;
			classes[alias] 	= targetClass;
		}
		
		public function getBuilderByAlias(alias:String):IMarkupBuilder
		{
			if (builders[alias] == null)
			{
				LogFactory.getLogger(this).error("Builder with alias <" + alias + "> not registered");
			}
			return builders[alias];
		}
		
		public function create(alias:String):IMarkable
		{
			var result:IMarkable;
			var resultClass:Class =  classes[alias];
			
			if (resultClass != null)
			{
				result = new resultClass();
			}
			else
			{
				LogFactory.getLogger(this).error("Class with alias <" + alias + "> not registered");
			}
			return result;
		}

        public function getParser (target:IMarkable):IMarkupParser
        {
            var result:IMarkupParser;
            if (parsers.length == 0)
            {
                result = new MarkupParser();
                result.factory = this;
            }
            else
            {
                result = parsers.pop();
            }
            result.target = target;
            return result;
        }
    }
}