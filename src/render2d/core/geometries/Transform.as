package render2d.core.geometries 
{
	import render2d.utils.FastMath;
	public class Transform 
	{
		protected var _transformData:Vector.<Number> = new Vector.<Number>(8, true);
		
		public var x:Number = 0;
		public var y:Number = 0;
		
		public var scaleX:Number = 1;
		public var scaleY:Number = 1;
		
		protected var _rotationX:Number = 0;
		protected var _rotationY:Number = 0;
		protected var _rotationZ:Number = 0;
		
		public function Transform() 
		{
			identity();
		}
		
		public function set rotationX(value:Number):void
		{
			_rotationX = value;
		}
		
		public function get rotationX():Number
		{
			return _rotationX;
		}
		
		public function set rotationY(value:Number):void
		{
			_rotationY = value;
		}
		
		public function get rotationY():Number
		{
			return _rotationY;
		}
		
		public function set rotationZ(value:Number):void
		{
			_transformData[6] = value;
		}
		
		public function get rotationZ():Number
		{
			return _transformData[6];
		}
		
		public function set transformData(value:Vector.<Number>):void
		{
			this._transformData = value
		}
		
		public function get transformData():Vector.<Number> 
		{
			_transformData[0] = x;
			_transformData[1] = -y;
			
			_transformData[2] = scaleX;
			_transformData[3] = -scaleY;
			
			_transformData[4] = Math.cos(FastMath.convertToRadian(_rotationX));
			_transformData[5] = Math.sin(FastMath.convertToRadian(_rotationX));
			
			
			
			
			return _transformData;
		}
		
		public function copyTransformTo(constantsVector:Vector.<Number>, registerIndex:int):void 
		{
			constantsVector[registerIndex++] = x;
			constantsVector[registerIndex++] = -y;
			
			constantsVector[registerIndex++] = scaleX;
			constantsVector[registerIndex++] = -scaleY;
			
			constantsVector[registerIndex++] = Math.cos(FastMath.convertToRadian(_rotationX));
			constantsVector[registerIndex++] = Math.sin(FastMath.convertToRadian(_rotationX));
		}
		
		public function identity():void 
		{
			//_transformData[0] = x;
			//_transformData[1] = y;
			
			//_transformData[2] = scaleX;
			//_transformData[3] = -scaleY;
			
			_transformData[4] = 0;
			_transformData[5] = 0;
			_transformData[6] = 0;
			
			_transformData[7] = 0;
		}
		
		public function toString():String 
		{
			return "[Transform transformData=" + transformData + " x=" + x + " y=" + y + " scaleX=" + scaleX + " scaleY=" + scaleY + 
						" rotationX=" + rotationX + " rotationY=" + rotationY + " rotationZ=" + rotationZ + 
						"]";
		}
	}

}