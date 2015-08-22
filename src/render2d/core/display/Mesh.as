package render2d.core.display 
{
	import render2d.core.geometries.BaseGeometry;
	import render2d.core.geometries.Transform;
	import render2d.core.materials.BaseMaterial;
	
	public class Mesh extends Transform
	{
		public var material:BaseMaterial;
		public var geometry:BaseGeometry;
		
		public function Mesh(geometry:BaseGeometry = null, material:BaseMaterial = null) 
		{
			this.geometry = geometry;
			this.material = material;
		}
	}
}