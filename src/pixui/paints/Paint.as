package pixui.paints {
	import flash.display.Graphics;
	
	public class Paint {
		
		/**
		 * Paints to the given graphics.
		 * @param  graphics  The <code>Graphics</code> instance to paint to.
		 * @param  width     The width of the painting.
		 * @param  height    The height of the painting.
		 */
		public function draw(graphics:Graphics, width:Number, height:Number):void {
			throw new Error('Method paint must be overriden!');
		}
		
	}
}