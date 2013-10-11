/*
 * Copyright (c) 2008-2013 Ray Yee. All rights reserved.
 */
package common.mathematics
{
	import flash.utils.getTimer;

	/**
	 *  var random:Random = new Random(777); // fixed seed
	    trace( random.getNext() ); // 0.7393220608912693
	    trace( random.getNext() ); // 0.017692924714110075
	    trace( random.getNext() ); // 0.08819738521431512
	    trace( random.getNext() ); // 0.5297092030592517 
	 * @author rayyee
	 */	
	public class Random
	{
		
		private const MAX_RATIO:Number = 1 / uint.MAX_VALUE;
		private var r:uint;
		
		/**
		 * Constructor
		 **/
		public function Random(seed:uint = 0)
		{
			r = seed || getTimer();
		}
		
		//  returns a random Number from 0 – 1
		public function getNext():Number
		{
			r ^= (r << 21);
			r ^= (r >>> 35);
			r ^= (r << 4);
			return (r * MAX_RATIO);
		}
	}
}