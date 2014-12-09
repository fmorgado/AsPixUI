package pixui.utils.layout {
	import flash.display.DisplayObject;
	
	/**
	 * Layout the objects vertically, aligning the group within <code>height</code>.
	 * @param  objects  The objects to layout vertically.
	 * @param  height   The available height.
	 * @param  gap      The vertical gap between objects, in pixels.
	 * @param  align    The vertical alignment of the group, a value between 0 and 1. @default 0.5
	 * @param  top      The base Y coordinate. @default 0
	 */
	public function layoutYAlign(objects:Vector.<DisplayObject>, height:Number, gap:Number, align:Number = 0.5, top:Number = 0):void {
		var layoutHeight:Number = measureLayoutY(objects, gap);
		layoutY(objects, gap, Math.round((height - layoutHeight) * align) + top);
	}
}