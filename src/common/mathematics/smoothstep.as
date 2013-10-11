/*
 * Copyright (c) 2008-2013 Ray Yee. All rights reserved.
 */
package common.mathematics
{
	/**
	 * Smoothstep is a scalar interpolation function commonly used in computer graphics and video game engines.
	 * The function interpolates smoothly between two input values based on a third one that should be between the first two. The returned value is clamped between 0 and 1. 
	 */	
	[Inline] public function smoothstep( start : Number, end : Number, x : Number ):Number
	{
		//smoothstep(t) = 3*t*t - 2*t*t*t    [0 <= t <= 1]
		//smoothstep_eo(t) = 2*smoothstep((t+1)/2) - 1
		//smootherstep(t) =  6t^5 - 15t^4 + 10t^3

		x = norm( x, start, end );
		
		//smoothstep
//		return 3 * x * x - 2 * x * x * x;
		
		//smoothstep_eo
//		var eo : Number = (x + 1) / 2;
//		return 2 * (3 * eo * eo - 2 * eo * eo * eo) - 1;
		
		//smootherstep
		return x * x * x * ( x * ( x * 6 - 15 ) + 10 );
	}
}