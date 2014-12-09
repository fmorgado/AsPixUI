package pixui.utils.layout {
	import flash.display.DisplayObject;
	
	public function getMaxHeight(objects:Vector.<DisplayObject>):Number {
		var result:Number = 0;
		var length:uint = objects.length;
		for (var index:uint = 0; index < length; index++) {
			var newHeight:Number = objects[index].height;
			if (newHeight > result) result = newHeight;
		}
		return result;
	}
}