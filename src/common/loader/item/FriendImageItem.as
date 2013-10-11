/*
 * Copyright (c) 2008-2013 Ray Yee. All rights reserved.
 */

package common.loader.item
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	
	/**
	 * 加载好友头像
	 * @author rayyee
	 */
	public class FriendImageItem extends AbstractItem
	{
		private var _loader:Loader;
		
		/**
		 * 构造
		 * @param	url
		 * @param	priority
		 */
		public function FriendImageItem(url:String, prop:Object = null)
		{
			super(url, prop);
		}
		
		/**
		 * 开始加载
		 */
		override public function load():void
		{
			super.load();
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteHandler);
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgressHandler);
			_loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorHandler);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOErrorHandler);
			_loader.load(new URLRequest(_sUrl), _context);
		}
		
		/**
		 * 当加载完成过后触发
		 * @param	e
		 */
		override protected function onCompleteHandler(e:Event):void
		{
			//跨域加载设置
			try
			{
				_content = _loader.content;
			}
			catch (e:SecurityError)
			{
				_loader.loadBytes(_loader.contentLoaderInfo.bytes);
			}
			if (_content)
			{
				super.onCompleteHandler(e);
				if (_callBack != null)
				{
					_callBack(_content);
				}
				clearListeners();
			}
		}
		
		/**
		 * 移除侦听
		 */
		private function clearListeners():void
		{
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onCompleteHandler);
			_loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgressHandler);
			_loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorHandler);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIOErrorHandler);
			_loader = null;
		}
	
	}

}