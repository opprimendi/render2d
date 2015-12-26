package render2d.core.gl 
{
	import flash.display3D.Context3D;
	import flash.display3D.Program3D;
	import render2d.core.cameras.Camera;
	
	public class Driver implements IShaderContext
	{
		private var context3D:Context3D;
		
		private var shaderContext:ShaderContext;
		
		public var profile:Profile;
		public var camera:Camera;
		
		public function Driver(context3D:Context3D) 
		{
			this.context3D = context3D;
			initialize();
		}
		
		public function clear():void
		{
			
		}
		
		public function drawTriangles():void
		{
			shaderContext.update();
			//context3D.drawTriangles();
		}
		
		public function present():void
		{
			
		}
		
		/* INTERFACE render2d.core.gl.IShaderContext */
		
		public function disposeProgram(program:Program3D):void 
		{
			shaderContext.disposeProgram(program);
		}
		
		public function createProrgam():Program3D 
		{
			shaderContext.createProrgam(program);
		}
		
		public function setProgram(program3D:Program3D):void 
		{
			shaderContext.setProgram(program);
		}
		
		private function initialize():void 
		{
			getProfile(context3D)
			shaderContext = new ShaderContext(profile, context3D);
		}
		
		private function getProfile(context3D:Context3D):void 
		{
			profile = Profile.getProfile(context3D.profile);
		}
	}
}