package pixui.utils.layout {
	import flash.display.DisplayObject;
	
	/**
	 * Align an object on the horizontal and vertical axes.
	 * @param  object  The object to align.
	 * @param  width   The available width.
	 * @param  height  The available height.
	 * @param  hAlign  The horizontal alignment. A value between 0 and 1.
	 * @param  vAlign  The vertical alignment. A value between 0 and 1.
	 * @param  left    The base X coordinate. Default is 0.
	 * @param  top     The base Y coordinate. Default is 0.
	 */
	public function alignXY(object:DisplayObject, width:Number, height:Number, hAlign:Number, vAlign:Number, left:Number = 0, top:Number = 0):void {
		alignX(object, width, hAlign, left);
		alignY(object, height, vAlign, top);
	}
}