package render2d.core.gl.shading 
{
	public class ShaderStd 
	{
		
		public static const SET_MESH_VERTEX_DATA:String = "mov	vt0	va0 \n";
		public static const SCREEN_SPACE_RATIO:String = "mul	vt0.xy vt0.xy vc1.zw \n";
		
	}

}