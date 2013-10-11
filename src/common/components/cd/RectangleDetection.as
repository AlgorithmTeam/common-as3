/*
 * Copyright (c) 2008-2013 Ray Yee. All rights reserved.
 */

package common.components.cd
{

    public class RectangleDetection
    {
        public function RectangleDetection()
        {

        }

        public function intersectWithRectangle(a : Object, b : Object) : Boolean
        {
            return (
                    a.left < b.right &&	//leftA < rightB
                    b.left < a.right &&	//leftB < rightA
                    a.top < b.bottom && //topA < bottomB
                    b.top < a.bottom	//topB < bottomA
                    );
        }

        public function intersectWithPoint() : Boolean
        {
            
        }
    }
}
