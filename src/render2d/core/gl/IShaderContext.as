package render2d.core.gl 
{
	import flash.display3D.Program3D;
	
	public interface IShaderContext 
	{
		function disposeProgram(program:Program3D):void;
		
		function createProrgam():Program3D;
		
		function setProgram(program3D:Program3D):void;
	}
	
}