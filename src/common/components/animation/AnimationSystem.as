/*
 * Copyright (c) 2008-2013 Ray Yee. All rights reserved.
 */

package common.components.animation
{

    import ash.tools.ListIteratingSystem;

    public class AnimationSystem extends ListIteratingSystem
    {
        public function AnimationSystem()
        {
            super(AnimationNode, updateNode);
        }

        private function updateNode(node : AnimationNode, time : Number) : void
        {
            node.animation.animation.animate(time);
        }
    }
}
