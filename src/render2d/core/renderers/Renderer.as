package render2d.core.renderers 
{
	import com.adobe.utils.AGALMacroAssembler;
	import com.adobe.utils.AGALMiniAssembler;
	import render2d.core.display.Mesh;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DStencilAction;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.Context3DTriangleFace;
	import flash.display3D.Program3D;
	import flash.display3D.textures.CubeTexture;
	import flash.display3D.textures.Texture;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	import render2d.core.primitives.PlanePrimitive;
	/**
	 * ...
	 * @author Asfel
	 */
	public class Renderer 
	{
		private var macroAsm:AGALMacroAssembler = new AGALMacroAssembler();
		private var miniAsm:AGALMiniAssembler = new AGALMiniAssembler();
		
		private var context3D:Context3D;
		public var displayList:DisplayList = new DisplayList();
		public var viewMatirx:Matrix3D;
		
		private var byMaterial:Vector.<Mesh> = new Vector.<Mesh>;
		
		private var vertexShader:ByteArray;
		private var fragmentShader:ByteArray;
		
		
		private var program:Program3D;
		
		public function Renderer(context3D:Context3D) 
		{
			this.context3D = context3D;
			
			renderTarget = context3D['createTexture'](1024, 1024, Context3DTextureFormat.BGRA, true);
			
			//helpMatrix.appendScale(0.5, 0.5, 1);
			
			var vertex:String = 
									"m44 vt0, va0, vc0\n"
								+	"m44 vt0, vt0, vc4\n"
								+	"mov vt1, vt0\n"
								+	"sin vt1.x, vt1.x\n"
								//+	"sin vt1.x, vt1.x\n"
								+	"mov op, vt1\n"
								+	"mov v0, va1\n"
								+	"mov v1, vt0"
								
			vertex =  "m44 vt1, va0, vc0\n"
					
					//+ "sin vt1.x, vt1.x\n"
					+ "mov op, vt1\n"
					+ "mov v1, vt1\n"
					+ "mov v0, va1"
			
			var fragment:String = 
									
									"tex ft0, v0, fs0 <2d,nearest>\n"
								+	"mov ft1, ft0\n"
								+	"add ft0, ft0, v1\n"
								+	"mul ft0, ft0, v1\n"
								
								+	"sub ft0, ft0, v1\n"
								+	"div ft0, ft0, v0\n"
								+	"mul ft0.x, ft0.x, ft0.x\n"
								
								
								
								
								//+	"mul ft0, v0, ft0\n"
								+	"mov oc, ft0"
									
			fragment = ''
						+ 'mov ft0, v0\n'
						+ 'mov ft1, v1\n'
						
						+ 'mov ft3, fc0\n'
						
						+ 'mul ft3, ft3 v1\n'
						
						+ 'sin ft3.x, ft3.x\n'
						//+ 'sin ft3.y, ft3.y\n'
						+ 'cos ft3.y, ft3.y\n'
						
						//+ 'nrm ft1.xyz, ft1\n'
						
						+ 'add ft0, ft0, ft3\n'
						
						+ 'tex ft0, ft0, fs0 <cube,clamp,miplinear,-0.1>\n'
						+ 'mul ft3, ft3, v1\n'
						+ 'add ft0, ft0, ft3\n'
						+ 'mov oc, ft0';
			//fragment = 'tex oc, v0, fs0 <2d,repeat,linear>';
						
			vertexShader = miniAsm.assemble(Context3DProgramType.VERTEX, vertex);
			fragmentShader = miniAsm.assemble(Context3DProgramType.FRAGMENT, fragment);
			
			program = context3D.createProgram();
			program.upload(vertexShader, fragmentShader);
			
			context3D.setProgram(program);
			context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 8, Vector.<Number>([1, 1, 1]));
		}
		
		public function add(mesh:Mesh):void 
		{
			displayList.add(mesh);
		}
		
		
		private var helpMatrix:Matrix3D = new Matrix3D();
		public var time:Number = 0.0;
		private var timeAdd:Number = 0.01;
		private var renderTarget:Texture;
		
		
		public function render():void
		{
			
			var t:Number = getTimer();
			
			
			
			context3D.setRenderToTexture(renderTarget);
			//context3D.clear(1,1,1);
			context3D.clear();// 1, 1, 1);
			
			
			//viewMatrix.appendRotation(1, Vector3D.Z_AXIS);
			context3D.setCulling(Context3DTriangleFace.NONE);
			context3D.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
			
			
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, Vector.<Number>([time, time, time, 0]));
			context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, viewMatirx, true);
			context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 4, helpMatrix, true);
			
			time += timeAdd;
			
			byMaterial = new Vector.<Mesh>;
			
			displayList.list[0].geometry.render(context3D);
			
			for (var i:int = 0; i < displayList.list.length; i++)
			{
				var meshToRender:Mesh = displayList.list[i];
				
				
				

				//trace("1", viewMatirx.rawData);
				//trace("2", meshToRender.transform.rawData);
				
				
				//context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 4, meshToRender.transform, true);
				
				context3D.drawTriangles(meshToRender.geometry.indexBuffer);
			}
			
			
			context3D.present();
			
			context3D.clear();
			
			
			var plane:PlanePrimitive = new PlanePrimitive();
			var planeMesh:Mesh = new Mesh(plane, null);
			
			plane.render(context3D);
			
			context3D.setCulling(Context3DTriangleFace.NONE);
			context3D.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
			
			context3D.setTextureAt(0, renderTarget);
			
			context3D.drawTriangles(planeMesh.geometry.indexBuffer);
			context3D.present();
			
			trace('render time: ' + (getTimer() - t));
			
			context3D.clear();
		}
		
		public function playback():void 
		{
			timeAdd *= -1;
		}
		
		public function reseTexture(texture:CubeTexture):void 
		{
			context3D.setTextureAt(0, texture);
		}
		
	}

}