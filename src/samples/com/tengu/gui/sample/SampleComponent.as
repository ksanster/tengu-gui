/**
 * Created with IntelliJ IDEA.
 * User: a.semin
 * Date: 22.08.13
 * Time: 18:45
 * To change this template use File | Settings | File Templates.
 */
package com.tengu.gui.sample
{
    import com.tengu.gui.containers.VBox;
    import com.tengu.gui.enum.HorizontalAlign;
    import com.tengu.gui.enum.VerticalAlign;
    import com.tengu.gui.markup.api.IMarkupParser;

    import flash.events.MouseEvent;

    public class SampleComponent extends VBox
    {
        private static const markup:XML =
        <VBox   id="vbox"
                gap="10"
                hAlign={HorizontalAlign.CENTER}
                vAlign={VerticalAlign.MIDDLE}
                x="50" y="50"
                width="400" height="400">

            <Text text="label text"/>
            <Radio label="Радио1"/>
            <Button id="button1" label="button1" width="150" height="30">
                <events>
                    <event name={MouseEvent.CLICK} listener="onMouseClick" capture="false" priority="2" weak="false"/>
                </events>
            </Button>
            <HBox width="100%" height="200" style="filled">
                <ButtonGroup width="50%" height="100%" selectedIndex="-1">
                    <layout>
                        <VerticalLayout horizontalAlign="center" verticalAlign="top"/>
                    </layout>
                    <Radio id="radio1" label="Радио1"/>
                    <Radio id="radio2" label="Радио2" />
                    <Radio id="radio3" label="Радио3" />
                </ButtonGroup>
                <VBox width="50%" height="100%" style="filled" vAlign="middle">
                    <CheckBox label="Радио1" selected="true"/>
                </VBox>
            </HBox>

        </VBox>;

        private var parser:IMarkupParser;

        public function SampleComponent ()
        {
            super();
        }

        override protected function createChildren ():void
        {
            super.createChildren();

            textureManager.registerFloodFillTexture("fill", 0x00FFFF, .4);
            styleManager.registerStyle("filled", {background_fill: "fill"});

            parser = markupFactory.getParser(this);
            parser.parse(markup);
        }

        override protected function dispose ():void
        {
            parser.finalize();
            super.dispose();
        }

        public function onMouseClick(event:MouseEvent):void
        {
            trace("Click");
        }

    }
}
