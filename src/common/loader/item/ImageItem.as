/*
 * Copyright (c) 2008-2013 Ray Yee. All rights reserved.
 */

package common.loader.item
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	
	/**
	 * load image
	 * @author rayyee
	 */
	public class ImageItem extends AbstractItem
	{
		private var _loader:Loader;
		
		/**
		 * constructor
		 * @param	url
		 * @param	priority
		 */
		public function ImageItem(url:String, prop:Object = null)
		{
			super(url, prop);
		}
		
		/**
		 * start load
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
		 * load complete
		 * @param	e
		 */
		override protected function onCompleteHandler(e:Event):void
		{
			//cross domain load setting
			try {
				_content = (_loader.content as Bitmap).bitmapData;
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
		 * dispose loader
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