package render2d.core.geometries 
{
	import render2d.core.renderers.RenderSupport;
	
	public interface IGeometry 
	{
		
		function mapTriangle(v1:int, v2:int, v3:int):void;
		
		function addVertexAndUV(x:Number, y:Number, u:Number, v:Number):void;
		
		function setVertexAndUv(i:int, x:Number, y:Number, u:Number, v:Number):void;
		
		function setVertex(i:int, x:Number, y:Number):void;
		
		function setUV(i:int, u:Number, v:Number):void;
	}
	
}