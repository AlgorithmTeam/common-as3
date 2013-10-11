/*
 * Copyright (c) 2008-2013 Ray Yee. All rights reserved.
 */

package common.components.destroy
{

    import ash.core.Engine;
    import ash.core.NodeList;
    import ash.core.System;

    import common.components.destroy.DestroyEntityNode;

    public class DestroyEntitySystem extends System
    {
        private var nodes:NodeList;
        private var engine:Engine;

        public function DestroyEntitySystem()
        {
            super();
        }

        override public function addToEngine(engine : Engine) : void
        {
            super.addToEngine(engine);
            this.engine = engine;
            nodes = engine.getNodeList(DestroyEntityNode);
        }

        override public function update(time : Number) : void
        {
            super.update(time);
            for(var node:DestroyEntityNode = nodes.head; node; node = node.next)
            {
                engine.removeEntity(node.entity);
            }
        }
    }
}
