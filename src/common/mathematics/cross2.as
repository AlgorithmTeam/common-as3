/*
 * Copyright (c) 2008-2013 Ray Yee. All rights reserved.
 */
package common.mathematics
{
	/**
	 * 2d vector cross product
	 * 
	 * 		PointC on lineAB left or right
	 * 			cross2( v(B-A), v(C-A) )
	 * 			>0 then on left
	 * 			<0 then on right
	 * 			=0 then on line
	 * 
	 * 		sqrt( cross2(a,b) ) = area(a, b, b-a)
	 */	
	public function cross2( ax : Number, ay : Number, bx : Number, by : Number ):Number
	{
		return ax * by - ay * bx;
	}
}