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
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;

    public class BaseMarkupBuilder implements IMarkupBuilder
	{
		public function BaseMarkupBuilder()
		{
			//Empty
		}
		
		protected function parseCustomTag (target:IMarkable, parser:IMarkupParser, tagName:String, tagValue:*):Boolean
		{
            var component:GUIComponent;
            var value:String;
            if (tagName == MarkupProtocol.EVENTS)
            {
                addListeners(target, (tagValue as XML).children());
                return true;
            }
            if (tagName == MarkupProtocol.WIDTH)
            {
                component = target as GUIComponent;
                value = String(tagValue);
                if (value.charAt(value.length - 1) == "%")
                {
                    component.percentWidth = parseInt(value.substr(0, -1));
                }
                else
                {
                    component.width = parseInt(value);
                }
                return true;
            }
            if (tagName == MarkupProtocol.HEIGHT)
            {
                component = target as GUIComponent;
                value = String(tagValue);
                if (value.charAt(value.length - 1) == "%")
                {
                    component.percentHeight = parseInt(value.substr(0, -1));
                }
                else
                {
                    component.height = parseInt(value);
                }
                return true;
            }
			return false;
		}

        private function addListeners (target:IMarkable, nodes:XMLList):void
        {
            const dispatcher:IEventDispatcher = target as IEventDispatcher;
            var eventName:String;
            var methodName:String;
            if (dispatcher == null)
            {
                return;
            }
            for each (var node:XML in nodes)
            {
                eventName = String(node.@[MarkupProtocol.NAME]);
                methodName = String(node.@[MarkupProtocol.METHOD]);
                dispatcher.addEventListener(eventName, target[methodName]);
            }
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
				if (!Object(target).hasOwnProperty(name))
				{
					LogFactory.getLogger(this).error("Property " + name + " not found in [" + target + "]");
					continue;
				}
				if (!parseCustomTag(target, parser, name, value))
				{
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
				builder = parser.factory.getBuilderByAlias(name); 
				
				if (parseCustomTag(target, parser, name, value) || builder == null)
				{
					continue;
				}
				id = String(node.attribute("id"));
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
		
		public final function build(markup:XML, parser:IMarkupParser, target:IMarkable=null):IMarkable
		{
			var alias:String = String(markup.localName());
			
			if (target == null)
			{
				target = parser.factory.create(alias);
			}
			
			processAttributes(markup, parser, target);
			processChildren(markup, parser, target);
			
			return target;
		}
	}
}