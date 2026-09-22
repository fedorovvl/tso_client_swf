package ServerState
{
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;

    public class cLoginQueueStatus 
    {

        private var mAvg:Number;
        private var mQueuePos:int;
        private var mTime:Array;
        private var mAdvancedPositions:int;
        private var mSum:Number;

        public function cLoginQueueStatus()
        {
            super();
            this.mAdvancedPositions = 0;
            this.mQueuePos = 0;
            this.mAvg = 0;
            this.mSum = 0;
            this.mTime = [];
            this.mTime[0] = new Date().getTime();
        }

        public function update(_arg_1:String):void
        {
            var _local_4:Array;
            var _local_5:Array;
            var _local_6:int;
            var _local_7:int;
            var _local_8:String;
            var _local_2:String = String(_arg_1);
            var _local_3:Array = _local_2.split("&");
            if (_local_3.length >= 2)
            {
                _local_4 = String(_local_3[0]).split("=");
                _local_5 = String(_local_3[1]).split("=");
                _local_6 = 1;
                if (_local_4.length >= 2)
                {
                    _local_6 = int(_local_4[1]);
                };
                _local_7 = 1;
                if (_local_5.length >= 2)
                {
                    _local_7 = int(_local_5[1]);
                };
                if (this.mQueuePos == 0)
                {
                    this.mQueuePos = _local_6;
                }
                else
                {
                    if (_local_6 < this.mQueuePos)
                    {
                        this.mAdvancedPositions = (this.mAdvancedPositions + (this.mQueuePos - _local_6));
                        this.mQueuePos = _local_6;
                    };
                };
                if (this.mAdvancedPositions > 0)
                {
                    this.mAvg = ((this.mSum / this.mAdvancedPositions) * this.mQueuePos);
                };
                _local_8 = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "LoginQueuePosition", [this.mQueuePos, _local_7]);
                if (this.mAvg > 0)
                {
                    _local_8 = (_local_8 + (" " + cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "LoginQueueRemainingTime", [cLocaManager.GetInstance().FormatDuration(this.mAvg)])));
                }
                else
                {
                    _local_8 = (_local_8 + (" " + cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "LoginQueueApproxTime")));
                };
                globalFlash.gui.mNewsWindow.SetLoadingMessageFromBB(_local_8);
                globalFlash.gui.mLoadingZonePanel.SetLoadingMessageFromBB(_local_8, true);
                this.mTime[1] = new Date().getTime();
                this.mSum = (this.mSum + (this.mTime[1] - this.mTime[0]));
                this.mTime[0] = this.mTime[1];
            };
        }

        public function dispose():void
        {
            this.mAdvancedPositions = -1;
            this.mSum = 0;
            this.mAvg = 0;
            this.mTime.length = 0;
            this.mTime = null;
            var _local_1:String = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "LoadingZone");
            globalFlash.gui.mNewsWindow.SetLoadingMessageFromBB(_local_1);
            globalFlash.gui.mLoadingZonePanel.SetLoadingMessageFromBB(_local_1, false);
        }


    }
}
