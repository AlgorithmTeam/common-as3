/*
 * Copyright (c) 2008-2013 Ray Yee. All rights reserved.
 */

package common.loader
{

    import common.data.structure.BinaryHeap_Max;
    import common.data.structure.HashMap;
    import common.loader.item.AbstractItem;
    import common.signal.RySignal;

    import flash.events.Event;
    import flash.events.TimerEvent;
    import flash.utils.Timer;

    /**
	 * priority queue loader 
	 * 优先级队列加载器
	 * @author rayyee
	 */
	public class PQLoader implements IPQLoader
	{
		/**
		 * 二叉堆实现的优先级队列
		 */
		private var _loadingQueue:BinaryHeap_Max;
		
		/**
		 * 所有的加载
		 */
		private var _aItems:Array;
		
		/**
		 * 当前加载的连接数
		 */
		private var _iCurrentConnections:int;
		
		/**
		 * 允许的最大加载连接数 
		 */		
		private var _iMaxConnections:int;
		
		/**
		 * 是否已经开始加载了
		 */
		private var _bStart:Boolean;
		
		/**
		 * 模拟的加载进度值
		 */
		private var _nProgress:Number;
		
		/**
		 * 加载器的名字
		 */
		public var sName:String;
		
		/**
		 * 所有的加载实例
		 */
		private static var _pqLoaders:HashMap = new HashMap();
		
		/**
		 * 进度回调
		 */
		private var _progressHandler:Function;
		
		/**
		 * 计算总进度
		 */
		private var _progressTimer:Timer;
		
		/**
		 * 完成全部加载的消息 
		 */		
		private var _completeMsg:RySignal = new RySignal;
		
		/**
		 * 构造
		 */
		public function PQLoader(numConnection:int)
		{
			_nProgress = 0;
			_iMaxConnections = numConnection;
			_aItems = [];
			_loadingQueue = new BinaryHeap_Max;
		}
		
		/**
		 * 获取加载实例
		 * @param	name				
		 * @param	numConnection		进程数     默认3个进程同时加载
		 * @return
		 */
		public static function getInstance(name:String, numConnection:int = 3):PQLoader
		{
			if (!_pqLoaders.containsKey(name))
			{
				var _loader:PQLoader = new PQLoader(numConnection);
				_pqLoaders.put(name, _loader);
				_loader.sName = name;
			}
			return _pqLoaders.get(name) as PQLoader;
		}
		
		/**
		 * 添加一个要加载的东西
		 * 如果item已经被add过，会返回之前那个实例，并且这次所传的参数都被无视，完全是上次的实例情况
		 * @param	url
		 * @param	type
		 * @param	prop	
		 */
		public function addItem(url:String, item:Class = null, prop:Object = null):AbstractItem
		{
			var _haveItem:AbstractItem = getItem(url);
			if (_haveItem) return _haveItem;
			else
			{
				prop ||= {};
				prop.type ||= "binary";
				prop.priority ||= 0;
				var _item:AbstractItem = new item(url, prop);
				if (_bStart)
				{
					_loadingQueue.insert(_item);
					canLoadNext();
				}
				_aItems.push(_item);
				return _item;
			}
		}
		
		/**
		 * 获取加载器
		 * @param	key
		 * @return
		 */
		public function getItem(key:String):AbstractItem
		{
			for each (var item:AbstractItem in _aItems)
			{
				if (item.sUrl == key)
					return item;
			}
			
			return null;
		}
		
		/**
		 * 开始加载
		 */
		public function start():void
		{
			_bStart = true;
			_iCurrentConnections = 0;
			_loadingQueue.buildMaxHeap(_aItems, "iPriority");
			canLoadNext();
			_nProgress = 0;
			_progressTimer = new Timer(30);
			_progressTimer.addEventListener(TimerEvent.TIMER, function(e:TimerEvent):void {
				onProgressHandler();
			});
			_progressTimer.start();
		}
		
		/**
		 * 完成所有加载以后触发 
		 * @param value
		 */		
		public function complete( value : Function ):void
		{
			_completeMsg.add( value, true );
		}
		
		/**
		 * 加载下一个
		 * @param	item
		 */
		private function loadNext(item:AbstractItem):void
		{
			if (item.bLoaded || item.bLoading)
			{
				trace("[[PQLoader:reload？]]");
			}
			else
			{
				_iCurrentConnections++;
				item.load();
				item.addEventListener(AbstractItem.ITEM_LOAD_COMPLETE, function(e:Event):void
					{
						_iCurrentConnections--;
						canLoadNext();
						if (_iCurrentConnections == 0)
						{
							_progressTimer.stop();
//							dispatchEvent(new Event(Event.COMPLETE));
							_completeMsg.dispatch();
						}
					});
			}
			canLoadNext();
		}
		
		/**
		 * 加载进度
		 */
		private function onProgressHandler():void
		{
			var totalBytes:Number = 0;
			var loadedBytes:Number = 0;
			for each (var item:AbstractItem in _aItems)
			{
				if (item.nTotalBytes > 0)
				{
					loadedBytes += item.nLoadedBytes;
					totalBytes += item.nTotalBytes;
				}
			}
			_nProgress = loadedBytes / totalBytes;
			_nProgress = _nProgress > 1 ? 1 : _nProgress;
			if (_progressHandler != null)
				_progressHandler(_nProgress);
		}
		
		/**
		 * 判断是否可以加载下一个
		 */
		private function canLoadNext():void
		{
			if (_iCurrentConnections < _iMaxConnections)
			{
				if (_loadingQueue.iHeapSize >= 0)
				{
					var _item:AbstractItem = _loadingQueue.extract() as AbstractItem;
					loadNext(_item);
				}
			}
		}
		
		/**
		 * 是否开始加载
		 */
		public function get bStart():Boolean
		{
			return _bStart;
		}
		
		/**
		 * 进度
		 */
		public function get nProgress():Number 
		{
			return _nProgress;
		}
		
		/**
		 * 侦听进度
		 * @param	value
		 */
		public function addProgressHandler(value:Function):void 
		{
			_progressHandler = value;
		}

		/**
		 * 加载的最大连接数
		 */
		public function get iMaxConnections():int
		{
			return _iMaxConnections;
		}

		/**
		 * @private
		 */
		public function set iMaxConnections(value:int):void
		{
			_iMaxConnections = value;
		}
	
	}

}