package pixui.utils.layout {
	import flash.display.DisplayObject;
	
	public function fitSizeInferior(object:DisplayObject, width:Number, height:Number,
									left:Number = 0, top:Number = 0,
									alignH:Number = 0.5, alignV:Number = 0.5,
									originalWidth:Number = NaN, originalHeight:Number = NaN):void {
		if (isNaN(originalWidth))
			originalWidth = object.width;
		if (isNaN(originalHeight))
			originalHeight = object.height;
		
		var originalRatio:Number = originalWidth / originalHeight;
		
		if (width / originalWidth < height / originalHeight) {
			object.width = width;
			object.height = width / originalRatio;
		} else {
			object.height = height;
			object.width = height * originalRatio;
		}
		
		alignXY(object, width, height, alignH, alignV, left, top);
	}
}