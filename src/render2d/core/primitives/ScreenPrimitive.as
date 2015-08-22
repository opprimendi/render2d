package render2d.core.primitives 
{
	import render2d.core.geometries.BaseGeometry;
	
	/**
	 * ...
	 * @author Asfel
	 */
	public class ScreenPrimitive extends BaseGeometry 
	{
		
		public function ScreenPrimitive() 
		{
			super();
			
			construct();
		}
		
		private function construct():void 
		{
			vertices.push(
							-1, 	-1, 	0, 			0, 	0,
							-1,  	 1, 	0, 			1, 	0,
							 1,  	 1, 	0, 			1,	1,
							 1, 	-1, 	0, 			0, 	1);
							 
			
						
			
			indecis.push(
							0, 1, 2, 0, 2, 3
						
						
						);
		}
		
	}

}