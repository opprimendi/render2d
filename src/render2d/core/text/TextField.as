package render2d.core.text 
{
	import render2d.core.display.Mesh;
	import render2d.core.geometries.BaseGeometry;
	import render2d.core.materials.BaseMaterial;
	
	public class TextField extends Mesh
	{
		private var textFormat:TextFormat;
		
		public var textWidth:Number;
		public var textHeight:Number;
		
		public function TextField(text:String, textWidth:Number, textHeight:Number, textFormat:TextFormat) 
		{
			this.textHeight = textHeight;
			this.textWidth = textWidth;
			this.textFormat = textFormat;
			
			geometry = new BaseGeometry();
			this.material = new BaseMaterial(textFormat.font.fontMaterial);
			
			textFormat.font.fillBatched(geometry.vertices, geometry.indecis, textWidth, textHeight, text, textFormat.fontSize, textFormat.hAlign, textFormat.vAlign);
		}
		
		
		
	}

}