package render2d.core.gl.shading 
{
	public class BasicShader extends AssemblerShader
	{
		public function BasicShader() 
		{
			super(StandarShders.BASIC_SHADER, ShaderVersion.V1);
			
			vertexData = 
																					//Matrix3D cameraTransform = vc0;
																					//Matrix3D meshTransform = vc2;
									ShaderStd.SET_MESH_VERTEX_DATA 					//Vec2[] meshVertexData = mesh.vertexData;
								
								//+	"mov	vt3			vc2						\n"
								//+	"mov	vt4			vc3						\n"
								
								//+	"mov	vt2			vt0						\n"
									
								//+	"dp3	vt2.x		vc0			vt3			\n"
								//+	"dp3	vt2.y		vc1			vt4			\n"
								
								+	"dp3	vt0.x		va0			vc2			\n"
								+	"dp3	vt0.y		va0			vc3			\n"
								
								+	"mov	v0, 		va1						\n" //copy uvData to v1
								+	"mov	op,			vt0						  ";//copy meshVertexData to output
								
			fragmentData = 			
										"tex ft0, v0, fs0 <ignoresampler>\n"
									
									//+	"sub ft0.xyz ft0.xyz fc0.www \n"
									//+	"add ft0.xyz ft0.xyz fc0.xyz \n"
									//+	"add ft0.xyz ft0.xyz fc0.xyz \n" //better way to coloring. for color mode multiply color to pixel for fill change pixel to color
									//+	"add ft0.xyz ft0.xyz fc0.xyz \n"
									
									+	"mov oc, ft0"
		}
	}
}