package pixui.utils.layout {
	import flash.display.DisplayObject;
	
	public function fitHeight(object:DisplayObject, height:Number, top:Number = 0):void {
		object.y = top;
		object.height = height;
	}
}