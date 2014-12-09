package pixui.utils.layout {
	import flash.display.DisplayObject;
	
	/**
	 * Measure the required width to layout given objects horizontally.
	 * @param  objects  The object to layout.
	 * @param  gap      The horizontal gap between objects, in pixels.
	 */
	public function measureLayoutX(objects:Vector.<DisplayObject>, gap:Number = 0):Number {
		var result:Number = 0;
		
		var length:uint = objects.length;
		for (var index:uint = 0; index < length; index++) {
			result += objects[index].width;
			result += gap;
		}
		
		if (length > 0)
			result -= gap;
		
		return result;
	}
}