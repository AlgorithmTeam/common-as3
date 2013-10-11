/*
 * Copyright (c) 2008-2013 Ray Yee. All rights reserved.
 */

package common.loader.item
{
	import com.shinezone.core.structure.views.AbstractPanel;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	
	/**
	 * 面板加载
	 * @author rayyee
	 */
	public class PanelItem extends AbstractItem
	{
		/**
		 * 加载器 
		 */		
		private var _loader:Loader;
		
		/**
		 * 构造
		 * @param	url
		 * @param	priority
		 */
		public function PanelItem(url:String, prop:Object = null)
		{
			super(url, prop);
		}
		
		/**
		 * 开始加载
		 */
		override public function load():void
		{
			super.load();
			_loader.load(new URLRequest(_sUrl), _context);
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteHandler);
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgressHandler);
			_loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorHandler);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOErrorHandler);
		}
		
		/**
		 * 初始化先
		 * 生成加载器 
		 */		
		override protected function initLoader():void
		{
			_loader = new Loader();
			_loader.load(new URLRequest(_sUrl), _context);
//			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteHandler);
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onInitProgressHandler);
//			_loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorHandler);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onInitIOErrorHandler);
		}
		
		private function onInitProgressHandler(e:ProgressEvent):void
		{
			_nTotalBytes = e.bytesTotal;
			if (!_bLoading)
				_loader.close();
			_loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onInitProgressHandler);
		}
		
		private function onInitIOErrorHandler(e:IOErrorEvent):void
		{
			trace("PQLoader::", e, _sUrl);
			_loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onInitIOErrorHandler);
		}
		
		/**
		 * 当加载完成过后触发
		 * @param	e
		 */
		override protected function onCompleteHandler(e:Event):void
		{
			if (!(_loader.content is AbstractPanel))
				trace("[[Load:加载的不是AbstractPanel]]", _loader.content, _sUrl);
			else
			{
				_content = _loader.content as AbstractPanel;
				super.onCompleteHandler(e);
			}
		}
	
	}

}