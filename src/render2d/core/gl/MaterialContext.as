package render2d.core.gl 
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.textures.TextureBase;
	import render2d.core.display.ConstantBuffer;
	import render2d.core.materials.BaseMaterial;
	import render2d.core.materials.ColorBuffer;
	import render2d.core.renderers.SamplerData;
	
	public class MaterialContext 
	{
		private var currentMaterial:BaseMaterial;
		private var currentTexture:TextureBase;
		private var samplerData:SamplerData = new SamplerData();
		
		private var profile:Profile;
		private var context3D:Context3D;
		
		private var fragmentBuffer:ConstantBuffer;
		
		public function MaterialContext(profile:Profile, context3D:Context3D) 
		{
			this.profile = profile;
			this.context3D = context3D;
			
			initialize();
		}
		
		private function initialize():void 
		{
			fragmentBuffer = new ConstantBuffer(profile.maxFragmentConstants, Context3DProgramType.FRAGMENT);
			setSamplerTo(0, samplerData);//set default sampler
		}
		
		[Inline]
		public final function drawTriangles():void
		{
			fragmentBuffer.upload(context3D, 0);
		}
		
		public function clear():void
		{
			if (fragmentBuffer.size != 0)
			{
				fragmentBuffer.clear(context3D); 
				fragmentBuffer.clearConstants();
			}
			
			//context3D.setTextureAt(0, null);
		}
		
		[Inline]
		public final function setMaterial(material:BaseMaterial):void
		{
			var texture:TextureBase = material.texture.nativeTexture;
			
			if (currentTexture != texture)
				setTexture(material);
				
			if (currentMaterial.useColor)
			{
				var color:ColorBuffer = currentMaterial.colorBuffer;
				
				if (fragmentBuffer.size < 4 || !color.isEqualToVecotr(fragmentBuffer.constantsValue))
					setColor(color);
			}
			
			if (currentMaterial.samplerData && !SamplerData.isEqual(samplerData, currentMaterial.samplerData))
			{
				samplerData = currentMaterial.samplerData;
				setSamplerTo(0, samplerData);
			}
		}
		
		private function setSamplerTo(samplerIndex:int, sampler:SamplerData):void
		{
			context3D.setSamplerStateAt(0, samplerData.wrapMode, samplerData.filter, samplerData.mipFilter);
		}
		
		[Inline]
		public final function setColor(color:ColorBuffer):void 
		{
			
			fragmentBuffer.setVector(color.buffer, 0, 0, 4);
			fragmentBuffer.size = 4;
		}
		
		private function setTexture(material:BaseMaterial):void 
		{
			this.currentMaterial = material;
			this.currentTexture = material.texture.nativeTexture;
			
			material.setToContext(context3D);
		}
	}
}