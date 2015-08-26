package render2d.core.renderers 
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTriangleFace;
	import flash.display3D.Program3D;
	import render2d.core.cameras.Camera;
	import render2d.core.display.BatchedLayer;
	import render2d.core.display.Renderable;
	import render2d.core.geometries.BaseGeometry;
	import render2d.core.materials.BaseMaterial;
	import render2d.core.shading.BasicShader;
	import render2d.core.shading.BatchShader;

	public class BasicRenderer implements IRenderer
	{
		private var context3D:Context3D;
		
		private var basicShader:BasicShader = new BasicShader();
		private var batchShader:BatchShader = new BatchShader();
		
		private var currentMaterial:BaseMaterial;
		
		private var fragmentColorBuffer:Vector.<Number> = new Vector.<Number>(4, true);
		
		public function BasicRenderer(context3D:Context3D) 
		{
			this.context3D = context3D;
			context3D.enableErrorChecking = true;
			
			basicShader.create(context3D);
			basicShader.compile();
			basicShader.upload();
			basicShader.setToContext(context3D);
			
			batchShader.create(context3D);
			batchShader.compile();
			batchShader.upload();
		}
		
		public function configure(width:Number, height:Number):void
		{
			this.context3D.configureBackBuffer(width, height, 4, false);
			this.context3D.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
			//context3D.setCulling(Context3DTriangleFace.FRONT);
			
		}
		
		public function setProgram(program:Program3D):void
		{
			context3D.setProgram(program);
		}
		
		//private var periodic:Number = 0;
		public function render(renderablesList:Vector.<Renderable>, renderablesCount:int, camera:Camera):void
		{
			context3D.clear();
			
			context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 0, camera.transformData, 2);
			//context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 4, new <Number>[Math.cos(periodic)/50, Math.sin(periodic)/50, 0, 0], 1);
			
			//trace(Math.cos(periodic), periodic);
			
			//periodic += 0.05 + Math.random() * 0.1;
			
			//currentMaterial = null;
			
			var renderable:Renderable;
			var geom:BaseGeometry;
			
			
			for (var i:int = renderablesCount - 1; i > -1; i--)
			{
				renderable = renderablesList[i];
				
				if (currentMaterial == null || currentMaterial.texture != renderable.material.texture)
				{
					currentMaterial = renderable.material;
					currentMaterial.render(context3D);
				}
				
				geom = renderable.geometry;
				
				geom.render(context3D);
				
				
				context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 2, renderable.transformData, 2);
				
				
				
				if (renderable.material.useColor)
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
				
				context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, fragmentColorBuffer, 1);
				
					
				//context3D.setVertexBufferAt(2, null);
				renderable.render(context3D);
				
				
				//if (renderable is BatchedLayer)
				//	batchShader.setToContext(context3D);
				//else
				//	basicShader.setToContext(context3D);
					
				context3D.drawTriangles(geom.indexBuffer);
			}
			
			context3D.present();
			
			
		}
	}
}