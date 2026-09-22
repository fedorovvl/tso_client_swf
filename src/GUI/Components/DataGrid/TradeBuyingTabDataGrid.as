package GUI.Components.DataGrid
{
    import flash.display.Shape;
    import mx.controls.listClasses.ListBaseContentHolder;
    import mx.core.FlexShape;
    import flash.display.Graphics;
    import mx.collections.ArrayCollection;
    import flash.display.Sprite;
    import mx.controls.listClasses.IListItemRenderer;
    import flash.events.MouseEvent;

    public class TradeBuyingTabDataGrid extends CustomDataGrid 
    {

        private var selectionUpward:Boolean;


        override protected function finishKeySelection():void
        {
        }

        override protected function drawRowBackground(_arg_1:Sprite, _arg_2:int, _arg_3:Number, _arg_4:Number, _arg_5:uint, _arg_6:int):void
        {
            var _local_9:Shape;
            var _local_11:Object;
            var _local_7:ListBaseContentHolder = ListBaseContentHolder(_arg_1.parent);
            var _local_8:Number = 0;
            if (_arg_2 < _arg_1.numChildren)
            {
                _local_9 = Shape(_arg_1.getChildAt(_arg_2));
            }
            else
            {
                _local_9 = new FlexShape();
                _local_9.name = "background";
                _arg_1.addChild(_local_9);
            };
            _local_9.y = _arg_3;
            _arg_4 = Math.min(_arg_4, (_local_7.height - _arg_3));
            var _local_10:Graphics = _local_9.graphics;
            _local_10.clear();
            if (dataProvider)
            {
                if (_arg_6 < dataProvider.length)
                {
                    _local_11 = (dataProvider as ArrayCollection).getItemAt(_arg_6);
                    if (!_local_11.isAffordable)
                    {
                        _arg_5 = 0xFF0000;
                        _local_8 = 0.2;
                    }
                    else
                    {
                        _arg_5 = 0xFFFFFF;
                        _local_8 = 0;
                    };
                };
            };
            _local_10.beginFill(_arg_5, _local_8);
            _local_10.drawRect(0, 0, _local_7.width, _arg_4);
            _local_10.endFill();
        }

        private function disabledFunction(_arg_1:*):Boolean
        {
            return (!(_arg_1.isAffordable));
        }

        override protected function mouseEventToItemRenderer(_arg_1:MouseEvent):IListItemRenderer
        {
            var _local_2:IListItemRenderer = super.mouseEventToItemRenderer(_arg_1);
            if (_local_2)
            {
                if (_local_2.data)
                {
                    if (this.disabledFunction(_local_2.data))
                    {
                        return (null);
                    };
                };
            };
            return (_local_2);
        }

        override protected function moveSelectionVertically(_arg_1:uint, _arg_2:Boolean, _arg_3:Boolean):void
        {
        }


    }
}
