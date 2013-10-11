/*
 * Copyright (c) 2008-2013 Ray Yee. All rights reserved.
 */

package common.components.behavior
{

    import ash.core.Engine;
    import ash.core.NodeList;
    import ash.core.System;

    public class MoveRenderSystem extends System
    {
        private var nodes : NodeList;

        public function MoveRenderSystem()
        {

        }

        override public function addToEngine(engine : Engine) : void
        {
            super.addToEngine(engine);
            nodes = engine.getNodeList(MoveRenderNode);
            nodes.nodeRemoved.add(onNodeRemove);
        }

        private function onNodeRemove(node:MoveRenderNode):void
        {
//            trace("MoveRenderSystem" + node);
        }

        override public function update(time : Number) : void
        {
            super.update(time);
            for ( var node : MoveRenderNode = nodes.head; node; node = node.next )
            {
                node.behavior.moveNext(time);
            }
        }
    }
}