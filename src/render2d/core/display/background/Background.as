package render2d.core.display.background 
{
	import flash.display3D.Context3DMipFilter;
	import flash.display3D.Context3DTextureFilter;
	import flash.display3D.Context3DWrapMode;
	import render2d.core.display.Renderable;
	import render2d.core.gl.shading.StandarShders;
	import render2d.core.materials.BaseMaterial;
	import render2d.core.renderers.SamplerData;

	
	public class Background extends Renderable 
	{
		
		public function Background(width:Number, height:Number, material:BaseMaterial) 
		{
			super();
			
			this.material = material;
			material.samplerData = new SamplerData(Context3DWrapMode.REPEAT, Context3DTextureFilter.LINEAR, Context3DMipFilter.MIPLINEAR);
			material.shader = StandarShders.BACKGROUND_SHADER;
			
			this.geometry = new BackgroundGeometry(width, height);
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