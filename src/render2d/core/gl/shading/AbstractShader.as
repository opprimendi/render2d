package render2d.core.gl.shading 
{
	import flash.display3D.Program3D;
	import flash.utils.ByteArray;
	import render2d.core.error.AbstractMethodError;
	import render2d.core.gl.ShaderContext;
	
	public class AbstractShader 
	{
		public var id:int;
		public var version:int;
		
		public var vertexData:String;
		public var fragmentData:String;
		
		public var compiledVertexData:ByteArray;
		public var compiledFragmentData:ByteArray;
		
		public var program:Program3D;
		
		public function AbstractShader(id:int, version:int) 
		{
			this.version = version;
			this.id = id;
		}
		
		public function compile():void
		{
			throw new AbstractMethodError("compile");
		}
		
		public function createCompileUpload(shaderContext:ShaderContext):void
		{
			create(shaderContext);
			compile();
			upload(shaderContext);
		}
		
		public function createAndUpload(shaderContext:ShaderContext):void
		{
			create(shaderContext);
			upload(shaderContext);
		}
		
		public function create(shaderContext:ShaderContext):void
		{
			program = shaderContext.createProgram();
		}
		
		public function upload(shaderContext:ShaderContext):void
		{
			shaderContext.upload(program, compiledVertexData, compiledFragmentData);
		}
	}
}