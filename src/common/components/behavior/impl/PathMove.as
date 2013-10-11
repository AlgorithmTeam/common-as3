/*
 * Copyright (c) 2008-2013 Ray Yee. All rights reserved.
 */

package common.components.behavior.impl
{

    import common.components.behavior.api.IMove;

    import org.osflash.signals.Signal;

    /**
     * 根据指定路径组移动
     */
    public class PathMove implements IMove
    {

        private var _complete:Signal = new Signal();

        public function PathMove()
        {
        }

        public function moveNext(time : Number = 0.0) : void
        {
        }

        public function get toComplete() : Signal
        {
            return _complete;
        }
    }
}
