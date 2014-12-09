package pixui.utils.layout {
	import flash.display.DisplayObject;
	
	public function fitSize(object:DisplayObject, width:Number, height:Number, left:Number = 0, top:Number = 0):void {
		fitWidth(object, width, left);
		fitHeight(object, height, top);
	}
	
}