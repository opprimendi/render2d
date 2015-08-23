package render2d.core.geometries 
{
	public class Transform 
	{
		protected var _transformData:Vector.<Number> = new Vector.<Number>(8, true);
		
		public var x:Number = 0;
		public var y:Number = 0;
		
		public var scaleX:Number = 1;
		public var scaleY:Number = 1;
		
		private var _rotationX:Number;
		private var _rotationY:Number;
		private var _rotationZ:Number;
		
		public function Transform() 
		{
			identity();
		}
		
		public function set rotationX(value:Number):void
		{
			_transformData[4] = value;
		}
		
		public function get rotationX():Number
		{
			return _transformData[4];
		}
		
		public function set rotationY(value:Number):void
		{
			_transformData[5] = value;
		}
		
		public function get rotationY():Number
		{
			return _transformData[5];
		}
		
		public function set rotationZ(value:Number):void
		{
			_transformData[6] = value;
		}
		
		public function get rotationZ():Number
		{
			return _transformData[6];
		}
		
		public function get transformData():Vector.<Number> 
		{
			_transformData[0] = x;
			_transformData[1] = -y;
			
			_transformData[2] = scaleX;
			_transformData[3] = -scaleY;
			
			return _transformData;
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