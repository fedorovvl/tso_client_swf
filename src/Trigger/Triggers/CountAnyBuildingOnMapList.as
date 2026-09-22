package Trigger.Triggers
{
    import Trigger.InstantTrigger;
    import Model.Observer;
    import Utils.StringUtils;
    import Utils.TriggerUtils;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Interface.cGameInterface;
    import Model.Notifier;
    import Interface.cGeneralInterface;

    public class CountAnyBuildingOnMapList extends InstantTrigger implements Observer 
    {

        private var buildingList:Array;

        public function CountAnyBuildingOnMapList(_arg_1:Triggerable, _arg_2:TriggerVO, _arg_3:cGameInterface)
        {
            super(_arg_1, _arg_2, _arg_3);
            if (_arg_2.min < 0)
            {
                _arg_2.min = 0;
            };
            if (_arg_2.max < 0)
            {
                _arg_2.max = int.MAX_VALUE;
            };
            this.buildingList = StringUtils.split(_arg_2.item_string, StringUtils.COMMA);
            _arg_3.channels.ZONE.addPropertyObserver(TriggerUtils.ON_MAP_NOTIFICATION_PROPERTY_NAME, this);
        }

        override public function check():Boolean
        {
            updateCurrentAmount();
            var _local_1:Number = getCurrentAmount();
            if (((definition.min <= _local_1) && (_local_1 <= definition.max)))
            {
                trigger();
                return (true);
            };
            return (false);
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            var _local_4:String = (_arg_3 as String);
            if (((this.buildingList.length == 0) || (TriggerUtils.contains(this.buildingList, _local_4))))
            {
                this.check();
            };
        }

        override protected function computeCurrentAmount():Number
        {
            var _local_2:String;
            var _local_1:int;
            for each (_local_2 in this.buildingList)
            {
                _local_1 = (_local_1 + (para as cGeneralInterface).mCurrentPlayer.GetBuildingCount(_local_2));
            };
            return (_local_1);
        }

        override public function dispose():void
        {
            (para as cGeneralInterface).channels.ZONE.removePropertyObserver(TriggerUtils.ON_MAP_NOTIFICATION_PROPERTY_NAME, this);
            this.buildingList = null;
            super.dispose();
        }


    }
}
