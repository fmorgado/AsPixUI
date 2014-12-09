package pixui.utils.layout {
	import flash.display.DisplayObject;
	
	public function fitSizeAll(objects:Vector.<DisplayObject>, width:Number, height:Number, left:Number = 0, top:Number = 0):void {
		var length:uint = objects.length;
		for (var index:uint = 0; index < length; index++)
			fitSize(objects[index], width, height, left, top);
	}
}