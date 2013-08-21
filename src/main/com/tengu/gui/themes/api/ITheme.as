package com.tengu.gui.themes.api
{
	import flash.system.ApplicationDomain;

	public interface ITheme
	{
		function get fonts ():Vector.<Class>;
		function get css ():String;
		function get fills ():XML;
		
		function get library ():ApplicationDomain;
	}
}