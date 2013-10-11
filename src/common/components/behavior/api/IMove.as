/*
 * Copyright (c) 2008-2013 Ray Yee. All rights reserved.
 */

package common.components.behavior.api
{

    import org.osflash.signals.Signal;

    public interface IMove
    {
        function moveNext(time : Number = 0.0) : void;

        function get toComplete():Signal;
    }
}
