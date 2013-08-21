package com.tengu.gui.markup
{
	import com.tengu.gui.markup.api.IMarkable;
	import com.tengu.gui.markup.api.IMarkupBuilder;
	import com.tengu.gui.markup.api.IMarkupBuilderFactory;
	import com.tengu.gui.markup.api.IMarkupParser;
	import com.tengu.log.LogFactory;
	
	public class MarkupParser implements IMarkupParser
	{
		private var builderFactory:IMarkupBuilderFactory;
		private var parserTarget:IMarkable;
		
		private var elementsById:Object;
		
		public function set factory(value:IMarkupBuilderFactory):void
		{
			builderFactory = value;
		}
		
		public function get factory():IMarkupBuilderFactory 
		{
			return builderFactory;
		}
		
		public function set target(value:IMarkable):void
		{
			parserTarget = value;
		}
		
		public function get target():IMarkable
		{
			return parserTarget;
		}
		
		public function MarkupParser()
		{
			elementsById = {};
		}
		
		public function parse (markup:XML):void
		{
			var alias:String = String(markup.localName());
			var childBuilder:IMarkupBuilder
			var builder:IMarkupBuilder = builderFactory.getBuilderByAlias(alias);
			var children:XMLList = markup.children();
			
			builder.build(markup, this, target);
		}
		
		public function addElement(id:String, element:IMarkable):void
		{
			elementsById[id] = element;
		}
		
		public function getElementById(id:String):IMarkable
		{
			if (elementsById[id] == null)
			{
				LogFactory.getLogger(this).error("Element not found. id=", id);
			}
			return elementsById[id];
		}
		
		public function finalize():void
		{
			elementsById = null;
			target = null;
			builderFactory = null;
		}
	}
}