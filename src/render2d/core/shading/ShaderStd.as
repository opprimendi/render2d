package render2d.core.shading 
{
	/**
	 * ...
	 * @author Asfel
	 */
	public class ShaderStd 
	{
		
		public static const SET_MESH_VERTEX_DATA:String = "mov	vt0	va0 \n";
		public static const CREEN_SPACE_RATIO:String = "mul	vt0.xy vt0.xy vc1.zw \n";
		
	}

}