package render2d.core.materials 
{
	/**
	 * ...
	 * @author ...
	 */
	public class ColorBuffer 
	{
		public var buffer:Vector.<Number> = new Vector.<Number>(4, true);
		
		public function ColorBuffer() 
		{
			
		}
		
		public function setColor(color:uint):void
		{
			
		}
		
		public function isEqualToVecotr(vector:Vector.<Number>):Boolean
		{
			return !(buffer[0] != vector[0] || buffer[1] != vector[1] || buffer[2] != vector[2] || buffer[3] != vector[3]);
		}
		
		public function isEqual(color:ColorBuffer):Boolean
		{
			var colorBuffer:Vector.<Number> = color.buffer;
			return isEqualToVecotr(colorBuffer);
		}
		
		public function setFromColor(color:ColorBuffer):void
		{
			var colorBuffer:Vector.<Number> = color.buffer;
			buffer[0] = colorBuffer[0];
			buffer[1] = colorBuffer[1];
			buffer[2] = colorBuffer[2];
			buffer[3] = colorBuffer[3];
		}
		
		public function set a(value:Number):void
		{
			buffer[3] = value;
		}
		
		public function get a():Number
		{
			return buffer[3];
		}
		
		public function set r(value:Number):void
		{
			buffer[0] = value;
		}
		
		public function get r():Number
		{
			return buffer[0];
		}
		
		public function set g(value:Number):void
		{
			buffer[1] = value;
		}
		
		public function get g():Number
		{
			return buffer[1];
		}
		
		public function set b(value:Number):void
		{
			buffer[2] = value;
		}
		
		public function get b():Number
		{
			return buffer[2];
		}
		
		public function toString():String 
		{
			return "[ColorBuffer buffer=" + buffer + " a=" + a + " r=" + r + " g=" + g + " b=" + b + "]";
		}
	}

}