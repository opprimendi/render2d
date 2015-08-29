package render2d.core.display 
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.VertexBuffer3D;
	import flash.geom.Vector3D;
	import render2d.core.geometries.BaseGeometry;
	import render2d.core.renderers.RenderSupport;
	
	public class BatchedLayer extends Renderable 
	{
		private var renderablesList:Vector.<Renderable> = new Vector.<Renderable>;
		
		private var orderBuffer:VertexBuffer3D;
		private var orderBufferData:Vector.<Number> = new Vector.<Number>;
		
		private var primitive:BaseGeometry;
		
		
		private var maxUsedConstantsByLayer:int = RenderSupport.maxVertexConstants - 4;
		private var maxRenderables:int = maxUsedConstantsByLayer / 2;
		private var maxUsedRegisters:int = (maxUsedConstantsByLayer + 1) * 4;
		
		
		private var constantsVector:Vector.<Number>
		private var identityVector:Vector.<Number>
		
		public function BatchedLayer(primitive:BaseGeometry) 
		{
			constantsVector = new Vector.<Number>(maxUsedRegisters, true);
			identityVector = new Vector.<Number>(maxUsedRegisters, true);
			
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
		
				
		public function clean():void 
		{
			renderablesList = new Vector.<Renderable>;
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
			var registerIndex:int = 0;
			for (var i:int = 0; i < renderablesList.length; i++)
			{
				isNeedFinalRender = true;
				
				
				var renderable:Renderable = renderablesList[i];
				//trace(renderable.transformData);
				
				
				constantsVector[registerIndex++] = renderable.transformData[0];
				constantsVector[registerIndex++] = renderable.transformData[1];
				constantsVector[registerIndex++] = renderable.transformData[2];
				constantsVector[registerIndex++] = renderable.transformData[3];
				constantsVector[registerIndex++] = renderable.transformData[4];
				constantsVector[registerIndex++] = renderable.transformData[5];
				constantsVector[registerIndex++] = renderable.transformData[6];
				constantsVector[registerIndex++] = renderable.transformData[7];
				
				//trace(constantsVector,"/" , renderable.transformData);
				//renderSupport.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 4 + 2 * k, renderable.transformData, 2);
				k++;
				
				
				if (k == maxRenderables)
				{
					isNeedFinalRender = false;
					renderSupport.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 4, constantsVector, k * 2);
					renderSupport.drawRenderable(this);
					
					registerIndex = 0;
					
					k = 0;
				}
			}
			
			if (isNeedFinalRender)
			{
				renderSupport.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 4, constantsVector, k * 2);
				renderSupport.drawRenderable(this);
			}
			
				
			constantsVector = new Vector.<Number>(maxUsedRegisters, true);
			
			renderSupport.setVertexBufferAt(2, null, 0, Context3DVertexBufferFormat.FLOAT_1);
			renderSupport.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 4, constantsVector, maxRenderables * 2);
			
			//for (i = 0; i < renderablesList.length; i++)
			//{
				
				//k++;
				
				//if (k == maxRenderables)
				//	break;
			//}
		}

		
	}

}