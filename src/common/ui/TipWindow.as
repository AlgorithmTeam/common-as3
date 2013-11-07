/**
 * User: Ray Yee
 * Date: 13-11-7
 */
package common.ui
{
    import com.bit101.components.Label;

    import flash.display.DisplayObjectContainer;

    public class TipWindow extends ModalWindow
    {
        private var contentLabel:Label;

        public function TipWindow( parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0, title:String = "Window" )
        {
            super( parent, 0, 0, title );

            contentLabel = new Label( this, 20, 20, "这是一个提示弹框!" );
            _panel.width = contentLabel.textField.textWidth + 40;
            _titleBar.width = contentLabel.textField.textWidth + 40;
            contentLabel.x = _panel.width / 2 - contentLabel.textField.textWidth / 2;
        }

        public function set label( value:String ):void
        {
            contentLabel.text = value;
            contentLabel.draw();
            _panel.width = contentLabel.textField.textWidth + 40;
            _titleBar.width = contentLabel.textField.textWidth + 40;
            contentLabel.x = _panel.width / 2 - contentLabel.textField.textWidth / 2;
        }

        override public function set visible( value:Boolean ):void
        {
            if ( value )
            {
                center();
            }
            super.visible = value;
        }
    }
}