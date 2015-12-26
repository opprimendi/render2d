package render2d.core.display 
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	
	public class ConstantBuffer 
	{
		private var registerOffset:int;
		
		private var identityVector:Vector.<Number>;
		public var constantsValue:Vector.<Number>;
		
		public var currentRegisterIndex:int = 0;
		
		public var type:String;
		
		public function ConstantBuffer(size:int, type:String = Context3DProgramType.VERTEX) 
		{
			this.type = type;
			constantsValue = new Vector.<Number>(size, true);
			identityVector = new Vector.<Number>(size, true);
		}
		
		public function addValue(value:Number):void
		{
			setValue(currentRegisterIndex++, value);
		}
		
		public function setValue(registerIndex:int, value:Number):void
		{
			constantsValue[registerIndex] = value
		}
		
		public function addFromVector(vector:Vector.<Number>, startFrom:int, length:int):void
		{
			length += startFrom;
			for (var i:int = startFrom; i < length; i++)
			{
				addValue(vector[i]);
			}
		}
		
		public function setVector(vector:Vector.<Number>, startRegisterIndex:int, startFrom:int, length:int):void
		{
			length += startFrom;
			for (var i:int = startFrom; i < length; i++)
			{
				setValue(startRegisterIndex++, vector[i]);
			}
		}
		
		public function upload(context3D:Context3D, registerOffset:int):void
		{
			this.registerOffset = registerOffset;
			context3D.setProgramConstantsFromVector(type, registerOffset, constantsValue, currentRegisterIndex);
		}
		
		public function clear(context3D:Context3D):void
		{
			context3D.setProgramConstantsFromVector(type, registerOffset, identityVector, currentRegisterIndex);
		}
		
		public function clearConstants():void
		{
			currentRegisterIndex = 0;
		}
	}
}