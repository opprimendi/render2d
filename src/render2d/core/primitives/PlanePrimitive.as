package render2d.core.primitives 
{
	import render2d.core.geometries.BaseGeometry;
	
	public class PlanePrimitive extends BaseGeometry 
	{
		
		public function PlanePrimitive() 
		{
			super();
			construct();
		}
		
		private function construct():void 
		{
			addVertex(-0.5, -0.5, 0, 0);
			addVertex( 0.5, -0.5, 1, 0);
			addVertex( 0.5,  0.5, 1, 1);
			addVertex(-0.5,  0.5, 0, 1);
		
			mapTriangle(0, 1, 2);
			mapTriangle(0, 2, 3);
		}
	}
}