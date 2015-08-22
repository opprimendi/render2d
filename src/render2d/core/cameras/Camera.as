package render2d.core.cameras 
{
	import render2d.core.geometries.Transform;
	
	public class Camera extends Transform
	{
		public function Camera() 
		{
			
		}
		
		public function get screenSpaceRatio():Number 
		{
			return transformData[7];
		}
		
		public function set screenSpaceRatio(value:Number):void 
		{
			transformData[7] = value;
		}
	}

}