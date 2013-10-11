/*
 * Copyright (c) 2008-2013 Ray Yee. All rights reserved.
 */

package common.components.renderer.impl.starling
{

    import common.components.renderer.*;

    import starling.display.DisplayObject;
    import starling.display.DisplayObjectContainer;

    public class StarlingRenderItem extends RendererItem
    {
        public var sprite : DisplayObject;
        private var container : DisplayObjectContainer;

        public function StarlingRenderItem(container : DisplayObjectContainer, sprite : DisplayObject)
        {
            this.sprite = sprite;
            this.container = container;
            if ( sprite ) initialization();
        }

        override public function initialization() : void
        {
            width = sprite.width;
            height = sprite.height;
        }

        override public function transform() : void
        {
            sprite.x = x;
            sprite.y = y;
        }

        override public function added() : void
        {
            super.added();
            container.addChild(sprite);
            width = sprite.width;
            height = sprite.height;
        }

        override public function removed() : void
        {
            super.removed();
            container.removeChild(sprite);
            width = 0;
            height = 0;
        }
    }
}
