package render2d.core.shading 
{
	public class BackgroundShader extends AssemblerShader
	{
		public function BackgroundShader() 
		{
			vertexData = 
																					//Matrix3D cameraTransform = vc0;
																					//Matrix3D meshTransform = vc2;
									"mov	vt0 		va0						\n" //Vec2[] meshVertexData = mesh.vertexData;
								+	"mov	vt1.xy		vc0.zw					\n" //Vec2 cameraScale = cameraTransform.scale;
								+	"abs	vt1.y		vt1.y					\n"	//cameraScale.y = Math.abs(cameraScale.y);
								+	"mul	vt0.xy		vt0.xy		vt1.xy		\n" //meshVertexData.multipy(cameraScale);
								+	"mul	vt0.xy		vt0.xy		vc1.w		\n" //meshVertexData.multipy(cameraTransform.screenSpaceRatio);
								+	"mov	vt2			va1						\n" //Vec2[] uvData = mesh.uvData;
								+	"mov	vt3			vc0						\n" //Vec4[] cameraTransformBuffer = cameraTransform.clone();
								+	"mul	vt3 		vt3			vc2.zw		\n" //cameraTransformBuffer.multiplu(meshTransform.scale);
								+	"add	vt2 		vt2			vt3.xy		\n" //uvData.add(cameraTransform.position);
								+	"mov	v0	 		vt2						\n" //copy uvData to v1
								+	"mov	op			vt0						  ";//copy meshVertexData to output
								
			fragmentData = 			//anisotropic2x												 		//pixel(Vec2 position, TextureFillModel fillMode, TextureSampler sampler, MipMapSampler mipSampler, Number bias)
										"tex oc, v0, fs0 <ignoresampler>"//<2d,repeat,anisotropic4x,miplinear> \n" //Pixel pixel = texture.getPixelAt(fs0, TextureFillModel.WRAP, TextureSampler.LINEAR, MipMapSampler.LINEAR, -0.5
		}
	}
}