package pixui.utils.layout {
	import flash.display.DisplayObject;
	
	/**
	 * Align an object to the horizontal center.
	 * @param  object  The object to align.
	 * @param  width   The available width.
	 * @param  left    The base X coordinate. Default is 0.
	 */
	public function alignCenter(object:DisplayObject, width:Number, left:Number = 0):void {
		object.x = Math.round((width - object.width) * 0.5 + left);
	}
}