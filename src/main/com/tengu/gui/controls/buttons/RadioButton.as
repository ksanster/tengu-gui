/**
 * Created with IntelliJ IDEA.
 * User: a.semin
 * Date: 19.08.13
 * Time: 13:45
 * To change this template use File | Settings | File Templates.
 */
package com.tengu.gui.controls.buttons
{
    import com.tengu.gui.enum.HorizontalAlign;

    public class RadioButton extends IconButton
    {
        public function RadioButton ()
        {
            super();
        }

        override protected function createChildren ():void
        {
            super.createChildren();
            toggle = true;
            layout.horizontalAlign = HorizontalAlign.LEFT;
        }
    }
}
