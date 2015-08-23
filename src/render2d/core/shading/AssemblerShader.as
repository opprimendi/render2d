package render2d.core.shading 
{
	import com.adobe.utils.AGALMiniAssembler;
	import flash.display3D.Context3DProgramType;
	
	public class AssemblerShader extends AbstractShader 
	{
		private static const compiler:AGALMiniAssembler = new AGALMiniAssembler();
		
		public function AssemblerShader() 
		{
			
		}
		
		override public function compile():void 
		{
			compiledVertexData = compiler.assemble(Context3DProgramType.VERTEX, vertexData);
			compiledFragmentData = compiler.assemble(Context3DProgramType.FRAGMENT, fragmentData);
		}
	}
}