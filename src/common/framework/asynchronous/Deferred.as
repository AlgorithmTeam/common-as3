/*
 * Copyright (c) 2008-2013 Ray Yee. All rights reserved.
 */
package common.framework.asynchronous
{


    public class Deferred implements Promise
    {
        private var _complete : Function;
        protected var _reject : Function;

        /**
         * Constructor
         **/
        public function Deferred()
        {
        }

        /**
         * 进程处理完成
         * 注意：只会存在一个callback重复添加会覆盖
         * @param value
         * @return
         */
        public function complete(value : Function) : Promise
        {
            _complete = value;
            return this;
        }

        /**
         * 进程处理发生错误后
         * 注意：只会存在一个callback重复添加会覆盖
         * @param value
         * @return
         */
        public function reject(value : Function) : Promise
        {
            _reject = value;
            return this;
        }

        protected function propagate(...args) : void
        {
            _complete.apply(null, args);
        }
    }
}