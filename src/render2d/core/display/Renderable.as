package render2d.core.display 
{
	import render2d.core.geometries.BaseGeometry;
	import render2d.core.geometries.Transform;
	import render2d.core.materials.BaseMaterial;
	import render2d.core.renderers.RenderSupport;
	import render2d.core.renderers.SamplerData;
	import render2d.core.shading.AbstractShader;
	
	public class Renderable extends Transform
	{
		public var material:BaseMaterial;
		public var geometry:BaseGeometry;
		
		public var samplerData:SamplerData;
		
		public var shader:AbstractShader;
		
		public var visible:Boolean = false;
		
		public function Renderable() 
		{
			
		}
		
		public function render(renderSupport:RenderSupport):void
		{
			if (shader)
			{
				renderSupport.setProgram(shader.program);
			}
				
			renderSupport.drawRenderable(this);
		}
	}
}