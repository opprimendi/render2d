package render2d.core.geometries 
{
	/**
	 * ...
	 * @author Asfel
	 */
	public class Transform 
	{
		public var transformData:Vector.<Number> = new Vector.<Number>(8, true);
		
		public function Transform() 
		{
			identity();
		}
		
		public function set x(value:Number):void
		{
			transformData[0] = value;
		}
		
		public function get x():Number
		{
			return transformData[0];
		}
		
		public function set y(value:Number):void
		{
			transformData[1] = -value;
		}
		
		public function get y():Number
		{
			return -transformData[1];
		}
		
		public function set scaleX(value:Number):void
		{
			transformData[2] = value;
		}
		
		public function get scaleX():Number
		{
			return transformData[2];
		}
		
		public function set scaleY(value:Number):void
		{
			transformData[3] = -value;
		}
		
		public function get scaleY():Number
		{
			return -transformData[3];
		}
		
		public function set rotationX(value:Number):void
		{
			transformData[4] = value;
		}
		
		public function get rotationX():Number
		{
			return transformData[4];
		}
		
		public function set rotationY(value:Number):void
		{
			transformData[5] = value;
		}
		
		public function get rotationY():Number
		{
			return transformData[5];
		}
		
		public function set rotationZ(value:Number):void
		{
			transformData[6] = value;
		}
		
		public function get rotationZ():Number
		{
			return transformData[6];
		}
		
		public function identity():void 
		{
			transformData[0] = 0;
			transformData[1] = 0;
			
			transformData[2] = 1;
			transformData[3] = -1;
			
			transformData[4] = 0;
			transformData[5] = 0;
			transformData[6] = 0;
			
			transformData[7] = 0;
		}
		
		public function toString():String 
		{
			return "[Transform transformData=" + transformData + " x=" + x + " y=" + y + " scaleX=" + scaleX + " scaleY=" + scaleY + 
						" rotationX=" + rotationX + " rotationY=" + rotationY + " rotationZ=" + rotationZ + 
						"]";
		}
	}

}