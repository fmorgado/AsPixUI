package pixui.utils.layout {
	import flash.display.DisplayObject;
	
	/**
	 * Measure the required height to layout given objects vertically.
	 * @param  objects  The object to layout.
	 * @param  gap      The vertical gap between objects, in pixels.
	 */
	public function measureLayoutY(objects:Vector.<DisplayObject>, gap:Number = 0):Number {
		var result:Number = 0;
		
		var length:uint = objects.length;
		for (var index:uint = 0; index < length; index++) {
			result += objects[index].height;
			result += gap;
		}
		
		if (length > 0)
			result -= gap;
		
		return result;
	}
}