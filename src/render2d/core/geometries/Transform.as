package render2d.core.geometries 
{
	import render2d.utils.FastMath;
	public class Transform 
	{
		/**
		 * usaly 2 register
		 * 
		 * example
		 * 
		 * x,y,w,h - first register
		 * scaleX, scaleY, rotationX, rotationY - second register
		 */
		protected var _transformData:Vector.<Number> = new Vector.<Number>(8, true);
		
		public var x:Number = 0;
		public var y:Number = 0;
		
		public var scaleX:Number = 1;
		public var scaleY:Number = 1;
		
		protected var _rotation:Number = 0;
		
		public function Transform() 
		{
			identity();
		}
		
		public function set rotation(value:Number):void
		{
			_rotation = value;
		}
		
		public function get rotation():Number
		{
			return _rotation;
		}
		
		public function set transformData(value:Vector.<Number>):void
		{
			this._transformData = value
		}
		
		public function get transformData():Vector.<Number> 
		{
			_transformData[0] = x;
			_transformData[1] = y;
			
			_transformData[2] = scaleX;
			_transformData[3] = scaleY;
			
			_transformData[4] = Math.cos(FastMath.convertToRadian(_rotation));
			_transformData[5] = Math.sin(FastMath.convertToRadian(_rotation));
			
			return _transformData;
		}
		
		public function copyTransformTo(constantsVector:Vector.<Number>, registerIndex:int):void 
		{
			constantsVector[registerIndex++] = x;
			constantsVector[registerIndex++] = y;
			
			constantsVector[registerIndex++] = scaleX;
			constantsVector[registerIndex++] = scaleY;
			
			constantsVector[registerIndex++] = Math.cos(FastMath.convertToRadian(_rotation));
			constantsVector[registerIndex++] = Math.sin(FastMath.convertToRadian(_rotation));
		}
		
		public function identity():void 
		{
			//_transformData[0] = x;
			//_transformData[1] = y;
			
			//_transformData[2] = scaleX;
			//_transformData[3] = -scaleY;
			
			_transformData[4] = Math.cos(FastMath.convertToRadian(_rotation));
			_transformData[5] = Math.sin(FastMath.convertToRadian(_rotation));
			_transformData[6] = 0;
			
			_transformData[7] = 0;
		}
		
		public function toString():String 
		{
			return "[Transform transformData=" + transformData + " x=" + x + " y=" + y + " scaleX=" + scaleX + " scaleY=" + scaleY + 
						" rotationX=" + rotation + "]";
		}
	}

}