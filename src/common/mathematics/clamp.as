/*
 * Copyright (c) 2008-2013 Ray Yee. All rights reserved.
 */
package common.mathematics
{
	/**
	 * returns smallest integer not less than a scalar or each vector component.
	 * x` = x; x` in rang(a, b);
	 */	
	[Inline] public function clamp( x : Number, a : Number, b : Number ):Number
	{
		return max(a, min(b, x));
	}
}