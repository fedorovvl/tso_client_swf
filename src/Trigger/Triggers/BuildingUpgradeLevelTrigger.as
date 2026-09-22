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

    public final class BuildingUpgradeLevelTrigger extends InstantTrigger implements Observer 
    {

        private var names:HashSetWrapper = new HashSetWrapper();

        public function BuildingUpgradeLevelTrigger(_arg_1:Triggerable, _arg_2:TriggerVO, _arg_3:cGeneralInterface)
        {
            var _local_4:String;
            super(_arg_1, _arg_2, _arg_3);
            if (_arg_2.max == 0)
            {
                _arg_2.max = 100;
            };
            if (_arg_2.min == 0)
            {
                _arg_2.min = 1;
            };
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
            var _local_5:Object;
            var _local_6:String;
            var _local_1:cGeneralInterface = (para as cGeneralInterface);
            var _local_2:Vector.<cBuilding>;
            var _local_3:cBuilding;
            var _local_4:Number = 0;
            if (StringUtils.isEmpty(definition.item_string))
            {
                _local_2 = _local_1.mCurrentPlayerZone.mStreetDataMap.GetBuildings_vector();
                for each (_local_3 in _local_2)
                {
                    if (null != _local_3)
                    {
                        if (((_local_3.GetUpgradeLevel() >= definition.min) && (_local_3.GetUpgradeLevel() <= definition.max)))
                        {
                            _local_4++;
                        };
                    };
                };
            }
            else
            {
                _local_2 = _local_1.mCurrentPlayerZone.mStreetDataMap.getBuildingsByName_vector(definition.item_string);
                if (_local_2 != null)
                {
                    for each (_local_3 in _local_2)
                    {
                        if (null != _local_3)
                        {
                            if (((_local_3.GetUpgradeLevel() >= definition.min) && (_local_3.GetUpgradeLevel() <= definition.max)))
                            {
                                _local_4++;
                            };
                        };
                    };
                };
            };
            if (!this.names.isEmpty())
            {
                for each (_local_5 in this.names.toArray())
                {
                    _local_6 = (_local_5 as String);
                    _local_2 = _local_1.mCurrentPlayerZone.mStreetDataMap.getBuildingsByName_vector(_local_6);
                    if (_local_2 != null)
                    {
                        for each (_local_3 in _local_2)
                        {
                            if (((!(null == _local_3)) && (_local_3.GetBuildingMode() >= cBuilding.BUILDING_MODE_BUILDING_IS_ACTIVE_MIN)))
                            {
                                _local_4++;
                            };
                        };
                    };
                };
            };
            return (_local_4);
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
