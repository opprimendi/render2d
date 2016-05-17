package render2d.utils  
{
	import flash.geom.Matrix;
	
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
		
				/**
		 * То же саоме что matrix.concat() но в итоге не нужен клон матрици от исходной
		 * 
		 * @param	matrixA
		 * @param	matrixB
		 * @param	dest
		 */
		[Inline]
		public static function concatMatrices(matrixA:Matrix, matrixB:Matrix, dest:Matrix):void
		{
			var a:Number = matrixA.a * matrixB.a + matrixA.b * matrixB.c;
			var b:Number = matrixA.a * matrixB.b + matrixA.b * matrixB.d;
			
			var c:Number = matrixA.c * matrixB.a + matrixA.d * matrixB.c;
			var d:Number = matrixA.c * matrixB.b + matrixA.d * matrixB.d;
			
			var tx:Number = matrixA.tx * matrixB.a + matrixA.ty * matrixB.c + matrixB.tx;
			var ty:Number = matrixA.tx * matrixB.b + matrixA.ty * matrixB.d + matrixB.ty;
			
			dest.a = a;
			dest.b =  b;
			dest.c = c;
			dest.d = d;
			dest.tx = tx;
			dest.ty = ty;
		}
		
		
	}

}