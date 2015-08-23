package render2d.core.renderers 
{
	import render2d.core.display.Mesh;
	import render2d.core.display.Renderable;
	
	public class DisplayList 
	{
		public var list:Vector.<Renderable> = new Vector.<Renderable>;
		
		public function DisplayList() 
		{
			
		}
		
		public function add(mesh:Mesh):void
		{
			list.push(mesh);
		}
		
	}

}