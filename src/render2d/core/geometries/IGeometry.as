package render2d.core.geometries 
{
	public interface IGeometry 
	{
		
		function mapTriangle(v1:int, v2:int, v3:int):void;
		
		function addVertexAndUV(x:Number, y:Number, u:Number, v:Number):void;
		
		function setVertexAndUV(i:int, x:Number, y:Number, u:Number, v:Number):void;
		
		function setVertex(i:int, x:Number, y:Number):void;
		
		function setUV(i:int, u:Number, v:Number):void;
	}
	
}