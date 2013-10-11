/*
 * Copyright (c) 2008-2013 Ray Yee. All rights reserved.
 */

package common.components.keyboard
{

    import flash.display.DisplayObjectContainer;
    import flash.events.KeyboardEvent;
    import flash.utils.Dictionary;

    public class KeyboardMapper
    {

        private var keyMap : Dictionary;

        public function KeyboardMapper(c : DisplayObjectContainer)
        {
            keyMap = new Dictionary();
            c.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
        }

        public function mapKey(gameKey : String, keyboardKey : String) : KeyboardMapper
        {
            if ( !keyMap[keyboardKey] ) keyMap[keyboardKey] = new KeyMapStructure();
            var key : KeyMapStructure = keyMap[keyboardKey];
            if ( !keyMap[gameKey] ) keyMap[gameKey] = key;

            return this;
        }

        public function mapListener(gameKey : String, listener : Function) : KeyboardMapper
        {
            var key : KeyMapStructure = keyMap[gameKey];
            key.listener = listener;
            return this;
        }

        private function onKeyDown(event : KeyboardEvent) : void
        {
            var key : KeyMapStructure = keyMap[event.keyCode];
            key.listener && key.listener();
        }
    }
}

class KeyMapStructure
{
    public var listener : Function;
}

