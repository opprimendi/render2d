package render2d.core.display 
{
	import render2d.core.geometries.BaseGeometry;
	import render2d.core.geometries.Transform;
	import render2d.core.materials.BaseMaterial;
	
	public class Renderable extends Transform
	{
		public var material:BaseMaterial;
		public var geometry:BaseGeometry;
		
		public function Renderable() 
		{
			
		}
		
		public var visible:Boolean = false;
		
		public function get width():Number
		{
			return Math.abs(geometry.minX - geometry.maxX);
		}
		
		public function get height():Number
		{
			return Math.abs(geometry.minY - geometry.maxY);
		}
	}
}