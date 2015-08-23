package render2d.core.error 
{
	public class AbstractMethodError extends Error 
	{
		public function AbstractMethodError(methodName:String) 
		{
			super("Abstract method " + methodName + " should be overridden", 0);
		}
	}

}