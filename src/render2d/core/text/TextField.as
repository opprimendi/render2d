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
				textFormat.font.fillBatched(geometry.vertices, geometry.indecis, textWidth, textHeight, this.text, textFormat.fontSize, textFormat.hAlign, textFormat.vAlign);
			}
		}
		
		override public function toString():String 
		{
			return "[TextField]";
		}
		
		public function clone():TextField
		{
			var textField:TextField = new TextField(text, textWidth, textHeight, textFormat, false);
			textField.geometry = this.geometry;
			textField.shader = shader;
			
			return textField;
		}
		
		public function dispose():void 
		{
			geometry.dispose();
		}
	}
}