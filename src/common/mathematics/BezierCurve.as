/*
 * Copyright (c) 2008-2013 Ray Yee. All rights reserved.
 */
package common.mathematics
{

    import common.mathematics.*;
	import flash.geom.Point;

	/**
	 * Quadratic Bezier curve 
	 */	
	public class BezierCurve
	{
		private var a : Point;
		private var b : Point;
		private var c : Point;
		
		/**
		 * Constructor
		 **/
		public function BezierCurve( a : Point, b : Point, c : Point )
		{
			this.a = a;
			this.b = b;
			this.c = c;
		}
		
		public function to( amt : Number, source : Point ):void
		{
			var abx : Number = lerp( a.x, b.x, amt );
			var aby : Number = lerp( a.y, b.y, amt );
			var bcx : Number = lerp( b.x, c.x, amt );
			var bcy : Number = lerp( b.y, c.y, amt );
			
			source.x = lerp( abx, bcx, amt );
			source.y = lerp( aby, bcy, amt );
		}
	}
}