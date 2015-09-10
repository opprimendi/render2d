package render2d.core.text 
{
	import render2d.core.display.Mesh;
	import render2d.core.geometries.BaseGeometry;
	import render2d.core.materials.BaseMaterial;
	
	public class TextField extends Mesh
	{
		private var textFormat:TextFormat;
		private var text:String;
		
		public var textWidth:Number;
		public var textHeight:Number;
		
		public function TextField(text:String, textWidth:Number, textHeight:Number, textFormat:TextFormat, isGenerateGeometry:Boolean = true) 
		{
			this.text = text;
			this.textHeight = textHeight;
			this.textWidth = textWidth;
			this.textFormat = textFormat;
			
			this.material = new BaseMaterial(textFormat.font.fontMaterial);
			
			if (isGenerateGeometry)
			{
				geometry = new BaseGeometry();
				textFormat.font.fillBatched(geometry.vertices, geometry.indecis, textWidth, textHeight, text, textFormat.fontSize, textFormat.hAlign, textFormat.vAlign);
			}
		}
		
		override public function toString():String 
		{
			return "[TextField]";
		}
		
		[Inline]
		private static function extractRed(c:uint):int 
		{
			return (( c >> 16 ) & 0xFF);
		}
			 
		[Inline]
		private static function extractGreen(c:uint):int 
		{
			return ( (c >> 8) & 0xFF );
		}
			 
		[Inline]
		private static function extractBlue(c:uint):int 
		{
			return ( c & 0xFF );
		}
		
		public function applyColor(color:int):void
		{
			material.useColor = true;
			material.r = extractRed(color)/255;
			material.g = extractGreen(color)/255;
			material.b = extractBlue(color)/255;
			material.a = 2;
		}
		
		public function clone():TextField
		{
			var textField:TextField = new TextField(text, textWidth, textHeight, textFormat, false);
			textField.geometry = this.geometry;
			
			return textField;
		}
		
		public function dispose():void 
		{
			geometry.dispose();
		}
	}
}