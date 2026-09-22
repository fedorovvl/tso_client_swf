package GUI.GAME
{
    import GUI.cGuiBaseElement;
    import flash.utils.Timer;
    import Interface.cGameInterface;
    import GUI.Components.EventWidgetList;
    import mx.events.FlexEvent;
    import flash.events.TimerEvent;
    import GUI.Components.ItemRenderer.EventWidgetItemRenderer;

    public class cEventWidgetList extends cGuiBaseElement 
    {

        private var timer:Timer;
        private var _itemRendererMap:Object = {};
        private var mGI:cGameInterface;
        protected var mPanel:EventWidgetList;


        public function Init(_arg_1:EventWidgetList):void
        {
            this.mGI = (global.ui as cGameInterface);
            AddBaseElement(_arg_1);
            this.mPanel = _arg_1;
            this.timer = new Timer(10000);
            this.mPanel.addEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
            this.timer.addEventListener(TimerEvent.TIMER, this.updateEventTimes);
            this.timer.start();
        }

        private function completeHandler(_arg_1:FlexEvent):void
        {
        }

        public function Refresh():void
        {
            var _local_1:Object;
            var _local_2:EventWidgetItemRenderer;
            var _local_3:Object;
            var _local_6:String;
            var _local_7:int;
            if (!this.mGI.mEventManager)
            {
                return;
            };
            _local_3 = {};
            var _local_4:int;
            var _local_5:Array = this.mGI.mEventManager.GetActiveVisibleEvents();
            _local_5.sortOn("prio", Array.NUMERIC);
            for (_local_6 in this._itemRendererMap)
            {
                this.mPanel.list.removeChild(this._itemRendererMap[_local_6]);
                delete this._itemRendererMap[_local_6];
            };
            _local_7 = 0;
            while (((_local_7 < 3) && (_local_7 < _local_5.length)))
            {
                _local_2 = new EventWidgetItemRenderer();
                this._itemRendererMap[_local_5[_local_7].event_name_string] = _local_2;
                this.mPanel.list.addChild(_local_2);
                _local_2.data = _local_5[_local_7];
                _local_3[_local_5[_local_7].event_name_string] = _local_5[_local_7];
                _local_4++;
                _local_7++;
            };
            if (((this.mPanel.list.numChildren > 0) && (global.ui.isOnHomzone())))
            {
                this.Show();
            }
            else
            {
                Hide();
            };
        }

        private function updateEventTimes(_arg_1:TimerEvent):void
        {
            var _local_2:EventWidgetItemRenderer;
            for each (_local_2 in this._itemRendererMap)
            {
                _local_2.updateTime();
            };
        }

        override public function Show():void
        {
            super.Show();
        }


    }
}
