package render2d.core.geometries 
{
	import render2d.core.renderers.RenderSupport;
	
	public class FastGeometry implements IGeometry
	{
		public var vertices:Vector.<Number> = new Vector.<Number>;
		public var indecis:Vector.<uint> = new Vector.<uint>;
		
		public function FastGeometry() 
		{
			
		}
		
		public function mapTriangle(v1:int, v2:int, v3:int):void 
		{
			
		}
		
		public function addVertex(x:Number, y:Number, u:Number, v:Number):void 
		{
			
		}
		
		public function setVertex(x:Number, y:Number):void
		{
			
		}
		
		public function uploadVertexBuffer(offset:int = 0, length:int = 0):void 
		{
			
		}
		
		public function uploadIndexBuffer(offset:int = 0, length:int = 0):void 
		{
			
		}
		
		public function dispose():void 
		{
			
		}
		
		public function render(renderSupport:RenderSupport):void 
		{
			
		}
		
	}

}