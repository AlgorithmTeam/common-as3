/*
 * Copyright (c) 2008-2013 Ray Yee. All rights reserved.
 */

package common.effect.map
{
	import flash.display.BitmapData;

	public class LensMapBitmap
	{
		/**
		 * Creates a displacement map for the fisheye lens effect.
		 *
		 * @param diameter 	The diameter of the lens to create.
		 * @param amount 	The amount of distortion the map should enable.
		 *
		 * @return The map needed for the displacement.
		 */
		public static function createFisheyeLens(diameter:uint, amount:Number = 0.8):BitmapData
		{
			// by default, map is filled with medium gray, which results in no displacement
			var lens:BitmapData = new BitmapData(diameter, diameter, false, 0xFF808080);
			// values are the same, but kept separate just for clarity
			var center:Number = diameter / 2;
			var radius:Number = center;
			// run through full height of map
			for (var y:uint = 0; y < diameter; ++y)
			{
				// current y coordinate in relation to the center of the map
				var ycoord:int = y - center;
				// run through full width of map
				for (var x:uint = 0; x < diameter; ++x)
				{
					// current x coordinate in relation to the center of the map
					var xcoord:int = x - center;
					// the distance from the current coordinates to the map center
					var distance:Number = Math.sqrt(xcoord * xcoord + ycoord * ycoord);
					// only if we are within the radius of the lens do we need to recolor
					if (distance < radius)
					{
						// a number between 0 and 1 based on the distance from center and the amount of distortion
						var t:Number = Math.pow(Math.sin(Math.PI / 2 * distance / radius), amount);
						// the amount of distortion on each axis determines the amount to recolor
						// the pixel at the current coordinate, using the blue channel for horizontal distortion
						// and the green channel for vertical distortion
						var dx:Number = xcoord * (t - 1) / diameter;
						var dy:Number = ycoord * (t - 1) / diameter;
						var blue:uint = 0x80 + dx * 0xFF;
						var green:uint = 0x80 + dy * 0xFF;
						lens.setPixel(x, y, green << 8 | blue);
					}
				}
			}
			return lens;
		}
	}
}