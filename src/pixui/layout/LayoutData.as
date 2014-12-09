package pixui.layout {
	
	/**
	 * The base class for layout data objects.
	 * @see pixui.views.View#layoutData
	 */
	public class LayoutData extends LayoutObject {
		//{ Constructor
		///////////////////////////////////////////////////////////////////////
		/**
		 * Constructor.
		 * @param  params  An object containing initial tween properties.
		 */
		public function LayoutData(params:Object = null) { super(params); }
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Properties
		///////////////////////////////////////////////////////////////////////
		protected var _minWidth:Number = NaN;
		/** The minimum width of the object, in pixels. @default NaN */
		public final function get minWidth():Number { return _minWidth; }
		public final function set minWidth(value:Number):void {
			if (value == _minWidth) return;
			_minWidth = value;
			invalidate();
		}
		
		protected var _maxWidth:Number = NaN;
		/** The maximum width of the object, in pixels. @default NaN */
		public final function get maxWidth():Number { return _maxWidth; }
		public final function set maxWidth(value:Number):void {
			if (value == _maxWidth) return;
			_maxWidth = value;
			invalidate();
		}
		
		protected var _minHeight:Number = NaN;
		/** The minimum height of the object, in pixels. @default NaN */
		public final function get minHeight():Number { return _minHeight; }
		public final function set minHeight(value:Number):void {
			if (value == _minHeight) return;
			_minHeight = value;
			invalidate();
		}
		
		protected var _maxHeight:Number = NaN;
		/** The maximum width of the object, in pixels. @default NaN */
		public final function get maxHeight():Number { return _maxHeight; }
		public final function set maxHeight(value:Number):void {
			if (value == _maxHeight) return;
			_maxHeight = value;
			invalidate();
		}
		
		protected var _preferredWidth:Number = NaN;
		/** The minimum height of the object, in pixels. @default NaN */
		public final function get preferredWidth():Number { return _preferredWidth; }
		public final function set preferredWidth(value:Number):void {
			if (value == _preferredWidth) return;
			_preferredWidth = value;
			invalidate();
		}
		
		protected var _preferredHeight:Number = NaN;
		/** The maximum width of the object, in pixels. @default NaN */
		public final function get preferredHeight():Number { return _preferredHeight; }
		public final function set preferredHeight(value:Number):void {
			if (value == _preferredHeight) return;
			_preferredHeight = value;
			invalidate();
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
	}
}