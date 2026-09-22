package GUI.helpers
{
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.geom.Point;

    public class MovieClipHelpers 
    {


        public static function removeFromParent(_arg_1:DisplayObject):void
        {
            if (_arg_1 == null)
            {
                return;
            };
            if (_arg_1.parent == null)
            {
                return;
            };
            _arg_1.parent.removeChild(_arg_1);
        }

        public static function removeAllChildren(_arg_1:DisplayObjectContainer):void
        {
            if (_arg_1 == null)
            {
                return;
            };
            while (_arg_1.numChildren > 0)
            {
                _arg_1.removeChildAt(0);
            };
        }

        public static function localToLocal(_arg_1:DisplayObject, _arg_2:DisplayObject, _arg_3:Point):Point
        {
            if (_arg_3 == null)
            {
                return (null);
            };
            if (_arg_1 == null)
            {
                return (null);
            };
            if (_arg_2 == null)
            {
                return (null);
            };
            var _local_4:Point = _arg_1.localToGlobal(_arg_3);
            var _local_5:Point = _arg_2.globalToLocal(_local_4);
            return (_local_5);
        }


    }
}
