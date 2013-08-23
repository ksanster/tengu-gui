package com.tengu.gui.markup.builders
{
    import com.tengu.gui.base.GUIComponent;
    import com.tengu.gui.markup.api.IMarkable;
    import com.tengu.gui.markup.api.IMarkupBuilder;
    import com.tengu.gui.markup.api.IMarkupParser;
    import com.tengu.gui.markup.enum.MarkupProtocol;
    import com.tengu.log.LogFactory;

    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;

    import flash.events.IEventDispatcher;

    public class BaseMarkupBuilder implements IMarkupBuilder
    {
        public function BaseMarkupBuilder ()
        {
        }

        public function build (markup:XML, parser:IMarkupParser, target:IMarkable = null):IMarkable
        {
            var alias:String = String(markup.localName());

            if (target == null)
            {
                target = parser.factory.create(alias);
            }

            processChildren(markup, parser, target);
            processAttributes(markup, parser, target);

            return target;
        }

        protected final function processAttributes (node:XML, parser:IMarkupParser, target:IMarkable):void
        {
            const attributes:XMLList = node.attributes();
            var name:String;
            var value:*;

            if (target == null)
            {
                return;
            }

            for each (node in attributes)
            {
                name = String(node.localName());
                value = node.valueOf();
                if (!parseCustomTag(target, parser, name, value))
                {
                    if (!Object(target).hasOwnProperty(name))
                    {
                        LogFactory.getLogger(this).error("Property " + name + " not found in [" + target + "]");
                        continue;
                    }
                    target[name] = value;
                }
            }

        }

        protected final function processChildren (node:XML, parser:IMarkupParser, target:IMarkable):void
        {
            const children:XMLList = node.children();

            var node:XML;
            var name:String;
            var value:*;
            var id:String;
            var element:IMarkable;
            var builder:IMarkupBuilder;

            if (target == null)
            {
                return;
            }

            for each (node in children)
            {
                name = String(node.localName());
                value = node;

                if (parseCustomTag(target, parser, name, value))
                {
                    continue;
                }

                builder = parser.factory.getBuilderByAlias(name);
                if (builder == null)
                {
                    LogFactory.getLogger(this).error("Cannot parse tag <" + name + ">");
                    continue;
                }
                id = String(node.attribute(MarkupProtocol.ID));
                element = builder.build(node, parser);
                if (id != null)
                {
                    parser.addElement(id, element);
                }
                if (Object(target).hasOwnProperty(name))
                {
                    target[name] = element;
                }
                else if (element is DisplayObject && target is DisplayObjectContainer)
                {
                    (target as DisplayObjectContainer).addChild(element as DisplayObject);
                }
            }
        }

        protected function parseCustomTag (target:IMarkable, parser:IMarkupParser, tagName:String, tagValue:*):Boolean
        {
            //Abstract
            return false;
        }


    }
}
