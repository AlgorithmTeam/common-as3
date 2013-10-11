/*
 * Copyright (c) 2008-2013 Ray Yee. All rights reserved.
 */
package common.color
{

    import flash.geom.ColorTransform;

    public class ColorUtil
    {
        /**
         * Constructor
         **/
        public function ColorUtil()
        {
        }

        /**
         * RGBColorTransform Create an instance of the information.
         * @ Param rgb RGB integer value that indicates (0x000000 - 0xFFFFFF)
         * @ Param amount of fill adaptive value (0.0 - 1.0)
         * @ Param alpha transparency (0.0 - 1.0)
         * @ Return a new instance ColorTransform
         * */
        public static function colorTransform(rgb : uint = 0, amount : Number = 1.0, alpha : Number = 1.0) : ColorTransform
        {
            amount = (amount > 1) ? 1 : (amount < 0) ? 0 : amount;
            alpha = (alpha > 1) ? 1 : (alpha < 0) ? 0 : alpha;
            var r : Number = ((rgb >> 16) & 0xff) * amount;
            var g : Number = ((rgb >> 8) & 0xff) * amount;
            var b : Number = (rgb & 0xff) * amount;
            var a : Number = 1 - amount;
            return new ColorTransform(a, a, a, alpha, r, g, b, 0);
        }

        /**
         * Subtraction.
         * 2 RGB single number that indicates (0x000000 0xFFFFFF up from) is subtracted
         * from the return numbers.
         * @ Param col1 RGB numbers show (0x000000 0xFFFFFF up from)
         * @ Param col2 RGB numbers show (0x000000 0xFFFFFF up from)
         * @ Return value subtracted Blend
         **/
        public static function subtract(col1 : uint, col2 : uint) : uint
        {
            var colA : Array = toRGB(col1);
            var colB : Array = toRGB(col2);
            var r : uint = Math.max(Math.max(colB [0] - (256 - colA [0]),
                    colA [0] - (256 - colB [0])), 0);
            var g : uint = Math.max(Math.max(colB [1] - (256 - colA [1]),
                    colA [1] - (256 - colB [1])), 0);
            var b : uint = Math.max(Math.max(colB [2] - (256 - colA [2]),
                    colA [2] - (256 - colB [2])), 0);
            return r << 16 | g << 8 | b;
        }

        /**
         * Additive color.
         * 2 RGB single number that indicates (0x000000 0xFFFFFF up from) Returns the value
         * of the additive mixture.
         * @ Param col1 RGB numbers show (0x000000 0xFFFFFF up from)
         * @ Param col2 RGB numbers show (0x000000 0xFFFFFF up from)
         * @ Return the additive color
         **/
        public static function sum(col1 : uint, col2 : uint) : uint
        {
            var c1 : Array = toRGB(col1);
            var c2 : Array = toRGB(col2);
            var r : uint = Math.min(c1 [0] + c2 [0], 255);
            var g : uint = Math.min(c1 [1] + c2 [1], 255);
            var b : uint = Math.min(c1 [2] + c2 [2], 255);
            return r << 16 | g << 8 | b;
        }

        /**
         * Subtractive.
         * 2 RGB single number that indicates (0x000000 0xFFFFFF up from) Returns the value
         * of the subtractive color.
         * @ Param col1 RGB numbers show (0x000000 0xFFFFFF up from)
         * @ Param col2 RGB numbers show (0x000000 0xFFFFFF up from)
         * @ Return the subtractive
         **/
        public static function sub(col1 : uint, col2 : uint) : uint
        {
            var c1 : Array = toRGB(col1);
            var c2 : Array = toRGB(col2);
            var r : uint = Math.max(c1 [0] - c2 [0], 0);
            var g : uint = Math.max(c1 [1] - c2 [1], 0);
            var b : uint = Math.max(c1 [2] - c2 [2], 0);
            return r << 16 | g << 8 | b;
        }

        /**
         * Comparison (dark).
         * 2 RGB single number that indicates (0x000000 0xFFFFFF up from) to compare,
         * RGB lower combined returns a numeric value for each number.
         * @ Param col1 RGB numbers show (0x000000 0xFFFFFF up from)
         * @ Param col2 RGB numbers show (0x000000 0xFFFFFF up from)
         * @ Return comparison (dark) values
         **/
        public static function min(col1 : uint, col2 : uint) : uint
        {
            var c1 : Array = toRGB(col1);
            var c2 : Array = toRGB(col2);
            var r : uint = Math.min(c1 [0], c2 [0]);
            var g : uint = Math.min(c1 [1], c2 [1]);
            var b : uint = Math.min(c1 [2], c2 [2]);
            return r << 16 | g << 8 | b;
        }

        /**
         * Comparison (light).
         * 2 RGB single number that indicates (0x000000 0xFFFFFF up from) to compare,
         * RGB values combined with higher returns to their numbers.
         * @ Param col1 RGB numbers show (0x000000 0xFFFFFF up from)
         * @ Param col2 RGB numbers show (0x000000 0xFFFFFF up from)
         * @ Return comparison (light) value
         **/
        public static function max(col1 : uint, col2 : uint) : uint
        {
            var c1 : Array = toRGB(col1);
            var c2 : Array = toRGB(col2);
            var r : uint = Math.max(c1 [0], c2 [0]);
            var g : uint = Math.max(c1 [1], c2 [1]);
            var b : uint = Math.max(c1 [2], c2 [2]);
            return r << 16 | g << 8 | b;
        }

        /**
         *    Values calculated from each RGB * RGB color value.
         * @ Param r the red (R) indicating the number (0-255)
         * @ Param g green (G) indicates the number (0-255)
         * @ Param b blue (B) shows the number (0-255)
         * @ Return obtained from the RGB color value for each indicating the number
         **/
        public static function rgb(r : uint, g : uint, b : uint) : uint
        {
            return r << 16 | g << 8 | b;
        }

        /**
         * HSV calculated from the numbers of each RGB color value.
         * @ Param h hue (Hue) number that indicates (to 360-0)
         * @ Param s the saturation (Saturation) shows the number (0.0 to 1.0)
         * @ Param v lightness (Value) indicates the number (0.0 to 1.0)
         * @ Return obtained from the RGB color value for each indicating the number
         **/
        public static function hsv(h : int, s : Number, v : Number) : uint
        {
            return rgb.apply(null, HSVtoRGB(h, s, v));
        }

        /**
         * RGB figures show (0x000000 0xFFFFFF up from) the
         * R, G, B returns an array divided into a number from 0 to 255, respectively.
         *
         * @ Param rgb RGB numbers show (0x000000 0xFFFFFF up from)
         * @ Return array indicates the value of each color [R, G, B]
         **/
        public static function toRGB(rgb : uint) : Array
        {
            var r : uint = rgb >> 16 & 0xFF;
            var g : uint = rgb >> 8 & 0xFF;
            var b : uint = rgb & 0xFF;
            return [r, g, b];
        }

        /**
         * RGB from the respective figures, HSV sequences in terms of returns.
         * RGB values are as follows.
         * R - a number from 0 to 255
         * G - a number from 0 to 255
         * B - a number from 0 to 255
         *
         * HSV values are as follows.
         * H - a number between 360-0
         * S - number between 0 and 1.0
         * V - number between 0 and 1.0
         *
         * Can not compute, including alpha.
         * @ Param r the red (R) indicating the number (0x00 to 0xFF to)
         * @ Param g green (G) indicates the number (0x00 to 0xFF to)
         * @ Param b blue (B) shows the number (0x00 to 0xFF to)
         * @ Return HSV values into an array of [H, S, V]
         **/
        public static function RGBtoHSV(r : Number, g : Number, b : Number) : Array
        {
            r /= 255;
            g /= 255;
            b /= 255;
            var h : Number = 0, s : Number = 0, v : Number = 0;
            var x : Number, y : Number;
            if ( r >= g ) x = r;
            else x = g;
            if ( b > x ) x = b;
            if ( r <= g ) y = r;
            else y = g;
            if ( b < y ) y = b;
            v = x;
            var c : Number = x * y;
            if ( x == 0 ) s = 0;
            else s = c / x;
            if ( s != 0 )
            {
                if ( r == x )
                {
                    h = (g * b) / c;
                }
                else
                {
                    if ( g == x )
                    {
                        h = 2 + (b * r) / c;
                    }
                    else
                    {
                        if ( b == x )
                        {
                            h = 4 + (r * g) / c;
                        }
                    }
                }
                h = h * 60;
                if ( h < 0 ) h = h + 360;
            }
            return [h, s, v];
        }

        /**
         * RGB from the respective figures, HSV sequences in terms of returns.
         * RGB values are as follows.
         * R - a number from 0 to 255
         * G - a number from 0 to 255
         * B - a number from 0 to 255
         *
         * CMYK values are as follows.
         * C - a number between 0 to 255 representing cyan
         * M - number between 0 to 255 representing magenta
         * Y - number between 0 to 255 representing yellow
         * K - number between 0 to 255 representing black
         *
         * Can not compute, including alpha.
         * @ Param r the red (R) indicating the number (0x00 to 0xFF to)
         * @ Param g green (G) indicates the number (0x00 to 0xFF to)
         * @ Param b blue (B) shows the number (0x00 to 0xFF to)
         * @ Return CMYK values into an array of [H, S, V]
         **/
        public static function RGBtoCMYK(r : Number, g : Number, b : Number) : Array
        {
            var c : Number = 0, m : Number = 0, y : Number = 0, k : Number = 0, z : Number = 0;
            c = 255 - r;
            m = 255 - g;
            y = 255 - b;
            k = 255;

            if ( c < k )
                k = c;
            if ( m < k )
                k = m;
            if ( y < k )
                k = y;
            if ( k == 255 )
            {
                c = 0;
                m = 0;
                y = 0;
            }
            else
            {
                c = Math.round(255 * (c - k) / (255 - k));
                m = Math.round(255 * (m - k) / (255 - k));
                y = Math.round(255 * (y - k) / (255 - k));
            }
            return [ c, m, y, k ];
        }

        /**
         * HSV from each of the RGB values to determine a return as an array.
         * RGB values are as follows.
         * R - a number from 0 to 255
         * G - a number from 0 to 255
         * B - a number from 0 to 255
         *
         * HSV values are as follows.
         * H - a number between 360-0
         * S - number between 0 and 1.0
         * V - number between 0 and 1.0
         *
         * H is replaced with equivalent numbers in the range of the 360-0 that is out of range.
         * Can not compute, including alpha.
         *
         * @ Param h hue (Hue) number that indicates (to 360-0)
         * @ Param s the saturation (Saturation) shows the number (0.0 to 1.0)
         * @ Param v lightness (Value) indicates the number (0.0 to 1.0)
         * @ Return RGB values into an array of [R, G, B]
         **/
        public static function HSVtoRGB(h : Number, s : Number, v : Number) : Array
        {
            var r : Number = 0, g : Number = 0, b : Number = 0;
            var i : Number, x : Number, y : Number, z : Number;
            if ( s < 0 ) s = 0;
            if ( s > 1 ) s = 1;
            if ( v < 0 ) v = 0;
            if ( v > 1 ) v = 1;
            h = h % 360;
            if ( h < 0 ) h += 360;
            h /= 60;
            i = h >> 0;
            x = v * (1 - s);
            y = v * (1 - s * (h - i));
            z = v * (1 - s * (1 - h + i));
            switch ( i )
            {
                case 0:
                    r = v;
                    g = z;
                    b = x;
                    break;
                case 1:
                    r = y;
                    g = v;
                    b = x;
                    break;
                case 2:
                    r = x;
                    g = v;
                    b = z;
                    break;
                case 3:
                    r = x;
                    g = y;
                    b = v;
                    break;
                case 4:
                    r = z;
                    g = x;
                    b = v;
                    break;
                case 5:
                    r = v;
                    g = x;
                    b = y;
                    break;
            }
            return [r * 255 >> 0, g * 255 >> 0, b * 255 >> 0];
        }

        /**
         * RGB from each of the CMYK values to determine a return as an array.
         * CMYK values are as follows.
         * C - a number between 0 to 255 representing cyan
         * M - number between 0 to 255 representing magenta
         * Y - number between 0 to 255 representing yellow
         * K - number between 0 to 255 representing black
         *
         **/
        public static function CMYKtoRGB(c : Number, m : Number, y : Number, k : Number) : Array
        {
            c = 255 - c;
            m = 255 - m;
            y = 255 - y;
            k = 255 - k;
            return [
                (255 - c) * (255 - k) / 255,
                (255 - m) * (255 - k) / 255,
                (255 - y) * (255 - k) / 255];
        }
    }
}