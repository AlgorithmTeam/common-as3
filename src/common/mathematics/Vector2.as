/*
 * Copyright (c) 2008-2013 Ray Yee. All rights reserved.
 */

package common.mathematics
{

    public class Vector2
    {
        /**
         * horizontal component of the vector
         */
        public var _x : Number;
        /**
         * vertical component of the vector
         */
        public var _y : Number;

        public static const EPSILON : Number = 0.0000001;
        public static const EPSILON_SQUARED : Number = EPSILON * EPSILON;

        /**
         * Constructor
         * @param x
         * @param y
         */
        public function Vector2(x : Number = 0, y : Number = 0)
        {
            _x = x;
            _y = y;
        }

        /**
         * Length of the vector
         */
        public function get length() : Number
        {
            return Math.sqrt(_x * _x + _y * _y);
        }

        public function set length(l : Number) : void
        {
            var a : Number = this.angle;
            _x = l * Math.cos(a);
            _y = l * Math.sin(a);
        }

        /**
         * length of the vector squared
         */
        public function get lengthSquared() : Number
        {
            return _x * _x + _y * _y;
        }

        /**
         * The angle formed by the vector with the horizontal axis
         */
        public function get angle() : Number
        {
            if ( isZero() ) return 0;

            return Math.atan2(_y, _x);
        }

        public function set angle(rads : Number) : void
        {
            var len : Number = this.length;
            _x = len * Math.cos(rads);
            _y = len * Math.sin(rads);
        }

        /**
         * Checking the vector for zero-length
         * @return    true - if the vector is zero
         */
        public function isZero() : Boolean
        {
            return (Math.abs(_x) < EPSILON && Math.abs(_y) < EPSILON);
        }
    }
}
