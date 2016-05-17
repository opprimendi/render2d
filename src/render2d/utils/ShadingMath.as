package render2d.utils 
{
	import flash.geom.Vector3D;
	/**
	 * ...
	 * @author ...
	 */
	public class ShadingMath 
	{
		
		public function ShadingMath() 
		{
			
		}
		
		private static const TEMP_VECTOR3D:Vector3D = new Vector3D();
		
		public static function dp3(a:Vector3D, b:Vector3D):Number
		{
			return a.x * b.x + a.y * b.y + a.z + b.z;
		}
		
		public static function m3x2(output:Vector3D, vector:Vector3D, matrix:Vector.<Number>):void
		{
			TEMP_VECTOR3D.setTo(matrix[0], matrix[1], matrix[2]);
			output.x = dp3(vector, TEMP_VECTOR3D);
			
			TEMP_VECTOR3D.setTo(matrix[3], matrix[4], matrix[5]);
			output.y = dp3(vector, TEMP_VECTOR3D);
		}
	}

}