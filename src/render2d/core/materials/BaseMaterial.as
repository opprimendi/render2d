package render2d.core.materials 
{
	import flash.display3D.Context3D;
	import flash.display3D.textures.TextureBase;

	public class BaseMaterial 
	{
		//public var id:int = Ident.next();
		
		public var texture:TextureBase;
		public var useColor:Boolean = false;
		public var r:int;
		public var g:int;
		public var b:int;
		
		//private var _init:Boolean;
		
		public function BaseMaterial(texture:TextureBase) 
		{
			this.texture = texture;
		}
		
		public function render(context3D:Context3D):void 
		{
			//if (!_init)
			//{
			//	_init = true;
			
				context3D.setTextureAt(0, texture);
			//}
		}
		
	}

}