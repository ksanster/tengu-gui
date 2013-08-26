/**
 * Created with IntelliJ IDEA.
 * User: a.semin
 * Date: 26.08.13
 * Time: 14:02
 * To change this template use File | Settings | File Templates.
 */
package com.tengu.gui.api
{
    import flash.events.IEventDispatcher;

    public interface IEventDispatcherEx extends IEventDispatcher
    {
        function listen(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void;
        function unlisten (type:String, listener:Function, useCapture:Boolean = false):void;
        function unlistenAll ():void;

    }
}
