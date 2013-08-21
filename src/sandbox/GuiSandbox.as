/**
 * Created with IntelliJ IDEA.
 * User: a.semin
 * Date: 21.08.13
 * Time: 11:24
 * To change this template use File | Settings | File Templates.
 */
package
{
    import com.tengu.gui.GUIRoot;
    import com.tengu.gui.enum.HorizontalAlign;
    import com.tengu.gui.enum.VerticalAlign;
    import com.tengu.gui.markup.MarkupBuilderFactory;
    import com.tengu.gui.markup.MarkupParser;
    import com.tengu.gui.markup.api.IMarkable;
    import com.tengu.gui.markup.api.IMarkupBuilderFactory;
    import com.tengu.gui.markup.api.IMarkupParser;
    import com.tengu.gui.themes.SimpleTheme;

    import flash.display.DisplayObject;

    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;

    [SWF(width="800", height="600", frameRate="24")]
    public class GuiSandbox extends Sprite
    {
        private var guiRoot:GUIRoot;
        private var theme:SimpleTheme;
        public function GuiSandbox ()
        {
            super();
            if (stage != null)
            {
                initialize();
            }
            else
            {
                addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            }
        }

        private function initialize ():void
        {
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;

            guiRoot = new GUIRoot();
            addChild(guiRoot);

            theme = new SimpleTheme();
            theme.addEventListener(Event.INIT, onThemeInit);
        }

        private function addSome ():void
        {
            const markup:XML =  <VBox   id="vbox"
                                        gap="10"
                                        hAlign={HorizontalAlign.CENTER} vAlign={VerticalAlign.MIDDLE}
                                        x="50" y="50"
                                        width="400" height="400">
                                    <Button id="button1" label="button1" width="150" height="30"/>
                                    <Button id="button2" label="button2" width="110" height="30"/>
                                </VBox>;

            const factory:IMarkupBuilderFactory = new MarkupBuilderFactory();
            const parser:IMarkupParser = new MarkupParser();
            parser.factory = factory;
            parser.target = factory.create(markup.localName());
            parser.parse(markup);

            addChild(parser.target as DisplayObject);
        }

        private function onThemeInit (event:Event):void
        {
            theme.removeEventListener(Event.INIT, onThemeInit);
            guiRoot.applyTheme(theme);

            addSome();
        }

        private function onAddedToStage (event:Event):void
        {
            removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            initialize();
        }
    }
}
