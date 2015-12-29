package render2d.core.gl 
{
	import flash.display3D.Context3D;
	import flash.display3D.Program3D;
	import flash.utils.ByteArray;
	import render2d.core.gl.shading.AbstractShader;
	import render2d.core.gl.shading.ShaderLibrary;
	import render2d.core.gl.shading.ShaderVersion;
	
	
	public class ShaderContext implements IShaderContext
	{
		public var maxPrograms:int;
		public var programsUsed:int;
		
		public var curentProgram:Program3D;
		
		private var shaderLibrary:ShaderLibrary;
		
		private var context3D:Context3D;
		private var profile:Profile;
		
		public function ShaderContext(profile:Profile, context3D:Context3D) 
		{
			this.profile = profile;
			this.maxPrograms = profile.maxProgram;
			
			this.context3D = context3D;
			
			shaderLibrary = new ShaderLibrary(this);
		}
		
		public final function disposeProgram(program:Program3D):void
		{
			programsUsed--;
			program.dispose();
		}
		
		public final function createProgram():Program3D
		{
			programsUsed++;
			return context3D.createProgram();
		}
		
		public final function upload(program3D:Program3D, compiledVertexData:ByteArray, compiledFragmentData:ByteArray):void
		{
			program3D.upload(compiledVertexData, compiledFragmentData);
		}
		
		[Inline]
		public final function setProgram(program3D:Program3D):void
		{
			if (curentProgram == program3D)
				return;
				
			curentProgram = program3D;
			context3D.setProgram(curentProgram);
		}
		
		public function setShader(shaderId:int):void 
		{
			var shader:AbstractShader = shaderLibrary.getShader(shaderId, ShaderVersion.V1);
			setProgram(shader.program);
		}
	}
}