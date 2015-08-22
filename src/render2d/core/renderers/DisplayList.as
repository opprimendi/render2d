package render2d.core.renderers 
{
	import render2d.core.display.Mesh;
	/**
	 * ...
	 * @author Asfel
	 */
	public class DisplayList 
	{
		public var list:Vector.<Mesh> = new Vector.<Mesh>;
		
		public function DisplayList() 
		{
			
		}
		
		public function add(mesh:Mesh):void
		{
			list.push(mesh);
		}
		
	}

}