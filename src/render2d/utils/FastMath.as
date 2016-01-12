package render2d.utils  
{
	
	public class FastMath
	{	
		/**
		 * Return base logarifm of value e.g log(512, 2) Log2(512) - 9
		 * @param	value
		 * @param	base
		 * @return
		 */
		[Inline]
		public static function log(value:Number, base:Number):Number
		{
			return Math.log(value) / Math.log(base);
		}
		
		public static const ONE_DEGREE_IN_RADIANS:Number = Math.PI / 180;
		public static const ONE_RADIAN_IN_DEGREE:Number = 180 / Math.PI;
		
		[Inline]
		public static function convertToRadian(angle:Number):Number
		{
			return angle * ONE_DEGREE_IN_RADIANS;
		}
		
		[Inline]
		public static function convertToDegree(angle:Number):Number
		{
			return angle * ONE_RADIAN_IN_DEGREE;
		}	
		
		[Inline]
		public static function angle(x1:Number, y1:Number, x2:Number, y2:Number):Number
		{
			x1 = x2 - x1;
			y1 = y2 - y1;

			return Math.atan2(y1, x1) //+ Math.PI / 2;
        }
		
		public static function absNumber(n:Number):Number
		{
			return n < 0? -n:n;
		}
		
		public static function absInt(i:int):int
		{
			return i < 0? -i:i;
		}
		
		
	}

}