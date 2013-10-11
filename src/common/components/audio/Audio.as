/*
 * Copyright (c) 2008-2013 Ray Yee. All rights reserved.
 */

package common.components.audio
{

    import flash.media.Sound;

    public class Audio
    {
        public var toPlay : Array = [];

        public function play(sound : *) : void
        {
            if (sound is Class && sound.toString() == "[class Sound]")
            {
                toPlay.push(new sound);
            }
            else if (sound is Sound)
            {
                toPlay.push(sound);
            }
        }
    }
}
