package render2d.core.cameras 
{
	/**
	 * ...
	 * @author ...
	 */
	public class Projection 
	{
		private var width:Number;
		private var height:Number;
		
		public var scaleX:Number = 1;
		public var scaleY:Number = 1;
		
		public function Projection(width:Number = 800, height:Number = 600) 
		{
			this.height = height;
			this.width = width;
			
			calculateProjection();
		}
		
		public function configure(width:Number, height:Number):void
		{
			this.height = height;
			this.width = width;
			
			calculateProjection();
		}
		
		private function calculateProjection():void 
		{
			scaleX =  2.0 / width;
			scaleY =  2.0 / height;
		}
	}
}