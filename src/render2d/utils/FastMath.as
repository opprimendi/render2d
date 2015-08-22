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
		
		[Inline]
		public static function convertToRadian(angle:Number):Number
		{
			return angle * Math.PI / 180;
		}
		
		[Inline]
		public static function convertToDegree(angle:Number):Number
		{
			return 180 * angle / Math.PI;
		}	
		
	}

}