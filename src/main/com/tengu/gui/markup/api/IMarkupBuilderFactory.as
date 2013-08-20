package com.tengu.gui.markup.api
{
	public interface IMarkupBuilderFactory
	{
		function registerBuilder (builder:IMarkupBuilder, targetClass:Class, alias:String):void;
		
		function getBuilderByAlias (alias:String):IMarkupBuilder;
		
		function create (alias:String):IMarkable;
	}
}