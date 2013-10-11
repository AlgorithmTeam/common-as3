/*
 * Copyright (c) 2008-2013 Ray Yee. All rights reserved.
 */

package common.components.audio
{

    import ash.core.Engine;
    import ash.core.NodeList;
    import ash.core.System;

    import flash.media.Sound;

    public class FSMAudioPlaySystem extends System
    {

        private var audioNodes : NodeList;

        public function FSMAudioPlaySystem()
        {
        }

        override public function addToEngine(engine : Engine) : void
        {
            super.addToEngine(engine);
            audioNodes = engine.getNodeList(FSMAudioNode);
//            audioNodes.nodeAdded.add(onNodeAdded);
        }

//        private function onNodeAdded(node:FSMAudioNode):void
//        {
//            trace(node);
//        }


        override public function update(time : Number) : void
        {

            for ( var node : FSMAudioNode = audioNodes.head; node; node = node.next )
            {
                //TODO:FSMAudioNode/FSMAudioAddedSystem可能会有bug，导致update触发之前，已经又2次audio被创建，所以会又覆盖问题。
//                node.sound.play(0, 1);

                node.entity.remove(Sound);
                node.audio.play(node.sound);

//                for each( var type : Class in node.audio.toPlay )
//                {
//                    var sound : Sound = new type();
//                    sound.play(0, 1);
//                    node.audio.toPlay.length = 0;
//                }
            }

        }
    }
}
