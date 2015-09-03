package render2d.core.display.background 
{
	import flash.display3D.Context3DWrapMode;
	import render2d.core.display.Renderable;
	import render2d.core.materials.BaseMaterial;
	import render2d.core.renderers.SamplerData;
	import render2d.core.shading.BackgroundShader;

	
	public class Background extends Renderable 
	{
		
		public function Background(width:Number, height:Number, material:BaseMaterial) 
		{
			super();
			
			this.material = material;
			this.geometry = new BackgroundGeometry(width, height);
			samplerData = new SamplerData(Context3DWrapMode.REPEAT);
		}
		
		public function resize(width:Number, height:Number):void
		{
			
		}
		
		override public function toString():String 
		{
			return "[Background]";
		}
		
	}

}