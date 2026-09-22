package Trigger.Triggers
{
    import Trigger.InstantTrigger;
    import Model.Observer;
    import Map.cPlayerZoneScreen;
    import Utils.StringUtils;
    import Utils.TriggerUtils;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Interface.cGeneralInterface;
    import Model.Notifier;
    import GO.cStreet;
    import __AS3__.vec.Vector;
    import Map.AdditionalDataTSO;

    public class StreetsInSectorListTrigger extends InstantTrigger implements Observer 
    {

        private var sectorList:Array;
        private var currentPlayerZone:cPlayerZoneScreen;

        public function StreetsInSectorListTrigger(_arg_1:Triggerable, _arg_2:TriggerVO, _arg_3:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3);
            this.sectorList = StringUtils.split(_arg_2.item_string, StringUtils.COMMA);
            this.currentPlayerZone = _arg_3.mCurrentPlayerZone;
            _arg_3.mCurrentPlayer.addPropertyObserver(TriggerUtils.STREETS_UPDATED_PROPERTY_NAME, this);
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            this.check();
        }

        override protected function computeCurrentAmount():Number
        {
            var _local_3:cStreet;
            var _local_4:int;
            var _local_5:int;
            var _local_6:String;
            var _local_1:int;
            var _local_2:Vector.<cStreet> = this.currentPlayerZone.mStreetDataMap.GetStreets_vector();
            if (this.sectorList.length > 0)
            {
                for each (_local_3 in _local_2)
                {
                    if (null != _local_3)
                    {
                        _local_4 = _local_3.GetGrid();
                        _local_5 = this.currentPlayerZone.mStreetDataMap.mAdditionalData.get(_local_4, AdditionalDataTSO.Sector);
                        _local_6 = String(_local_5);
                        if (TriggerUtils.contains(this.sectorList, _local_6))
                        {
                            _local_1++;
                        };
                    };
                };
            }
            else
            {
                _local_1 = _local_2.length;
            };
            return (_local_1);
        }

        override public function dispose():void
        {
            (para as cGeneralInterface).mCurrentPlayer.removePropertyObserver(TriggerUtils.STREETS_UPDATED_PROPERTY_NAME, this);
            this.currentPlayerZone = null;
            this.sectorList = null;
            super.dispose();
        }

        override public function check():Boolean
        {
            updateCurrentAmount();
            var _local_1:Number = getCurrentAmount();
            if (_local_1 >= definition.amount)
            {
                trigger();
                return (true);
            };
            return (false);
        }


    }
}
