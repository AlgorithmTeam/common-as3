/*
 * Copyright (c) 2008-2013 Ray Yee. All rights reserved.
 */

package common.sprite
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	
	/**
	 * 序列位图动画
	 * @author rayyee
	 */
	public class AnimationBitmap extends Bitmap
	{
		
		/**
		 * animation datas
		 */
		public var _aBitmapDatas			:Vector.<BitmapData>;
		
		/**
		 * currentFrame
		 */
		public var _iCurrentFrame			:int;
		
		/**
		 * animation is playing
		 */
		private var _bIsPlaying			:Boolean;
		
		/**
		 * loop playing
		 */
		private var _bLoop					:Boolean;
		
		/**
		 * key frame
		 * 存放的是所有关键帧所在的位置，
		 * 并且第一帧和最后一帧必须是关键帧，
		 * 这个关键帧数的长度就是位图数据的长度.
		 */
		private var _aKeyframes			:Vector.<int>;
		
		/**
		 * Constructor
		 * @param	value
		 * @param	loop
		 * @param	keyFrames
		 */
		public function AnimationBitmap(value:Vector.<BitmapData>, loop:Boolean = true, keyFrames:Vector.<int> = null)
		{
			if (keyFrames && value.length != keyFrames.length)
			{
				throw new Error("AnimationBitmap:帧数和帧间隔数不一样引发的错误！");
				return;
			}
			this._aKeyframes 			= keyFrames;
			this._bLoop 		= loop;
			this._aBitmapDatas 	= value;
		}
		
		public function resetBitmapDatas(value:Vector.<BitmapData>):void
		{
			this._aBitmapDatas 	= value;
		}
		
		public function gotoAndPlay(value:int):void
		{
			_iCurrentFrame = value - 1;
			_bIsPlaying = true;
            if (!hasEventListener(Event.ENTER_FRAME)) addEventListener(Event.ENTER_FRAME, onRenderAnimation);
		}
		
		public function play():void
		{
			_iCurrentFrame = 0;
			_bIsPlaying = true;
            if (!hasEventListener(Event.ENTER_FRAME)) addEventListener(Event.ENTER_FRAME, onRenderAnimation);
		}
		
		public function gotoAndStop(value:int):void
		{
			_iCurrentFrame 	= value - 1;
			bitmapData 		= _aBitmapDatas[_iCurrentFrame];
			_bIsPlaying 	= false;
            if (hasEventListener(Event.ENTER_FRAME)) removeEventListener(Event.ENTER_FRAME, onRenderAnimation);
		}
		
		public function stop():void
		{
			_iCurrentFrame 	= 0;
			bitmapData 		= _aBitmapDatas[_iCurrentFrame];
			_bIsPlaying 	= false;
			if (hasEventListener(Event.ENTER_FRAME)) removeEventListener(Event.ENTER_FRAME, onRenderAnimation);
		}
		
		public function reset():void
		{
			_iCurrentFrame = 0;
		}
		
		/**
		 * animation is playing
		 */
		public function get bIsPlaying():Boolean 
		{
			return _bIsPlaying;
		}
		
		/**
		 * render animation by enter_frame
		 * @param	e
		 */
		public function onRenderAnimation(e:Event = null):void
		{
			if (_aKeyframes)
			{
				if (_iCurrentFrame >= _aKeyframes[_aKeyframes.length - 1])
				{
					if (_bLoop) _iCurrentFrame = 0;
					else 
					{
						stop();
						return;
					}
				}
				var keyFrame:int = _aKeyframes.indexOf(_iCurrentFrame + 1);
				if (keyFrame != -1)
				{
					bitmapData = _aBitmapDatas[keyFrame];
				}
			}
			else
			{
				if (_iCurrentFrame >= _aBitmapDatas.length)
				{
					if (_bLoop) _iCurrentFrame = 0;
					else 
					{
						stop();
						return;
					}
				}
				bitmapData = _aBitmapDatas[_iCurrentFrame];
			}
			_iCurrentFrame++;
		}
	
	}

}