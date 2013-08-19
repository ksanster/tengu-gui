package com.tengu.gui.layouts
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	import com.tengu.gui.containers.GUIContainer;

	public class GroupsLayout extends BaseLayout
	{
		private var _groupsCount : uint = 0;
		private var _vertGap : Number = 0;
		public function GroupsLayout(groupsCount:uint)
		{
			super();
			this.groupsCount = groupsCount || 1;
		}
		
		//*** public ***//
		public function get groupsCount():uint
		{
			return _groupsCount;
		}

		public function set groupsCount(value:uint):void
		{
			_groupsCount = value;
		}
		
		public function get horGap():Number
		{
			return this.gap;
		}
		
		public function set horGap(value : Number):void
		{
			this.gap = value;
		}
		
		public function set vertGap(value : Number):void
		{
			_vertGap = value;
		}
		
		public override function arrange(target:GUIContainer):Rectangle
		{
			var index:int = 0;
			var i:uint = 0;
			var x:int = paddingLeft;
			var y:int = paddingTop;
			
			var count:uint = target.numChildren;  
			var itemsInGroup:uint = Math.ceil( count / groupsCount);
			
			if (count == 0)
			{
				return bounds;
			}
			
			var clip:DisplayObject =  target.getChildAt(0);
			var cellWidth:int = clip.width;
			var cellHeight:int = clip.height;
			
			bounds = new Rectangle();
			
			for (i = 0; i < count; i++)
			{
				clip = target.getChildAt(i);
				clip.x = x;
				clip.y = y;
				
				bounds = bounds.union(new Rectangle(x, y, clip.width, clip.height));
				
				y += cellHeight;
				y += _vertGap;
				
				index++;
				
				if (index == itemsInGroup)
				{
					index = 0;
					y  = paddingTop;
					x += cellWidth;
					x += gap;
				}
			}
			
			//bounds.width = target.displayWidth;
			//bounds.height = target.displayHeight;
			return bounds;
		}
	}
}