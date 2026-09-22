package GUI.Components
{
    import mx.controls.TileList;
    import com.bluebyte.bluefire.puremvc.view.IBFList;
    import mx.events.ScrollEvent;
    import mx.events.ScrollEventDirection;
    import flash.events.MouseEvent;
    import flash.display.Sprite;
    import mx.controls.listClasses.IListItemRenderer;

    public class CustomTileList extends TileList implements IBFList 
    {

        private var _windowID:String;


        override protected function mouseWheelHandler(_arg_1:MouseEvent):void
        {
            var _local_2:Number;
            var _local_3:Number;
            var _local_4:ScrollEvent;
            if (((verticalScrollBar) && (verticalScrollBar.visible)))
            {
                _arg_1.stopPropagation();
                _local_2 = verticalScrollPosition;
                _local_3 = verticalScrollPosition;
                _local_3 = (_local_3 - ((_arg_1.delta / Math.abs(_arg_1.delta)) * 1));
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

        public function get windowID():String
        {
            return (this._windowID);
        }

        public function set windowID(_arg_1:String):void
        {
            this._windowID = _arg_1;
            global.getApplication().inputNotifier.notifyClick(_arg_1);
            global.ui.mQuestClientCallbacks.InitiateWindowOpen(_arg_1);
        }

        override protected function drawSelectionIndicator(_arg_1:Sprite, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Number, _arg_6:uint, _arg_7:IListItemRenderer):void
        {
        }


    }
}
