package render2d.core.shading 
{
	public class BasicShader extends AssemblerShader
	{
		public function BasicShader() 
		{
			vertexData = 
																					//Matrix3D cameraTransform = vc0;
																					//Matrix3D meshTransform = vc2;
									"mov	vt0 		va0						\n" //Vec2[] meshVertexData = mesh.vertexData;
								+	"mul	vt0.xy		vt0.xy		vc2.zw		\n" //meshVertexData.multipy(meshTransform.scale);
								+	"sub	vt0.xy		vt0.xy		vc0.xy		\n" //meshVertexData.sub(cameraTransform.position);
								+	"add	vt0.xy		vt0.xy		vc2.xy		\n" //meshVertexData.add(meshTransform.position);
								+	"mov	vt1.xy		vc0.zw					\n" //Vec2 cameraScale = cameraTransform.scale;
								+	"abs	vt1.y		vt1.y					\n"	//cameraScale.y = Math.abs(cameraScale.y);
								+	"mul	vt0.xy		vt0.xy		vt1.xy		\n" //meshVertexData.multipy(cameraScale);
								+	"mul	vt0.xy		vt0.xy		vc1.w		\n" //meshVertexData.multipy(cameraTransform.screenSpaceRatio);
								+	"mov	v0, 		va1						\n" //copy uvData to v1
								+	"mov	op,			vt0						  ";//copy meshVertexData to output
								
			fragmentData = 			//anisotropic2x												 		//pixel(Vec2 position, TextureFillModel fillMode, TextureSampler sampler, MipMapSampler mipSampler, Number bias)
										"tex ft0, v0, fs0 <2d,repeat,anisotropic4x,miplinear> \n" //Pixel pixel = texture.getPixelAt(fs0, TextureFillModel.WRAP, TextureSampler.LINEAR, MipMapSampler.LINEAR, -0.5
									//+	"add ft0, v0, ft0 \n"
									//+	"div ft0, v0, ft0 \n"
									+	"sub ft0.xyz ft0.xyz fc0.www \n"
									+	"add ft0.xyz ft0.xyz fc0.xyz \n"
									+	"add ft0.xyz ft0.xyz fc0.xyz \n"
									+	"add ft0.xyz ft0.xyz fc0.xyz \n"
									
									+	"mov oc, ft0"
		}
	}
}