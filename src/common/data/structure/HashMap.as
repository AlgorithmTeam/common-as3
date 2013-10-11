/*
 * Copyright (c) 2008-2013 Ray Yee. All rights reserved.
 */

package common.data.structure
{
	import flash.utils.Dictionary;
	
	/**
	 * ...哈希表接口
	 * @author May
	 */
	public class HashMap
	{
		/**
		 * 键数组
		 */
		private var _keys:Array = null;
		/**
		 * 值对象
		 */
		private var props:Dictionary = null;
		
		/**
		 * 构造
		 */
		public function HashMap()
		{
			declareVariables();
		}
		
		/**
		 * 声明变量
		 */
		public function declareVariables():void
		{
			props = new Dictionary();
			_keys = new Array();
		}
		
		/**
		 * 是否包含指定的键值
		 * @param	键
		 * @return
		 */
		public function containsKey(key:Object):Boolean
		{
			return props[key] != null;
		}
		
		/**
		 * 是否包含指定的值
		 * @param	value   具体的值
		 * @return
		 */
		public function containsValue(value:Object):Boolean
		{
			var i:int;
			//键的长度
			var count:int = size();
			if (count > 0)
				for (i = 0; i < count; i += 1)
					if (props[_keys[i]] == value)
						return true;
			return false;
		}
		
		/**
		 * 根据键得到值
		 * @param	key
		 * @return
		 */
		public function get(key:Object):Object
		{
			return props[key];
		}
		
		/**
		 * 放入新值
		 * @param	key     键
		 * @param	value   值
		 * @return
		 */
		public function put(key:Object, value:Object):Object
		{
			var result:Object = null;
			//如果已经有包含
			if (containsKey(key))
			{
				result = get(key);
				props[key] = value;
			}
			//如果没有包含
			else
			{
				props[key] = value;
				_keys.push(key);
			}
			return result;
		}
		
		/**
		 * 根据键移除值
		 * @param	key   键
		 * @return
		 */
		public function remove(key:Object):Object
		{
			var result:Object = null;
			//如果包含这个值
			if (containsKey(key))
			{
				//删除值对象的元素
				delete props[key];
				var index:int = _keys.indexOf(key);
				if (index > -1)
					_keys.splice(index, 1);
			}
			return result;
		}
		
		/**
		 * 把指定哈希表放入当前表，删除当前表中内容
		 * @param	map
		 */
		public function putAll(map:HashMap):void
		{
			//重设变量
			declareVariables();
			putMap(map);
		}
		
		/**
		 * 把指定哈希表连接到当前表中，保留当前表中内容
		 * @param	map
		 */
		public function concat(map:HashMap):void
		{
			//但前表为空，则新建，否则保留原有表内容
			if (_keys == null)
				declareVariables();
			putMap(map);
		}
		/**
		 * 把指定哈希表放入当前表
		 * @param	map
		 */
		private function putMap(map:HashMap):void
		{
			if (map != null)
			{
				var count:int = map.size();
				if (count > 0)
				{
					var i:int;
					var arr:Array = map.keys();
					for (i = 0; i < count; i += 1)
						put(arr[i], map.get(arr[i]));
				}
			}
		}
		
		/**
		 * 键值长度
		 * @return
		 */
		public function size():uint
		{
			return _keys.length;
		}
		
		/**
		 * 是否为空
		 * @return
		 */
		public function isEmpty():Boolean
		{
			return size() < 1;
		}
		
		/**
		 * 值数组
		 * @return
		 */
		public function values():Array
		{
			var result:Array = new Array();
			var count:int = size();
			
			if (count > 0)
			{
				var i:int;
				for (i = 0; i < count; i += 1)
					result.push(props[_keys[i]]);
			}
			return result;
		}
		
		/**
		 * 键值数组
		 * @return
		 */
		public function keys():Array
		{
			return _keys;
		}
	
	}
}
