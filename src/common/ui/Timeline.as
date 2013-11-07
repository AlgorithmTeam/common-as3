/**
 * User: Ray Yee
 * Date: 13-11-7
 */
package common.ui
{
    import com.bit101.components.Component;
    import com.bit101.components.Label;
    import com.bit101.components.PushButton;
    import com.bit101.components.ScrollBar;
    import com.bit101.components.Slider;

    import event.GuiViewEvent;

    import flash.display.DisplayObjectContainer;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;

    /**
     * 时间轴
     */
    public class Timeline extends Component
    {
        private var scrollBar:ScrollBar;
        private var line:Component;

        private var frames:Array = [];

        public function Timeline( parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0 )
        {
            super( parent, xpos, ypos );
            setSize( 560, 400 );
            this.scrollRect = new Rectangle( 0, 0, 560, 400 );

            line = new Component( this, 0, 40 );
            line.graphics.lineStyle( 2, 0x222222 );

            scrollBar = new ScrollBar( Slider.HORIZONTAL, this, 0, 280, onChangeScroll );
            scrollBar.width = _width;

            scrollBar.minimum = 0;
            scrollBar.maximum = 200;

            drawLine();

            scrollBar.setThumbPercent( .1 );
        }

        public function addFrame( time:int, type:String ):void
        {
            var preButton:PushButton = frames[frames.length - 1];
            var frameButton:PushButton = new PushButton( line, time * 10, 20, type, onShowPlotFrame );
            frameButton.width = 60;
            if ( preButton && preButton.x + preButton.width > time * 10 )
            {
                frameButton.y = preButton.y + 20;
            }
            frames.push( frameButton );
        }

        private function onShowPlotFrame( e:MouseEvent ):void
        {
            dispatchEvent( new GuiViewEvent( GuiViewEvent.SHOW_PLOT_FRAME ) );
        }

        private function onChangeScroll( e:Event ):void
        {
            line.x = -scrollBar.value * 10;
        }

        public function set maxTime( value:int ):void
        {
            line.graphics.clear();
            drawLine();
            scrollBar.maximum = value;
        }

        private function drawLine():void
        {
            line.graphics.moveTo( 0, 20 );
            line.graphics.lineTo( scrollBar.maximum * 10, 20 );
            for ( var i:int = 0; i <= scrollBar.maximum / 10; i++ )
            {
                new Label( line, i * 100, 0, "" + i * 10 );
                line.graphics.moveTo( i * 100, 10 );
                line.graphics.lineTo( i * 100, 20 );
            }
        }
    }
}