/*
 * Copyright (c) 2008-2013 Ray Yee. All rights reserved.
 */

package common.starling.feathers
{

    import feathers.core.FeathersControl;

    import starling.display.DisplayObject;

    public class ProgressBar extends FeathersControl
    {

        private var _backgroundSkin:DisplayObject;
        private var _scrollSkin:DisplayObject;
        private var _maskSkin:DisplayObject;
        private var _foregroundSkin:DisplayObject;

        public function ProgressBar()
        {
            super();
        }

        public function initializeSkin(scroll:DisplayObject, background:DisplayObject, mask:DisplayObject, fore:DisplayObject):void
        {
            this.addChild(background);
            this.addChild(scroll);
            this.addChild(fore);

            _scrollSkin = scroll;
            _backgroundSkin = background;
            _maskSkin = mask;
            _foregroundSkin = fore;
            _scrollSkin
        }


    }
}
