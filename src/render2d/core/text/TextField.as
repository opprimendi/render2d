package render2d.core.text 
{
	import render2d.core.display.Mesh;
	import render2d.core.geometries.BaseGeometry;
	import render2d.core.materials.BaseMaterial;
	import render2d.utils.FastMath;
	
	public class TextField extends Mesh
	{
		private var textFormat:TextFormat;
		private var text:String;
		public var w:Number;
		
		public var minX:Number;
		public var maxX:Number;
		
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
				
				minX = 0;
				maxX = 0;
				
				for (var i:int = 0; i < geometry.vertices.length; i+=4)
				{
					minX = Math.min(minX, geometry.vertices[i]);
					maxX = Math.max(maxX, geometry.vertices[i]);
				}
				
				w = Math.abs(minX) + Math.abs(maxX);
			}
			
		
		}
		
		override public function get transformData():Vector.<Number> 
		{
			
			_transformData[0] = x + -((maxX + minX) / 2 * scaleX);
			_transformData[1] = -y;
			
			_transformData[2] = scaleX;
			_transformData[3] = -scaleY;
			
			_transformData[4] = Math.cos(FastMath.convertToRadian(_rotationX));
			_transformData[5] = Math.sin(FastMath.convertToRadian(_rotationX));
			
			return _transformData;
		}
		
		override public function set transformData(value:Vector.<Number>):void 
		{
			super.transformData = value;
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
			textField.minX = minX;
			textField.maxX = maxX;
			textField.w = w;
			
			return textField;
		}
		
		public function dispose():void 
		{
			geometry.dispose();
		}
	}
}