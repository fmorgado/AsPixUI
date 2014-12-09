package pixui.utils.layout {
	
	public class ScalePolicy {
		
		/** Indicates that the view must be resized to the size of the source. */
		public static const AUTOSIZE:String = 'autoSize';
		
		/** Indicates that the image must not be scaled. */
		public static const NONE:String = 'none';
		
		/** Indicates that the image must be scaled to the available size. */
		public static const FILL:String = 'fill';
		
		/** Indicates that the image must be scaled to fit inside the
		 *  available size, while maintaining the aspect ratio. */
		public static const INFERIOR_FIT:String = 'inferiorFit';
		
		/** Indicates that the image must be scaled in order to fill the
		 *  available size, while maintaining the aspect ratio. */
		public static const SUPERIOR_FIT:String = 'superiorFit';
		
	}
}