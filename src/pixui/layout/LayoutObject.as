package pixui.layout {
	import pixlib.utils.Dispatcher;
	
	public class LayoutObject extends Dispatcher {
		
		//{ Constructor & Initialization
		///////////////////////////////////////////////////////////////////////
		/**
		 * Constructor.
		 * @param  params  An object containing initial tween properties.
		 */
		public function LayoutObject(params:Object = null) {
			initialize();
			if (params != null) _parseParams(params);
		}
		
		/**
		 * This method is called on construction, before parameters are parsed.
		 * Override this to initialize the object.
		 */
		protected function initialize():void {}
		
		private function _parseParams(params:Object):void {
			var onChange:Function;
			
			for (var key:String in params) {
				switch (key) {
					case 'onInvalidate':
						onChange = params[key];
						break;
					default:
						this[key] = params[key];
				}
			}
			
			// Add listener after parameters parsing so it doesn't get called.
			if (onChange != null)
				addInvalidateListener(onChange);
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Properties
		///////////////////////////////////////////////////////////////////////
		protected var _left:Number = 0;
		/** The left padding, in pixels. */
		public final function get left():Number { return _left; }
		public final function set left(value:Number):void {
			if (value == _left) return;
			_left = value;
			invalidate();
		}
		
		protected var _top:Number = 0;
		/** The top padding, in pixels. */
		public final function get top():Number { return _top; }
		public final function set top(value:Number):void {
			if (value == _top) return;
			_top = value;
			invalidate();
		}
		
		protected var _right:Number = 0;
		/** The right padding, in pixels. */
		public final function get right():Number { return _right; }
		public final function set right(value:Number):void {
			if (value == _right) return;
			_right = value;
			invalidate();
		}
		
		protected var _bottom:Number = 0;
		/** The bottom padding, in pixels. */
		public final function get bottom():Number { return _bottom; }
		public final function set bottom(value:Number):void {
			if (value == _bottom) return;
			_bottom = value;
			invalidate();
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Invalidation Handling
		///////////////////////////////////////////////////////////////////////
		protected var _isInvalid:Boolean = false;
		/** Indicates if the layout is invalid. */
		public final function get isInvalid():Boolean { return _isInvalid; }
		
		/** Invalidate the layout, if it's not already invalid. */
		public final function invalidate():void {
			if (! _isInvalid) {
				_isInvalid = true;
				dispatchInvalidate();
			}
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Events / Listeners Handling
		///////////////////////////////////////////////////////////////////////
		/** The event type used when the layout is invalidated. */
		public static const INVALIDATE:String = 'change';
		
		/** Dispatch the <code>INVALIDATE</code> event. The argument to listeners is <code>this</code>. */
		protected final function dispatchInvalidate():void {
			dispatch(INVALIDATE, this);
		}
		
		/**
		 * Add a listener for the <code>CHANGE</code> event.
		 * @param  listener  The listener to add.
		 */
		public final function addInvalidateListener(listener:Function):void {
			this.addListener(INVALIDATE, listener);
		}
		/**
		 * Remove a listener for the <code>CHANGE</code> event.
		 * @param  listener  The listener to remove.
		 */
		public final function removeInvalidateListener(listener:Function):void {
			this.removeListener(INVALIDATE, listener);
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
	}
}