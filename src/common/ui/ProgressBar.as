/*
 * Copyright (c) 2008-2013 Ray Yee. All rights reserved.
 */

package common.ui
{

    import ash.tick.ITickProvider;

    import flash.display.MovieClip;
    import flash.display.Sprite;

    /**
     * 通过移动scroll bar来实现的进度条UI
     */
    public class ProgressBar
    {

        [Inject]
        public var ticker : ITickProvider;

        private var total : Number;
        private var scroll : Sprite;
        private var toProgress : Number;

        public function ProgressBar(skin : MovieClip)
        {
            this.scroll = skin.scroll_mc;
            scroll.mask = skin.mask_mc;
            total = scroll.width;
        }

        [PostConstruct]
        public function initializationInejected() : void
        {
            progress(0);
        }

        public function progress(value : Number) : void
        {
            if (value > 1) return;
            toProgress = (total * value >> 0) - total;
            ticker.add(update);
        }

        public function update(time : Number) : void
        {
            if ( Math.abs(toProgress - scroll.x) > 1 ) scroll.x += (toProgress - scroll.x) * .5;
            else ticker.remove(update);
        }
    }
}