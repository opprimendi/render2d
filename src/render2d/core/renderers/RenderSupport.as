package render2d.core.renderers 
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Program3D;
	import flash.display3D.textures.TextureBase;
	import flash.display3D.VertexBuffer3D;
	import flash.utils.ByteArray;
	import render2d.core.display.Renderable;
	import render2d.core.geometries.BaseGeometry;
	import render2d.core.materials.BaseMaterial;
	import render2d.core.renderers.debug.RendererDebugData;
	
	public class RenderSupport 
	{
		public var rendererDebugData:RendererDebugData = new RendererDebugData();
		
		public var maxVertexConstants:int = 128;
		public var maxFragmentConstants:int = 30;
		
		public var freeVertexConstants:int = 0;
		public var freeFragmentConstants:int = 0;
		
		private var usedConstantsBuffer:Vector.<int> = new Vector.<int>;
		
		private var context3D:Context3D;
		
		private var currentGeometry:BaseGeometry;
		private var currentMaterial:BaseMaterial;
		private var currentTexture:TextureBase;
		private var currentProgram:Program3D;
		
		public function RenderSupport(context3D:Context3D) 
		{
			this.context3D = context3D;
			
			freeVertexConstants = maxVertexConstants;
			freeFragmentConstants = maxFragmentConstants;
		}
		
		public function drawRenderable(renderable:Renderable):void
		{
			var material:BaseMaterial = renderable.material;
			var texture:TextureBase = material.texture;
			var geom:BaseGeometry = renderable.geometry;
			
			if (currentMaterial == null || currentMaterial.texture != material.texture)
				setMaterial(material);
				
			if (currentGeometry != geom)
				setGeometry(geom);
				
			rendererDebugData.verticesCount += geom.verticesCount;
			rendererDebugData.trianglesCount += geom.trianglesCount;
			
			setProgramConstantsFromVector(Context3DProgramType.VERTEX, 2, renderable.transformData, 2);
				
			drawTriangles(geom.indexBuffer);
		}
		
		private function setGeometry(geom:BaseGeometry):void 
		{
			rendererDebugData.geometriesCount++;
			currentGeometry = geom;
			geom.render(this);
		}
		
		public function setMaterial(material:BaseMaterial):void
		{
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
			
			freeFragmentConstants = maxFragmentConstants;
			freeVertexConstants = maxVertexConstants;
			
			//CONFIG::debug
			//{
				rendererDebugData.drawCalls++;
			//}
		}
		
		public function present():void
		{
			context3D.present();
		}
		
		public function clear():void
		{
			context3D.clear();
			rendererDebugData.clear();
			
			freeVertexConstants = maxVertexConstants;
			freeFragmentConstants = maxFragmentConstants;
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
			
			indexBuffer.uploadFromVector(indecis, offset, length);
		}
		
		public function setVertexBufferAt(index:int, vertexBuffer:VertexBuffer3D, offset:int, format:String):void 
		{
			rendererDebugData.stateChanges++;
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
		
		public function setProgram(program:Program3D):void 
		{
			rendererDebugData.stateChanges++;
			context3D.setProgram(program);
		}
		
	}

}