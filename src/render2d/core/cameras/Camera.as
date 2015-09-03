package render2d.core.cameras 
{
	import render2d.core.geometries.Transform;
	
	public class Camera extends Transform
	{
		private var _width:Number;
		private var _height:Number;
		
		private var halfWidth:Number;
		private var halfHeiight:Number;
		
		public function Camera() 
		{
			
		}
		
		public function configure(width:Number, height:Number):void
		{	
			_height = height;
			_width = width;
			
			halfWidth = width / 2;
			halfHeiight = height / 2;
			
			screenSpaceRatio = 1 / ((_width + _height) / 4);
			//aspectRatio = height / width;
		}
		
		public function get minX():Number
		{
			return x - halfWidth / scaleX;
		}
		
		public function get maxX():Number
		{
			return x + halfWidth / scaleX;
		}
		
		public function get minY():Number
		{
			return y - halfHeiight / scaleY;
		}
		
		public function get maxY():Number
		{
			return y + halfHeiight / scaleY;
		}
		
		public function get aspectRatio():Number 
		{
			return transformData[6];
		}
		
		public function set aspectRatio(value:Number):void 
		{
			transformData[6] = value;
		}
		
		public function get screenSpaceRatio():Number 
		{
			return transformData[7];
		}
		
		public function set screenSpaceRatio(value:Number):void 
		{
			transformData[7] = value;
		}
		
		public function get width():Number 
		{
			return _width;
		}
		
		public function get height():Number 
		{
			return _height;
		}
	}

}