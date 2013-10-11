/*
 * Copyright (c) 2008-2013 Ray Yee. All rights reserved.
 */

package common.reflect
{

    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.MovieClip;
    import flash.utils.describeType;
    import flash.utils.getDefinitionByName;
    import flash.utils.getQualifiedClassName;

    /**
     * 反射美术资源
     * 动态映射到程序实现
     */
    public class AssetsReflect
    {
        /**
         * 注入器
         */
//        public static var injector:Injector;

        /**
         * Constructor
         */
        public function AssetsReflect()
        {
        }

        /**
         * 创建美术资源
         * 并添加到View中
         * 并且映射关系
         * @param viewInstance
         * @param artCls
         */
        public static function createArtToView(viewInstance : DisplayObjectContainer, artCls : Class) : void
        {
            var _assets : MovieClip = new artCls as MovieClip;
            mapArtTo(_assets, viewInstance);
            viewInstance.addChild(_assets);
            viewInstance.hasOwnProperty("skin") && ((viewInstance as Object).skin = _assets);
        }

        /**
         * 映射一个美术资源到某对象
         * @param art
         * @param mapped
         */
        public static function mapArtTo(art : DisplayObjectContainer, mapped : Object) : void
        {
            var mappedDescribe : XML = describeType(mapped);
            var child : DisplayObject, childClassName : String;
            var skinProcessor:*;
            for each( var node : XML in mappedDescribe..variable.metadata.(@name == "Map") )
            {
                child = searchChild(art, node.parent().@name);
                if ( child )
                {
                    childClassName = getQualifiedClassName(child);
                    //如果要映射成的类型是显示对象资源的类型  那就直接映射
                    if ( childClassName == node.parent().@type )
                        mapped[node.parent().@name] = child;
                    //如果metadata有skin字段   且该显示对象的类型和skin的值是一样的  那实例化待注入的变量并将skin通过构造函数传入
                    else
//                    if ( node.arg.(@key == "skin").@value == childClassName )
                    {
                        skinProcessor = new (getDefinitionByName(node.parent().@type) as Class)(child);
                        mapped[node.parent().@name] = skinProcessor;
//                        if (injector) injector.injectInto(skinProcessor);
                    }

                    //else
                    //trace("ArtSymbolMapper::no map object ", childClassName, node, node.parent().@name);
                }
            }
        }

        /**
         * 遍历显示对象结构
         * 找出对应的显示对象
         * @param p
         * @param name
         * @return
         */
        private static function searchChild(p : DisplayObjectContainer, name : String) : DisplayObject
        {
            var i : int = 0, len : int = p.numChildren, child : DisplayObject;
            for ( ; i < len; i += 1 )
            {
                child = p.getChildAt(i);
                if ( child.name == name )
                {
                    return child;
                }
                if ( child is DisplayObjectContainer )
                {
                    child = searchChild(child as DisplayObjectContainer, name);
                    if ( child ) return child;
                }
            }
            return null;
        }
    }
}
