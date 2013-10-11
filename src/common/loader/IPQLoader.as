/*
 * Copyright (c) 2008-2013 Ray Yee. All rights reserved.
 */

package common.loader
{

    import common.loader.item.AbstractItem;

    public interface IPQLoader
    {
        function addItem(url : String, item : Class = null, prop : Object = null) : AbstractItem;

        function getItem(key : String) : AbstractItem;

        function start() : void;

        function complete(value : Function) : void;

        function get bStart() : Boolean;

        function get nProgress() : Number;

        function addProgressHandler(value : Function) : void;

        function get iMaxConnections() : int;

        function set iMaxConnections(value : int) : void;
    }
}
