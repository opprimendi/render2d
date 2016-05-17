package render2d.core.cameras 
{
	import render2d.core.geometries.Transform;
	
	public class Camera extends Transform
	{
		private var _width:Number;
		private var _height:Number;
		
		private var halfWidth:Number;
		private var halfHeiight:Number;
		
		public var projection:Projection = new Projection();
		
		public function Camera() 
		{
			
		}
		
		public function configure(width:Number, height:Number):void
		{	
			projection.configure(width, height);
			
			this.scaleX = projection.scaleX;
			this.scaleY = projection.scaleY;
			
			_height = height;
			_width = width;
			
			halfWidth = width / 2;
			halfHeiight = height / 2;
		}
		
		public function copyTransformTo(constantsVector:Vector.<Number>, registerIndex:int):void 
		{
			constantsVector[registerIndex++] = x;
			constantsVector[registerIndex++] = y;
			
			constantsVector[registerIndex++] = projection.scaleX * scaleX;
			constantsVector[registerIndex++] = projection.scaleY * scaleY;
			
			constantsVector[registerIndex++] = 0;
			constantsVector[registerIndex++] = 0;
			
			constantsVector[registerIndex++] = 0;//projection.scaleX;
			constantsVector[registerIndex++] = 0;//projection.scaleY;
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