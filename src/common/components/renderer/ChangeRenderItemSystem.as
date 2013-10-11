/*
 * Copyright (c) 2008-2013 Ray Yee. All rights reserved.
 */

package common.components.renderer
{

    import ash.core.Engine;
    import ash.core.NodeList;
    import ash.core.System;

    public class ChangeRenderItemSystem extends System
    {
        private var nodes : NodeList;
        private var engine : Engine;

        public function ChangeRenderItemSystem()
        {
        }

        override public function addToEngine(engine : Engine) : void
        {
            super.addToEngine(engine);
            this.engine = engine;
            nodes = engine.getNodeList(ChangeRenderItemNode);
        }

        override public function update(time : Number) : void
        {
            for ( var node : ChangeRenderItemNode = nodes.head; node; node = node.next )
            {
                if ( node.oldItem == node.changeItem.newItem ) continue;
                else
                {
                    node.entity.remove(RendererItem);

                    node.entity.add(node.changeItem.newItem, RendererItem);

                    node.changeItem.newItem.x = node.oldItem.x;
                    node.changeItem.newItem.y = node.oldItem.y;

                    node.entity.remove(ChangeRenderItem);
                }

            }

        }
    }
}
