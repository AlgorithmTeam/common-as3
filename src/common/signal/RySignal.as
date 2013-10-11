/*
 * Copyright (c) 2008-2013 Ray Yee. All rights reserved.
 */
package common.signal
{
	import flash.utils.Dictionary;

	public class RySignal
	{
		private var _listeners:Dictionary;

		/**
		 * Constructor 
		 */		
		public function RySignal()
		{
			_listeners 	= new Dictionary(true);
		}
		
		public function add(value:Function, bOnce:Boolean = false):void
		{
			if (_listeners[value]) return;
			var lisen:ListenerNode = new ListenerNode;
			lisen.res = value;
			lisen.once = bOnce;
			_listeners[value] = lisen;
		}
		
		public function remove(value:Function):void
		{
			delete _listeners[value];
			_listeners[value] = null;
		}
		
		public function removeAll() : void
		{
			var lisen:ListenerNode;
			for (var i:* in _listeners)
			{
				lisen = _listeners[i];
				if (lisen)
				{
					delete _listeners[i];
					_listeners[i] = null;
				}
			}
		}
		
		public function dispatch(...objects) : void
		{
			var lisen:ListenerNode;
			for (var i:* in _listeners)
			{
				lisen = _listeners[i];
				if (lisen)
				{
					lisen.res.apply(null, objects);	
					if (lisen.once)
					{
						delete _listeners[i];
						_listeners[i] = null;
					}
				}
			}
		}
		
	}
}