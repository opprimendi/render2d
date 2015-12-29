package render2d.core.display.background 
{
	import flash.display3D.Context3DTextureFilter;
	import flash.display3D.Context3DWrapMode;
	import render2d.core.display.Renderable;
	import render2d.core.materials.BaseMaterial;
	import render2d.core.renderers.RenderSupport;
	import render2d.core.renderers.SamplerData;
	import render2d.core.gl.shading.BackgroundShader;

	
	public class Background extends Renderable 
	{
		
		public function Background(width:Number, height:Number, material:BaseMaterial) 
		{
			super();
			
			this.material = material;
			
			this.geometry = new BackgroundGeometry(width, height);
			samplerData = new SamplerData(Context3DWrapMode.REPEAT, Context3DTextureFilter.ANISOTROPIC8X);
		}
		
		public function resize(width:Number, height:Number, uvScaleW:Number, uvScaleH:Number):void
		{
			(geometry as BackgroundGeometry).resize(width, height, uvScaleW, uvScaleH);
			geometry.uploadVertexBuffer();
		}
		
		override public function toString():String 
		{
			return "[Background]";
		}
		
	}

}