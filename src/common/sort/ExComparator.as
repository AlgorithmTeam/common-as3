/*
 * Copyright (c) 2008-2013 Ray Yee. All rights reserved.
 */

package common.sort
{
	
	/**
	 * ...排序  扩展
	 * @example		var _exComparator:ExComparator = new ExComparator();
	 * 				vec = _exComparator.sort(vec,["level","cash"],[1,-1]);
	 * @author rayyee
	 */
	public class ExComparator
	{
		/**
		 * 需要判断的类型
		 */
		private var _aTypes:Array;
		/**
		 * 顺序  [升序 或 降序]
		 */
		private var _iOrder:Object;
		
		/**
		 * 排序
		 * @param	aObjects	要排序的集合  Vector 或 Array
		 * @param	types		排序的条件  支持多个类型判断  数组内存放字符串
		 * @param	order		升序[1]  降序[-1]   可以传数组对应types的内容
		 * @return
		 */
		public function sort(aObjects:*, types:Array, order:* = 1):*
		{
			_iOrder = order;
			_aTypes = types;
			
			aObjects.sort(function(a:*, b:*):Number {
				return comparatorSub(a, b, 0);
			});
			return aObjects;
		}
		
		/**
		 * 排序方法子程序
		 * @param	a
		 * @param	b
		 * @param	value
		 * @return
		 */
		private function comparatorSub(a:*, b:*, value:int):Number
		{
			if (value < _aTypes.length)
			{
				var diff:Number = getDifference(a, b, _aTypes[value]);
				if (diff > 0)
				{
					return 1 * (_iOrder is Array ? _iOrder[value] : int(_iOrder));
				}
				else if (diff < 0)
				{
					return -1 * (_iOrder is Array ? _iOrder[value] : int(_iOrder));
				}
				else
				{
					value++;
					return comparatorSub(a, b, value);
				}
			}
			else
			{
				return 0;
			}
		}
		
		/**
		 * 获取2个元素的比较值
		 * @param	a
		 * @param	b
		 * @param	value
		 * @return
		 */
		private function getDifference(a:*, b:*, value:String):Number
		{
			var aProperty:Array = value.split(".");
			if (aProperty.length == 1)
			{
				if (a[value] > b[value])
					return 1;
				else if (a[value] < b[value])
					return -1;
				return 0;
			}
			else if (aProperty.length == 2)
			{
				if (a[aProperty[0]][aProperty[1]] > b[aProperty[0]][aProperty[1]])
					return 1;
				else if (a[aProperty[0]][aProperty[1]] < b[aProperty[0]][aProperty[1]])
					return -1;
				return 0;
			}
			else if (aProperty.length == 3)
			{
				if (a[aProperty[0]][aProperty[1]][aProperty[2]] > b[aProperty[0]][aProperty[1]][aProperty[2]])
					return 1;
				else if (a[aProperty[0]][aProperty[1]][aProperty[2]] < b[aProperty[0]][aProperty[1]][aProperty[2]])
					return -1;
				return 0;
			}
			else
				return 0;
		}
	
	}

}