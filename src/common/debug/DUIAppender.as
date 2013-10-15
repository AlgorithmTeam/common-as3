package common.debug
{
	import flash.display.DisplayObjectContainer;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import caurina.transitions.Equations;
	import caurina.transitions.Tweener;
	
	import framecore.structure.moudle.varMoudle.GameVar;

	public class DUIAppender implements IDLogAppender
	{
		protected var _logViewer:DLogViewer;
	   	private var _main:DisplayObjectContainer;
		public function DUIAppender(stage:DisplayObjectContainer)
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			
			_logViewer 	= new DLogViewer();
			_main		= stage;
			_logViewer.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
  
		private var hasShift:Boolean;
		private function onKeyUp(event:KeyboardEvent):void{
			if(event.keyCode == Keyboard.SHIFT){
				GameVar.stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
				hasShift = false;
			}
		}
		private function onKeyDown(event:KeyboardEvent):void
		{
			if(event.keyCode == Keyboard.SHIFT){
				GameVar.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
				hasShift = true;
			}
			if (event.keyCode != DConsole.hotKeyCode || !hasShift){//如果按下的不是log键或没按shift
				return;
			}
			 
			showLogViewer();
		}
		
		private function showLogViewer():void
		{
			if(_logViewer)
			{
				if (_logViewer.parent)
				{
					_logViewer.y	=	0;
                    _logViewer.parent.removeChild(_logViewer);
//					Tweener.removeTweens(_logViewer);
//					Tweener.addTween(_logViewer,{time:.4,transition:Equations.easeOutExpo,y:-_logViewer.height,onComplete:function ():void{
//						_logViewer.parent.removeChild(_logViewer);
//					}});
					_logViewer.deactivate();
				}
				else
				{
					_logViewer.y	=	-_logViewer.height;
					_main.addChild(_logViewer);
                    _logViewer.y = 0;
//                  Tweener.removeTweens(_logViewer);
//					Tweener.addTween(_logViewer,{time:.4,y:0,transition:Equations.easeOutExpo});
//					var char:String = String.fromCharCode(event.charCode);
//					_logViewer.restrict = "^"+char.toUpperCase()+char.toLowerCase();	// disallow hotKey character
					_logViewer.activate();
				}
			}
		}
		
		public function addLogMessage(level:String, loggerName:String, message:String):void
		{
			if(_logViewer)
				_logViewer.addLogMessage(level, loggerName, message);
		}
	}
}