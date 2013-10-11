/*
 * Copyright (c) 2008-2013 Ray Yee. All rights reserved.
 */

package common.components.behavior.impl
{

    import ash.core.Entity;

    import common.components.behavior.api.IMove;

    import common.components.renderer.RendererItem;
    import common.mathematics.Vector2;

    import org.osflash.signals.Signal;

    /**
     * 2点间线性的移动
     */
    public class LinearMove implements IMove
    {

        private var _toComplete : Signal;

        public var tx : Number;
        public var ty : Number;

        private var ox:Number;
        private var oy:Number;

        //移动向量（当然，向量只记方向和移动量）
        private var moveVector : Vector2;
        private var targetLen : Number;

        private var item : RendererItem;
        public var entity : Entity;
        public var speed : Number = 3;

        //TODO:加入Easing功能
        public function LinearMove(tx : Number, ty : Number, render : RendererItem, entity : Entity = null, speed:Number = 3)
        {
            //TODO:不应该依赖Entity, 必须去掉
            this.speed = speed;
            this.item = render;
            this.entity = entity;
            _toComplete = new Signal();
            this.tx = tx;
            this.ty = ty;
            this.ox = item.x;
            this.oy = item.y;
            moveVector = new Vector2(tx - item.x, ty - item.y);
            targetLen = moveVector.length;
            moveVector.length = 1;

        }

        public function moveNext(time : Number = 0.0) : void
        {
            var moveLen : Number = moveVector.length;
            if ( moveLen + speed * time < targetLen )
            {
                moveLen = moveVector.length = moveLen + speed * time;
            }
            else
            {
                moveLen = moveVector.length = targetLen;
            }

            item.x = moveVector._x + ox;
            item.y = moveVector._y + oy;

            if ( moveLen == targetLen )
            {
                _toComplete.dispatch(entity);
            }
        }

        public function get toComplete() : Signal
        {
            return _toComplete;
        }
    }
}
