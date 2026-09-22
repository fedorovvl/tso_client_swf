package GUI.Decorator
{
    import mx.managers.ToolTipManager;
    import mx.events.ToolTipEvent;
    import GUI.Components.ToolTips.cToolTipUtil;
    import mx.core.UIComponent;
    import flash.events.MouseEvent;
    import flash.display.DisplayObject;
    import flash.filters.BitmapFilter;
    import flash.filters.ColorMatrixFilter;
    import flash.display.BitmapData;
    import flash.geom.Matrix;
    import flash.display.Bitmap;

    public final class GUIDecorator 
    {

        private static var showDelay:Number = ToolTipManager.showDelay;
        private static var hideDelay:Number = ToolTipManager.hideDelay;


        public static function setToolTip(ui:UIComponent, tooltipType:String, tooltipText:String=null, data:Object=null):void
        {
            if (((ui == null) || (tooltipType == null)))
            {
                return;
            };
            if (tooltipText != null)
            {
                ui.toolTip = tooltipText;
            };
            ui.addEventListener(ToolTipEvent.TOOL_TIP_CREATE, function (_arg_1:ToolTipEvent):void
            {
                cToolTipUtil.createToolTip(tooltipType, _arg_1, data);
            });
        }

        public static function setToolTipDelays(ui:UIComponent, showDelay:Number, hideDelay:Number=0):void
        {
            if (ui == null)
            {
                return;
            };
            ui.addEventListener(MouseEvent.ROLL_OVER, function (_arg_1:MouseEvent):void
            {
                ToolTipManager.showDelay = internal::showDelay;
                if (internal::hideDelay != 0)
                {
                    ToolTipManager.hideDelay = internal::hideDelay;
                };
            });
            ui.addEventListener(MouseEvent.ROLL_OUT, function (_arg_1:MouseEvent):void
            {
                ToolTipManager.showDelay = GUIDecorator.showDelay;
                if (internal::hideDelay != 0)
                {
                    ToolTipManager.hideDelay = GUIDecorator.hideDelay;
                };
            });
        }

        public static function removeFilter(_arg_1:DisplayObject, _arg_2:BitmapFilter):void
        {
            var _local_3:int = _arg_1.filters.indexOf(_arg_2);
            if (_local_3 >= 0)
            {
                _arg_1.filters.splice(_local_3, 1);
                _arg_1.filters = _arg_1.filters;
            };
        }

        public static function greyFilter(_arg_1:UIComponent, _arg_2:Number=0.4):void
        {
            if (_arg_1 == null)
            {
                return;
            };
            addFilter(_arg_1, new ColorMatrixFilter([_arg_2, _arg_2, _arg_2, 0, 0, _arg_2, _arg_2, _arg_2, 0, 0, _arg_2, _arg_2, _arg_2, 0, 0, 0, 0, 0, 1, 0]));
        }

        public static function addFilter(_arg_1:DisplayObject, _arg_2:BitmapFilter):void
        {
            if (_arg_1.filters.length == 0)
            {
                _arg_1.filters = [_arg_2];
            }
            else
            {
                _arg_1.filters.push(_arg_2);
                _arg_1.filters = _arg_1.filters;
            };
        }

        public static function coloringFilter(_arg_1:UIComponent, _arg_2:uint):void
        {
            if (_arg_1 == null)
            {
                return;
            };
            var _local_3:Number = ((_arg_2 >> 16) & 0xFF);
            var _local_4:Number = ((_arg_2 >> 8) & 0xFF);
            var _local_5:Number = (_arg_2 & 0xFF);
            _local_3 = (_local_3 / 0xFF);
            _local_4 = (_local_4 / 0xFF);
            _local_5 = (_local_5 / 0xFF);
            addFilter(_arg_1, new ColorMatrixFilter([_local_3, 0, 0, 0, 0, 0, _local_4, 0, 0, 0, 0, 0, _local_5, 0, 0, 0, 0, 0, 1, 0]));
        }

        public static function overlay(_arg_1:DisplayObject, _arg_2:DisplayObject, _arg_3:int=0, _arg_4:int=0):Bitmap
        {
            var _local_5:BitmapData;
            var _local_8:int;
            var _local_9:int;
            var _local_10:int;
            var _local_11:int;
            var _local_6:Matrix = new Matrix();
            var _local_7:Matrix = new Matrix();
            if (_arg_3 < 0)
            {
                _local_6.tx = -(_arg_3);
                _local_7.tx = 0;
                _local_10 = _arg_2.width;
                _local_8 = (_arg_1.width - _arg_3);
            }
            else
            {
                _local_6.tx = 0;
                _local_7.tx = _arg_3;
                _local_10 = (_arg_2.width + _arg_3);
                _local_8 = _arg_1.width;
            };
            if (_arg_4 < 0)
            {
                _local_6.ty = -(_arg_4);
                _local_7.ty = 0;
                _local_10 = _arg_2.height;
                _local_8 = (_arg_1.height - _arg_4);
            }
            else
            {
                _local_6.ty = 0;
                _local_7.ty = _arg_4;
                _local_11 = (_arg_2.height + _arg_4);
                _local_9 = _arg_1.height;
            };
            _local_5 = new BitmapData(((_local_8 > _local_10) ? _local_8 : _local_10), ((_local_9 > _local_11) ? _local_9 : _local_11), true, 0);
            _local_5.draw(_arg_1, _local_6);
            _local_5.draw(_arg_2, _local_7);
            return (new Bitmap(_local_5));
        }


    }
}
