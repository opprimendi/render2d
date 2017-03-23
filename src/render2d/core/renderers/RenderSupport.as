package render2d.core.renderers 
{
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DMipFilter;
	import flash.display3D.Context3DProfile;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTextureFilter;
	import flash.display3D.Context3DWrapMode;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Program3D;
	import flash.display3D.textures.TextureBase;
	import flash.display3D.VertexBuffer3D;
	import flash.geom.Matrix3D;
	import flash.utils.ByteArray;
	import render2d.core.cameras.Camera;
	import render2d.core.display.BlendMode;
	import render2d.core.display.Renderable;
	import render2d.core.geometries.BaseGeometry;
	import render2d.core.materials.BaseMaterial;
	import render2d.core.renderers.debug.RendererDebugData;
	import render2d.core.shading.AbstractShader;
	
	public class RenderSupport 
	{
		private var fragmentColorBuffer:Vector.<Number> = new Vector.<Number>(4, true);
		public var currentFragmentColorBuffer:Vector.<Number> = new Vector.<Number>(4, true);
		
		private var _blendMode:BlendMode = BlendMode.NORMAL;
		
		public var rendererDebugData:RendererDebugData = new RendererDebugData();
		
		private var maxVertexBuffers:int = 4096;
		private var maxIndexBuffers:int = 4096;
		private var maxProgram:int = 4096;
		private var maxTextures:int = 4096;
		
		public static var maxVertexConstants:int = 128;
		public static var maxFragmentConstants:int = 28;
		static public var maxAgalVersion:int = 1;
		
		public var freeVertexConstants:int = 0;
		public var freeFragmentConstants:int = 0;
		
		private var usedConstantsBuffer:Vector.<int> = new Vector.<int>;
		
		private var context3D:Context3D;
		
		private var currentGeometry:BaseGeometry;
		private var currentMaterial:BaseMaterial;
		private var currentTexture:TextureBase;
		private var currentProgram:Program3D;
		
		private var _camera:Camera;
		
		private var samplerData:SamplerData;
		
		public function RenderSupport(context3D:Context3D) 
		{
			this.context3D = context3D;
			
			setSamplerStateAt(0, new SamplerData());
			
			rendererDebugData.profile = context3D.profile;
			rendererDebugData.driver = context3D.driverInfo;
			
			if (context3D.profile == Context3DProfile.BASELINE)
			{
				maxVertexConstants = 128;
				maxFragmentConstants = 28;
				maxAgalVersion = 1;
			}
			else if (context3D.profile == Context3DProfile.STANDARD_CONSTRAINED || context3D.profile == Context3DProfile.STANDARD)
			{
				maxVertexConstants = 250;
				maxFragmentConstants = 64;
				maxAgalVersion = 1;
			}
			
			freeVertexConstants = maxVertexConstants;
			freeFragmentConstants = maxFragmentConstants;
		}
		
		public function set enableErrorChecking(value:Boolean):void
		{
			context3D.enableErrorChecking = value;
		}
		
		public function get camera():Camera 
		{
			return _camera;
		}
		
		public function set camera(value:Camera):void 
		{
			_camera = value;
		}
		
		public function drawRenderable(renderable:Renderable):void
		{
			var material:BaseMaterial = renderable.material;
			var texture:TextureBase = material? material.texture:null;
			var geom:BaseGeometry = renderable.geometry;
			
			//trace('draw renderable', renderable);
			
			//trace('draw renderable');
			setSamplerStateAt(0, renderable.samplerData);
			
			setShader(renderable.shader);
			setBlendMode(renderable.blendMode);
			
			//rendererDebugData.materialsUsed = 1;
			//rendererDebugData.geometriesCount = 1;
			
			//trace(material.texture, renderable);
			
			if (material && material.texture != null && (currentMaterial == null || currentMaterial.texture != material.texture))
				setMaterial(material);
				
			if (currentGeometry != geom)
				setGeometry(geom);
				
			rendererDebugData.verticesCount += geom.verticesCount;
			rendererDebugData.trianglesCount += geom.trianglesCount;
			
			//setProgramConstantsFromVector(Context3DProgramType.VERTEX, 2, renderable.transformData, 2);
			
			if (renderable.material && renderable.material.useColor)
			{
				fragmentColorBuffer[0] = renderable.material.r;
				fragmentColorBuffer[1] = renderable.material.g;
				fragmentColorBuffer[2] = renderable.material.b;
				fragmentColorBuffer[3] = renderable.material.a;
			}
			else
			{
				fragmentColorBuffer[0] = 0;
				fragmentColorBuffer[1] = 0;
				fragmentColorBuffer[2] = 0;
				fragmentColorBuffer[3] = 0;
			}
			
			if (fragmentColorBuffer[0] != currentFragmentColorBuffer[0] || fragmentColorBuffer[1] != currentFragmentColorBuffer[1] || 
					fragmentColorBuffer[2] != currentFragmentColorBuffer[2] || fragmentColorBuffer[3] != currentFragmentColorBuffer[3])
					{
						currentFragmentColorBuffer[0] = fragmentColorBuffer[0];
						currentFragmentColorBuffer[1] = fragmentColorBuffer[1];
						currentFragmentColorBuffer[2] = fragmentColorBuffer[2];
						currentFragmentColorBuffer[3] = fragmentColorBuffer[3];
						
						setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, fragmentColorBuffer, 1);
					}
				
			drawTriangles(geom.indexBuffer);
		}
		
		public function setBlendMode(value:BlendMode):void
		{
			if (_blendMode == value)
				return;
				
			rendererDebugData.stateChanges++;
			_blendMode = value;
			_blendMode.applyBlendMode(context3D);
		}
		
		private function setSamplerStateAt(samplerIndex:int, newSamplerData:SamplerData):void 
		{
			if (newSamplerData == null)
				return;
			
			if (samplerData == null || !SamplerData.isEqual(samplerData, newSamplerData))
			{
				//trace('set sampler state', newSamplerData);
				this.samplerData = newSamplerData;
				context3D.setSamplerStateAt(samplerIndex, samplerData.wrapMode, samplerData.filter, samplerData.mipFilter);
				rendererDebugData.stateChanges++;
				//trace("setSamplerStateAt");
			}
		}
		
		private function setGeometry(geom:BaseGeometry):void 
		{
			//trace('set geometry');
			rendererDebugData.geometriesCount++;
			currentGeometry = geom;
			geom.render(this);
		}
		
		public function setMaterial(material:BaseMaterial):void
		{
			//trace('set material');
			currentMaterial = material;
			material.render(context3D);
			
			//CONFIG::debug
			//{
				rendererDebugData.materialsUsed++;
			//}
		}
		
		public function drawTriangles(indexBuffer:IndexBuffer3D, firstIndex:int=0, numTriangles:int=-1):void
		{
			context3D.drawTriangles(indexBuffer, firstIndex, numTriangles);
			
			//freeFragmentConstants = maxFragmentConstants;
			//freeVertexConstants = maxVertexConstants;
			
			//CONFIG::debug
			//{
				rendererDebugData.drawCalls++;
			//}
		}
		
		public function present():void
		{
			//trace('present');
			if(camera)
				setProgramConstantsFromVector(Context3DProgramType.VERTEX, 0, camera.transformData, 2);
			
			context3D.present();
			//trace('-----present-----');
		}
		
		public function clear():void
		{
			//context3D.setColorMask(0, 0, 0, 1);
			
			context3D.clear(0, 0, 0, 0);
			rendererDebugData.clear();
			
			freeVertexConstants = maxVertexConstants;
			freeFragmentConstants = maxFragmentConstants;
		}
		
		public function setProgramConstantsFromMatrix(programType:String, firstRegister:int, matrix:Matrix3D, transposed:Boolean):void
		{
			var numRegisters:int = 16;
			
			if (programType == Context3DProgramType.VERTEX)
			{
				freeVertexConstants -= numRegisters;
			}
			else
			{
				maxFragmentConstants -= numRegisters;
			}
			
			rendererDebugData.stateChanges++;
			
			context3D.setProgramConstantsFromMatrix(programType, firstRegister, matrix, transposed);
		}
		
		public function setProgramConstantsFromVector(programType:String, firstRegister:int, data:Vector.<Number>, numRegisters:int = -1):void
		{
			if (numRegisters == -1)
				numRegisters = data.length / 4;
			
			//usedConstantsBuffer
			
			if (programType == Context3DProgramType.VERTEX)
			{
				freeVertexConstants -= numRegisters;
			}
			else
			{
				maxFragmentConstants -= numRegisters;
			}
			
			rendererDebugData.stateChanges++;
			//trace("setProgramConstantsFromVector", programType);
			context3D.setProgramConstantsFromVector(programType, firstRegister, data, numRegisters);
		}
		
		public function createVertexBuffer(numVertices:int, dataPerVertex:int):VertexBuffer3D 
		{
			rendererDebugData.vertexBuffersCreated++;
			return context3D.createVertexBuffer(numVertices, dataPerVertex);
		}
		
		public function createIndexBuffer(length:int):IndexBuffer3D 
		{
			rendererDebugData.indexBuffersCreated++;
			return context3D.createIndexBuffer(length);
		}
		
		public function uploadVertexBufferFromByteArray(vertexBuffer:VertexBuffer3D, vertices:ByteArray, offset:int, length:int):void 
		{
			rendererDebugData.vertexBuffersUpload++;
			rendererDebugData.stateChanges++;
			
			trace(vertices.bytesAvailable);
			var k:int = 0;
			for (var i:int = 0; i < vertices.length; )
			{
				trace(k, vertices[i++], vertices[i++], vertices[i++], vertices[i++]);
				k++;
			}
			
			trace("II", i, length);
			
			
			vertexBuffer.uploadFromByteArray(vertices, 0, offset, length);
		}
		
		public function uploadVertexBuffer(vertexBuffer:VertexBuffer3D, vertices:Vector.<Number>, offset:int, length:int):void 
		{
			rendererDebugData.vertexBuffersUpload++;
			rendererDebugData.stateChanges++;
			
			vertexBuffer.uploadFromVector(vertices, offset, length);
		}
		
		public function uploadIndexBuffer(indexBuffer:IndexBuffer3D, indecis:Vector.<uint>, offset:int, length:int):void 
		{
			rendererDebugData.indexBuffersUpload++;
			rendererDebugData.stateChanges++;
			//trace("uploadIndexBuffer");
			indexBuffer.uploadFromVector(indecis, offset, length);
		}
		
		public function setVertexBufferAt(index:int, vertexBuffer:VertexBuffer3D, offset:int, format:String):void 
		{
			rendererDebugData.stateChanges++;
			//trace("setVertexBufferAt", index);
			context3D.setVertexBufferAt(index, vertexBuffer, offset, format);
		}
		
		public function upload(program:Program3D, compiledVertexData:ByteArray, compiledFragmentData:ByteArray):void 
		{
			rendererDebugData.programUploaded++;
			program.upload(compiledVertexData, compiledFragmentData);
		}
		
		public function createProgram():Program3D 
		{
			rendererDebugData.programCreated++;
			return context3D.createProgram();
		}
		
		public function setShader(shader:AbstractShader):void
		{
			if (shader == null)
				return;
				
			setProgram(shader.program);
		}
		
		public function setProgram(program:Program3D):void 
		{
			if (currentProgram == program)
				return;
				
			currentProgram = program;
			rendererDebugData.stateChanges++;
			//trace("setProgram");
			context3D.setProgram(program);
		}
		
		public function disposeIndexBuffer(indexBuffer:IndexBuffer3D):void 
		{
			indexBuffer.dispose();
			rendererDebugData.indexBuffersCreated--;
		}
		
		public function disposeVertexBuffer(vertexBuffer:VertexBuffer3D):void 
		{
			vertexBuffer.dispose();
			rendererDebugData.vertexBuffersCreated--;
		}
		
		public function drawToBitmap(bitmapData:BitmapData):void 
		{
			context3D.drawToBitmapData(bitmapData);
		}
		
	}

}