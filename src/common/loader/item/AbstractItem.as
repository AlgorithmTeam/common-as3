/*
 * Copyright (c) 2008-2013 Ray Yee. All rights reserved.
 */

package common.loader.item
{

    import common.signal.RySignal;

    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import flash.events.SecurityErrorEvent;
    import flash.system.LoaderContext;

    /**
	 * 抽象加载
	 * @author rayyee
	 */
	public class AbstractItem extends EventDispatcher
	{
		
		/**
		 * 是否加载完成
		 */
		protected var _bLoaded:Boolean;
		
		/**
		 * 是否开始加载
		 */
		protected var _bLoading:Boolean;
		
		/**
		 * 加载完的回调
		 */
		protected var _callBack:Function;
		
		/**
		 * 路径
		 */
		protected var _sUrl:String;
		
		/**
		 * 已经加载的字节数
		 */
		protected var _nLoadedBytes:Number;
		
		/**
		 * 总字节数
		 */
		protected var _nTotalBytes:Number;
		
		/**
		 * 优先级
		 */
		protected var _iPriority:int;
		
		/**
		 * 加载的配置，包括域
		 */
		protected var _context:LoaderContext;
		
		/**
		 * 被加载到的内容
		 */
		protected var _content:*;
		
		/**
		 * @private
		 * 该item被加载完成以后会触发   不管是加载成功了还是失败
		 */		
		public static const ITEM_LOAD_COMPLETE:String = "Event::Item_Load_Complete";
		
		/**
		 * 完成全部加载的消息 
		 */		
		private var _completeMsg:RySignal = new RySignal;
		
		/**
		 * 构造
		 */
		public function AbstractItem(url:String, prop:Object)
		{
			_nLoadedBytes = 0.0;
			_nTotalBytes = 0.0001;
//			prop ||= { };
//			prop.priority ||= 10;
			_sUrl = url;
			_callBack = prop.cb;
			_iPriority = prop.priority;
			_context = prop.context;
			
			initLoader();
		}
		
		protected function initLoader():void
		{
			
		}
		
		/**
		 * 开始加载
		 */
		public function load():void
		{
			_bLoading = true;
		}
		
		/**
		 * 地址错误
		 * @param	e
		 */
		protected function onIOErrorHandler(e:IOErrorEvent):void
		{
//			dispatchEvent(new Event(Event.COMPLETE));
			dispatchEvent(new Event(ITEM_LOAD_COMPLETE));
			trace("PQLoader::", e, _sUrl);
		}
		
		/**
		 * 安全错误
		 * @param	e
		 */
		protected function onSecurityErrorHandler(e:SecurityErrorEvent):void 
		{
//			dispatchEvent(new Event(Event.COMPLETE));
			dispatchEvent(new Event(ITEM_LOAD_COMPLETE));
			trace("PQLoader::", e, _sUrl);
		}
		
		/**
		 * 加载进度
		 * @param	e
		 */
		protected function onProgressHandler(e:ProgressEvent):void
		{
			_nLoadedBytes = e.bytesLoaded;
			_nTotalBytes = e.bytesTotal;
			dispatchEvent(e);
		}
		
		/**
		 * 当加载完成过后触发
		 * @param	e
		 */
		protected function onCompleteHandler(e:Event):void
		{
			_bLoading = false;
			_bLoaded = true;
			dispatchEvent(e);
			dispatchEvent(new Event(ITEM_LOAD_COMPLETE));
			_completeMsg.dispatch();
		}
		
		/**
		 * 当该节点加载进程完成后触发 
		 * @param value
		 */		
		public function complete( value : Function ):void
		{
			if ( _bLoaded && _content ) value.call( this );
			else _completeMsg.add( value, true );
		}
		
		/**
		 * 已经加载完的内容
		 */
		public function get content():*
		{
			return _content;
		}
		
		/**
		 * 获取此加载类的加载路径
		 */
		public function get sUrl():String
		{
			return _sUrl;
		}
		
		/**
		 * 获取此加载类是否已经加载完成
		 */
		public function get bLoaded():Boolean 
		{
			return _bLoaded;
		}
		
		/**
		 * 获取此加载类是否正在加载
		 */
		public function get bLoading():Boolean 
		{
			return _bLoading;
		}
		
		/**
		 * 获取此加载类的优先级
		 */
		public function get iPriority():int 
		{
			return _iPriority;
		}
		
		/**
		 * 总字节数
		 */
		public function get nTotalBytes():Number 
		{
			return _nTotalBytes;
		}
		
		/**
		 * 已经加载的字节数
		 */
		public function get nLoadedBytes():Number 
		{
			return _nLoadedBytes;
		}
	
	}
}