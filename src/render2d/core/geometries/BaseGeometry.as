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
		
		/**
		 * Map vertices indices to triangle
		 * @param	v1 - vertex index #1
		 * @param	v2 - vertex index #2
		 * @param	v3 - vertex index #3
		 */
		public function mapTriangle(v1:int, v2:int, v3:int):void
		{
			indecis.push(v1, v2, v3);
			trianglesCount++;
		}
		
		/**
		 * Update specified triangle vertices indices
		 * @param	i - index of triangle
		 * @param	v1 - vertex index #1
		 * @param	v2 - vertex index #2
		 * @param	v3 - vertex index #3
		 */
		public function updateTriangleMap(i:int, v1:int, v2:int, v3:int):void 
		{
			i *= 3;
			indecis[i] = v1;
			indecis[i + 1] = v2;
			indecis[i + 2] = v3;
			trianglesCount++;
		}
		
		/**
		 * Push new vertex and uv to buffers, uses only with non static geometry
		 * @param	x - vertex X value
		 * @param	y - vertex Y value
		 * @param	u - vertex U value
		 * @param	v - vertex V value
		 */
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
		
		/**
		 * Update specified vertex x,y and u,v values, uses to fill up geometry in static mode or update vertices values
		 * @param	i - vertex index
		 * @param	x - vertex X value
		 * @param	y - vertex Y value
		 * @param	u - vertex U value
		 * @param	v - vertex V value
		 */
		public function setVertexAndUV(i:int, x:Number, y:Number, u:Number, v:Number):void
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
		
		/**
		 * Set specified vertex x, y values
		 * @param	i - vertex index
		 * @param	x - vertex X value
		 * @param	y - vertex Y value
		 */
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
		
		/**
		 * Add offset to all u,v valuse in geometry and update buffer if neccessary
		 * @param	u - u value offset
		 * @param	v - v value offset
		 * @param	updateBuffer - if set to true then UV buffer will be reupload
		 */
		public function addUVStride(u:Number, v:Number, updateBuffer:Boolean = true):void
		{
			for (var i:int = 0; i < verticesCount; i+=4)
			{
				vertices[i + 2] += u;
				vertices[i + 3] += v;
			}
			
			if(updateBuffer)
				updateUV();
		}
		
		/**
		 * Set or update specified vertex UV values
		 * @param	i - vertex index
		 * @param	u - vertex U value
		 * @param	v - vertex V value
		 */
		public function setUV(i:int, u:Number, v:Number):void
		{
			vertices[i + 2] = u;
			vertices[i + 3] = v;
		}
		
		/**
		 * Call on render phase it need to set render support and update buffers if it neccessarry also set buffers to context
		 * @param	renderSupport
		 */
		public function render(renderSupport:RenderSupport):void
		{
			if (!_init)
				init(renderSupport);
				
			setBuffers(renderSupport);
		}
		
		/**
		 * Set buffers to context at 0(x, y values), 1(u, v values)
		 * @param	renderSupport
		 */
		private function setBuffers(renderSupport:RenderSupport):void 
		{
			renderSupport.setVertexBufferAt(0, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
			renderSupport.setVertexBufferAt(1, vertexBuffer, 2, Context3DVertexBufferFormat.FLOAT_2);
		}
		
		/**
		 * fully reupload UV buffer
		 */
		public function updateUV():void
		{
			uploadVertexBuffer(verticesCount / 2);
		}
		
		/**
		 * Upload/reupload vertex buffer or just part of buffer
		 * @param	offset - start vertex index
		 * @param	length - number of vertices to upload
		 */
		public function uploadVertexBuffer(offset:int = 0, length:int = 0):void
		{
			if (!vertexBuffer)
				return;
				
			if (length == 0)
				length = numVertices;
			
			renderSupport.uploadVertexBuffer(vertexBuffer, vertices, offset, length);
		}
		
		/**
		 * Upload/reupload index buffer or just set part of buffer
		 * @param	offset - start index of indices
		 * @param	length - number of indices to upload
		 */
		public function uploadIndexBuffer(offset:int = 0, length:int = 0):void
		{
			if (!indexBuffer)
				return;
				
			if (length == 0)
				length = numVertices;
			
			renderSupport.uploadIndexBuffer(indexBuffer, indecis, offset, length);
		}
		
		/**
		 * Init operation. Create buffers and upload them first time
		 * @param	renderSupport
		 */
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
		
		/**
		 * Fully dispose geometry, release GPU memory and destroy buffers
		 */
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