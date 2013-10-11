/*
 * Copyright (c) 2008-2013 Ray Yee. All rights reserved.
 */
package common.mathematics
{
	/**
	 * Re-maps a number from one range to another. 
	 * In the example above, the number '25' is converted from a value in the range 0..100 into a value that ranges from the left edge (0) to the right edge (width) of the screen. 
	 */	
	[Inline] public function map( value : Number, start1 : Number, stop1 : Number, start2 : Number, stop2 : Number ) : Number
	{
			return start2 + ( stop2 - start2 ) * ( ( value - start1 ) / ( stop1 - start1 ) );
	}
}