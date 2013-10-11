/*
 * Copyright (c) 2008-2013 Ray Yee. All rights reserved.
 */

package common.loader.item
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	/**
	 * 加载xml文件
	 * @author rayyee
	 */
	public class XMLItem extends AbstractItem 
	{
		
		private var _loader:URLLoader;
		
		/**
		 * 构造
		 * @param	url
		 * @param	priority
		 */
		public function XMLItem(url:String, prop:Object = null) 
		{
			super(url, prop);
		}
		
		/**
		 * 开始加载
		 */
		override public function load():void
		{
			super.load();
			_loader = new URLLoader();
			_loader.addEventListener(Event.COMPLETE, onCompleteHandler);
			_loader.addEventListener(ProgressEvent.PROGRESS, onProgressHandler);
			_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorHandler);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, onIOErrorHandler);
			_loader.load(new URLRequest(_sUrl));
		}
		
		/**
		 * 当加载完成过后触发
		 * @param	e
		 */
		override protected function onCompleteHandler(e:Event):void
		{
			_content = XML(_loader.data);
			super.onCompleteHandler(e);
		}
		
	}

}