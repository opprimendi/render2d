package render2d.core.geometries 
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBufferUsage;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.VertexBuffer3D;
	
	public class BaseGeometry 
	{
		public var vertexBuffer:VertexBuffer3D;
		public var indexBuffer:IndexBuffer3D;
		
		public var id:int = Ident.next();
		
		public var numVertices:int;
		
		public var vertices:Vector.<Number> = new Vector.<Number>;
		public var indecis:Vector.<uint> = new Vector.<uint>;
		
		public var _init:Boolean;
		
		public var minX:Number = 0;
		public var maxX:Number = 0;
		public var minY:Number = 0;
		public var maxY:Number = 0;
		
		public function BaseGeometry() 
		{
			
		}
		
		public function mapTriangle(v1:int, v2:int, v3:int):void
		{
			indecis.push(v1, v2, v3);
		}
		
		public function addVertex(x:Number, y:Number, u:Number, v:Number):void
		{
			minX = Math.min(x, minX);
			maxX = Math.max(x, maxX);
			minY = Math.min(y, minY);
			maxY = Math.max(y, maxY);
			
			vertices.push(x, y, u, v);
		}
		
		public function render(context3D:Context3D):void
		{
			if (!_init)
				init(context3D);
				
			setBuffers(context3D);
		}
		
		private function setBuffers(context3D:Context3D):void 
		{
			context3D.setVertexBufferAt(0, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
			context3D.setVertexBufferAt(1, vertexBuffer, 2, Context3DVertexBufferFormat.FLOAT_2);
		}
		
		public function uploadVertexBuffer(offset:int = 0, length:int = 0):void
		{
			if (!vertexBuffer)
				return;
				
			if (length == 0)
				length = numVertices;
			
			vertexBuffer.uploadFromVector(vertices, offset, length);
		}
		
		public function uploadIndexBuffer(offset:int = 0, length:int = 0):void
		{
			if (!indexBuffer)
				return;
				
			if (length == 0)
				length = numVertices;
			
			indexBuffer.uploadFromVector(indecis, offset, length);
		}
		
		private function init(context3D:Context3D):void 
		{
			_init = true;
			
			numVertices = vertices.length / 4;
			
			vertexBuffer = context3D.createVertexBuffer(numVertices, 4);
			indexBuffer = context3D.createIndexBuffer(indecis.length);
			
			uploadVertexBuffer(0, numVertices);
			uploadIndexBuffer(0, indecis.length);
		}
	}

}