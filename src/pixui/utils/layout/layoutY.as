package pixui.utils.layout {
	import flash.display.DisplayObject;
	
	/**
	 * Layout objects vertically.
	 * @param  objects  The objects to layout.
	 * @param  gap      The vertical gap between objects, in pixels.
	 * @param  top      The starting Y coordinate.    
	 */
	public function layoutY(objects:Vector.<DisplayObject>, gap:Number = 0, top:Number = 0):void {
		var length:uint = objects.length;
		for (var index:uint = 0; index < length; index++) {
			var object:DisplayObject = objects[index];
			object.y = top;
			top += object.height + gap;
		}
	}
}