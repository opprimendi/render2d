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
    /** A class that provides constant values for horizontal alignment of objects. */
    public final class HAlign
    {
        /** @private */
        public function HAlign() { throw new Error(); }
        
        /** Left alignment. */
        public static const LEFT:int = 0;
        
        /** Centered alignement. */
        public static const CENTER:int = 1;
        
        /** Right alignment. */
        public static const RIGHT:int = 2;
        
        /** Indicates whether the given alignment string is valid. */
        public static function isValid(hAlign:int):Boolean
        {
            return hAlign == LEFT || hAlign == CENTER || hAlign == RIGHT;
        }
    }
}