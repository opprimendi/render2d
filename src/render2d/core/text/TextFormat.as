package render2d.core.text 
{
	import flash.text.TextFieldAutoSize;
	
	public class TextFormat 
	{
		public var fontSize:Number = 12;
		public var color:uint = 0x000000;
		public var hAlign:int = HAlign.CENTER;
		public var vAlign:int = VAlign.CENTER;
		public var bold:Boolean = false;
		public var italic:Boolean = false;
		public var underline:Boolean = false;
		public var autoScale:Boolean = false;
		public var autoSize:String = TextFieldAutoSize.NONE;
		public var kerning:Boolean = false;
		
		public var font:BitmapFont;
		
		public function TextFormat(font:BitmapFont, fontSize:Number = 12) 
		{
			this.font = font;
		}
		
	}

}