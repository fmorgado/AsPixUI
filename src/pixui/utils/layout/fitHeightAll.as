package pixui.utils.layout {
	import flash.display.DisplayObject;
	
	public function fitHeightAll(objects:Vector.<DisplayObject>, height:Number, top:Number = 0):void {
		var length:uint = objects.length;
		for (var index:uint = 0; index < length; index++)
			fitHeight(objects[index], height, top);
	}
}