package render2d.core.display 
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import render2d.core.renderers.RenderSupport;
	
	public class BlendMode 
	{
		public static const NORMAL:BlendMode	= new BlendMode(Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO);
		public static const LAYER:BlendMode		= new BlendMode(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
		public static const MULTIPLY:BlendMode	= new BlendMode(Context3DBlendFactor.ZERO, Context3DBlendFactor.SOURCE_COLOR);
		public static const ADD:BlendMode		= new BlendMode(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE);
		public static const ALPHA:BlendMode		= new BlendMode(Context3DBlendFactor.ZERO, Context3DBlendFactor.SOURCE_ALPHA);
		public static const SCREEN:BlendMode	= new BlendMode(Context3DBlendFactor.ONE, Context3DBlendFactor.ONE_MINUS_SOURCE_COLOR);
		public static const ALPHA2:BlendMode	= new BlendMode(Context3DBlendFactor.ONE, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
		//Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA
		public var src:String;
		public var dst:String;
		
		public function BlendMode(src:String, dst:String) 
		{
			this.dst = dst;
			this.src = src;
		}
		
		public function applyBlendMode(context3D:Context3D):void
		{
			context3D.setBlendFactors(src, dst);
		}
	}
}