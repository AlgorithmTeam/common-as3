/*
 * Copyright (c) 2008-2013 Ray Yee. All rights reserved.
 */

package common.components.renderer
{

    import ash.core.Engine;
    import ash.core.NodeList;
    import ash.core.System;

    public class RendererItemSystem extends System
    {
        private var renderItems : NodeList;

        public function RendererItemSystem()
        {
            super();
        }

        override public function addToEngine(engine : Engine) : void
        {
            super.addToEngine(engine);

            renderItems = engine.getNodeList(RendererItemNode);

            for ( var node : RendererItemNode = renderItems.head; node; node = node.next )
            {
                node.item.added();
                node.item.transform();
            }

            renderItems.nodeRemoved.add(onNodeRemove);
            renderItems.nodeAdded.add(onNodeAdd);
        }

        private function onNodeAdd(node : RendererItemNode) : void
        {
            node.item.added();
            node.item.transform();
        }

        private function onNodeRemove(node : RendererItemNode) : void
        {
            node.item.removed();
        }

        override public function update(time : Number) : void
        {
            for ( var node : RendererItemNode = renderItems.head; node; node = node.next )
            {
                node.item.transform();
            }
        }
    }
}
