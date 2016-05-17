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
			//setVertexAndUV(3, -0.5,  -0.5, 0, 1);
			//setVertexAndUV(2,  0.5,  -0.5, 1, 1);
			//setVertexAndUV(1,  0.5,   0.5, 1, 0);
			//setVertexAndUV(0, -0.5,   0.5, 0, 0);
			
			///**
			  	setVertexAndUV(0, -1,  -1, 0, 0);
				setVertexAndUV(1,  1,  -1, 1, 0);
				setVertexAndUV(2,  1,   1, 1, 1);
				setVertexAndUV(3, -1,   1, 0, 1);
			 //*/
		
			/**
			 * Должно быть на обарот 
			 * CCW и оринтация вершин наобарот
			 * Но есть две причины поступать так
			 * 1. Камера повернута по Y что меняет ее оринтацию в x 0-1, y 0-1 с x 0-1, y 1-0 т.е более привичная а так же избавляет от sub в вычеслении координат
			 * 2. После смены оринтации камеры Z смотрит в противоположную сторону и поворачивает вдоль X геометрию поэтому ее задняя часть становится передней
			 * 	  а следовательно чтобы соответсвовать выставленому куликгу BACK нужно и ордер выставить инверсивный
			 */
			//cw - back
			updateTriangleMap(0, 0, 1, 2);
			updateTriangleMap(1, 2, 3, 0);
			
			//ccw - front
			//updateTriangleMap(0, 3, 2, 1);
			//updateTriangleMap(1, 1, 0, 3);
		}
	}
}