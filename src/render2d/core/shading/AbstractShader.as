package render2d.core.shading 
{
	import flash.display3D.Context3D;
	import flash.display3D.Program3D;
	import flash.utils.ByteArray;
	import render2d.core.error.AbstractMethodError;
	import render2d.core.renderers.RenderSupport;
	
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
		
		public function create(renderSupport:RenderSupport):void
		{
			program = renderSupport.createProgram();
		}
		
		public function upload(renderSupport:RenderSupport):void
		{
			renderSupport.upload(program, compiledVertexData, compiledFragmentData);
		}
		
		public function setToContext(renderSupport:RenderSupport):void
		{
			trace("set program", this);
			renderSupport.setProgram(program);
		}
	}

}