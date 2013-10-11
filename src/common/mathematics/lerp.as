/*
 * Copyright (c) 2008-2013 Ray Yee. All rights reserved.
 */
package common.mathematics
{
	/**
	 * Calculates a number between two numbers at a specific increment. 
	 * The amt parameter is the amount to interpolate between the two values where 0.0 equal to the first point, 0.1 is very near the first point, 0.5 is half-way in between, etc. 
	 * The lerp function is convenient for creating motion along a straight path and for drawing dotted lines.
	 */	
	[Inline] public function lerp( start : Number, end : Number, amt : Number ) : Number
	{
		return start + ( end - start ) * amt;
	}
}