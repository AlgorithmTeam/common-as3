/*
 * Copyright (c) 2008-2013 Ray Yee. All rights reserved.
 */

package common.data.structure
{

    /**
     * 二叉堆
     * 最大堆性质，且可用于优先级队列
     * @author rayyee
     */
    public class BinaryHeap_Max implements Iterator
    {
        /**
         * 用来判断值大小的属性
         */
        private var _sType:String;

        /**
         * 堆大小
         */
        private var _iHeapSize:int;

        /**
         * 数据集合
         */
        private var _aSource:Array;

        /**
         * 构造
         */
        public function BinaryHeap_Max()
        {

        }

        /**
         * 返回集合中的最大关键字的元素
         * O(1)
         * @return
         */
        public function getMax():*
        {
            return _aSource[0];
        }

        /**
         * 把元素key插入到集合中，并且需要继续保持堆性质
         * O(lgn)
         * @param    key
         */
        public function insert( key:* ):void
        {
            _iHeapSize++;
            _aSource[_iHeapSize] = {};
            increase( _iHeapSize, key );
        }

        /**
         * 将value的关键字替换为key元素，key必须要大于value的关键字值
         * O(lgn)
         * @param    value
         * @param    key
         */
        public function increase( value:int, key:* ):void
        {
            if ( key[_sType] < _aSource[value][_sType] )
                throw new Error( "new key is smaller than current key" );
            _aSource[value] = key;
            var loop:Boolean = value > 0 && _aSource[parent( value )][_sType] < _aSource[value][_sType];
            while ( loop )
            {
                exchange( value, parent( value ) );
                value = parent( value );
                loop = value > 0 && _aSource[parent( value )][_sType] < _aSource[value][_sType];
            }
        }

        /**
         * 去掉并返回集合中最大关键字的元素
         * O(lgn)
         * @return
         */
        public function extract():*
        {
            if ( _iHeapSize < 0 )
                throw new Error( "heap underflow" );
            var max:* = _aSource[0];
            _aSource[0] = _aSource[_iHeapSize];
            _iHeapSize--;
            maxHeapify( 0 );
            return max;
        }

        /**
         * 建立最大堆
         * O(nlgn)
         * @param    value
         * @param    type
         */
        public function buildMaxHeap( value:Array, type:String ):void
        {
            _sType = type;
            _aSource = [];
            _aSource = _aSource.concat( value );
            _iHeapSize = _aSource.length - 1;
            for ( var i:int = ((_aSource.length - 1) >> 1) >> 0; i > -1; i -= 1 )
                maxHeapify( i );
        }

        /**
         * 保持最大堆性质
         * O(lgn)
         * @param    value    从这个参数索引节点开始保持下去
         */
        public function maxHeapify( value:int ):void
        {
            var l:int = value << 1;//inline left(value);
            var r:int = (value << 1) + 1;//inline right(value);
            var largest:int;
            if ( l <= _iHeapSize && _aSource[l][_sType] > _aSource[value][_sType] )
                largest = l;
            else
                largest = value;
            if ( r <= _iHeapSize && _aSource[r][_sType] > _aSource[largest][_sType] )
                largest = r;
            if ( largest != value )
            {
                //inline exchange(value, largest);
                var c:* = _aSource[value];
                _aSource[value] = _aSource[largest];
                _aSource[largest] = c;

                maxHeapify( largest );
            }
        }

        /**
         * 左节点
         * @param    value
         * @return
         */
        private function left( value:int ):int
        {
            return value << 1;
        }

        /**
         * 右节点
         * @param    value
         * @return
         */
        private function right( value:int ):int
        {
            return (value << 1) + 1;
        }

        /**
         * 父节点
         * @param    value
         * @return
         */
        private function parent( value:int ):int
        {
            return (value >> 1) >> 0;
        }

        /**
         * 交换元素
         * @param    a
         * @param    b
         */
        private function exchange( a:int, b:int ):void
        {
            var c:* = _aSource[a];
            _aSource[a] = _aSource[b];
            _aSource[b] = c;
        }

        /**
         * 获取堆当前的大小
         * @private
         */
        private function get iHeapSize():int
        {
            return _iHeapSize;
        }

        /**
         * 迭代器
         */
        public function get first():*
        {
            //getMax();
            return _aSource[0];
        }
        public function get next():*
        {
            return extract();
        }
        public function get hasNext():Boolean
        {
            return _iHeapSize >= 0;
        }

    }

}