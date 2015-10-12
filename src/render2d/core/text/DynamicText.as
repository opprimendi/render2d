package render2d.core.text 
{
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.VertexBuffer3D;
	import flash.geom.Transform;
	import render2d.core.display.Mesh;
	import render2d.core.geometries.BaseGeometry;
	import render2d.core.materials.BaseMaterial;
	import render2d.core.renderers.RenderSupport;
	import render2d.utils.FastMath;
	
	public class DynamicText extends Mesh 
	{
		private var _text:String;
		private var maxLength:int;
		
		private var charIndexMap:Object = { };
		private var usedChars:Object = { };
		private var charsWidth:Object = { };
		
		private var orderBuffer:VertexBuffer3D;
		private var orderBufferData:Vector.<Number> = new Vector.<Number>;
		
		private var constantsVector:Vector.<Number>;
		
		private var fragmentColorBuffer:Vector.<Number> = new Vector.<Number>(4, true);
		
		private var patternLength:int = 0;
		private var textFormat:TextFormat;
		private var textPattern:String;
		private var textWidth:Number;
		private var textHeight:Number;
		public var width:Number;
		
		public function DynamicText(textFormat:TextFormat, textPattern:String, maxLength:int, textWidth:Number, textHeight:Number, applyGeometry:BaseGeometry = null) 
		{
			this.textHeight = textHeight;
			this.textWidth = textWidth;
			this.maxLength = maxLength;
			this.textPattern = textPattern;
			this.textFormat = textFormat;
			this.maxLength = maxLength;
			
			material = new BaseMaterial(textFormat.font.fontMaterial);
			
			
			patternLength = textPattern.length;
			
			constantsVector = new Vector.<Number>(maxLength * patternLength * 4);
			
			geometry = applyGeometry;
			
			if (geometry == null)
			{
				geometry = new BaseGeometry();
				
				var indicesStep:int = 0;
				
				for (var i:int = 0; i < patternLength; i++)
				{
					var char:String = textPattern.charAt(i);
					
					var charData:BitmapChar = textFormat.font.getChar(char.charCodeAt(0));
						
					var u1:Number = charData.x / textFormat.font.textureWidth;
					var u2:Number = (charData.x + charData.width) / textFormat.font.textureWidth;
					var v1:Number = charData.y / textFormat.font.textureHeight;
					var v2:Number = (charData.y + charData.height) / textFormat.font.textureHeight;
						
					charIndexMap[char] = i;
					usedChars[char] = 0;
						
					for (var j:int = 0; j < maxLength; j++)
					{				
						var delta:int = geometry.vertices.length / 4;
						
						geometry.addVertexAndUV(0, 0, u1, v1);
						geometry.addVertexAndUV(charData.width, 0, u2, v1);
						geometry.addVertexAndUV(charData.width, charData.height, u2, v2);
						geometry.addVertexAndUV(0, charData.height, u1, v2);
						
						geometry.mapTriangle(indicesStep * 4, indicesStep * 4 + 1, indicesStep * 4 + 2);
						geometry.mapTriangle(indicesStep * 4, indicesStep * 4 + 2, indicesStep * 4 + 3);
						
						indicesStep++;
						
						var orderValue:int = 4 + delta / 4;
						
						orderBufferData.push(orderValue, orderValue, orderValue, orderValue);
					}
					
					var index:int = geometry.vertices.length - 16;
					var charWidth:Number = Math.abs(geometry.vertices[index]) + geometry.vertices[index + 8]
					charsWidth[char] = charWidth;
				}
			}
		}
		
		public function clone():DynamicText
		{
			var cloned:DynamicText = new DynamicText(textFormat, textPattern, maxLength, textWidth, textHeight, geometry);
			cloned.blendMode = blendMode;
			cloned.charIndexMap = charIndexMap;
			cloned.orderBufferData = orderBufferData;
			cloned.charsWidth = charsWidth;
			cloned.usedChars = usedChars;
			cloned.samplerData = cloned.samplerData;
			
			return cloned;
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
		
		public function set color(value:uint):void
		{
			material.useColor = true;
			material.a = 1;
			material.r = extractRed(value);
			material.g = extractGreen(value);
			material.b = extractBlue(value);
		}
		
		override public function render(renderSupport:RenderSupport):void 
		{

			if (!orderBuffer)
			{
				orderBuffer = renderSupport.createVertexBuffer(orderBufferData.length, 1);
				renderSupport.uploadVertexBuffer(orderBuffer, orderBufferData, 0, orderBufferData.length);
			}
			
			renderSupport.setVertexBufferAt(2, orderBuffer, 0, Context3DVertexBufferFormat.FLOAT_1);
			renderSupport.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 4, constantsVector);
				
			renderSupport.drawRenderable(this);
			
			renderSupport.setVertexBufferAt(2, null, 0, Context3DVertexBufferFormat.FLOAT_1);
		}
		
		public function set text(value:String):void
		{
			if (value == _text)
				return;
				
			var i:int;
			var char:String;
			
			_text = value;
			
			var len:int = value.length;
			
			if (len > maxLength)
				throw new Error("DynamicText text value is too large");
				
			var x:Number = 0;
			var y:Number = 0;
			
			constantsVector = new Vector.<Number>(maxLength * patternLength * 4);
			
			for (i = 0; i < len; i++)
			{
				char = value.charAt(i);
				
				var charWidth:Number = charsWidth[char];
				
				var bufferIndex:int = (charIndexMap[char] * maxLength + usedChars[char]) * 4;
				
				var constIndex:int = 0;
				constantsVector[bufferIndex + constIndex++] = x;
				constantsVector[bufferIndex + constIndex++] = y;
				constantsVector[bufferIndex + constIndex++] = 1;
				constantsVector[bufferIndex + constIndex++] = -1;

				//var charIndex:int = (charIndexMap[char] * maxLength * 16 + usedChars[char] * 16);
				
				//constantsVector[bufferIndex + constIndex++] = 0;
				//constantsVector[bufferIndex + constIndex++] = 0;
				
				//geometry.vertices[charIndex] = x;
				//geometry.vertices[charIndex + 1] = y;
				
				//geometry.vertices[charIndex + 4] = x;
				//geometry.vertices[charIndex + 4 + 1] = y;
				
				//geometry.vertices[charIndex + 8] = x + charWidth;
				//geometry.vertices[charIndex + 8 + 1] = y;
				
				//geometry.vertices[charIndex + 12] = x + charWidth;
				//geometry.vertices[charIndex + 12 + 1] = y;
				
				x += charWidth;
				
				usedChars[char]++;
			}
			
			this.width = x;
			
			for (i = 0; i < len; i++)
			{
				char = value.charAt(i);
				usedChars[char] = 0;
			}
			
			//geometry.uploadVertexBuffer();
		}
		
		public function get text():String
		{
			return _text;
		}
		
	}

}