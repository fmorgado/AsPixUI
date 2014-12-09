package pixui.utils.layout {
	import flash.display.DisplayObject;
	
	/**
	 * Align an object on the horizontal axis.
	 * @param  object  The object to align.
	 * @param  width   The available width.
	 * @param  align   The alignment. A value between 0 and 1.
	 * @param  left    The base X coordinate. Default is 0.
	 */
	public function alignX(object:DisplayObject, width:Number, align:Number, left:Number = 0):void {
		object.x = Math.round((width - object.width) * align + left);
	}
}