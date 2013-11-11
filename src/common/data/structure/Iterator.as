/**
 * User: Ray Yee
 * Date: 13-11-11
 */
package common.data.structure
{
    public interface Iterator
    {
        function get hasNext():Boolean;

        function get first():*;

        function get next():*;
    }
}
