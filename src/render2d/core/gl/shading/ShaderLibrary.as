package render2d.core.gl.shading 
{
	import render2d.core.gl.ShaderContext;

	public class ShaderLibrary 
	{
		private var library:Object = {};
		private var shaderContext:ShaderContext;
		
		public function ShaderLibrary(shaderContext:ShaderContext) 
		{
			this.shaderContext = shaderContext;
			initStandartShaders();
		}
		
		private function initStandartShaders():void 
		{
			var basicShader:BasicShader = new BasicShader();
			registerShader(basicShader);
			
			var backgroundShader:BackgroundShader = new BackgroundShader();
			registerShader(backgroundShader);
			
			var batchShader:BatchShader = new BatchShader();
			registerShader(batchShader);
		}
		
		public function getShader(id:int, version:int):AbstractShader
		{
			return library[id];
		}
		
		public function registerShader(shader:AbstractShader):void
		{
			shader.createCompileUpload(shaderContext);
			
			library[shader.id] = shader;
		}
	}
}