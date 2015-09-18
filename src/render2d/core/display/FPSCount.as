package render2d.core.display 
{
	import flash.utils.getTimer;
	import render2d.core.renderers.RenderSupport;
	import render2d.core.text.DynamicText;
	import render2d.core.text.TextFormat;
	
	/**
	 * ...
	 * @author Asfel
	 */
	public class FPSCount extends DynamicText 
	{
		private var _frames:int;
		private var _startTime:int;
		private var _fps:Number;
		
		public function FPSCount(textFormat:TextFormat) 
		{
			super(textFormat, "0123456789", 2, 100, 100);
		}
		
		override public function render(renderSupport:RenderSupport):void 
		{
			super.render(renderSupport);
			
			// Increment frame count each frame. When more than a second has passed, 
			// display number of accumulated frames and reset.
			// Thus FPS will only be calculated and displayed once per second.
			// There are more responsive methods that calculate FPS on every frame. 
			// This method is uses less CPU and avoids the "jitter" of those other methods.
			_frames++;
			var time:int = getTimer();
			var elapsed:int = time - _startTime;
			if(elapsed >= 1000)
			{
				_fps = Math.round(_frames * 1000 / elapsed);
				_frames = 0;
				_startTime = time;
				draw();
			}
		}
		
		override public function toString():String 
		{
			return "[FPSCount]";
		}
		
		private function draw():void 
		{
			text = _fps.toString();
		}
	}

}