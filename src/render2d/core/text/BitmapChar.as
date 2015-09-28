// =================================================================================================
//
//	Starling Framework
//	Copyright 2011-2014 Gamua. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package render2d.core.text
{
    /** A BitmapChar contains the information about one char of a bitmap font.  
     *  <em>You don't have to use this class directly in most cases. 
     *  The TextField class contains methods that handle bitmap fonts for you.</em>    
     */ 
    public class BitmapChar
    {
		/** The unicode ID of the char. */
		public var charID:int;

		/** The number of points to move the char in x direction on character arrangement. */
		public var xOffset:Number;

		/** The number of points to move the char in y direction on character arrangement. */
		public var yOffset:Number;

		/** The number of points the cursor has to be moved to the right for the next char. */
		public var xAdvance:Number;

		/** The width of the character in points. */
		public var kernings:Object;

		public var x:Number;

		public var y:Number;

		public var width:Number;

		/** The height of the character in points. */
		public var height:Number;
		
		public function toString():String 
		{
			return "[BitmapChar charID=" + charID + " xOffset=" + xOffset + " yOffset=" + yOffset + " xAdvance=" + xAdvance + 
						" kernings=" + kernings + " x=" + x + " y=" + y + " width=" + width + " height=" + height + 
						"]";
		}

        /** Creates a char with a texture and its properties. */
        public function BitmapChar(id:int, x:Number, y:Number, width:Number, height:Number,
                                   xOffset:Number, yOffset:Number, xAdvance:Number)
        {
            charID = id;
            this.xOffset = xOffset;
            this.yOffset = yOffset;
            this.xAdvance = xAdvance;
            kernings = null;
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
        }
        
        /** Adds kerning information relative to a specific other character ID. */
        public function addKerning(charID:int, amount:Number):void
        {
            if (kernings == null)
			{
                kernings = { };
			}
            
            kernings[charID] = amount;
        }
        
        /** Retrieve kerning information relative to the given character ID. */
        public function getKerning(charID:int):Number
        {
			if (kernings == null)
				return 0.0;
			
			var kerning:Number = kernings[charID];
			
			if (isNaN(kerning))
				return 0.0;
			else
				return kerning;
        }
    }
}