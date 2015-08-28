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

    /** A class that provides constant values for vertical alignment of objects. */
    public final class VAlign
    {
        /** @private */
        public function VAlign() { throw new Error(); }
        
        /** Top alignment. */
        public static const TOP:int = 0;
        
        /** Centered alignment. */
        public static const CENTER:int = 1;
        
        /** Bottom alignment. */
        public static const BOTTOM:int = 2;
        
        /** Indicates whether the given alignment string is valid. */
        public static function isValid(vAlign:int):Boolean
        {
            return vAlign == TOP || vAlign == CENTER || vAlign == BOTTOM;
        }
    }
}