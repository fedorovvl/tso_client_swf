package Trigger.Triggers
{
    import Trigger.InstantTrigger;
    import Model.Observer;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Interface.cGeneralInterface;
    import Model.Notifier;
    import Map.cSectorDiscovery;
    import ServerState.cPlayerData;
    import Enums.SECTOR_DISCOVERY_TYPE;

    public final class SectorExploredTrigger extends InstantTrigger implements Observer 
    {

        public function SectorExploredTrigger(_arg_1:Triggerable, _arg_2:TriggerVO, _arg_3:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3);
            if (_arg_2.min == 0)
            {
                _arg_2.min = 1;
            };
            if (_arg_2.max == 0)
            {
                _arg_2.max = 100100100;
            };
            _arg_3.mCurrentPlayer.addPropertyObserver("mDiscoveredSector_vector", this);
        }

        override public function dispose():void
        {
            (para as cGeneralInterface).mCurrentPlayer.removePropertyObserver("mDiscoveredSector_vector", this);
            super.dispose();
        }

        override public function check():Boolean
        {
            updateCurrentAmount();
            var _local_1:Number = getCurrentAmount();
            if ((((!(definition.id == -1)) && (_local_1 == 1)) || (((definition.id == -1) && (_local_1 >= definition.min)) && (_local_1 <= definition.max))))
            {
                trigger();
                return (true);
            };
            return (false);
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            this.check();
        }

        override protected function computeCurrentAmount():Number
        {
            var _local_3:cSectorDiscovery;
            var _local_1:cPlayerData = (para as cGeneralInterface).mCurrentPlayer;
            if (definition.id != -1)
            {
                if (_local_1.GetSectorDiscovery(definition.id) == SECTOR_DISCOVERY_TYPE.EXPLORED)
                {
                    return (1);
                };
                return (0);
            };
            var _local_2:Number = 0;
            for each (_local_3 in _local_1.GetSectorDiscoveries_vector())
            {
                if (SECTOR_DISCOVERY_TYPE.isExplored(_local_3.GetDiscoveryType()))
                {
                    _local_2++;
                };
            };
            return (_local_2);
        }


    }
}
