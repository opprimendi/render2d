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
									
									//float xnew = p.x * c - p.y * s;
									//float ynew = p.x * s + p.y * c;
									
									//NOTE m3x3 or m4x4 possibly faster then that because m3x3 is 4 mul and 4 add. Current method is 5 mul and 3 add 
									//with camera its 6 mul and 4 add when m3x3 well be (mesh m3x3 camera m3x3 vertex)~~~~~
									
								+	"mov	vt2 		va0					    \n" //Vec2[] meshVertexDataTemp = mesh.vertexData;									
								+	"mul	vt2.x		vt2.x		vc3.x		\n" //meshVertexDataTemp.x *= meshTransform.rotationCos;							//rotate mesh x by mesh rotation
								+	"mul	vt2.y		vt2.y		vc3.y		\n" //meshVertexDataTemp.y *= meshTransform.rotationSin;							
								+	"sub	vt0.x		vt2.x		vt2.y		\n" //meshVertexData.x = meshVertexDataTemp.x - meshVertexDataTemp.y				
								
								
								+	"mov	vt2 		va0						\n" //Vec2[] meshVertexDataTemp = mesh.vertexData;									
								+	"mul	vt2.x		vt2.x		vc3.y		\n" //meshVertexDataTemp.x *= meshTransform.rotationSin;							//rotate mesh y by mesh rotation
								+	"mul	vt2.y		vt2.y		vc3.x		\n" //meshVertexDataTemp.y *= meshTransform.rotationCos;							
								+	"add	vt0.y		vt2.x		vt2.y		\n" //meshVertexData.y = meshVertexDataTemp.x + meshVertexDataTemp.y;				
								
								
								
								+	"mul	vt0.xy		vt0.xy		vc2.zw		\n" //meshVertexData.multipy(meshTransform.scale);									//add mesh scale
								
								+	"sub	vt0.xy		vt0.xy		vc0.xy		\n" //meshVertexData.sub(cameraTransform.position); 								//move relatively by camera
								
								+	"add	vt0.xy		vt0.xy		vc2.xy		\n" //meshVertexData.add(meshTransform.position);   								//add renderable position
								
								+	"mul	vt0.xy		vt0.xy		vc0.zw		\n" //meshVertexData.multipy(cameraScale);											//add camera scale
								
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