package pixui.utils.layout {
	import flash.display.DisplayObject;
	
	public function fitWidth(object:DisplayObject, width:Number, left:Number = 0):void {
		object.x = left;
		object.width = width;
	}
}