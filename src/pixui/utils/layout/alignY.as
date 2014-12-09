package pixui.utils.layout {
	import flash.display.DisplayObject;
	
	/**
	 * Align an object on the vertical axis.
	 * @param  object  The object to align.
	 * @param  height  The available height.
	 * @param  align   The alignment. A value between 0 and 1.
	 * @param  top     The base Y coordinate. Default is 0.
	 */
	public function alignY(object:DisplayObject, height:Number, align:Number, top:Number = 0):void {
		object.y = Math.round((height - object.height) * align + top);
	}
}