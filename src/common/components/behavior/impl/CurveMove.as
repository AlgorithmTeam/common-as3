/*
 * Copyright (c) 2008-2013 Ray Yee. All rights reserved.
 */

package common.components.behavior.impl
{

    import common.components.behavior.api.IMove;

    import org.osflash.signals.Signal;

    /**
     * 2点间曲线运动
     */
    public class CurveMove implements IMove
    {
        public function CurveMove()
        {
        }

        public function moveNext(time : Number = 0.0) : void
        {
        }

        public function get toComplete() : Signal
        {
            return null;
        }
    }
}
