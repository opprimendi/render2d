package render2d.core.display 
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.VertexBuffer3D;
	import render2d.core.geometries.BaseGeometry;
	import render2d.core.renderers.RenderSupport;
	
	public class BatchedLayer extends Renderable 
	{
		private var renderablesList:Vector.<Renderable> = new Vector.<Renderable>;
		
		private var orderBuffer:VertexBuffer3D;
		private var orderBufferData:Vector.<Number> = new Vector.<Number>;
		
		private var primitive:BaseGeometry;
		
		private var maxRenderables:int = (128 - 4) / 2;
		
		public function BatchedLayer(primitive:BaseGeometry) 
		{
			this.primitive = primitive;
			geometry = new BaseGeometry();
			
			prepareGeometry();
		}
		
		private function prepareGeometry():void 
		{
			for (var i:int = 0; i < maxRenderables; i++)
			{
				var delta:int = geometry.vertices.length/4;
				geometry.vertices = geometry.vertices.concat(primitive.vertices);
				
				for (var j:int = 0; j < primitive.indecis.length; j++)
				{
					geometry.indecis.push(primitive.indecis[j] + delta);
				}
				
				var orderValue:int = 4 + delta / 2;
				orderBufferData.push(orderValue, orderValue, orderValue, orderValue);
			}
		}
		
		public function addRenderable(renderable:Renderable):void
		{
			renderablesList.push(renderable);
		}
		
		override public function render(renderSupport:RenderSupport):void 
		{
			
			//trace(geometry.indecis);
			//trace(geometry.vertices);
			//trace(orderBufferData);
			
			if (!orderBuffer)
			{
				orderBuffer = renderSupport.createVertexBuffer(orderBufferData.length, 1);
				renderSupport.uploadVertexBuffer(orderBuffer, orderBufferData, 0, orderBufferData.length);
			}
			
			renderSupport.setVertexBufferAt(2, orderBuffer, 0, Context3DVertexBufferFormat.FLOAT_1);
			
			var constUsed:int = 4 +(renderablesList.length - 1) * 2;
			
			var isNeedFinalRender:Boolean = true;
			var k:int = 0;
			for (var i:int = 0; i < renderablesList.length; i++)
			{
				isNeedFinalRender = true;
				
				
				var renderable:Renderable = renderablesList[i];
				//trace(renderable.transformData);
				renderSupport.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 4 + k * 2, renderable.transformData, 2);
				k++;
				
				if (k == maxRenderables)
				{
					k = 0;
					isNeedFinalRender = false;
					renderSupport.drawRenderable(this);
				}
				
				
				
			}
			
			renderSupport.drawRenderable(this);
			
		}
		
	}

}