package common.mathematics
{
    /**
     *   A generic lookup table useful for caching the results of a function
     *   @author Jackson Dunstan
     */
    public class LUT
    {
        /** Table of function values*/
        public var table:Vector.<Number>;

        /** 10^decimals of precision*/
        public var pow:Number;

        /**
         *   Make the look up table
         *   @param max Maximum value to cache
         *   @param numDigits Number of digits places of precision
         *   @param func Function to call to generate stored values.
         *               Must be valid on [0,max).
         *   @throws Error If func is null or invalid on [0,max)
         */
        public function LUT(numDigits:uint, max:Number, func:Function)
        {
            var pow:Number = this.pow = Math.pow(10, numDigits);
            var round:Number = 1.0 / pow;
            var len:uint = 1 + max*pow;
            var table:Vector.<Number> = this.table = new Vector.<Number>(len);

            var val:Number = 0;
            for (var i:uint = 0; i < len; ++i)
            {
                table[i] = func(val);
                val += round;
            }
        }

        /**
         *   Look up the value of the given input
         *   @param val Input value to look up the value of
         *   @return The value of the given input
         */
        public function val(val:Number): Number
        {
            return this.table[int(val*this.pow)];
        }
    }
}