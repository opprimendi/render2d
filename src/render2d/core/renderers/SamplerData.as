package render2d.core.renderers 
{
	import flash.display3D.Context3DMipFilter;
	import flash.display3D.Context3DTextureFilter;
	import flash.display3D.Context3DWrapMode;
	
	public class SamplerData 
	{
		public var wrapMode:String;
		public var filter:String;
		public var mipFilter:String;
		
		public function SamplerData(wrapMode:String = Context3DWrapMode.CLAMP, filter:String = Context3DTextureFilter.LINEAR, mipFilter:String = Context3DMipFilter.MIPLINEAR) 
		{
			this.mipFilter = mipFilter;
			this.filter = filter;
			this.wrapMode = wrapMode;
		}
		
		public function toString():String 
		{
			return "[SamplerData wrapMode=" + wrapMode + " filter=" + filter + " mipFilter=" + mipFilter + "]";
		}
		
		[Inline]
		public static function isEqual(samplerA:SamplerData, samplerB:SamplerData):Boolean
		{
			return samplerA == samplerB || !(samplerA.wrapMode != samplerB.wrapMode || samplerA.filter != samplerB.filter || samplerA.mipFilter != samplerB.mipFilter);
		}
	}

}