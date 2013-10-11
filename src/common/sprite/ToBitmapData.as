/*
 * Copyright (c) 2008-2013 Ray Yee. All rights reserved.
 */

package common.sprite
{

    import flash.display.BitmapData;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.utils.Dictionary;

    /**
     * 资源转位图序列
     * @author rayyee
     */
    public class ToBitmapData
    {

        /**
         * 单例
         */
        private static var _singleton : ToBitmapData;

        /**
         * 构造
         * @param    _internal
         */
        public function ToBitmapData(_internal : Internal)
        {}

        /**
         * 缓存
         */
        private static var cache : Dictionary = new Dictionary();

        /**
         * 获取实例
         */
        public static function getInstance() : ToBitmapData
        { return _singleton ||= new ToBitmapData(new Internal); }

        /**
         * 解析SpriteSheet为BitmapData Vector
         * @param       spriteSheet
         * @param       spriteWidth
         * @param       spriteHeight
         * @param       sheetWidth
         * @param       spriteNumber
         * @param       spriteStartIndex
         * @return
         */
        public function fromSpriteSheet(spriteSheet : BitmapData, spriteWidth : Number, spriteHeight : Number, sheetWidth : Number, spriteNumber : Number, spriteStartIndex : int) : Vector.<BitmapData>
        {
            var bmds : Vector.<BitmapData> = new <BitmapData>[];
            var bmd : BitmapData;
            var point : Point = new Point(0, 0);
            var rectangle : Rectangle = new Rectangle(0, 0, spriteWidth, spriteHeight);
            var len : int = spriteStartIndex + spriteNumber;
            for ( var i : int = spriteStartIndex; i < len; i++ )
            {
                bmd = new BitmapData(spriteWidth, spriteHeight, true, 0);
                rectangle.x = (i % sheetWidth) * spriteWidth;
                rectangle.y = Math.floor(i / sheetWidth) * spriteHeight;
                bmd.copyPixels(spriteSheet, rectangle, point);
                bmds.push(bmd);
            }

            return bmds;
        }

        /**
         * 解析MoveClip为BitmapData Vector
         * @param        mc
         * @return
         */
        public function fromMovieClip(mc : MovieClip) : Vector.<BitmapData>
        {
            if ( cache[mc] ) return cache[mc];
            else
            {
                var
                        bmd : BitmapData,
                        r : Rectangle,
                        rects : Array = [],
                        bmds : Vector.<BitmapData> = new Vector.<BitmapData>,
                        minX : int = int.MAX_VALUE,
                        minY : int = int.MAX_VALUE,
                        i : int = 0,
                        w : Sprite = new Sprite;

                w.addChild(mc);

                for ( ; i < mc.totalFrames; i++ )
                {
                    mc.gotoAndStop(i + 1);
                    r = w.getBounds(w);
                    minX = Math.min(minX, r.x);
                    minY = Math.min(minY, r.y);
                    rects.push(r);
                }

                for ( i = 0; i < mc.totalFrames; i++ )
                {
                    mc.gotoAndStop(i + 1);
                    r = rects[i];
                    r.left = minX;
                    r.top = minY;
                    bmd = new BitmapData(Math.max(1, r.width), Math.max(1, r.height), true, 0);
                    bmd.draw(w, new Matrix(1, 0, 0, 1, -r.x, -r.y));
                    bmds.push(bmd);
                }

                cache[mc] = bmds;

                return bmds;
            }
        }

    }

}

class Internal
{
}
;