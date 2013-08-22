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

            <Button id="button1" label="button1" width="150" height="30"/>

        </VBox>;
//                <HBox width="100%" height="200">
//                    <RadioGroup width="50%" height="100%" selectedIndex="0">
//                        <Radio id="radio1" label="Радио1"/>
//                        <Radio id="radio2" label="Радио2" />
//                        <Radio id="radio3" label="Радио3" />
//                    </RadioGroup>
//                    <VBox width="50%" height="100%" gap="5"
//                    hAlign="left" vAlign={VerticalAlign.MIDDLE}
//                    paddingLeft="5">
//                        <CheckBox id="checkbox1" label="Чекбокс1" selected="true"/>
//                        <CheckBox id="checkbox2" label="Чекбокс2" />
//                        <CheckBox id="checkbox3" label="Чекбокс3" />
//                    </VBox>
//                </HBox>

        private var parser:IMarkupParser;

        public function SampleComponent ()
        {
            super();
        }

        override protected function createChildren ():void
        {
            super.createChildren();
            parser = markupFactory.getParser(this);
            parser.parse(markup);
        }

        override protected function dispose ():void
        {
            parser.finalize();
            super.dispose();
        }

        private function onMouseOver(event:MouseEvent):void
        {
            trace("MouseOver");
        }

        private function onMouseClick(event:MouseEvent):void
        {
            trace("Click");
        }

    }
}
