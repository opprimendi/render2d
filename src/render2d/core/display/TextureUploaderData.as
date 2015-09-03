package render2d.core.display
{
	import flash.display.BitmapData;
	import flash.display3D.textures.Texture;
	
	public class TextureUploaderData 
	{
		public var texture:Texture;
		public var textureSource:BitmapData;
		public var currentMipLevel:int;
		public var maxMipLevel:int;
		public var isUseAlpha:Boolean;
		
		public function TextureUploaderData() 
		{
			
		}
		
	}

}