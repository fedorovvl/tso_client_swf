package GUI.helpers
{
    import flash.display.InteractiveObject;
    import flash.display.DisplayObjectContainer;
    import mx.core.UIComponent;
    import flash.display.DisplayObject;
    import nLib.cLog;

    public class UIComponentHelpers 
    {

        public static const TOP:String = "top";
        public static const BOTTOM:String = "bottom";
        public static const LEFT:String = "left";
        public static const RIGHT:String = "right";
        public static const VERTICAL_GAP:String = "verticalGap";
        public static const HORIZONTAL_GAP:String = "horizontalGap";
        public static const HORIZONTAL_CENTER:String = "horizontalCenter";
        public static const BACKGROUND_IMAGE:String = "backgroundImage";

        public function UIComponentHelpers()
        {
            super();
            throw (new Error("Do not instanciate this class!"));
        }

        public static function enableMouseInteractionForListWithStopAtFirstParentOption(_arg_1:Boolean, ... _args):void
        {
            var _local_3:InteractiveObject;
            for each (_local_3 in _args)
            {
                if (_local_3 != null)
                {
                    enableMouseInteraction(_local_3, _arg_1);
                };
            };
        }

        public static function removeMouseInteraction(_arg_1:InteractiveObject):void
        {
            var _local_5:DisplayObjectContainer;
            if (!_arg_1)
            {
                throw (new ArgumentError("InteractiveObject is null"));
            };
            var _local_2:DisplayObjectContainer = (_arg_1 as DisplayObjectContainer);
            _arg_1.mouseEnabled = false;
            if (_local_2)
            {
                _local_2.mouseChildren = false;
            };
            var _local_3:int;
            var _local_4:int = ((_local_2) ? _local_2.numChildren : 0);
            var _local_6:Function = removeMouseInteraction;
            while (_local_3 < _local_4)
            {
                _local_5 = (_local_2.getChildAt(_local_3) as DisplayObjectContainer);
                _local_3++;
                if (_local_5 != null)
                {
                    (_local_6(_local_5));
                };
            };
        }

        public static function getTopValue(_arg_1:UIComponent):Number
        {
            return (getStyleAsNumber(_arg_1, TOP));
        }

        public static function getBottomValue(_arg_1:UIComponent):Number
        {
            return (getStyleAsNumber(_arg_1, BOTTOM));
        }

        public static function removeFromParent(_arg_1:DisplayObject):Boolean
        {
            var _local_2:Boolean;
            if (!_arg_1)
            {
                throw (new ArgumentError("dObj"));
            };
            if (_arg_1.parent)
            {
                _arg_1.parent.removeChild(_arg_1);
                _local_2 = true;
            };
            return (_local_2);
        }

        public static function enableMouseInteractionForList(... _args):void
        {
            var _local_2:InteractiveObject;
            for each (_local_2 in _args)
            {
                if (_local_2 != null)
                {
                    enableMouseInteraction(_local_2);
                };
            };
        }

        public static function enableMouseInteraction(io:InteractiveObject, stopAtFirstMouseEnabledParent:Boolean=true):void
        {
            if (!io)
            {
                throw (new ArgumentError("InteractiveObject is null"));
            };
            io.mouseEnabled = true;
            var p:DisplayObjectContainer = io.parent;
            try
            {
                while (p)
                {
                    if (((stopAtFirstMouseEnabledParent) && (p.mouseChildren))) break;
                    p.mouseChildren = true;
                    p = p.parent;
                };
            }
            catch(e:Error)
            {
                cLog.error(((("Error:" + e.errorID) + " Message:") + e.message));
            };
        }

        public static function getStyleAsInt(_arg_1:UIComponent, _arg_2:String):int
        {
            return (int(getStyle(_arg_1, _arg_2)));
        }

        public static function getRightValue(_arg_1:UIComponent):Number
        {
            return (getStyleAsNumber(_arg_1, RIGHT));
        }

        public static function getLeftValue(_arg_1:UIComponent):Number
        {
            return (getStyleAsNumber(_arg_1, LEFT));
        }

        public static function getStyleAsNumber(_arg_1:UIComponent, _arg_2:String):Number
        {
            var _local_3:* = getStyle(_arg_1, _arg_2);
            var _local_4:Number = Number(_local_3);
            if (isNaN(_local_4))
            {
                return (0);
            };
            return (_local_4);
        }

        public static function getStyle(_arg_1:UIComponent, _arg_2:String):*
        {
            return (_arg_1.getStyle(_arg_2));
        }

        public static function getStyleAsString(_arg_1:UIComponent, _arg_2:String):String
        {
            return (String(getStyle(_arg_1, _arg_2)));
        }


    }
}
