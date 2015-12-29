package render2d.core.gl.shading 
{
	import com.adobe.utils.v3.AGALMiniAssembler;
	import flash.display3D.Context3DProgramType;
	import render2d.core.gl.Profile;
	
	public class AssemblerShader extends AbstractShader 
	{
		private static const compiler:AGALMiniAssembler = new AGALMiniAssembler();
		
		public function AssemblerShader(id:int, version:int) 
		{
			super(id, version);
		}
		
		override public function compile():void 
		{
			compiledVertexData = compiler.assemble(Context3DProgramType.VERTEX, vertexData, version);
			compiledFragmentData = compiler.assemble(Context3DProgramType.FRAGMENT, fragmentData, version);
		}
	}
}