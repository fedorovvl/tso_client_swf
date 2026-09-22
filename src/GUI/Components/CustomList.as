package GUI.Components
{
    import mx.controls.List;
    import flash.events.Event;
    import mx.events.ScrollEvent;
    import mx.events.ScrollEventDirection;
    import flash.events.MouseEvent;

    public class CustomList extends List 
    {


        override protected function collectionChangeHandler(_arg_1:Event):void
        {
            super.collectionChangeHandler(_arg_1);
            invalidateProperties();
        }

        override protected function mouseWheelHandler(_arg_1:MouseEvent):void
        {
            var _local_2:Number;
            var _local_3:int;
            var _local_4:ScrollEvent;
            if (((verticalScrollBar) && (verticalScrollBar.visible)))
            {
                _arg_1.stopPropagation();
                _local_2 = verticalScrollPosition;
                _local_3 = verticalScrollPosition;
                _local_3 = int((_local_3 - (_arg_1.delta / Math.abs(_arg_1.delta))));
                _local_3 = Math.max(0, Math.min(_local_3, verticalScrollBar.maxScrollPosition));
                verticalScrollPosition = _local_3;
                if (_local_2 != verticalScrollPosition)
                {
                    _local_4 = new ScrollEvent(ScrollEvent.SCROLL);
                    _local_4.direction = ScrollEventDirection.VERTICAL;
                    _local_4.position = verticalScrollPosition;
                    _local_4.delta = (verticalScrollPosition - _local_2);
                    dispatchEvent(_local_4);
                };
            };
        }


    }
}
