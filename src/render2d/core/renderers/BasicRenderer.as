package render2d.core.renderers 
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Program3D;
	import render2d.core.cameras.Camera;
	import render2d.core.display.Renderable;
	import render2d.core.geometries.BaseGeometry;
	import render2d.core.materials.BaseMaterial;
	import render2d.core.shading.BasicShader;

	public class BasicRenderer implements IRenderer
	{
		private var context3D:Context3D;
		private var basicShader:BasicShader = new BasicShader();
		private var currentMaterial:BaseMaterial;
		
		public function BasicRenderer(context3D:Context3D) 
		{
			this.context3D = context3D;
			context3D.enableErrorChecking = true;
			
			basicShader.create(context3D);
			basicShader.compile();
			basicShader.upload();
			basicShader.setToContext(context3D);
		}
		
		public function configure(width:Number, height:Number):void
		{
			this.context3D.configureBackBuffer(width, height, 1, true);
		}
		
		public function setProgram(program:Program3D):void
		{
			context3D.setProgram(program);
		}
		
		public function render(renderablesList:Vector.<Renderable>, renderablesCount:int, camera:Camera):void
		{
			context3D.clear();
			
			context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 0, camera.transformData, 2);
			
			currentMaterial = null;
			
			var renderable:Renderable;
			var geom:BaseGeometry;
				
			for (var i:int = 0; i < renderablesCount; i++)
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
				context3D.drawTriangles(geom.indexBuffer);
			}
			
			context3D.present();
		}
	}
}