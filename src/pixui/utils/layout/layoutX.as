package pixui.utils.layout {
	import flash.display.DisplayObject;
	
	/**
	 * Layout objects horizontally.
	 * @param  objects  The objects to layout.
	 * @param  gap      The horizontal gap between objects, in pixels.
	 * @param  left     The starting X coordinate.    
	 */
	public function layoutX(objects:Vector.<DisplayObject>, gap:Number = 0, left:Number = 0):void {
		var length:uint = objects.length;
		for (var index:uint = 0; index < length; index++) {
			var object:DisplayObject = objects[index];
			object.x = left;
			left += object.width + gap;
		}
	}
}