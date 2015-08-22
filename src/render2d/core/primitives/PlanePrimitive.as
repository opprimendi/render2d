package render2d.core.primitives 
{
	import render2d.core.geometries.BaseGeometry;
	
	/**
	 * ...
	 * @author Asfel
	 */
	public class PlanePrimitive extends BaseGeometry 
	{
		
		public function PlanePrimitive() 
		{
			super();
			
			construct();
		}
		
		private function construct():void 
		{
			vertices.push(
							-0.5, 	-0.5, 	0, 			0, 	0,
							-0.5,  	 0.5, 	0, 			1, 	0,
							 0.5,  	 0.5, 	0, 			1,	1,
							 0.5, 	-0.5, 	0, 			0, 	1);
							 
			
						
			
			indecis.push(
							0, 1, 2, 0, 2, 3
						
						
						);
		}
		
	}

}