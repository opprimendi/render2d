package render2d.core.display.background 
{
	import render2d.core.geometries.BaseGeometry;
	
	public class BackgroundGeometry extends BaseGeometry
	{
		private var width:Number;
		private var height:Number;
		
		public function BackgroundGeometry(width:Number, height:Number) 
		{
			super(2, 4, true);
			
			this.height = height;
			this.width = width;
			
			construct();
		}
		
		public function resize(width:Number, height:Number, uvScaleW:Number, uvScaleH:Number):void
		{
			setVertexAndUv(0, width * -0.5,  height * -0.5, 	-1 * uvScaleW, 	-1 * uvScaleH);
			setVertexAndUv(1, width *  0.5,  height * -0.5, 	 1 * uvScaleW, 	-1 * uvScaleH);
			setVertexAndUv(2, width *  0.5,  height *  0.5, 	 1 * uvScaleW, 	 1 * uvScaleH);
			setVertexAndUv(3, width * -0.5,  height *  0.5, 	-1 * uvScaleW, 	 1 * uvScaleH);
		}
		
		private function construct():void 
		{
			setVertexAndUv(0, width * -0.5,  height * -0.5, 	-0.5, 	-0.5);
			setVertexAndUv(1, width *  0.5,  height * -0.5, 	 0.5, 	-0.5);
			setVertexAndUv(2, width *  0.5,  height *  0.5, 	 0.5, 	 0.5);
			setVertexAndUv(3, width * -0.5,  height *  0.5, 	-0.5, 	 0.5);
			
			//setVertexAndUv(0, width * -0.5,  height * -0.5, 	-0.1, 	-0.1);
			//setVertexAndUv(1, width *  0.5,  height * -0.5, 	 0.1, 	-0.1);
			//setVertexAndUv(2, width *  0.5,  height *  0.5, 	 0.1, 	 0.1);
			//setVertexAndUv(3, width * -0.5,  height *  0.5, 	-0.1, 	 0.1);
		
			setTriangle(0, 0, 1, 2);
			setTriangle(1, 0, 2, 3);
			
			
		}
		
	}

}