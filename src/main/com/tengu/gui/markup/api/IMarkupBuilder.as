package com.tengu.gui.markup.api
{
	public interface IMarkupBuilder
	{
		function build (markup:XML, parser:IMarkupParser, target:IMarkable = null):IMarkable;
	}
}