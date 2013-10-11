/*
 * Copyright (c) 2008-2013 Ray Yee. All rights reserved.
 */
package common.mathematics
{
	/**
	 * Normalizes a number from another range into a value between 0 and 1. 
	 */	
	[Inline] public function norm( value : Number, start : Number, end : Number ) : Number
	{
		return ( value - start ) / ( end - start );
	}
}