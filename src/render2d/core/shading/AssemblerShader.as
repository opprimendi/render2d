package render2d.core.shading 
{
	import com.adobe.utils.v3.AGALMiniAssembler;
	import flash.display3D.Context3DProgramType;
	import render2d.core.renderers.RenderSupport;
	
	public class AssemblerShader extends AbstractShader 
	{
		private static const compiler:AGALMiniAssembler = new AGALMiniAssembler();
		
		public function AssemblerShader() 
		{
			
		}
		
		override public function compile():void 
		{
			compiledVertexData = compiler.assemble(Context3DProgramType.VERTEX, vertexData, RenderSupport.maxAgalVersion);
			compiledFragmentData = compiler.assemble(Context3DProgramType.FRAGMENT, fragmentData, RenderSupport.maxAgalVersion);
		}
	}
}