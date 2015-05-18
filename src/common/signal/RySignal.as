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
			for each(var listener:ListenerNode in _listeners)
			{
				remove(listener.res);
			}
		}
		
		public function dispatch(...objects) : void
		{
			var listener:ListenerNode;
			for (var i:* in _listeners)
			{
				listener = _listeners[i];
				if (listener)
				{
					listener.res.apply(null, objects);	
					if (listener.once)
					{
						remove(listener.res);
					}
				}
			}
		}
		
	}
}
