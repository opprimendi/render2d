package render2d.core.gl.texture
{
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.textures.Texture;
	import render2d.core.materials.MipmapGenerator;
	import render2d.utils.FastMath;
	
	public class TextureUploader 
	{
		private var context3D:Context3D;
		
		public var texturesList:Vector.<BitmapTexture> = new Vector.<BitmapTexture>
		
		public function TextureUploader(context3D:Context3D) 
		{
			this.context3D = context3D;
		}
		
		public function update():void
		{
			var texturesListLength:int = texturesList.length;
			for (var i:int = 0; i < texturesListLength; i++)
			{
				var currentTexture:BitmapTexture = texturesList[i];
				
				if (currentTexture.currentMipLevel == -1)
				{
					texturesList.splice(i, 1);
					texturesListLength--;
					i--;
					continue;
				}
				else
				{
					//trace("upload mip", currentTexture.currentMipLevel);
					MipmapGenerator.generateMipMaps(currentTexture.textureSource, currentTexture.nativeTexture, currentTexture.isUseAlpha, -1, currentTexture.currentMipLevel, 1);
				}
					
				currentTexture.currentMipLevel--;
			}
		}
		
		public function uploadTexture(textureSource:BitmapData, isUseMipmaps:Boolean = true):BitmapTexture 
		{
			var mipLevel:int = FastMath.log(textureSource.width, 2);
			var texture:Texture = context3D.createTexture(textureSource.width, textureSource.height, textureSource.transparent? Context3DTextureFormat.COMPRESSED:Context3DTextureFormat.COMPRESSED_ALPHA, false, isUseMipmaps? mipLevel:0);
			
			var textureUploadData:BitmapTexture = new BitmapTexture();
			textureUploadData.currentMipLevel = mipLevel;
			textureUploadData.maxMipLevel = mipLevel;
			textureUploadData.isUseAlpha = textureSource.transparent;
			textureUploadData.nativeTexture = texture;
			textureUploadData.textureSource = textureSource;
			
			textureUploadData.width = textureSource.width;
			textureUploadData.height = textureSource.height;
			
			texturesList.push(textureUploadData);
			
			if (!isUseMipmaps)
			{
				textureUploadData.currentMipLevel = 0;
				textureUploadData.maxMipLevel = 0;
			}
			
			return textureUploadData;
		}
		
	}

}