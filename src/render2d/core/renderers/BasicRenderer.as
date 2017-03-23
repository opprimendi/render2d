package render2d.core.renderers 
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTriangleFace;
	import flash.geom.Rectangle;
	import render2d.core.cameras.Camera;
	import render2d.core.display.BatchedLayer;
	import render2d.core.display.Renderable;
	import render2d.core.shading.BasicShader;
	import render2d.core.shading.BatchShader;

	public class BasicRenderer implements IRenderer
	{
		private var context3D:Context3D;
		
		public var basicShader:BasicShader = new BasicShader();
		public var batchShader:BatchShader = new BatchShader();
		
		private var fragmentColorBuffer:Vector.<Number> = new Vector.<Number>(4, true);
		public var currentFragmentColorBuffer:Vector.<Number> = new Vector.<Number>(4, true);
		
		public var renderSupport:RenderSupport;
		
		public function BasicRenderer(context3D:Context3D) 
		{
			this.context3D = context3D;
			context3D.enableErrorChecking = true;
			
			renderSupport = new RenderSupport(context3D);
			
			basicShader.create(renderSupport);
			basicShader.compile();
			basicShader.upload(renderSupport);
			basicShader.setToContext(renderSupport);
			
			batchShader.create(renderSupport);
			batchShader.compile();
			batchShader.upload(renderSupport);
		}
		
		public function configure(width:Number, height:Number, maxWidth:Number, maxHeight:Number):void
		{
			this.context3D.configureBackBuffer(width, height, 3, true);
			
			this.context3D.setScissorRectangle(new Rectangle(0, 0, maxWidth, maxHeight));
			//trace("Sc rect", maxWidth, maxHeight);
			this.context3D.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
			context3D.setCulling(Context3DTriangleFace.NONE);
			
			renderSupport.clear();
			renderSupport.present();
		}
		
		public function setCamera(camera:Camera):void
		{
			renderSupport.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 0, camera.transformData, 2);
		}
		
		//private var periodic:Number = 0;
		public function render(renderablesList:Vector.<Renderable>, renderablesCount:int, camera:Camera):void
		{
			renderSupport.clear();
			
			//renderSupport.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 0, camera.transformData, 2);
			//context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 4, new <Number>[Math.cos(periodic)/50, Math.sin(periodic)/50, 0, 0], 1);
			
			//trace(Math.cos(periodic), periodic);
			
			//periodic += 0.05 + Math.random() * 0.1;
			
			//currentMaterial = null;
			
			var renderable:Renderable;
			
			for (var i:int = renderablesCount - 1; i > -1; i--)
			{
				renderable = renderablesList[i];
				

				if (renderable is BatchedLayer)
				{
					
					batchShader.setToContext(renderSupport);
				}
				else
				{
					
					if (renderable.material && renderable.material.useColor)
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
					
					if (fragmentColorBuffer[0] != currentFragmentColorBuffer[0] || fragmentColorBuffer[1] != currentFragmentColorBuffer[1] || 
					fragmentColorBuffer[2] != currentFragmentColorBuffer[2] || fragmentColorBuffer[3] != currentFragmentColorBuffer[3])
					{
						currentFragmentColorBuffer[0] = fragmentColorBuffer[0];
						currentFragmentColorBuffer[1] = fragmentColorBuffer[1];
						currentFragmentColorBuffer[2] = fragmentColorBuffer[2];
						currentFragmentColorBuffer[3] = fragmentColorBuffer[3];
						
						renderSupport.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, fragmentColorBuffer, 1);
					}
					
					//basicShader.setToContext(renderSupport);
				}
					
				renderable.render(renderSupport);
				
			}
			
			renderSupport.present();
		}
	}
}