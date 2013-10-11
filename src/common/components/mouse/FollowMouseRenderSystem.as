/*
 * Copyright (c) 2008-2013 Ray Yee. All rights reserved.
 */

package common.components.mouse
{

    import ash.core.Engine;
    import ash.core.NodeList;
    import ash.core.System;

    public class FollowMouseRenderSystem extends System
    {
        private var nodes:NodeList;

        public function FollowMouseRenderSystem()
        {

        }

        override public function addToEngine(engine : Engine) : void
        {
            super.addToEngine(engine);
            nodes = engine.getNodeList(FollowMouseRenderNode);
        }

        override public function update(time : Number) : void
        {

            super.update(time);
            for(var node:FollowMouseRenderNode = nodes.head; node; node = node.next)
            {
                node.followMouse.update();
            }

        }
    }
}
