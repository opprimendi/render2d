package render2d.core.shading 
{
	import com.adobe.utils.AGALMiniAssembler;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Program3D;
	import flash.utils.ByteArray;
	
	public class ScreenShader 
	{
		private var vertex:String;
		private var pixel:String;
		private var shaderCompiled:Program3D;
		
		public function ScreenShader() 
		{
			vertex = 
									"m44 vt0, va0, vc0\n"
								+	"mov op, vt0\n"
								+	"mov v0, va1\n"
								+	"mov v1, vt0";
								
			pixel = 
									
									"tex ft0, v0, fs0 <2d,linear>\n"
								+	"mov oc, ft0";
								//pixel = getFragmentCode();
								
			//pixel = getSqueez();
		
		}
		
		public var _fov:Number = 0;
		public static const DEGREES_TO_RADIANS:Number = Math.PI/180;
		protected function getFish():String
		{
			var code:String;
			var numSamples:int = 1;
			//phi = sqrt(x^2 + y^2)
			//x = sin(phi)*x/phi
			//y = sin(phi)*y/phi
			//z = cos(phi)
			code = 
				//"tex ft0, v0, fs0 <2d,anisotropic16x,miplinear> \n" + 
				"sub ft0.x, v0.x, fc0.z\n" + //x = (uu-0.5)
				"sub ft0.y, fc0.z, v0.y\n" + //y = (0.5-vv)
				"mul ft0.xy, ft0.xy, fc0.xy\n" + //(xy = xy*fov)
				"mul ft1.xy, ft0.xy, ft0.xy\n" + //xy = xy*xy
				"add ft1.z, ft1.x, ft1.y\n" + //z = x^2 + y^2
				"sqt ft1.z, ft1.z\n" + //phi = sqrt(z)
				"sin ft1.w, ft1.z\n" + //sinPhi = sin(phi)
				"div ft0.xy, ft0.xy, ft1.zz\n" + //xy = xy/phi
				"mul ft0.xy, ft0.xy, ft1.ww\n" + //xy = xy*sinPhi
				"cos ft0.z, ft1.z\n" + //z = cos(phi)
				"mov ft0.w, fc0.w\n" +
				"tex oc, ft0, fs0 <2d,anisotropic16x,miplinear>\n";
			
			return code;
		}
		
		
		private function getSqueez():String
		{
				'sub ft3, v1.y, fc1.y \n' //offset = 1-y
			+	'pow ft3, ft3, fc2 \n' //offset = offset^3
			+	'mul ft3, ft3.y, fc3 \n' //offset = sin(count)*offset
			+	'mul ft3, ft3, fc4 \n' //offset *= .3
			
			+	'mul ft3.xy, ft3.xy, v0.yx \n' //offset *= .3
			//+	'mul ft3.y, ft3.x, v0.x \n' //offset *= .3
			+	'mul ft3, ft3, fc4 \n' //offset *= .3
			+	'mul ft3, ft3, fc5 \n' //offset *= .3
			
			+	'add ft2, v1, ft3 \n' //texturePos.x += offset
			+	'tex ft1, ft2, fs0 <2d,anisotropic16x,linear,miplinear> \n' //pixel = texture(texturePos)
			+	'mov oc, ft1 \n' //return(pixel)
			
			return			"mov ft0, v0 \n"
						+	"mov ft1, v1 \n"
						+	"mov ft2, fc4 \n"
						
						+	"mul ft1.yx, ft1.yx, fc4.xxx \n"
						+	"cos ft1, ft1 \n"
						+	"mul ft1.xyz, ft1.xyz, fc3.xxx \n"
						+	"add ft0.x, ft0.x, ft1.y \n"
						
						
					
						//+	"mul ft0.y, ft1.y, ft0.y \n"
						+	" \n"
						+	"tex ft0, ft0, fs0 <2d,linear>\n"
						+	"mov oc, ft0";
						
						
		}
		
		protected function getBright():String
		{
			return "tex ft0, v0, fs0 <2d,linear>	\n" +
				"dp3 ft1.xyz, ft0.xyz, ft0.xyz	\n" +
				"sqt ft1.x, ft1.x				\n" +
				"sub ft1.y, ft1.x, fc0.x		\n" +
				//"mul ft1.y, ft1.y, fc0.y		\n" +
				//"sat ft1.y, ft1.y				\n" +
				"mul ft0.xyz, ft0.xyz, ft1.y	\n" +
				"mul ft0.xyz, ft0.xyz, ft1.y	\n" +
				"mov oc, ft0					\n";
		}
		
		protected function getFragmentCode():String
		{
			var code:String;
			var numSamples:int = 1;
			var _realStepSize:int = 1;
			var _amount:int = 5;
			
			code = 
						"mov ft0, v0	\n" 
					+	"sub ft0.x, v0.x, fc0.x\n";
			
			code += "tex ft1, ft0, fs0 <2d,linear>\n";
			
			if(true)
				for (var x:Number = _realStepSize; x <= _amount; x += _realStepSize) {
					code += "add ft0.x, ft0.x, fc0.y	\n" +
						"tex ft2, ft0, fs0 <2d,linear>\n" +
						"add ft1, ft1, ft2 \n";
					++numSamples;
				}
			
			code += "mul oc, ft1, fc0.z";
			//code += "mov oc, ft1";
			
			return code;
		}
		
		private var grassCount:Number = 0;
		public function upload(context3D:Context3D):void
		{
			context3D.setProgram(shaderCompiled);
			
			var _data:Vector.<Number> = new <Number>[0, 0, 0.5, 1]
			_data[0] = _fov*DEGREES_TO_RADIANS;
			_data[1] = _fov * DEGREES_TO_RADIANS;
			
			_data[0] = 	Math.sin(_fov);
			_data[1] =  Math.sin(_fov);
			_data[2] =  Math.sin(_fov);
			_data[3] =  Math.sin(_fov);
			
			//context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, _data);
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, Vector.<Number>([1, 1, 1, 10]));
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 2, Vector.<Number>([3, 3, 3, 3]));
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 3, Vector.<Number>([0.3, 0, 0, 0]))
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 4, Vector.<Number>([Math.sin(grassCount), 0, 0, 0]));
			grassCount = (grassCount + .01);// % (Math.PI * 5);
			
			
			 
			_fov+=0.01;
		}
		
		public function create(context3D:Context3D):void
		{
			var agal:AGALMiniAssembler = new AGALMiniAssembler();
			var vertexCompiled:ByteArray = agal.assemble(Context3DProgramType.VERTEX, vertex);
			var fragmentCompiled:ByteArray = agal.assemble(Context3DProgramType.FRAGMENT, pixel);
			
			shaderCompiled = context3D.createProgram();
			shaderCompiled.upload(vertexCompiled, fragmentCompiled);
		}
	}

}