package render2d.core.gl.texture
{
	import flash.display.BitmapData;
	import flash.display3D.textures.TextureBase;
	
	public class BitmapTexture 
	{
		public var nativeTexture:TextureBase;
		public var textureSource:BitmapData;
		
		public var currentMipLevel:int;
		public var maxMipLevel:int;
		
		public var isUseAlpha:Boolean;
		
		public var width:Number;
		public var height:Number;
		
		public function BitmapTexture() 
		{
			
		}
		
	}

}