package pixui.paints.styles {
	import flash.display.Graphics;
	
	public class Style {
		
		/** Constructor. */
		public function Style() {}
		
		/** Configures the given <code>Graphicsz</code> instance. */
		public function configure(graphics:Graphics):void {
			throw new Error('Method configure must be overriden!');
		}
		
	}
}