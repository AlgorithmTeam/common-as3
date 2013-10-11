/*
 * Copyright (c) 2008-2013 Ray Yee. All rights reserved.
 */

package common.components.mouse
{

    import ash.core.Node;

    import common.components.mouse.FollowMouseEasing;
    import common.components.renderer.RendererItem;

    public class FollowMouseRenderNode extends Node
    {
        public var followMouse:FollowMouseEasing;
        public var item:RendererItem;
        public function FollowMouseRenderNode()
        {
        }
    }
}
