/*
 * Copyright (c) 2008-2013 Ray Yee. All rights reserved.
 */

package common.components.renderer.impl.starling
{

    import ash.signals.Signal0;

    import common.components.animation.Animatable;
    import common.components.renderer.RendererItem;

    import starling.display.DisplayObjectContainer;
    import starling.display.MovieClip;
    import starling.textures.Texture;

    public class StarlingMovieClipRenderItem extends RendererItem implements Animatable
    {
        public var movieClip : MovieClip;
        private var container : DisplayObjectContainer;
        private var _complete : Signal0 = new Signal0();
        private var currentLoop : int;
        private var maxLoop : int;

        public function StarlingMovieClipRenderItem(container : DisplayObjectContainer, frames : Vector.<Texture>, loop : int = 1)
        {
            super();

            this.maxLoop = loop;
            this.container = container;
            currentLoop = 0;

            movieClip = new MovieClip(frames);
            initialization();
        }

        public function get complete() : Signal0
        {
            return _complete;
        }

        public function animate(time : Number) : void
        {
            if ( movieClip.currentFrame < movieClip.numFrames - 1 ) movieClip.currentFrame += 1;
            else if ( currentLoop < maxLoop ) currentLoop++;
            else _complete.dispatch();
        }

        override public function initialization() : void
        {
            width = movieClip.width;
            height = movieClip.height;
        }

        override public function transform() : void
        {
            movieClip.x = x;
            movieClip.y = y;
        }

        override public function added() : void
        {
            super.added();
            container.addChild(movieClip);
            width = movieClip.width;
            height = movieClip.height;
        }

        override public function removed() : void
        {
            super.removed();
            container.removeChild(movieClip);
            width = 0;
            height = 0;
        }
    }
}
