package render2d.core.primitives 
{
	import render2d.core.geometries.BaseGeometry;
	
	public class PlanePrimitive extends BaseGeometry 
	{
		
		public function PlanePrimitive() 
		{
			super(2, 4, true);
			
			construct();
		}
		
		private function construct():void 
		{
			setVertexAndUv(0, -0.5,  -0.5, 0, 0);
			setVertexAndUv(1,  0.5,  -0.5, 1, 0);
			setVertexAndUv(2,  0.5,   0.5, 1, 1);
			setVertexAndUv(3, -0.5,   0.5, 0, 1);
		
			setTriangle(0, 0, 1, 2);
			setTriangle(1, 0, 2, 3);
		}
	}
}