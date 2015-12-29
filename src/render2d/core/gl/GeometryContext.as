package render2d.core.gl 
{
	import flash.display3D.Context3D;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.VertexBuffer3D;
	import render2d.core.geometries.BaseGeometry;
	
	public class GeometryContext 
	{
		private var profile:Profile;
		private var context3D:Context3D;
		
		private var currentGeomery:BaseGeometry;
		
		
		public function GeometryContext(profile:Profile, context3D:Context3D) 
		{
			this.context3D = context3D;
			this.profile = profile;
			
			initialize();
		}
		
		private function initialize():void 
		{
			
		}
		
		public function setGeometry(geometry:BaseGeometry):void
		{
			if (currentGeomery == geometry)
				return;
				
			currentGeomery = geometry;
			currentGeomery.setToContext(this);
		}
		
		public function setVertexBufferAt(index:Number, buffer:VertexBuffer3D, bufferOffset:Number, format:String):void 
		{
			context3D.setVertexBufferAt(index, buffer, bufferOffset, format);
		}
		
		public function createIndexBuffer(length:int):IndexBuffer3D 
		{
			return context3D.createIndexBuffer(length);
		}
		
		public function createVertexBuffer(numVertices:int, data32PerVertex:Number):VertexBuffer3D 
		{
			return context3D.createVertexBuffer(numVertices, data32PerVertex);
		}
		
		public function disposeIndexBuffer(indexBuffer:IndexBuffer3D):void 
		{
			indexBuffer.dispose();
		}
		
		public function disposeVertexBuffer(vertexBuffer:VertexBuffer3D):void 
		{
			vertexBuffer.dispose();
		}
		
		public function uploadVertexBuffer(vertexBuffer:VertexBuffer3D, vertices:Vector.<Number>, offset:int, length:int):void 
		{
			vertexBuffer.uploadFromVector(vertices, offset, length);
		}
		
		public function uploadIndexBuffer(indexBuffer:IndexBuffer3D, indecis:Vector.<uint>, offset:int, length:int):void 
		{
			indexBuffer.uploadFromVector(indecis, offset, length);
		}
	}
}