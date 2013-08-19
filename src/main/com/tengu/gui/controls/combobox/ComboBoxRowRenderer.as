package com.tengu.gui.controls.combobox
{
	import com.tengu.gui.controls.text.Text;
	import com.tengu.gui.controls.list.components.BaseRenderer;
	import com.tengu.gui.controls.list.components.IBaseRenderer;
	
	public class ComboBoxRowRenderer extends BaseRenderer implements IBaseRenderer
	{
		private var label:Text = null;
		
		public override function set data(value:Object):void
		{
			super.data = value;
			label.text = String(value);
		}
		public function ComboBoxRowRenderer()
		{
			super();
		}
		
		protected override function createChildren():void
		{
			super.createChildren();
			mouseEnabled = false;
			mouseChildren = false;
			label = new Text("");
			addChild(label);
		}
		
		protected override function dispose():void
		{
			label.finalize();
			label = null;
			super.dispose();
		}
		
		public override function clear():void
		{
			label.text = "";
		}

	}
}