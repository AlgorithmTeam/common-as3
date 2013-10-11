/*
 * Copyright (c) 2008-2013 Ray Yee. All rights reserved.
 */

package common.components.mouse
{

    import common.components.renderer.RendererItem;

    import flash.display.DisplayObjectContainer;
    import flash.ui.Mouse;

    public class FollowMouseEasing
    {
        public var target : RendererItem;
        /**
         * 拥有mouseX，mouseY属性的对象
         */
        protected var haveMousePosition : Object;
        private const speed : Number = 5;
//        private const speed2 : Number = 10;

        public function FollowMouseEasing(target : RendererItem, haveMousePosition : Object)
        {
            this.haveMousePosition = haveMousePosition;
            this.target = target;
        }

        public function update() : void
        {


            // Easing 1
            target.x -= (target.x - haveMousePosition.mouseX) / speed;
            target.y -= (target.y - haveMousePosition.mouseY) / speed;



            // Easing 2
//            var yDistance : Number = container.mouseY - target.y;
//            var xDistance : Number = container.mouseX - target.x;
//            if ( Math.sqrt(yDistance * yDistance + xDistance * xDistance) < speed2 )
//            {
//                target.x = container.mouseX;
//                target.y = container.mouseY;
//            }
//            else
//            {
//                var radian : Number = Math.atan2(yDistance, xDistance);
//                target.x += Math.cos(radian) * speed2;
//                target.y += Math.sin(radian) * speed2;
//            }

        }

    }
}
