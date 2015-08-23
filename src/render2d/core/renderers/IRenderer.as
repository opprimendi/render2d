package render2d.core.renderers 
{
	import render2d.core.cameras.Camera;
	import render2d.core.display.Renderable;
	public interface IRenderer 
	{
		function configure(width:Number, height:Number):void;
		function render(renderablesList:Vector.<Renderable>, renderablesCount:int, camera:Camera):void;
	}
}