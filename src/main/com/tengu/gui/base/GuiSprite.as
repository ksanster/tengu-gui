package com.tengu.gui.base
{
    import com.tengu.core.funcs.removeAllChildren;
    import com.tengu.core.tengu_internal;
    import com.tengu.gui.api.IEventDispatcherEx;

    import flash.display.DisplayObject;
    import flash.display.Sprite;

    public class GUISprite extends Sprite implements IEventDispatcherEx
    {
        tengu_internal var finalized:Boolean = false;

        private var listeners:Object;
        private var captureListeners:Object;

        protected var guiMinWidth:uint  = 0;
        protected var guiMinHeight:uint = 0;

        public function get minWidth ():uint
        {
            return guiMinWidth;
        }

        public function set minWidth(value:uint):void
        {
            guiMinWidth = value;
        }

        public function get minHeight():uint
        {
            return guiMinHeight;
        }

        public function set minHeight(value:uint):void
        {
            guiMinHeight = value;
        }

        public function get displayWidth ():Number
        {
            return super.width;
        }

        public function get displayHeight ():Number
        {
            return super.height;
        }

        public override function set x (value:Number):void
        {
            super.x = Math.round(value);
        }

        public override function set y (value:Number):void
        {
            super.y = Math.round(value);
        }

        public function GUISprite ()
        {
            super();
            initialize();
        }

        protected function initialize ():void
        {
            listeners        = {};
            captureListeners = {};
        }

        //Служебный метод для удаления детей через removeAllChildren
        protected function disposeComponent (component:DisplayObject):void
        {
            if (component is GUISprite)
            {
                (component as GUISprite).finalize();
            }
        }

        protected function dispose ():void
        {
            unlistenAll();
            removeAllChildren(this, disposeComponent);
        }

        public final function listen(type:String, listener:Function,
                                     useCapture:Boolean = false,
                                     priority:int = 0,
                                     useWeakReference:Boolean = false):void
        {
            addEventListener(type, listener, useCapture, priority, useWeakReference);
            if (useWeakReference)
            {
                return;
            }
            const hash:Object = useCapture ? captureListeners : listeners;
            var list:Vector.<Function> = hash[type];
            if (list == null)
            {
                list = new <Function>[];
                hash[type] = list;
            }
            list[list.length] = listener;

        }

        public final function unlisten (type:String, listener:Function, useCapture:Boolean = false):void
        {
            var index:int;
            const hash:Object = useCapture ? captureListeners : listeners;
            const list:Vector.<Function> = hash[type];
            if (list == null)
            {
                return;
            }
            index = list.indexOf(listener);
            if (index != -1)
            {
                list.splice(index, 1);
            }
            removeEventListener(type, listener, useCapture);
        }

        public final function unlistenAll ():void
        {
            var list:Vector.<Function>;
            var eventType:String;
            var method:Function;

            for (eventType in listeners)
            {
                list = listeners[eventType];
                for each (method in list)
                {
                    removeEventListener(eventType, method);
                }
                list.length = 0;
            }
            listeners = {};

            for (eventType in captureListeners)
            {
                list = listeners[eventType];
                for each (method in list)
                {
                    removeEventListener(eventType, method, true);
                }
                list.length = 0;
            }
            captureListeners = {};
        }

        public final function finalize ():void
        {
            if (tengu_internal::finalized)
            {
                return;
            }
            tengu_internal::finalized = true;
            dispose();
        }
    }
}
