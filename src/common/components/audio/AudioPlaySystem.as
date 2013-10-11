/*
 * Copyright (c) 2008-2013 Ray Yee. All rights reserved.
 */

package common.components.audio
{

    import ash.tools.ListIteratingSystem;

    import flash.media.Sound;
    import flash.media.SoundTransform;

    public class AudioPlaySystem extends ListIteratingSystem
    {
        private var soundTransform:SoundTransform;

        public function AudioPlaySystem(soundTransform:SoundTransform)
        {
            this.soundTransform = soundTransform;
            super(AudioNode, updateNode);
        }

        private function updateNode(audioNode : AudioNode, time : Number) : void
        {
            for each( var sound : Sound in audioNode.audio.toPlay )
            {
                sound.play(0, 1, soundTransform);
            }
            audioNode.audio.toPlay.length = 0;
        }

    }
}
