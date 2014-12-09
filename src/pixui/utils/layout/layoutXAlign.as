package pixui.utils.layout {
	import flash.display.DisplayObject;
	
	/**
	 * Layout the objects horizontally, aligning the group within <code>width</code>.
	 * @param  objects  The objects to layout horizontally.
	 * @param  width    The available width.
	 * @param  gap      The horizontal gap between objects, in pixels.
	 * @param  align    The horizontal alignment of the group, a value between 0 and 1. @default 0.5
	 * @param  left     The base X coordinate. @default 0
	 */
	public function layoutXAlign(objects:Vector.<DisplayObject>, width:Number, gap:Number, align:Number = 0.5, left:Number = 0):void {
		var layoutWidth:Number = measureLayoutX(objects, gap);
		layoutX(objects, gap, Math.round((width - layoutWidth) * align) + left);
	}
}