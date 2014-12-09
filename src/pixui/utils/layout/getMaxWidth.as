package pixui.utils.layout {
	import flash.display.DisplayObject;
	
	public function getMaxWidth(objects:Vector.<DisplayObject>):Number {
		var result:Number = 0;
		var length:uint = objects.length;
		for (var index:uint = 0; index < length; index++) {
			var newWidth:Number = objects[index].width;
			if (newWidth > result) result = newWidth;
		}
		return result;
	}
}