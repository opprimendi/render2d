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
			setVertexAndUV(0, -0.5,  -0.5, 0, 0);
			setVertexAndUV(1,  0.5,  -0.5, 1, 0);
			setVertexAndUV(2,  0.5,   0.5, 1, 1);
			setVertexAndUV(3, -0.5,   0.5, 0, 1);
		
			updateTriangleMap(0, 0, 1, 2);
			updateTriangleMap(1, 0, 2, 3);
		}
	}
}