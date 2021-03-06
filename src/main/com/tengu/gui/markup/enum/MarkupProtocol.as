/**
 * Created with IntelliJ IDEA.
 * User: a.semin
 * Date: 21.08.13
 * Time: 17:34
 * To change this template use File | Settings | File Templates.
 */
package com.tengu.gui.markup.enum
{
    import com.tengu.core.errors.StaticClassConstructError;

    public class MarkupProtocol
    {
        public static const ID:String       = "id";
        public static const EVENTS:String   = "events";
        public static const LAYOUT:String   = "layout";
        public static const VERTICAL_ALIGN:String   = "vAlign";
        public static const HORIZONTAL_ALIGN:String = "hAlign";
        public static const GAP:String      = "gap";
        public static const WIDTH:String    = "width";
        public static const HEIGHT:String   = "height";
        public static const STYLE:String    = "style";

        public static const NAME:String                 = "name";
        public static const LISTENER:String             = "listener";
        public static const PRIORITY:String             = "priority";
        public static const USE_CAPTURE:String          = "capture";
        public static const USE_WEAK_REFERENCE:String   = "weak";
        public function MarkupProtocol ()
        {
            throw new StaticClassConstructError(this);
        }
    }
}
