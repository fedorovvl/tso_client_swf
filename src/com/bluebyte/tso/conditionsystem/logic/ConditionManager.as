package com.bluebyte.tso.conditionsystem.logic
{
    import flash.utils.Dictionary;
    import mx.collections.ArrayCollection;
    import Communication.VO.ConditionVO;
    import GO.cBuilding;
    import Communication.VO.ConditionCollectionVO;
    import Communication.VO.ConditionUpdatedVO;
    import Communication.VO.TriggerVO;
    import BuffSystem.cBuffDefinition;
    import Interface.cGeneralInterface;
    import Communication.VO.ConditionFinishedVO;

    public class ConditionManager 
    {

        private var map:Dictionary = new Dictionary();


        public function Init(_arg_1:ConditionCollectionVO):void
        {
            var _local_2:ArrayCollection;
            var _local_3:ConditionVO;
            var _local_4:ConditionVO;
            var _local_5:cBuilding;
            var _local_6:ConditionVO;
            for each (_local_2 in this.map)
            {
                for each (_local_4 in _local_2)
                {
                    _local_4.completed = true;
                };
            };
            for each (_local_3 in _arg_1.conditions)
            {
                _local_5 = global.ui.mCurrentPlayerZone.mStreetDataMap.GetBuildingByUniqueId(_local_3.uniqueID);
                for each (_local_6 in this.getArrayForBuilding(_local_5))
                {
                    if (_local_6.index == _local_3.index)
                    {
                        _local_6.completed = false;
                        _local_6.amount = _local_3.amount;
                        break;
                    };
                };
            };
        }

        public function destroyTriggers(_arg_1:Object):void
        {
            delete this.map[_arg_1];
        }

        public function updateConditionValue(_arg_1:ConditionUpdatedVO):void
        {
            var _local_3:ConditionVO;
            var _local_2:cBuilding = global.ui.mCurrentPlayerZone.mStreetDataMap.GetBuildingByUniqueId(_arg_1.uniqueID);
            for each (_local_3 in this.getArrayForBuilding(_local_2))
            {
                if (_local_3.index == _arg_1.index)
                {
                    _local_3.amount = _arg_1.amount;
                };
            };
        }

        public function createTriggers(_arg_1:cBuilding, _arg_2:cGeneralInterface):void
        {
            var _local_4:TriggerVO;
            var _local_3:cBuffDefinition = _arg_1.GetUpgradeLevelBonusesForLevel((_arg_1.GetUpgradeLevel() + 1));
            if (_local_3 != null)
            {
                for each (_local_4 in _local_3.GetConditions_vector())
                {
                    this.getArrayForBuilding(_arg_1).addItem(new ConditionVO().Init(_local_4, 0));
                };
            };
        }

        private function getArrayForBuilding(_arg_1:cBuilding):ArrayCollection
        {
            if (!(_arg_1 in this.map))
            {
                this.map[_arg_1] = new ArrayCollection();
            };
            return (this.map[_arg_1] as ArrayCollection);
        }

        public function triggersFinished(_arg_1:cBuilding):Boolean
        {
            var _local_2:ConditionVO;
            if (!(_arg_1 in this.map))
            {
                return (true);
            };
            for each (_local_2 in this.getArrayForBuilding(_arg_1))
            {
                if (!_local_2.completed)
                {
                    return (false);
                };
            };
            return (true);
        }

        public function getConditionsForBuilding(_arg_1:cBuilding):ArrayCollection
        {
            if (!(_arg_1 in this.map))
            {
                return (null);
            };
            return (this.map[_arg_1] as ArrayCollection);
        }

        public function setTriggerFinished(_arg_1:ConditionFinishedVO):void
        {
            var _local_3:ConditionVO;
            var _local_2:cBuilding = global.ui.mCurrentPlayerZone.GetBuildingFromGridPosition(_arg_1.grid);
            for each (_local_3 in this.getArrayForBuilding(_local_2))
            {
                if (_local_3.index == _arg_1.index)
                {
                    _local_3.completed = true;
                    break;
                };
            };
        }


    }
}
