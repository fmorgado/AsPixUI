package pixui.views {
	import flash.display.DisplayObject;
	
	public class Button extends ButtonBase {
		
		/**
		 * Constructor.
		 * @param  label  An optional label.
		 * @param  icon   An optional icon.
		 */
		public function Button(label:String = null, icon:* = null) {
			super();
			if (label != null) this.label = label;
			if (icon != null) this.icon = icon;
		}
		
		/** @inheritDoc */
		override protected function initialize():void {
			super.initialize();
			_labelInstance = new Label();
		}
		
		private var _icon:DisplayObject;
		/**
		 * Get or set the icon of the button. Supports a <code>Function</code>,
		 * a <code>Class</code> or an instance of <code>DisplayObject</code>.
		 * The getter always returns null or a display object, not
		 * necessarily the same value passed to the setter.
		 */
		public final function get icon():Object { return _icon; }
		public final function set icon(value:Object):void {
			// Clear previous icon
			if (_icon != null) {
				//this.removeLayoutElement(_icon);
				_icon = null;
			}
			
			// Create new icon
			if (value != null) {
				if (value is Function)
					value = value();
				if (value is Class)
					value = new value();
				if (! (value is DisplayObject))
					throw new ArgumentError('Not a display object:  ' + value);
				
				_icon = value as DisplayObject;
				//this.addLayoutElementAt(_icon, 0);
			}
			
			invalidateLayout();
		}
		
		private var _labelStyle:Function;
		public final function set labelStyle(value:Function):void {
			_labelStyle = value;
			if (_labelInstance != null && _labelStyle != null)
				_labelStyle(_labelInstance);
		}
		
		private var _labelInstance:Label;
		public final function get labelInstance():Label { return _labelInstance; }
		
		/** Get or set the label. */
		public final function get label():String { return _labelInstance.text; }
		public final function set label(value:String):void {
			if (value == '') {
				// Destroy field if necessary
				if (_labelInstance.parent != null) {
					//this.removeLayoutElement(_labelInstance);
				}
			} else {
				// Create field if necessary
				if (_labelInstance.parent == null) {
					//this.addLayoutElement(_labelInstance);
				}
				_labelInstance.text = value;
			}
		}
		
	}
}