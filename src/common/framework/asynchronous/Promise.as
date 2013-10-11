/*
 * Copyright (c) 2008-2013 Ray Yee. All rights reserved.
 */

package common.framework.asynchronous
{

    /**
     * Safely asynchronous operation
     * @author rayyee
     */
    public interface Promise
    {

        /**
         * Operation complete
         * @param value
         * @return
         */
        function complete(value : Function) : Promise;

        /**
         * Errors than reject handler
         * @param value
         */
        function reject(value : Function) : Promise;

    }
}