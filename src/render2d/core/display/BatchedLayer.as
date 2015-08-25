package render2d.core.display 
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.VertexBuffer3D;
	import render2d.core.geometries.BaseGeometry;
	
	public class BatchedLayer extends Renderable 
	{
		private var renderablesList:Vector.<Renderable> = new Vector.<Renderable>;
		
		private var orderBuffer:VertexBuffer3D;
		private var orderBufferData:Vector.<Number> = new Vector.<Number>;
		
		public function BatchedLayer() 
		{
			geometry = new BaseGeometry();
		}
		
		public function addRenderable(renderable:Renderable):void
		{
			renderablesList.push(renderable);

			var delta:int = geometry.vertices.length/4;
			geometry.vertices = geometry.vertices.concat(renderable.geometry.vertices);
			
			for (var i:int = 0; i < renderable.geometry.indecis.length; i++)
			{
				geometry.indecis.push(renderable.geometry.indecis[i] + delta);
			}
			
			var orderValue:int = 4 + delta / 2;
			orderBufferData.push(orderValue, orderValue, orderValue, orderValue);
		}
		
		override public function render(context3D:Context3D):void 
		{
			super.render(context3D);
			
			//trace(geometry.indecis);
			//trace(geometry.vertices);
			//trace(orderBufferData);
			
			if (!orderBuffer)
			{
				orderBuffer = context3D.createVertexBuffer(orderBufferData.length, 1);
				orderBuffer.uploadFromVector(orderBufferData, 0, orderBufferData.length);
			}
			
			var constUsed:int = 4 +(renderablesList.length - 1) * 2;
			
			for (var i:int = 0; i < renderablesList.length; i++)
			{
				var renderable:Renderable = renderablesList[i];
				
				context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 4 + i * 2, renderable.transformData, 2);
			}
			
			context3D.setVertexBufferAt(2, orderBuffer, 0, Context3DVertexBufferFormat.FLOAT_1);
		}
		
	}

}