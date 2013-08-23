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

    public class ComponentBuilder extends BaseMarkupBuilder implements IMarkupBuilder
	{
		public function ComponentBuilder()
		{
			//Empty
		}
		
		protected override function parseCustomTag (target:IMarkable, parser:IMarkupParser, tagName:String, tagValue:*):Boolean
		{
            var component:GUIComponent;
            var value:String;
            if (tagName == MarkupProtocol.ID)
            {
                return true;
            }
            if (tagName == MarkupProtocol.STYLE)
            {
                target[tagName] = String(tagValue);
                return true;
            }
            if (tagName == MarkupProtocol.EVENTS)
            {
                addListeners(target as IEventDispatcher, parser.target, (tagValue as XML).children());
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
			return super.parseCustomTag(target, parser, tagName, tagValue);
		}

        private function addListeners (dispatcher:IEventDispatcher, target:IMarkable, nodes:XMLList):void
        {
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
	}
}