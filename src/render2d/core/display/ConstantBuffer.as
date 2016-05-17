package render2d.core.display 
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.geom.Matrix;
	import render2d.core.geometries.Transform;
	import render2d.core.geometries.transform_inner;
	
	use namespace transform_inner;
	
	public class ConstantBuffer 
	{
		private var registerOffset:int;
		
		private var identityVector:Vector.<Number>;
		public var constantsValue:Vector.<Number>;
		
		public var size:int = 0;
		
		public var type:String;
		
		public function ConstantBuffer(size:int, type:String = Context3DProgramType.VERTEX) 
		{
			this.type = type;
			constantsValue = new Vector.<Number>(size, true);
			identityVector = new Vector.<Number>(size, true);
		}
		
		[Inline]
		public final function fillTransform(transform:Transform):void
		{
			var matrix:Matrix = transform.transformMatrix
			
			constantsValue[size++] = matrix.a;
			constantsValue[size++] = matrix.b;
			constantsValue[size++] = 0;
			constantsValue[size++] = matrix.tx;
			
			constantsValue[size++] = matrix.c;
			constantsValue[size++] = matrix.d;
			constantsValue[size++] = 0;
			constantsValue[size++] = matrix.ty;
		}
		
		[Inline]
		public final function addValue(value:Number):void
		{
			setValue(size++, value);
		}
		
		[Inline]
		public final function setValue(registerIndex:int, value:Number):void
		{
			constantsValue[registerIndex] = value
		}
		
		[Inline]
		public final function addFromVector(vector:Vector.<Number>, startFrom:int, length:int):void
		{
			length += startFrom;
			for (var i:int = startFrom; i < length; i++)
			{
				addValue(vector[i]);
			}
		}
		
		[Inline]
		public final function setVector(vector:Vector.<Number>, startRegisterIndex:int, startFrom:int, length:int):void
		{
			length += startFrom;
			for (var i:int = startFrom; i < length; i++)
			{
				setValue(startRegisterIndex++, vector[i]);
			}
		}
		
		[Inline]
		public final function upload(context3D:Context3D, registerOffset:int):void
		{
			if (size == 0)
				return;
			
			this.registerOffset = registerOffset;
			context3D.setProgramConstantsFromVector(type, registerOffset, constantsValue, size / 4);
		}
		
		[Inline]
		public final function clear(context3D:Context3D):void
		{
			if (size == 0)
				return;
				
			registerOffset = 0;
			context3D.setProgramConstantsFromVector(type, registerOffset, identityVector, size / 4);
		}
		
		[Inline]
		public final function clearConstants():void
		{
			size = 0;
		}
	}
}