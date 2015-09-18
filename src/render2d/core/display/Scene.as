package render2d.core.display 
{
	import render2d.core.cameras.Camera;
	import render2d.core.display.background.Background;
	import render2d.core.geometries.BaseGeometry;
	import render2d.core.renderers.DisplayList;
	import render2d.core.renderers.IRenderer;
	
	public class Scene 
	{
		protected var width:Number;
		protected var height:Number;
		
		public var renderer:IRenderer;
		public var displayList:DisplayList = new DisplayList();
		public var camera:Camera = new Camera();
		
		protected var toRenderList:Vector.<Renderable> = new Vector.<Renderable>(5000, true);
		protected var toRenderCount:int = 0;
		
		public function Scene(width:Number, height:Number, renderer:IRenderer) 
		{
			this.height = height;
			this.width = width;
			this.renderer = renderer;
			
			configure(width, height, width, height);
		}
		
		public function configure(width:Number, height:Number, maxWidth:Number, maxHeight:Number):void
		{
			this.height = height;
			this.width = width;
			
			renderer.configure(width, height, maxWidth, maxHeight);
			camera.configure(width, height);
			
			
		}
		
		protected function collectRenderables():void
		{
			//TODO: вынести в отдельный объект коллектор чтобы можно было  юзать разные стратегии. И в нем же сортировать
			
			var renderablesList:Vector.<Renderable> = displayList.list;
			var renderablesCount:int = renderablesList.length;
			
			var minX:Number = camera.minX;
			var maxX:Number = camera.maxX;
			var minY:Number = camera.minY;
			var maxY:Number = camera.maxY;
			
			toRenderCount = 0;
			
			for (var i:int = 0; i < renderablesCount; i++)
			{
				var renderable:Renderable = renderablesList[i];
				
				if (renderable is Background)
				{
					toRenderList[toRenderCount] = renderable;
					toRenderCount++;
					
					continue;
				}
				
				//if (!renderable.visible)
				//	continue;
				
				var geometry:BaseGeometry = renderable.geometry;
				
				if (!(renderable is FPSCount))
				{
					if (renderable.x + geometry.maxX < minX || renderable.x + geometry.minX > maxX)
						continue;
						
					if (renderable.y + geometry.maxY < minY || renderable.y + geometry.minY > maxY)
						continue;
				}
				
				toRenderList[toRenderCount] = renderable;
				toRenderCount++;
			}
		}
		
		public function update():void
		{
			collectRenderables();
			
			renderer.render(toRenderList, toRenderCount, camera);
		}
	}
}