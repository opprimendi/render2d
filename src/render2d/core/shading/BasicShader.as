package render2d.core.shading 
{
	import com.adobe.utils.AGALMiniAssembler;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Program3D;
	import flash.utils.ByteArray;
	
	public class BasicShader 
	{
		private var vertex:String;
		private var pixel:String;
		private var shaderCompiled:Program3D;
		
		public static var agal:AGALMiniAssembler = new AGALMiniAssembler();
		
		public function BasicShader() 
		{
			vertex = 
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
								
			pixel = 			//anisotropic2x												  //pixel(Vec2 position, TextureFillModel fillMode, TextureSampler sampler, MipMapSampler mipSampler, Number bias)
										"tex ft0, v0, fs0 <2d,repeat,anisotropic16x,miplinear,-0.5> \n" //Pixel pixel = texture.getPixelAt(fs0, TextureFillModel.WRAP, TextureSampler.LINEAR, MipMapSampler.LINEAR, -0.5
									+	"add ft0, v0, ft0 \n"
									+	"div ft0, v0, ft0 \n"
									+	"mov oc, ft0"
		}
		
		public function upload(context3D:Context3D):void
		{
			context3D.setProgram(shaderCompiled);
		}
		
		public function create(context3D:Context3D):void
		{
			var vertexCompiled:ByteArray = agal.assemble(Context3DProgramType.VERTEX, vertex);
			var fragmentCompiled:ByteArray = agal.assemble(Context3DProgramType.FRAGMENT, pixel);
			
			shaderCompiled = context3D.createProgram();
			shaderCompiled.upload(vertexCompiled, fragmentCompiled);
		}
	}

}