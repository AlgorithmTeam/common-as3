/*
 * Copyright (c) 2008-2013 Ray Yee. All rights reserved.
 */

package common.components.renderer.impl.bitmap
{

    import ash.signals.Signal0;

    import common.components.animation.Animatable;
    import common.components.renderer.impl.display.DisplayObjectRendererItem;
    import common.sprite.AnimationBitmap;

    import flash.display.Sprite;
    import flash.utils.getTimer;

    public class AnimationBitmapRenderItem extends DisplayObjectRendererItem implements Animatable
    {
        private var _complete : Signal0 = new Signal0();
        private var _animation : AnimationBitmap;
        private var _container : Sprite;
        private var _oldTime:Number;
        private var _fpsTime:Number;

        public function AnimationBitmapRenderItem(animation : AnimationBitmap, container : Sprite, fps:Number = 24)
        {
            super(container);
            this.sprite = animation;
            this._container = container;
            this._animation = animation;
            initialization();
            added();
            _oldTime = getTimer();
            _fpsTime = 1000 / fps >> 0;
        }

        public function animate(time : Number) : void
        {
            var _nowTime:Number = getTimer();

            if (_nowTime - _oldTime > _fpsTime)
            {
                _oldTime = _nowTime;

                if (_animation._iCurrentFrame >= _animation._aBitmapDatas.length) _complete.dispatch();
                else _animation.onRenderAnimation();
            }

        }

        public function get complete() : Signal0
        {
            return _complete;
        }
    }
}
