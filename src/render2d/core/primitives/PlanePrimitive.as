package render2d.core.primitives 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import render2d.core.geometries.BaseGeometry;
	
	public class PlanePrimitive extends BaseGeometry 
	{
		private var framePolygon:SquarePolygon;
		private var holePolygon:SquarePolygon;
		
		public function PlanePrimitive() 
		{
			super(12, 12, true);
			
			construct();
		}
		
		private function construct():void 
		{
			framePolygon = new SquarePolygon( -0.5, -0.5, 1, 1);
			holePolygon = new SquarePolygon( -0.15, -0.15, 0.3, 0.3);
			
			setVertexAndUV(0, framePolygon.a.x, framePolygon.a.y, 0, 0);
			setVertexAndUV(1, framePolygon.halfPositionTop.x, framePolygon.halfPositionTop.y, 1, 1);
			setVertexAndUV(2, framePolygon.b.x, framePolygon.b.y, 1, 1);
			setVertexAndUV(3, framePolygon.halfPositionRight.x, framePolygon.halfPositionRight.y, 1, 1);
			setVertexAndUV(4, framePolygon.c.x, framePolygon.c.y, 1, 1);
			setVertexAndUV(5, framePolygon.halfPositionBottom.x, framePolygon.halfPositionBottom.y, 1, 1);
			setVertexAndUV(6, framePolygon.d.x, framePolygon.d.y, 1, 1);
			setVertexAndUV(7, framePolygon.halfPositionLeft.x, framePolygon.halfPositionLeft.y, 1, 1);
			
		
			updateRotate(Math.PI / 360);
			
			mapTriangles();
		}
		
		public function updateRotate(angle:Number):void
		{
			holePolygon.rotate(angle);
			holePolygon.recalculateABCD();
			
			setVertexAndUV(8, holePolygon.a.x, holePolygon.a.y, 1, 1);
			setVertexAndUV(9, holePolygon.b.x, holePolygon.b.y, 1, 1);
			setVertexAndUV(10, holePolygon.c.x, holePolygon.c.y, 1, 1);
			setVertexAndUV(11, holePolygon.d.x, holePolygon.d.y, 1, 1);
			
			uploadVertexBuffer(0, 12);
			
		}
		
		private function mapTriangles():void 
		{
			var A1:int = 0;
			var HT:int = 1;
			var B1:int = 2;
			var HR:int = 3;
			var C1:int = 4;
			var HB:int = 5;
			var D1:int = 6;
			var HL:int = 7;
			var A2:int = 8;
			var B2:int = 9;
			var C2:int = 10;
			var D2:int = 11;
			
			updateTriangleMap(0,  A1, HT, A2); //A1 HT A2
			updateTriangleMap(1,  HT, B2, A2); //HT B2 A2
			updateTriangleMap(2,  HT, B1, B2); //HT B1 B2
			updateTriangleMap(3,  B1, HR, B2); //B1 HR B2
			updateTriangleMap(4,  HR, C2, B2);//HR C2 B2
			updateTriangleMap(5,  HR, C1, C2);//HR C1 C2
			updateTriangleMap(6,  C1, HB, C2);//C1 HB C2
			updateTriangleMap(7,  HB, D2, C2);//HB D2 C2
			updateTriangleMap(8,  HB, D1, D2);//HB D1 D2
			updateTriangleMap(9,  D1, HL, D2);//D1 HL D2
			updateTriangleMap(10, HL, A2, D2);//HL A2 D2
			updateTriangleMap(11, HL, A1, A2);//Hl A1 A2
		}
	}
}