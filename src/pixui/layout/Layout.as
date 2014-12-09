package pixui.layout {
	
	/**
	 * The base class for layout implementations.
	 * @see pixui.views.View#layout
	 */
	public class Layout extends LayoutObject {
		//{ Constructor
		///////////////////////////////////////////////////////////////////////
		/**
		 * Constructor.
		 * @param  params  An object containing initial tween properties.
		 */
		public function Layout(params:Object = null) { super(params); }
		///////////////////////////////////////////////////////////////////////
		//}
		
		//{ Properties
		///////////////////////////////////////////////////////////////////////
		protected var _defaultLayoutData:LayoutData;
		/** The layout data to use when an object does not have its own. @default null */
		public final function get defaultLayoutData():LayoutData { return _defaultLayoutData; }
		public final function set defaultLayoutData(value:LayoutData):void {
			if (value == _defaultLayoutData) return;
			_defaultLayoutData = value;
			invalidate();
		}
		
		protected var _ignoreChildLayoutData:Boolean = false;
		/** Indicates if objects layout data should be ignored. @default false */
		public final function get ignoreChildLayoutData():Boolean { return ignoreChildLayoutData; }
		public final function set ignoreChildLayoutData(value:Boolean):void {
			if (value == _ignoreChildLayoutData) return;
			_ignoreChildLayoutData = value;
			invalidate();
		}
		///////////////////////////////////////////////////////////////////////
		//}
		
	}
}