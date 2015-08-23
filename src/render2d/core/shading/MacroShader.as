package render2d.core.shading 
{
	import com.adobe.utils.AGALMacroAssembler;
	import flash.display3D.Context3DProgramType;
	
	public class MacroShader extends AbstractShader 
	{
		private static const compiler:AGALMacroAssembler = new AGALMacroAssembler();
		
		public function MacroShader() 
		{
			
		}
		
		override public function compile():void 
		{
			compiledVertexData = compiler.assemble(Context3DProgramType.VERTEX, vertexData);
			compiledFragmentData = compiler.assemble(Context3DProgramType.FRAGMENT, fragmentData);
		}
	}
}