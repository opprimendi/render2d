package render2d.core.gl 
{
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DClearMask;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTriangleFace;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Program3D;
	import flash.utils.ByteArray;
	import render2d.core.cameras.Camera;
	import render2d.core.display.ConstantBuffer;
	import render2d.core.display.Renderable;
	import render2d.core.gl.texture.BitmapTexture;
	import render2d.core.gl.texture.TextureUploader;
	
	public class Driver implements IShaderContext
	{
		public var context:Context3D;
		
		private var textureUploader:TextureUploader;
		
		private var materialContext:MaterialContext;
		private var geometryContext:GeometryContext;
		private var shaderContext:ShaderContext;
		
		public var profile:Profile;
		public var camera:Camera = new Camera();
		
		private var vertexConstantBuffer:ConstantBuffer;
		
		public function Driver(context:Context3D) 
		{
			this.context = context;
			
			initialize();
		}
		
		public function createBitmapTexture(bitmapSource:BitmapData, isUseMipMaps:Boolean = false):BitmapTexture
		{
			return textureUploader.uploadTexture(bitmapSource, isUseMipMaps);
		}
		
		public function configureBackbuffer(width:Number, height:Number, antiAlias:int = 0):void
		{
			context.configureBackBuffer(width, height, antiAlias, false);
			context.setCulling(Context3DTriangleFace.FRONT);
			
			camera.configure(width, height);
		}
		
		public function drawRenderable(renderable:Renderable):void
		{
			renderable.copyTransformTo(vertexConstantBuffer.constantsValue, 8);
			camera.copyTransformTo(vertexConstantBuffer.constantsValue, 0);
			
			vertexConstantBuffer.size = 16;
			
			vertexConstantBuffer.upload(context, 0);
			
			
			geometryContext.setGeometry(renderable.geometry);
			materialContext.setMaterial(renderable.material);
			shaderContext.setShader(renderable.material.shader);
			
			drawTriangles(renderable.geometry.indexBuffer, 0, renderable.geometry.trianglesCount);
		}
		
		public function clear():void
		{
			materialContext.clear();
			context.clear(0, 0, 0, 1, 1, 0, Context3DClearMask.COLOR);
			vertexConstantBuffer.size = 4;
		}
		
		public function drawTriangles(indexBuffer:IndexBuffer3D, firstIndex:int = 0, numTriangles:int = -1):void
		{
			materialContext.drawTriangles();
			context.drawTriangles(indexBuffer, firstIndex, numTriangles);
		}
		
		public function present():void
		{
			textureUploader.update();
			context.present();
		}
		
		public function upload(program:Program3D, compiledVertexData:ByteArray, compiledFragmentData:ByteArray):void 
		{
			program.upload(compiledVertexData, compiledFragmentData);
		}
		
		/* INTERFACE render2d.core.gl.IShaderContext */
		
		public function disposeProgram(program:Program3D):void 
		{
			shaderContext.disposeProgram(program);
		}
		
		public function createProgram():Program3D 
		{
			return shaderContext.createProgram();
		}
		
		public function setProgram(program3D:Program3D):void 
		{
			shaderContext.setProgram(program3D);
		}
		
		/* INTERFACE render2d.core.gl.IShaderContext */
		
		private function initialize():void 
		{
			getProfile(context)
			
			textureUploader = new TextureUploader(context)
			shaderContext = new ShaderContext(profile, context);
			geometryContext = new GeometryContext(profile, context);
			materialContext = new MaterialContext(profile, context);
			
			vertexConstantBuffer = new ConstantBuffer(profile.maxVertexConstants, Context3DProgramType.VERTEX);
		}
		
		private function getProfile(context:Context3D):void 
		{
			profile = Profile.getProfile(context.profile);
		}
	}
}