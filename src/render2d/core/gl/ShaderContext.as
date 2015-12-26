package render2d.core.gl 
{
	import flash.display3D.Context3D;
	import flash.display3D.Program3D;
	
	public class ShaderContext implements IShaderContext
	{
		public var maxPrograms:int;
		public var programsUsed:int;
		
		public var curentProgram:Program3D;
		
		private var context3D:Context3D;
		private var isNeedProgramSet:Boolean;
		private var profile:Profile;
		
		public function ShaderContext(profile:Profile, context3D:Context3D) 
		{
			this.profile = profile;
			this.maxPrograms = profile.maxProgram;
			
			this.context3D = context3D;
		}
		
		public final function disposeProgram(program:Program3D):void
		{
			programsUsed--;
			program.dispose();
		}
		
		public final function createProrgam():Program3D
		{
			programsUsed++;
			return context3D.createProgram();
		}
		
		public final function setProgram(program3D:Program3D):void
		{
			if (curentProgram == program3D)
				return;
				
			curentProgram = program3D;
			isNeedProgramSet = true;
		}
		
		public final function update():void
		{
			if (isNeedProgramSet)
				context3D.setProgram(curentProgram);
		}
	}
}