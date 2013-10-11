/*
 * Copyright (c) 2008-2013 Ray Yee. All rights reserved.
 */
package common.mathematics
{
	/**
	 * 2d vector mod 
	 */	
	public function mod( x : Number, y : Number ):Number
	{
		return Math.sqrt( x * x + y * y );
	}
}