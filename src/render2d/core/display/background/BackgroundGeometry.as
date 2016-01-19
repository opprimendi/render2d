package render2d.core.display.background 
{
	import render2d.core.geometries.BaseGeometry;
	
	public class BackgroundGeometry extends BaseGeometry
	{
		
		public function BackgroundGeometry(width:Number, height:Number) 
		{
			super(2, 4, true);
			
			this.height = height;
			this.width = width;
			
			construct();
		}
		
		public function resize(width:Number, height:Number, uvScaleW:Number, uvScaleH:Number):void
		{
			setVertexAndUV(0, width * -0.5,  height * -0.5, 	-1 * uvScaleW, 	-1 * uvScaleH);
			setVertexAndUV(1, width *  0.5,  height * -0.5, 	 1 * uvScaleW, 	-1 * uvScaleH);
			setVertexAndUV(2, width *  0.5,  height *  0.5, 	 1 * uvScaleW, 	 1 * uvScaleH);
			setVertexAndUV(3, width * -0.5,  height *  0.5, 	-1 * uvScaleW, 	 1 * uvScaleH);
		}
		
		private function construct():void 
		{
			setVertexAndUV(0, width * -0.5,  height * -0.5, 	-1, 	-1);
			setVertexAndUV(1, width *  0.5,  height * -0.5, 	 1, 	-1);
			setVertexAndUV(2, width *  0.5,  height *  0.5, 	 1, 	 1);
			setVertexAndUV(3, width * -0.5,  height *  0.5, 	-1, 	 1);
			

			
			//setVertexAndUV(0, width * -0.5,  height * -0.5, 	-0.1, 	-0.1);
			//setVertexAndUV(1, width *  0.5,  height * -0.5, 	 0.1, 	-0.1);
			//setVertexAndUV(2, width *  0.5,  height *  0.5, 	 0.1, 	 0.1);
			//setVertexAndUV(3, width * -0.5,  height *  0.5, 	-0.1, 	 0.1);
		
			updateTriangleMap(0, 0, 1, 2);
			updateTriangleMap(1, 2, 3, 0);
			
			
		}
		
	}

}