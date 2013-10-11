/*
 * Copyright (c) 2008-2013 Ray Yee. All rights reserved.
 */

package common.effect.background
{

    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.DisplayObjectContainer;
    import flash.filters.GlowFilter;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    public class ScrollBitmapBackground
    {
        public var display : BitmapData;
        private var scrollRect : Rectangle;
        private var starGlow : GlowFilter;
        private var width : Number;
        private var height : Number;

        public var starsInterval : int = 20;
        public var starsC : int = 0;

        public function ScrollBitmapBackground(w : Number, h : Number, c : DisplayObjectContainer)
        {
            width = w;
            height = h;
            display = new BitmapData(w, h, true, 0x00000000);
            var bitmap : Bitmap = new Bitmap(display);
            c.addChild(bitmap);

            for ( var i : int = 0; i < height; i += starsInterval )
            {
                newStars(i);
            }

            starGlow = new GlowFilter(0xffffff);

            display.applyFilter(display, display.rect, new Point(), starGlow);

            scrollRect = new Rectangle(0, 0, width, 1);

        }

        public function update(time : Number) : void
        {

            if ( starsC == starsInterval )
            {
                newStars(0);
                starsC = 0;
                display.applyFilter(display, scrollRect, new Point(), starGlow);
            }

            display.scroll(0, 1);

            display.fillRect(scrollRect, 0x00000000);

            starsC++;

        }

        /**
         * Random color
         */
        private function get R() : int
        {
            return 0x40 + Math.floor(Math.random() * 0xBF);
        }

        private function newStars(i : int) : void
        {
            var x : Number;
            var y : Number;

            x = Math.floor(Math.random() * width);
            y = i + 1;
            display.setPixel32(x, y, 0x55 << 24 | R << 16 | R << 8 | R);

            x = Math.floor(Math.random() * width);
            y = i + 2;
            display.setPixel32(x, y, 0x7F << 24 | R << 16 | R << 8 | R);

            x = Math.floor(Math.random() * width);
            y = i + 2;
            display.setPixel32(x, y, 0xBF << 24 | R << 16 | R << 8 | R);

            x = Math.floor(Math.random() * width);
            y = i + 3;
            display.setPixel32(x, y, 0xFF << 24 | R << 16 | R << 8 | R);

        }
    }
}
