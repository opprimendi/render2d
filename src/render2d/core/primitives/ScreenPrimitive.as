package render2d.core.primitives 
{
	import render2d.core.geometries.BaseGeometry;
	
	public class ScreenPrimitive extends BaseGeometry 
	{
		public function ScreenPrimitive() 
		{
			super();
			construct();
		}
		
		private function construct():void 
		{
			addVertex( -1, -1, 0, 0);
			addVertex( -1,  1, 1, 0);
			addVertex(  1,  1, 1, 1);
			addVertex(  1, -1, 0, 1);
			
			mapTriangle(0, 1, 2);
			mapTriangle(0, 2, 3);
		}
	}
}