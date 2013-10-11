/*
 * Copyright (c) 2008-2013 Ray Yee. All rights reserved.
 */

package common.components.animation
{

    import ash.signals.Signal0;

    public interface Animatable
    {
        function animate(time : Number) : void;
        function get complete():Signal0;
    }
}
