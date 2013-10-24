package common.effect
{
	import com.adobe.utils.ArrayUtil;
	import com.coffeebean.tween.TweenManager;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import starling.animation.Transitions;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;

	public class EffectUtil
	{
		public function EffectUtil()
		{
		}
		
		private static var _inJumpList:Array = [];
		
		private static var _timer:Timer;
		/**
		 * starling的显示对象跳动
		 */
		public static function jumpDisplayObject(dis:DisplayObject, jumpTimes:int = 1, space:Number = 0.5):void
		{
			if(ArrayUtil.arrayContainsValue(_inJumpList, dis))
			{
				//元件正在跳动的时候，不再继续执行跳动方法
				return;
			}
			var Y:int = dis.y;
			var times:int = 0;
			_inJumpList.push(dis);
			
			jumpUp(0);
			
			function jumpUp(del:Number):void
			{
				times++;
				if(times <= jumpTimes)
				{
					var d:Number = del == 0 ? 0 : space; 
					TweenManager.to(dis,0.15,{y:Y - 15,transition: Transitions.EASE_OUT, onComplete:jumpBack, delay:d});
				}
				else
				{
					if(ArrayUtil.arrayContainsValue(_inJumpList, dis))
						ArrayUtil.removeValueFromArray(_inJumpList, dis);
				}
			}
			
			function jumpBack():void
			{
				TweenManager.to(dis,0.4,{y:Y,transition: Transitions.EASE_OUT_BOUNCE, onComplete:jumpUp, onCompleteArgs:[space]});
			}
			
		}
		/**
		 * 缩放摇摆
		 */
		public static function shake(dis:DisplayObject,time:int = 3):void
		{
			var parent:DisplayObjectContainer = dis.parent;
			var coordX:Number = dis.x;  
			var coordY:Number = dis.y;
			
			var displayContainer:Sprite = new Sprite();
			displayContainer.rotation
			parent.addChild(displayContainer);
			displayContainer.x = coordX + dis.width/2;
			displayContainer.y = coordY + dis.height/2;
			displayContainer.addChild(dis);
			dis.x = -dis.width/2,dis.y = -dis.height/2;
			
			TweenManager.to(displayContainer,0.5,{scaleX:1.2,scaleY:1.2,onComplete:startShake});
			
			function startShake():void
			{
				TweenManager.to(displayContainer,0.3,{rotation:-Math.PI/4,onComplete:rightShake});
			}
			
			function rightShake():void
			{
				TweenManager.to(displayContainer,0.3,{rotation:Math.PI/4,onComplete:originalShake});
			}
			
			function originalShake():void
			{
				TweenManager.to(displayContainer,0.3,{rotation:0,onComplete:scaleOriginal});
			}
			
			function scaleOriginal():void
			{
				TweenManager.to(displayContainer,0.5,{scaleX:1,scaleY:1,onComplete:restoration});
			}
			
			function restoration():void
			{
				parent.removeChild(displayContainer);
				parent.addChild(dis);
				dis.x = coordX,dis.y = coordY;
			}
		}
	}
}
