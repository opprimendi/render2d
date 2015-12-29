package render2d.core.materials 
{
	import flash.display3D.Context3D;
	import flash.display3D.textures.TextureBase;
	import render2d.core.display.BlendMode;
	import render2d.core.gl.shading.StandarShders;
	import render2d.core.renderers.SamplerData;

	public class BaseMaterial 
	{
		public var texture:TextureBase;
		
		public var useColor:Boolean = false;
		public var colorBuffer:ColorBuffer = new ColorBuffer();
		
		public var samplerData:SamplerData;
		
		public var shader:int = StandarShders.BASIC_SHADER
		public var blendMode:BlendMode = BlendMode.NORMAL;
		
		public function BaseMaterial(texture:TextureBase) 
		{
			this.texture = texture;
		}
		
		public function setToContext(context3D:Context3D):void 
		{
			context3D.setTextureAt(0, texture);
		}
		
		public function clone():BaseMaterial
		{
			return new BaseMaterial(texture);
		}
	}
}