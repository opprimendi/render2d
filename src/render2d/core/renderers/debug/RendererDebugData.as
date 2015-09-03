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
		
		public var driver:String;
		public var profile:String;
		
		
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
		
		private var string:String = "";
		
		public function toString():String 
		{
			string = "[RendererDebugData" +
						
						"\n driver=" + driver + "\n profile=" + profile + 
						
						"\n stateChanges=" + stateChanges + "\n drawCalls=" + drawCalls + "\n materialsUsed=" + materialsUsed + 
						
						"\n geometriesCount=" + geometriesCount + "\n trianglesCount=" + trianglesCount + "\n verticesCount=" + verticesCount +
						
						"\n vertexBuffersUpload=" + vertexBuffersUpload + "\n indexBuffersUpload=" + indexBuffersUpload + "\n programUploaded=" + programUploaded + 
						
						"\n programCreated=" + programCreated + "\n vertexBuffersCreated=" + vertexBuffersCreated + "\n indexBuffersCreated=" + indexBuffersCreated + 
						
						"\n]";
						
			return string;
		}
	}

}