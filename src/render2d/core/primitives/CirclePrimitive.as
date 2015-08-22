package render2d.core.primitives 
{
	import render2d.core.geometries.BaseGeometry;
	
	public class CirclePrimitive extends BaseGeometry 
	{
		private var vertexCount:int;
		
		public function CirclePrimitive(vertexCount:int = 60) 
		{
			this.vertexCount = vertexCount;
			construct();
		}
		
		private function construct():void 
		{
			var r:Number = 0.5;
			var angle:Number = Math.PI / (vertexCount / 2);
			
			for (var i:int = 0; i < vertexCount; i++)
			{
				var currentAngle:Number = angle * i;
				var x:Number = r * Math.sin(currentAngle);
				var y:Number = r * Math.cos(currentAngle);
				
				addVertex(x, y, 0, x + 0.5, y + 0.5);
				mapTriangle(i, i + 1, vertexCount);
			}
			
			addVertex(0, 0, 0.5, 0.5);
			indecis.push(vertexCount-1, 0, vertexCount);
		}
		
		
		
	}

}