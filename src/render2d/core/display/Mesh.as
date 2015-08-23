package render2d.core.display 
{
	import render2d.core.geometries.BaseGeometry;
	import render2d.core.materials.BaseMaterial;
	
	public class Mesh extends Renderable
	{
		public function Mesh(geometry:BaseGeometry = null, material:BaseMaterial = null) 
		{
			this.geometry = geometry;
			this.material = material;
		}
	}
}