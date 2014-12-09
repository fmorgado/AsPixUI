package pixui.utils.layout {
	import flash.display.DisplayObject;
	
	public function alignXAll(objects:Vector.<DisplayObject>, width:Number, align:Number, left:Number = 0):void {
		var length:uint = objects.length;
		for (var index:uint = 0; index < length; index++)
			alignX(objects[index], width, align, left);
	}
}