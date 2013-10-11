/*
 * Copyright (c) 2008-2013 Ray Yee. All rights reserved.
 */

package common.starling.feathers
{

    import feathers.controls.Button;
    import feathers.core.DisplayListWatcher;

    import starling.display.DisplayObjectContainer;

    public class RayTheme extends DisplayListWatcher
    {
        public function RayTheme(topLevelContainer : DisplayObjectContainer)
        {
            super(topLevelContainer);

            initializeTheme();
        }

        private function initializeTheme() : void
        {
            setInitializerForClass(Button, buttonInitializer);
        }

        private function buttonInitializer(button:Button):void
        {

        }
    }
}
