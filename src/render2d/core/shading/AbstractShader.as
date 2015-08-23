package render2d.core.shading 
{
	import flash.display3D.Context3D;
	import flash.display3D.Program3D;
	import flash.utils.ByteArray;
	import render2d.core.error.AbstractMethodError;
	
	public class AbstractShader 
	{
		public var vertexData:String;
		public var fragmentData:String;
		
		public var compiledVertexData:ByteArray;
		public var compiledFragmentData:ByteArray;
		
		public var program:Program3D;
		
		public function AbstractShader() 
		{
			
		}
		
		public function compile():void
		{
			throw new AbstractMethodError("compile");
		}
		
		public function create(context3D:Context3D):void
		{
			program = context3D.createProgram();
		}
		
		public function upload():void
		{
			program.upload(compiledVertexData, compiledFragmentData);
		}
		
		public function setToContext(context3D:Context3D):void
		{
			context3D.setProgram(program);
		}
	}

}