package render2d.core.display 
{
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.VertexBuffer3D;
	import render2d.core.geometries.BaseGeometry;
	import render2d.core.materials.BaseMaterial;
	import render2d.core.renderers.RenderSupport;
	
	public class BatchedLayer extends Renderable 
	{
		public var debugMaterial:BaseMaterial;
		
		private var renderablesList:Vector.<Renderable>;
		
		private var orderBuffer:VertexBuffer3D;
		private var orderBufferData:Vector.<Number> = new Vector.<Number>;
		
		private var primitive:BaseGeometry;
		
		private var maxUsedConstantsByLayer:int = RenderSupport.maxVertexConstants - 4;
		private var maxRenderables:int = maxUsedConstantsByLayer / 2;
		private var maxUsedRegisters:int = (maxUsedConstantsByLayer + 1) * 4;
		
		private var constantsVector:Vector.<Number>
		private var identityVector:Vector.<Number>
		
		private var renderablesCount:int = 0;
		
		public function BatchedLayer(primitive:BaseGeometry) 
		{
			constantsVector = new Vector.<Number>(maxUsedRegisters, true);
			
			var k:int = 0;
			for (var i:int = 0; i < maxRenderables; i++)
			{
				constantsVector[k] =     0;
				constantsVector[k + 1] = 0;
				
				constantsVector[k + 2] = 0;
				constantsVector[k + 3] = 0;
				
				constantsVector[k + 4] = 1;
				constantsVector[k + 5] = 1;
				k += 8;
			}
			
			identityVector = new Vector.<Number>(maxUsedRegisters, true);
			renderablesList = new Vector.<Renderable>(15000, true);
			
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
			renderablesCount = 0;
		}
		
		public function setRenderList(foodBufferList:Vector.<Renderable>, foodsCount:int):void 
		{
			renderablesCount = foodsCount;
			renderablesList = foodBufferList;
		}
		
		public function addRenderable(renderable:Renderable):void
		{
			renderablesList[renderablesCount] = renderable;
			renderablesCount++;
		}
		
		private var zzz:Number = 0;
		override public function render(renderSupport:RenderSupport):void 
		{
			var numRenderables:int = renderablesCount;
			geometry.verticesCount = 0;
			geometry.trianglesCount = 0;
			
			if (numRenderables == 0)
				return;
				
			//renderSupport.rendererDebugData.materialsUsed++;
			//renderSupport.rendererDebugData.geometriesCount++;
			
			//zzz += 0.01;
			
			//currentColor = 0; //for debug draw calls
			//trace(geometry.indecis);
			//trace(geometry.vertices);
			//trace(orderBufferData);
			
			if (!orderBuffer)
			{
				orderBuffer = renderSupport.createVertexBuffer(orderBufferData.length, 1);
				renderSupport.uploadVertexBuffer(orderBuffer, orderBufferData, 0, orderBufferData.length);
			}
			
			renderSupport.setVertexBufferAt(2, orderBuffer, 0, Context3DVertexBufferFormat.FLOAT_1);
			
			var isNeedFinalRender:Boolean = true;
			var k:int = 0;
			var transform:Vector.<Number>;
			var registerIndex:int = 0;
			var b:Boolean = false;
			var drw:int = 0;
			for (var i:int = 0; i < numRenderables; i++)
			{
				isNeedFinalRender = true;
				
				var renderable:Renderable = renderablesList[i];
				
				//var addx:Number = Math.cos(zzz * 3 + i);
				//var addy:Number = Math.sin(zzz * 3 + i);
				
				//if (i % 2 == 0)
				//{
				//	renderable.x += addx;
				//	renderable.y -= addy;
				//	renderable.scaleX = addx * 10;
				//	renderable.scaleY = addx * 10;
				//}
				
				//renderable.rotationX += addx+addy + i;
				
				renderable.copyTransformTo(constantsVector, registerIndex);
				registerIndex += 8;
				
				k++;
				
				if (k == maxRenderables)
				{
					isNeedFinalRender = false;
					
					renderSupport.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 4, constantsVector, k * 2);
					geometry.verticesCount = k * 8;
					geometry.trianglesCount = k * 2;
					
				
					
					//if (drw % 3 == 0)
					//{
					//	var mb:BaseMaterial = this.material;
					//	this.material = debugMaterial;
					//	this.debugMaterial = mb;
						
					//	setNextColor(renderSupport, true);
					//}
					//else
					//	setNextColor(renderSupport);
						
					//drw++;
					renderSupport.drawRenderable(this);
					
					//renderSupport.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 4 + k * 2, identityVector, (maxRenderables - k) * 2); //clean unused registers
					
					registerIndex = 0;
					k = 0;
				}
			}
			
			if (isNeedFinalRender)
			{
				//TODO: можно забивать в констанс вектор пустые значения после актуальных для того чтобы сделать на 1 вызов меньше сет константс. А вообще клин тут не нужен т.к нужно вызвать drawTriangles с правильным количеством триугольников
				renderSupport.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 4 + k * 2, identityVector, (maxRenderables - k) * 2); //clean unused registers
				renderSupport.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 4, constantsVector, k * 2); //fill registers to use
				geometry.verticesCount = k * 8;
				geometry.trianglesCount = k * 2;
				
				//setNextColor(renderSupport);
				renderSupport.drawRenderable(this);
			}
			
			//constantsVector = new Vector.<Number>(maxUsedRegisters, true);
			
			renderSupport.setVertexBufferAt(2, null, 0, Context3DVertexBufferFormat.FLOAT_1);
			renderSupport.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 4, identityVector, k * 2); //clean only last used registers
		}
		
		public function shift():void 
		{
			renderablesList.shift();
		}
		
		public function pop():void 
		{
			renderablesList.pop();
		}
		
		private var currentColor:int = 0;
		private var colors:Vector.<int> = new <int>[0xFF0000, 0x00FF00, 0x0000FF, 0xFF00FF, 0xFFFF00, 0x00FFFF, 0xFFFFFF, 0xCCCCCC];
		private var fragmentColorBuffer:Vector.<Number> = new Vector.<Number>(4, true);
		
		/**
		 * For debug drawing reason
		 */
		private function setNextColor(renderSupport:RenderSupport, colorr:Boolean = false):void
		{
			if (currentColor == colors.length)
				currentColor = 0;
			
			var color:int = colors[currentColor];
			
			if (colorr)
			{
				fragmentColorBuffer[0] = 0;
				fragmentColorBuffer[1] = 0;
				fragmentColorBuffer[2] = 0;
				fragmentColorBuffer[3] = 0;
			}
			else
			{
				fragmentColorBuffer[0] = extractRed(color) / 255;
				fragmentColorBuffer[1] = extractGreen(color) / 255;
				fragmentColorBuffer[2] = extractBlue(color) / 255;
				fragmentColorBuffer[3] = 1;
			}
			
			renderSupport.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, fragmentColorBuffer, 1);
			
			currentColor++;
		}
		
		private function cleanColor(renderSupport:RenderSupport):void
		{
			fragmentColorBuffer[0] = 0;
			fragmentColorBuffer[1] = 0;
			fragmentColorBuffer[2] = 0;
			fragmentColorBuffer[3] = 0;
			
			renderSupport.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, fragmentColorBuffer, 1);
		}

		[Inline]
		private static function extractRed(c:uint):int 
		{
			return (( c >> 16 ) & 0xFF);
		}
			 
		[Inline]
		private static function extractGreen(c:uint):int 
		{
			return ( (c >> 8) & 0xFF );
		}
			 
		[Inline]
		private static function extractBlue(c:uint):int 
		{
			return ( c & 0xFF );
		}
		
		override public function toString():String 
		{
			return "[BatchedLayer]";
		}
	}
}