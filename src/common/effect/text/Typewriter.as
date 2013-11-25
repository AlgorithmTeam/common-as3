/**
 * User: Ray Yee
 * Date: 13-11-25
 */
package common.effect.text
{
    import flash.text.TextField;

    import moebius.base.tick.base.Tick;
    import moebius.base.tick.core.TickManager;

    public class Typewriter extends Tick
    {
        private var counter:int = 0;
        private var typewriterText:String;
        private var myTextField:TextField;

        public function Typewriter( tf:TextField )
        {
            myTextField = tf;
            TickManager.GetInstance().addTick( this );
            setCallBack( addCharacter );
        }

        public function setTextSource( value:String ):void
        {
            typewriterText = value;
        }

        override public function reStart():void
        {
            counter = 0;
            super.reStart();
        }

        private function addCharacter():void
        {
            // get a single character out of the String
            var characterToAdd:String = typewriterText.charAt( counter );

            // add the character to the TextField
            myTextField.appendText( characterToAdd );
            counter++;

            // if you reached the end of the String stop Timer
            if ( counter == typewriterText.length )
            {
                stop();
            }
        }
    }
}
