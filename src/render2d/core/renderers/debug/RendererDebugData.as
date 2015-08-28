package render2d.core.renderers.debug 
{
	public class RendererDebugData 
	{
	
		public var stateChanges:int = 0;
		
		public var drawCalls:int = 0;
		
		public var materialsUsed:int = 0;
		
		public var geometriesCount:int = 0;
		public var trianglesCount:int = 0;
		public var verticesCount:int = 0;
		
		public var vertexBuffersUpload:int = 0;
		public var indexBuffersUpload:int = 0;;
		
		
		
		
		public var programUploaded:int = 0;
		public var programCreated:int = 0;
		
		public var vertexBuffersCreated:int = 0;
		public var indexBuffersCreated:int = 0;
		
		
		
		
		
		public function RendererDebugData() 
		{
			
		}
		
		public function clear():void 
		{
			drawCalls = 0;
			stateChanges = 0;
			materialsUsed = 0;
			trianglesCount = 0;
			verticesCount = 0;
			vertexBuffersUpload = 0;
			indexBuffersUpload = 0;
			geometriesCount = 0;
		}
		
		public function toString():String 
		{
			return "[RendererDebugData\nstateChanges=" + stateChanges + "\ndrawCalls=" + drawCalls + "\nmaterialsUsed=" + materialsUsed + 
						
						"\ngeometriesCount=" + geometriesCount + "\ntrianglesCount=" + trianglesCount + "\nverticesCount=" + verticesCount +
						
						"\nvertexBuffersUpload=" + vertexBuffersUpload + "\nindexBuffersUpload=" + indexBuffersUpload + "\nprogramUploaded=" + programUploaded + 
						
						"\nprogramCreated=" + programCreated + "\nvertexBuffersCreated=" + vertexBuffersCreated + "\nindexBuffersCreated=" + indexBuffersCreated + "\n]";
		}
	}

}