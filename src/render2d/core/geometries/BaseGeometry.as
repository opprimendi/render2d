package render2d.core.geometries 
{
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.VertexBuffer3D;
	import render2d.core.renderers.RenderSupport;
	
	public class BaseGeometry implements IGeometry
	{
		private var renderSupport:RenderSupport;
		public var vertexBuffer:VertexBuffer3D;
		public var indexBuffer:IndexBuffer3D;
		
		//public var id:int = Ident.next();
		
		public var numVertices:int;
		public var uvsCount:int;
		
		public var vertices:Vector.<Number>;
		public var indecis:Vector.<uint>;
		
		public var _init:Boolean;
		
		public var minX:Number = 0;
		public var maxX:Number = 0;
		public var minY:Number = 0;
		public var maxY:Number = 0;
		
		public var width:Number;
		public var height:Number;
		
		public var verticesCount:int = 0;
		public var trianglesCount:int = 0;
		
		public function BaseGeometry(trianglesCount:int = 0, verticesCount:int = 0, isStatic:Boolean = false) 
		{
			this.verticesCount = verticesCount;
			this.trianglesCount = trianglesCount;
			
			vertices = new Vector.<Number>(verticesCount * 4, isStatic);
			indecis = new Vector.<uint>(trianglesCount * 3, isStatic);
		}
		
		public function mapTriangle(v1:int, v2:int, v3:int):void
		{
			indecis.push(v1, v2, v3);
			trianglesCount++;
		}
		
		public function setTriangle(i:int, v1:int, v2:int, v3:int):void 
		{
			i *= 3;
			indecis[i] = v1;
			indecis[i + 1] = v2;
			indecis[i + 2] = v3;
			trianglesCount++;
		}
		
		public function addVertexAndUV(x:Number, y:Number, u:Number, v:Number):void
		{
			minX = Math.min(x, minX);
			maxX = Math.max(x, maxX);
			minY = Math.min(y, minY);
			maxY = Math.max(y, maxY);
			
			width = Math.abs(minX - maxX);
			height = Math.abs(minY - maxY);
			
			verticesCount += 2;
			uvsCount += 2;
			
			vertices.push(x, y, u, v);
		}
		
		public function setVertexAndUv(i:int, x:Number, y:Number, u:Number, v:Number):void
		{
			minX = Math.min(x, minX);
			maxX = Math.max(x, maxX);
			minY = Math.min(y, minY);
			maxY = Math.max(y, maxY);
			
			width = Math.abs(minX - maxX);
			height = Math.abs(minY - maxY);
			
			i *= 4;
			
			vertices[i] = x;
			vertices[i + 1] = y;
			vertices[i + 2] = u;
			vertices[i + 3] = v;
		}
		
		public function setVertex(i:int, x:Number, y:Number):void
		{
			minX = Math.min(x, minX);
			maxX = Math.max(x, maxX);
			minY = Math.min(y, minY);
			maxY = Math.max(y, maxY);
			
			width = Math.abs(minX - maxX);
			height = Math.abs(minY - maxY);
			
			vertices[i] = x;
			vertices[i + 1] = y;
		}
		
		public function addUVStride(x:Number, y:Number):void
		{
			var len:int = vertices.length;
			
			for (var i:int = 0; i < verticesCount; i+=4)
			{
				vertices[i + 2] += y;
				vertices[i + 3] += y;
			}
			
			updateUV();
		}
		
		public function setUV(i:int, u:Number, v:Number):void
		{
			vertices[i + 2] = u;
			vertices[i + 3] = v;
		}
		
		public function render(renderSupport:RenderSupport):void
		{
			if (!_init)
				init(renderSupport);
				
			setBuffers(renderSupport);
		}
		
		private function setBuffers(renderSupport:RenderSupport):void 
		{
			renderSupport.setVertexBufferAt(0, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
			renderSupport.setVertexBufferAt(1, vertexBuffer, 2, Context3DVertexBufferFormat.FLOAT_2);
		}
		
		public function updateUV():void
		{
			uploadVertexBuffer(verticesCount / 2);
		}
		
		public function uploadVertexBuffer(offset:int = 0, length:int = 0):void
		{
			if (!vertexBuffer)
				return;
				
			if (length == 0)
				length = numVertices;
			
			renderSupport.uploadVertexBuffer(vertexBuffer, vertices, offset, length);
		}
		
		public function uploadIndexBuffer(offset:int = 0, length:int = 0):void
		{
			if (!indexBuffer)
				return;
				
			if (length == 0)
				length = numVertices;
			
			renderSupport.uploadIndexBuffer(indexBuffer, indecis, offset, length);
		}
		
		private function init(renderSupport:RenderSupport):void 
		{
			_init = true;
			
			this.renderSupport = renderSupport;
			
			numVertices = vertices.length / 4;
			
			vertexBuffer = renderSupport.createVertexBuffer(numVertices, 4);
			indexBuffer = renderSupport.createIndexBuffer(indecis.length);
			
			uploadVertexBuffer(0, numVertices);
			uploadIndexBuffer(0, indecis.length);
		}
		
		public function dispose():void 
		{
			if (renderSupport)
			{
				renderSupport.disposeIndexBuffer(indexBuffer)
				renderSupport.disposeVertexBuffer(vertexBuffer)
			}
		}
	}

}