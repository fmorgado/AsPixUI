package pixui.utils.layout {
	import flash.display.DisplayObject;
	
	/**
	 * Align an object to the vertical middle.
	 * @param  object  The object to align.
	 * @param  height  The available height.
	 * @param  top     The base Y coordinate. Default is 0.
	 */
	public function alignMiddle(object:DisplayObject, height:Number, top:Number = 0):void {
		object.y = Math.round((height - object.height) * 0.5 + top);
	}
}