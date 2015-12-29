package render2d.core.display 
{
	import render2d.core.geometries.BaseGeometry;
	import render2d.core.geometries.Transform;
	import render2d.core.gl.Driver;
	import render2d.core.materials.BaseMaterial;
	
	public class Renderable extends Transform
	{
		public var material:BaseMaterial;
		public var geometry:BaseGeometry;
		
		public var visible:Boolean = false;
		
		public function Renderable() 
		{
			
		}
		
		public function render(drvier:Driver):void
		{
			drvier.drawRenderable(this);
		}
	}
}