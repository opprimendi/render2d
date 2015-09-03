package render2d.core.display
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
		
		public var texturesList:Vector.<TextureUploaderData> = new Vector.<TextureUploaderData>
		
		public function TextureUploader(context3D:Context3D) 
		{
			this.context3D = context3D;
		}
		
		public function update():void
		{
			var texturesListLength:int = texturesList.length;
			for (var i:int = 0; i < texturesListLength; i++)
			{
				var currentTexture:TextureUploaderData = texturesList[i];
				
				if (currentTexture.currentMipLevel == -1)
				{
					texturesList.splice(i, 1);
					texturesListLength--;
					i--;
					continue;
				}
				else
					MipmapGenerator.generateMipMaps(currentTexture.textureSource, currentTexture.texture, currentTexture.isUseAlpha, -1, currentTexture.currentMipLevel, 1);
					
				currentTexture.currentMipLevel--;
			}
		}
		
		public function uploadTexture(textureSource:BitmapData):Texture 
		{
			var mipLevel:int = FastMath.log(textureSource.width, 2);
			var texture:Texture = context3D['createTexture'](textureSource.width, textureSource.height, textureSource.transparent? Context3DTextureFormat.BGRA_PACKED:Context3DTextureFormat.BGR_PACKED, false, mipLevel);
			
			var textureUploadData:TextureUploaderData = new TextureUploaderData();
			textureUploadData.currentMipLevel = mipLevel;
			textureUploadData.maxMipLevel = mipLevel;
			//textureUploadData.isUseAlpha = false;
			textureUploadData.isUseAlpha = textureSource.transparent;
			textureUploadData.texture = texture;
			textureUploadData.textureSource = textureSource;
			
			texturesList.push(textureUploadData);
			
			return texture;
		}
		
	}

}