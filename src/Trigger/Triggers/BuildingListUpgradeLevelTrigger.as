package Trigger.Triggers
{
    import Trigger.InstantTrigger;
    import Model.Observer;
    import Utils.HashSetWrapper;
    import Utils.StringUtils;
    import Utils.TriggerUtils;
    import GO.cBuilding;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Interface.cGeneralInterface;
    import Model.Notifier;
    import __AS3__.vec.Vector;

    public class BuildingListUpgradeLevelTrigger extends InstantTrigger implements Observer 
    {

        private var names:HashSetWrapper = new HashSetWrapper();
        private var mBuldingList:Array;

        public function BuildingListUpgradeLevelTrigger(_arg_1:Triggerable, _arg_2:TriggerVO, _arg_3:cGeneralInterface)
        {
            var _local_4:String;
            super(_arg_1, _arg_2, _arg_3);
            this.mBuldingList = StringUtils.split(_arg_2.item_string, StringUtils.COMMA);
            for each (_local_4 in StringUtils.split(_arg_2.name_string, ","))
            {
                this.names.add(_local_4);
            };
            if (!this.names.isEmpty())
            {
                _arg_3.channels.ZONE.addPropertyObserver(TriggerUtils.ON_MAP_NOTIFICATION_PROPERTY_NAME, this);
            };
            _arg_3.channels.BUILDING.addPropertyObserver(cBuilding.BUILDING_UPGRADED_string, this);
            _arg_3.mCurrentPlayerZone.mStreetDataMap.addPropertyObserver("mBuildings_vector", this);
        }

        override public function dispose():void
        {
            if (!this.names.isEmpty())
            {
                (para as cGeneralInterface).channels.ZONE.removePropertyObserver(TriggerUtils.ON_MAP_NOTIFICATION_PROPERTY_NAME, this);
            };
            (para as cGeneralInterface).mCurrentPlayerZone.mStreetDataMap.removePropertyObserver("mBuildings_vector", this);
            (para as cGeneralInterface).channels.BUILDING.removePropertyObserver(cBuilding.BUILDING_UPGRADED_string, this);
            super.dispose();
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            this.check();
        }

        override protected function computeCurrentAmount():Number
        {
            var _local_3:cBuilding;
            var _local_4:Object;
            var _local_5:String;
            var _local_1:Vector.<cBuilding> = (para as cGeneralInterface).mCurrentPlayerZone.mStreetDataMap.GetBuildings_vector();
            var _local_2:int;
            for each (_local_3 in _local_1)
            {
                if (null != _local_3)
                {
                    if (_local_3.getPlayerID() == (para as cGeneralInterface).mHomePlayer.GetPlayerId())
                    {
                        if (((definition.item_string == "") || (TriggerUtils.contains(this.mBuldingList, _local_3.GetBuildingName_string()))))
                        {
                            if (_local_3.GetUpgradeLevel() >= definition.min)
                            {
                                _local_2++;
                            };
                        };
                    };
                };
            };
            if (!this.names.isEmpty())
            {
                for each (_local_4 in this.names.toArray())
                {
                    _local_5 = (_local_4 as String);
                    _local_1 = (para as cGeneralInterface).mCurrentPlayerZone.mStreetDataMap.getBuildingsByName_vector(_local_5);
                    if (_local_1 != null)
                    {
                        for each (_local_3 in _local_1)
                        {
                            if (null != _local_3)
                            {
                                _local_2++;
                            };
                        };
                    };
                };
            };
            return (_local_2);
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
