package pixui.utils.layout {
	import flash.display.DisplayObject;
	
	import pixui.utils.layout.ScalePolicy;
	import pixui.views.View;
	
	public function fitSizeWithPolicy(
		view:View,
		object:DisplayObject,
		scalePolicy:String,
		alignH:Number = 0.5,
		alignV:Number = 0.5,
		originalWidth:Number = NaN,
		originalHeight:Number = NaN
	):void {
		if (isNaN(originalWidth))
			originalWidth = object.width;
		if (isNaN(originalHeight))
			originalHeight = object.height;
		
		switch (scalePolicy) {
			case ScalePolicy.AUTOSIZE:
				object.x = view.left;
				object.y = view.top;
				object.width = originalWidth;
				object.height = originalHeight;
				view.setSize(originalWidth + view.left + view.right, originalHeight + view.top + view.bottom);
				break;
			
			case ScalePolicy.NONE:
				object.width = originalWidth;
				object.height = originalHeight;
				alignXY(object, view.availableWidth, view.availableHeight, alignH, alignV, view.left, view.top);
				break;
			
			case ScalePolicy.FILL:
				object.x = view.left;
				object.y = view.top;
				object.width = view.availableWidth;
				object.height = view.availableHeight;
				break;
			
			case ScalePolicy.INFERIOR_FIT:
				fitSizeInferior(object, view.availableWidth, view.availableHeight, view.left, view.top, alignH, alignV, originalWidth, originalHeight);
				break;
			
			case ScalePolicy.SUPERIOR_FIT:
				fitSizeSuperior(object, view.availableWidth, view.availableHeight, view.left, view.top, alignH, alignV, originalWidth, originalHeight);
				break;
			
			default:
				throw new Error('Invalid scalePolicy argument:  ' + scalePolicy);
		}
	}
}