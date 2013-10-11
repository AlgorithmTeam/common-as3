/*
 * Copyright (c) 2008-2013 Ray Yee. All rights reserved.
 */

package common.components.behavior
{

    import ash.core.Node;

    import common.components.behavior.api.IMove;
    import common.components.renderer.RendererItem;

    public class MoveRenderNode extends Node
    {
        public var item:RendererItem;
        public var behavior:IMove;
    }
}
