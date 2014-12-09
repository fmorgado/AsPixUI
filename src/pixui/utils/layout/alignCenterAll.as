package pixui.utils.layout {
	import flash.display.DisplayObject;
	
	/**
	 * Align all objects to the horizontal center.
	 * @param  objects  The objects to align.
	 * @param  width    The available width.
	 * @param  left     The base X coordinate. Default is 0.
	 */
	public function alignCenterAll(objects:Vector.<DisplayObject>, width:Number, left:Number = 0):void {
		var length:uint = objects.length;
		for (var index:uint = 0; index < length; index++)
			alignCenter(objects[index], width, left);
	}
}