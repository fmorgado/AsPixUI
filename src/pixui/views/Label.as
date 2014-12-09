package pixui.views {
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import pixlib.managers.StyleManager;
	
	public class Label extends TextField {
		
		/**
		 * Constructor.
		 * @param  text   An optional text.
		 */
		public function Label(text:String = null) {
			super();
			initialize();
			StyleManager.style(this);
			if (text != null)
				this.text = text;
		}
		
		/**
		 * Called on construction. Override this method to add adicional
		 * initialization. Always call <code>super.initialize()</code> at the
		 * top of the overriding method.
		 */
		protected function initialize():void {
			this.cacheAsBitmap = true;
			this.mouseEnabled = false;
			this.tabEnabled = false;
			this.autoSize = TextFieldAutoSize.LEFT;
			this.multiline = false;
		}
		
		/** Set the text format of the label. */
		public final function set textFormat(value:TextFormat):void {
			this.defaultTextFormat = value;
			this.text = this.text;
		}
		
		/**
		 * Move the view.
		 * @param  x  The new X coordinate.
		 * @param  y  The new Y coordinate.
		 */
		public function move(x:Number, y:Number):void {
			this.x = x;
			this.y = y;
		}
		
		private var _truncationPostfix:String = '...';
		public function get truncationPostfix():String { return _truncationPostfix; }
		public function set truncationPostfix(value:String):void {
			_truncationPostfix = value;
			text = _text;
		}
		
		private var _maxWidth:Number = NaN;
		public function get maxWidth():Number { return _maxWidth; }
		public function set maxWidth(value:Number):void {
			_maxWidth = value;
			text = _text;
		}
		
		private var _maxHeight:Number = NaN;
		public function get maxHeight():Number { return _maxHeight; }
		public function set maxHeight(value:Number):void {
			_maxHeight = value;
			text = _text;
		}
		
		private var _text:String = '';
		override public function get text():String { return _text; }
		override public function set text(value:String):void {
			_text = value;
			
			super.text = value;
			
			var length:int = value.length;
			if (value.length == 0) return;
			
			if (multiline) {
				if (! isNaN(_maxHeight) && height > _maxHeight) {
					do {
						length --;
						super.text = value.substr(0, length) + _truncationPostfix;
					} while (height > _maxHeight && numLines > 1);
				}
			} else {
				if (! isNaN(_maxWidth) && width > _maxWidth && value.length) {
					do {
						length --;
						super.text = value.substr(0, length) + _truncationPostfix;
					} while (width > _maxWidth && length > 0);
				}
			}
		}
		
	}
}