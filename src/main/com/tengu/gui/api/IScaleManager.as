package com.tengu.gui.api
{
	public interface IScaleManager
	{
		function get scaleX ():Number;
		function get scaleY ():Number;
		function get scale ():Number;
		function get lodFactor ():Number;
		
		function setDefaultSize (width:uint, height:uint):void;
		function setScreenSize (width:uint, height:uint):void;
	}
}