package render2d.core.primitives 
{
	import render2d.core.geometries.BaseGeometry;
	
	/**
	 * ...
	 * @author Asfel
	 */
	public class CirclePrimitive extends BaseGeometry 
	{
		
		public function CirclePrimitive() 
		{
			super();
			
			construct();
		}
		
		private function construct():void 
		{
			var r:Number = 0.5;
			var pointsCount:int = 60;
			var angle:Number = Math.PI / (pointsCount / 2);
			
			for (var i:int = 0; i < pointsCount; i++)
			{
				var currentAngle:Number = angle * i;
				var x:Number = r * Math.sin(currentAngle);
				var y:Number = r * Math.cos(currentAngle);
				
				addVertex(x, y, 0, x + 0.5, y + 0.5);
			}
			
			addVertex(0, 0, 0, 0.5, 0.5);
			
			
			for (i = 0; i < pointsCount; i++)
			{
				indecis.push(i, i + 1, pointsCount);
			}
			
			
			
			indecis.push(pointsCount-1, 0, pointsCount);
		}
		
		private function addVertex(x:Number, y:Number, z:Number, u:Number, v:Number):void
		{
			vertices.push(x, y, z, u, v);
		}
		
	}

}