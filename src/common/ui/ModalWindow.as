/**
 * User: Ray Yee
 * Date: 13-11-7
 */
package common.ui
{
    import com.bit101.components.Window;

    import flash.display.DisplayObjectContainer;
    import flash.display.Shape;
    import flash.events.Event;

    public class ModalWindow extends Window
    {
        private var isNeedCenter:Boolean;

        public function ModalWindow( parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0, title:String = "Window" )
        {
            super( parent, xpos, ypos, title );

            this.hasCloseButton = true;
            super.visible = false;
            this.draggable = false;

            addEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
        }

        public function center():void
        {
            draw();
            isNeedCenter = true;
            stage && centerLogic();
        }

        private function centerLogic():void
        {
            if ( _titleBar )
            {
                _titleBar.x = (stage.stageWidth >> 1) - (_panel.width >> 1);
                _titleBar.y = (stage.stageHeight >> 1) - (_panel.height >> 1);
            }
            if ( _panel )
            {
                _panel.x = (stage.stageWidth >> 1) - (_panel.width >> 1);
                _panel.y = (stage.stageHeight >> 1) - (_panel.height >> 1) + 20;
            }
        }

        override public function set y( value:Number ):void
        {
            if ( _titleBar ) _titleBar.y = value;
            if ( _panel ) _panel.y = value + 20;
        }

        override public function set x( value:Number ):void
        {
            if ( _titleBar ) _titleBar.x = value;
            if ( _panel ) _panel.x = value;
        }

        override public function set visible( value:Boolean ):void
        {
            if ( value )
            {
                super.visible = true;
                this.alpha = .05;
                removeEventListener( Event.ENTER_FRAME, onHideRenderer );
                if ( !hasEventListener( Event.ENTER_FRAME ) ) addEventListener( Event.ENTER_FRAME, onShowRenderer );
            }
            else
            {
                this.alpha = 1;
                removeEventListener( Event.ENTER_FRAME, onShowRenderer );
                if ( !hasEventListener( Event.ENTER_FRAME ) ) addEventListener( Event.ENTER_FRAME, onHideRenderer );
            }
        }

        private function onHideRenderer( e:Event ):void
        {
            this.alpha -= 0.05;
            if ( this.alpha <= .01 )
            {
                super.visible = false;
                this.alpha = 0;
                removeEventListener( Event.ENTER_FRAME, onHideRenderer );
            }
        }

        private function onShowRenderer( e:Event ):void
        {
            this.alpha += 0.05;
            if ( this.alpha >= .99 )
            {
                this.alpha = 1;
                removeEventListener( Event.ENTER_FRAME, onShowRenderer );
            }
        }

        private function onAddedToStage( event:Event ):void
        {
            removeEventListener( Event.ADDED_TO_STAGE, onAddedToStage );

            var modal:Shape = new Shape();
            modal.graphics.beginFill( 0x000000, .3 );
            modal.graphics.drawRect( 0, 0, stage.stageWidth, stage.stageHeight );
            addChildAt( modal, 0 );

            if ( isNeedCenter )
            {
                centerLogic();
            }
        }
    }
}
