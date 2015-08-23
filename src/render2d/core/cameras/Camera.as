package render2d.core.cameras 
{
	import render2d.core.geometries.Transform;
	
	public class Camera extends Transform
	{
		private var _width:Number;
		private var _height:Number;
		
		public function Camera() 
		{
			
		}
		
		public function configure(width:Number, height:Number):void
		{	
			_height = height;
			_width = width;
			
			screenSpaceRatio = 1 / ((_width + _height) / 4);
		}
		
		public function get minX():Number
		{
			return x - _width / 2;
		}
		
		public function get maxX():Number
		{
			return x + _width / 2;
		}
		
		public function get minY():Number
		{
			return y - _height / 2;
		}
		
		public function get maxY():Number
		{
			return y + _height / 2;
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