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
    import com.tengu.gui.sample.SampleComponent;
    import com.tengu.gui.themes.SimpleTheme;
    import com.tengu.log.LogFactory;
    import com.tengu.log.targets.TraceTarget;

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

            LogFactory.addTarget(new TraceTarget());

            guiRoot = new GUIRoot();
            addChild(guiRoot);

            theme = new SimpleTheme();
            theme.addEventListener(Event.INIT, onThemeInit);
        }

        private function addSampleComponent ():void
        {

            var component:SampleComponent = new SampleComponent();
            guiRoot.addChild(component);
        }

        private function onThemeInit (event:Event):void
        {
            theme.removeEventListener(Event.INIT, onThemeInit);
            guiRoot.applyTheme(theme);

            addSampleComponent();
        }

        private function onAddedToStage (event:Event):void
        {
            removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            initialize();
        }
    }
}
