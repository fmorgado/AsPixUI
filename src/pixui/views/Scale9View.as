package pixui.views {
	import flash.display.DisplayObject;
	
	import pixlib.utils.resolvers.resolveInstanceOf;
	
	public class Scale9View extends View {
		
		private var _topLeft:DisplayObject;
		private var _topCenter:DisplayObject;
		private var _topRight:DisplayObject;
		private var _middleLeft:DisplayObject;
		private var _middleCenter:DisplayObject;
		private var _middleRight:DisplayObject;
		private var _bottomLeft:DisplayObject;
		private var _bottomCenter:DisplayObject;
		private var _bottomRight:DisplayObject;
		
		private var _w1:Number;
		private var _w2:Number;
		private var _h1:Number;
		private var _h2:Number;
		
		public function Scale9View(
			topLeft:Object,
			topCenter:Object,
			topRight:Object,
			middleLeft:Object,
			middleCenter:Object,
			middleRight:Object,
			bottomLeft:Object,
			bottomCenter:Object,
			bottomRight:Object
		) {
			_topLeft = resolveInstanceOf(topLeft, DisplayObject) as DisplayObject;
			_topCenter = resolveInstanceOf(topCenter, DisplayObject) as DisplayObject;
			_topRight = resolveInstanceOf(topRight, DisplayObject) as DisplayObject;
			_middleLeft = resolveInstanceOf(middleLeft, DisplayObject) as DisplayObject;
			_middleCenter = resolveInstanceOf(middleCenter, DisplayObject) as DisplayObject;
			_middleRight = resolveInstanceOf(middleRight, DisplayObject) as DisplayObject;
			_bottomLeft = resolveInstanceOf(bottomLeft, DisplayObject) as DisplayObject;
			_bottomCenter = resolveInstanceOf(bottomCenter, DisplayObject) as DisplayObject;
			_bottomRight = resolveInstanceOf(bottomRight, DisplayObject) as DisplayObject;
			super();
		}
		
		override protected function initialize():void {
			super.initialize();
			addChild(_topLeft);
			addChild(_topCenter);
			addChild(_topRight);
			addChild(_middleLeft);
			addChild(_middleCenter);
			addChild(_middleRight);
			addChild(_bottomLeft);
			addChild(_bottomCenter);
			addChild(_bottomRight);
			
			_w1 = _topLeft.width;
			_w2 = _topRight.width;
			_h1 = _topLeft.height;
			_h2 = _bottomLeft.height;
		}
		
		override protected function validateLayout():void {
			var leftWidth:Number;
			var centerWidth:Number;
			var rightWidth:Number;
			
			var topHeight:Number;
			var middleHeight:Number;
			var bottomHeight:Number;
			
			if (_w1 + _w2 <= _width) {
				leftWidth = _w1;
				rightWidth = _w2;
				centerWidth = _width - leftWidth - rightWidth;
				
				_topLeft.width = _middleLeft.width = _bottomLeft.width = leftWidth;
				_topRight.width = _middleCenter.width = _middleRight.width = rightWidth;
				
			} else {
				var ratio:Number = _w1 / _w2;
				leftWidth = _width * ratio;
				rightWidth = _width - leftWidth;
				centerWidth = 0;
				
				_topLeft.width = _middleLeft.width = _bottomLeft.width = leftWidth;
				_topRight.width = _middleCenter.width = _middleRight.width = rightWidth;
			}
			
			if (_h1 + _h2 <= _height) {
				topHeight = _h1;
				bottomHeight = _h2;
				middleHeight = _height - topHeight - bottomHeight;
				
				_topLeft.height = _topCenter.height = _topRight.height = topHeight;
				_bottomLeft.height = _bottomCenter.height = _bottomRight.height = bottomHeight;
				
			} else {
				var ratio2:Number = _w1 / _w2;
				topHeight = _height * ratio2;
				bottomHeight = _height - topHeight;
				middleHeight = 0;
				
				_topLeft.height = _topCenter.height = _topRight.height = topHeight;
				_bottomLeft.height = _bottomCenter.height = _bottomRight.height = bottomHeight;
			}
			
			_topCenter.x = _middleCenter.x = _bottomCenter.x = leftWidth;
			_topCenter.width = _middleCenter.width = _bottomCenter.width = centerWidth;
			_topRight.x = _middleRight.x = _bottomRight.x = _width - rightWidth;
			
			_middleLeft.y = _middleCenter.y = _middleRight.y = topHeight;
			_middleLeft.height = _middleCenter.height = _middleRight.height = middleHeight;
			_bottomLeft.y = _bottomCenter.y = _bottomRight.y = _height - bottomHeight;
		}
	}
}