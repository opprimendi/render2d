package render2d.core.renderers 
{
	import render2d.core.cameras.Camera;
	import render2d.core.display.Mesh;
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.Program3D;
	import flash.display3D.textures.Texture;
	import flash.display3D.textures.TextureBase;
	import render2d.core.geometries.BaseGeometry;
	import render2d.core.materials.BaseMaterial;
	import render2d.core.primitives.ScreenPrimitive;
	import render2d.core.shading.BasicShader;
	import render2d.core.shading.ScreenShader;

	public class BasicRenderer 
	{
		public var camera:Camera = new Camera();
		
		private var context3D:Context3D;
		private var renderTarget:TextureBase;
		
		public var displayList:DisplayList = new DisplayList();
		
		private var basicShader:BasicShader = new BasicShader();
		private var screenShader:ScreenShader = new ScreenShader();
		
		public var renderTime:Number = 0;
		
		public function BasicRenderer(context3D:Context3D, width:int, height:int) 
		{
			this.context3D = context3D;
			context3D.enableErrorChecking = false;
			camera.screenSpaceRatio = 1 / ((width + height) / 4);
			
			
			
			this.context3D.configureBackBuffer(width, height, 1, true, true, true);
			renderTarget = this.context3D.createTexture(1024, 1024, Context3DTextureFormat.BGRA, true);
			(renderTarget as Texture).uploadFromBitmapData(new BitmapData(1024, 1024, false, 0xFF0000));
			
			for (var i:int = 0; i < 10; i++)
			{
				(renderTarget as Texture).uploadFromBitmapData(new BitmapData(1, 1), i + 1);
			}
			
			screenShader.create(context3D);
			basicShader.create(context3D);
			
			
			basicShader.upload(context3D);
		}
		
		public function setProgram(program:Program3D):void
		{
			context3D.setProgram(program);
		}
		
		public function render():void
		{
			//renderTime = getTimer();
			context3D.clear();
			
			renderToTexture();
			//copyToBackBuffer();
			//renderTime = getTimer() - renderTime;
		}
		
		private function renderToTexture():void
		{
			//context3D.setRenderToTexture(renderTarget);
			
			//viewMatirx.identity();
			//viewMatirx.appendRotation(180, Vector3D.Z_AXIS);
			//viewMatirx.appendRotation(180, Vector3D.Y_AXIS);
			
			//viewMatirx.appendTranslation(1/400, 0, 0);
			
			
			context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 0, camera.transformData, 2);
			
			var l:int = displayList.list.length;
			
			if(l > 0)
				displayList.list[0].material.render(context3D);
			
			var mesh:Mesh;
			var geom:BaseGeometry;
				
			for (var i:int = 0; i < l; i++)
			{
				mesh = displayList.list[i];
				
				geom = mesh.geometry;
				
				geom.render(context3D);
				
				//displayList.list[i].transform.prepend(viewMatirx);
				//trace(mesh);
				context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 2, mesh.transformData, 2);
				context3D.drawTriangles(geom.indexBuffer);
			}
			
			context3D.present();
			//context3D.clear(0.0, 0.0, 0.0, 0.0);
		}
		
		private function copyToBackBuffer():void
		{
			//context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, viewMatirx, true);
			
			screenShader.upload(context3D);
			
			var geometry:ScreenPrimitive = new ScreenPrimitive();
			var material:BaseMaterial = new BaseMaterial(renderTarget);
			var mesh:Mesh = new Mesh(geometry, material);
			
			
			geometry.render(context3D);
			material.render(context3D);
			
			//displayList.list[0].material.render(context3D);
			context3D.drawTriangles(geometry.indexBuffer);
			
			context3D.present();
		}
	}

}