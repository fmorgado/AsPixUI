package pixui.utils.layout {
	import flash.display.DisplayObject;
	
	/**
	 * Align an object to the horizontal center and vertical middle.
	 * @param  object  The object to align.
	 * @param  width   The available width.
	 * @param  height  The available height.
	 * @param  left    The base X coordinate. Default is 0.
	 * @param  top     The base Y coordinate. Default is 0.
	 */
	public function alignCenterMiddle(object:DisplayObject, width:Number, height:Number, left:Number = 0, top:Number = 0):void {
		alignCenter(object, width, left);
		alignMiddle(object, height, top);
	}
}