package GUI.Effects
{
    import flash.filters.GlowFilter;
    import __AS3__.vec.Vector;
    import flash.display.DisplayObject;
    import flash.utils.Dictionary;
    import __AS3__.vec.*;

    public class gGlowManager 
    {

        private static var glow:GlowFilter = new GlowFilter(16441444, 1, 10, 10, 4);
        private static var step:Number = 0.075;
        private static var elements:Vector.<DisplayObject> = new Vector.<DisplayObject>();
        private static var specificGlows:Object = {};


        public static function addElementWithGlow(_arg_1:DisplayObject, _arg_2:GlowFilter):void
        {
            var _local_3:int = elements.indexOf(_arg_1);
            if (_local_3 == -1)
            {
                _arg_1.filters = [_arg_2];
                specificGlows[_arg_1.toString()] = _arg_2;
                elements.push(_arg_1);
            };
        }

        public static function removeElement(_arg_1:DisplayObject):void
        {
            var _local_2:int = elements.indexOf(_arg_1);
            if (_local_2 > -1)
            {
                _arg_1.filters = [];
                elements.splice(_local_2, 1);
            };
        }

        public static function glowStep():void
        {
            var _local_2:DisplayObject;
            var _local_3:GlowFilter;
            glow.alpha = (glow.alpha + step);
            var _local_1:Dictionary = new Dictionary(true);
            for each (_local_2 in elements)
            {
                _local_3 = specificGlows[_local_2.toString()];
                if (_local_3 != null)
                {
                    if (!(_local_3 in _local_1))
                    {
                        _local_3.alpha = (_local_3.alpha + step);
                        _local_1[_local_3] = true;
                    };
                    _local_2.filters = [_local_3];
                }
                else
                {
                    _local_2.filters = [glow];
                };
            };
            if (((glow.alpha <= 0) || (glow.alpha >= 1)))
            {
                step = (step * -1);
            };
        }

        public static function addElement(_arg_1:DisplayObject):void
        {
            var _local_2:int = elements.indexOf(_arg_1);
            if (_local_2 == -1)
            {
                _arg_1.filters = [glow];
                elements.push(_arg_1);
            };
        }


    }
}
