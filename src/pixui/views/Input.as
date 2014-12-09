package pixui.views {
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	public class Input extends View {
		
		override protected function initialize():void {
			super.initialize();
			this.cacheAsBitmap = true;
			this.tabEnabled = false;
			
			const field:TextField = _textField = new TextField();
			field.cacheAsBitmap = true;
			field.multiline = false;
			field.type = TextFieldType.INPUT;
			this.addChild(field);
		}
		
		override protected function enabledChange():void {
			this.tabChildren = this.mouseChildren = _enabled;
		}
		
		protected var _textField:TextField;
		/** Get the text field. */
		public final function get textField():TextField { return _textField; }
		
		override protected function validateLayout():void {
			super.validateLayout();
			_textField.x = _left;
			_textField.y = _top;
			_textField.width = availableWidth;
			_textField.height = availableHeight;
		}
		
	}
}