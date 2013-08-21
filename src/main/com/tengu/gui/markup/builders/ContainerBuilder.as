/**
 * Created with IntelliJ IDEA.
 * User: a.semin
 * Date: 21.08.13
 * Time: 13:36
 * To change this template use File | Settings | File Templates.
 */
package com.tengu.gui.markup.builders
{
    import com.tengu.gui.containers.GUIContainer;
    import com.tengu.gui.layouts.ILayout;
    import com.tengu.gui.markup.api.IMarkable;
    import com.tengu.gui.markup.api.IMarkupBuilder;
    import com.tengu.gui.markup.api.IMarkupParser;
    import com.tengu.gui.markup.enum.MarkupProtocol;

    public class ContainerBuilder extends BaseMarkupBuilder
    {
        public function ContainerBuilder ()
        {
            super();
        }

        protected override function parseCustomTag (target:IMarkable, parser:IMarkupParser, tagName:String, tagValue:*):Boolean
        {
            const container:GUIContainer = target as GUIContainer;
            if (tagName == MarkupProtocol.LAYOUT)
            {
                createLayout(target, parser, (tagValue as XML).children()[0]);
                return true;
            }
            if (tagName == MarkupProtocol.VERTICAL_ALIGN)
            {
                container.layout.verticalAlign = tagValue;
                return true;
            }
            if (tagName == MarkupProtocol.HORIZONTAL_ALIGN)
            {
                container.layout.horizontalAlign = tagValue;
                return true;
            }
            if (tagName == MarkupProtocol.GAP)
            {
                container.layout.gap = tagValue;
                return true;
            }
            return super.parseCustomTag(target, parser, tagName, tagValue);
        }

        private function createLayout (target:IMarkable, parser:IMarkupParser, node:XML):void
        {
            const container:GUIContainer = target as GUIContainer;
            const alias:String = String(node.localName());
            const builder:IMarkupBuilder = parser.factory.getBuilderByAlias(alias);

            container.layout = builder.build(node, parser) as ILayout;
        }

    }
}
