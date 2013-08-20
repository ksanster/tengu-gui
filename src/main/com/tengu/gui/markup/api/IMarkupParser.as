package com.tengu.gui.markup.api
{
	public interface IMarkupParser
	{
		function set factory (value:IMarkupBuilderFactory):void;
		function get factory ():IMarkupBuilderFactory;
		
		function set target (value:IMarkable):void;
		function get target ():IMarkable;
		
		function parse (markup:XML):void;
		
		function getElementById (id:String):IMarkable;
		function addElement (id:String, element:IMarkable);
		
		function finalize ():void;
	}
}