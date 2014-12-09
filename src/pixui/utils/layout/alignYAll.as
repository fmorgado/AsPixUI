package pixui.utils.layout {
	import flash.display.DisplayObject;
	
	public function alignYAll(objects:Vector.<DisplayObject>, height:Number, align:Number, top:Number = 0):void {
		var length:uint = objects.length;
		for (var index:uint = 0; index < length; index++)
			alignY(objects[index], height, align, top);
	}
}