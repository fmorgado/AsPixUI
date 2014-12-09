package pixui.utils.layout {
	import flash.display.DisplayObject;
	
	public function fitWidthAll(objects:Vector.<DisplayObject>, width:Number, left:Number = 0):void {
		var length:uint = objects.length;
		for (var index:uint = 0; index < length; index++)
			fitWidth(objects[index], width, left);
	}
}