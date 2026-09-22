package Trigger.Triggers
{
    import Trigger.InstantTrigger;
    import Model.Observer;
    import Interface.cGeneralInterface;
    import BuffSystem.cBuff;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import ServerState.cPlayerData;
    import Utils.StringUtils;
    import Model.Notifiers.Channel;
    import GO.cBuilding;
    import Model.Notifiers.BuffAppliedNotification;
    import Model.Notifier;

    public final class BuffInsufficientForEnemiesTrigger extends InstantTrigger implements Observer 
    {

        private var gi:cGeneralInterface;

        public function BuffInsufficientForEnemiesTrigger(_arg_1:Triggerable, _arg_2:TriggerVO, _arg_3:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3.channels.BUFF);
            this.gi = _arg_3;
            _arg_3.channels.BUFF.addPropertyObserver(cBuff.BUFF_APPLIED_string, this);
        }

        private function CalculateBuffsLeft():int
        {
            var _local_2:cPlayerData;
            var _local_3:cBuff;
            var _local_1:int;
            for each (_local_2 in this.gi.GetPlayerList_vector())
            {
                if (!this.gi.IsAdventureZoneID(_local_2.getPlayerID()))
                {
                    for each (_local_3 in _local_2.getAvailableBuffs_vector())
                    {
                        if (StringUtils.equalsIgnoreCase(_local_3.GetBuffDefinition().GetName_string(), definition.item_string))
                        {
                            _local_1 = (_local_1 + _local_3.GetAmount());
                        };
                    };
                    break;
                };
            };
            return (_local_1);
        }

        override public function dispose():void
        {
            (para as Channel).removePropertyObserver(cBuff.BUFF_APPLIED_string, this);
            super.dispose();
        }

        private function CalculateUnitsLeft():int
        {
            var _local_2:cBuilding;
            var _local_1:int;
            for each (_local_2 in this.gi.mCurrentPlayerZone.mStreetDataMap.GetBuildings_vector())
            {
                if ((((!(_local_2 == null)) && (_local_2.GetArmy().HasUnits())) && (!(_local_2.GetArmy().GetSquad(definition.target_string) == null))))
                {
                    _local_1 = (_local_1 + _local_2.GetArmy().GetSquad(definition.target_string).amount);
                };
            };
            return (_local_1);
        }

        override public function check():Boolean
        {
            var _local_1:int = this.CalculateUnitsLeft();
            var _local_2:int = this.CalculateBuffsLeft();
            if (_local_1 > _local_2)
            {
                trigger();
                return (true);
            };
            return (false);
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            if (_arg_2 == cBuff.BUFF_APPLIED_string)
            {
                if (StringUtils.equalsIgnoreCase((_arg_3 as BuffAppliedNotification).buff.getName(), definition.item_string))
                {
                };
                this.check();
            };
        }


    }
}
