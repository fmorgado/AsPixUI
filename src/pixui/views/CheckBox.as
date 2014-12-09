package pixui.views {
	public class CheckBox extends Button {
		
		/**
		 * Constructor.
		 * @param  label  An optional label.
		 */
		public function CheckBox(label:String = null) {
			super(label, null);
		}
		
		/** @inheritDoc */
		override protected function initialize():void {
			super.initialize();
			selectable = true;
		}
		
	}
}