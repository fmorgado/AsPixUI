package pixui.utils.layout {
	import flash.display.DisplayObject;
	
	/**
	 * Align all objects to the vertical middle.
	 * @param  objects  The objects to align.
	 * @param  height   The available height.
	 * @param  top      The base Y coordinate. Default is 0.
	 */
	public function alignMiddleAll(objects:Vector.<DisplayObject>, height:Number, top:Number = 0):void {
		var length:uint = objects.length;
		for (var index:uint = 0; index < length; index++)
			alignMiddle(objects[index], height, top);
	}
}