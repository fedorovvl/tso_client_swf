package com.bluebyte.tso.util
{
    import flash.display.DisplayObject;

    public class DisplayObjectUtils 
    {


        public static function findAncestor(_arg_1:DisplayObject, _arg_2:DisplayObject):DisplayObject
        {
            if (_arg_1 == _arg_2)
            {
                return (_arg_2);
            };
            if (_arg_1.parent == null)
            {
                return (null);
            };
            if (_arg_1.parent == _arg_2)
            {
                return (_arg_2);
            };
            return (findAncestor(_arg_1.parent, _arg_2));
        }


    }
}
