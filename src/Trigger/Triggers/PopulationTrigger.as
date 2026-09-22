package Trigger.Triggers
{
    import Trigger.InstantTrigger;
    import Model.Observer;
    import ServerState.cResources;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Interface.cGeneralInterface;
    import Model.Notifier;

    public final class PopulationTrigger extends InstantTrigger implements Observer 
    {

        public function PopulationTrigger(_arg_1:Triggerable, _arg_2:TriggerVO, _arg_3:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3);
            if (_arg_2.max == 0)
            {
                _arg_2.max = 100100100;
            };
            _arg_3.mCurrentPlayerZone.GetResources(_arg_3.mCurrentPlayer).addPropertyObserver(cResources.POPULATION_CHANGE, this);
        }

        override public function check():Boolean
        {
            updateCurrentAmount();
            var _local_1:Number = getCurrentAmount();
            if (((_local_1 >= definition.min) && (_local_1 <= definition.max)))
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
            var _local_1:cGeneralInterface = (para as cGeneralInterface);
            var _local_2:cResources = _local_1.mCurrentPlayerZone.GetResources(_local_1.mCurrentPlayer);
            var _local_3:Number = 0;
            if (definition.item_string == "free")
            {
                _local_3 = _local_2.GetFree();
            }
            else
            {
                if (definition.item_string == "military")
                {
                    _local_3 = _local_2.GetMilitary();
                }
                else
                {
                    if (definition.item_string == "workers")
                    {
                        _local_3 = _local_2.GetWorkers();
                    }
                    else
                    {
                        if (definition.item_string == "freeCapacity")
                        {
                            _local_3 = (_local_2.GetPlayerResource(defines.POPULATION_RESOURCE_NAME_string).maxLimit - (_local_2.GetAssignedPopulation() + _local_2.GetFree()));
                        }
                        else
                        {
                            if (definition.item_string == "maxCapacity")
                            {
                                _local_3 = _local_2.GetPlayerResource(defines.POPULATION_RESOURCE_NAME_string).maxLimit;
                            };
                        };
                    };
                };
            };
            return (_local_3);
        }

        override public function dispose():void
        {
            var _local_1:cGeneralInterface = (para as cGeneralInterface);
            var _local_2:cResources = _local_1.mCurrentPlayerZone.GetResources(_local_1.mCurrentPlayer);
            _local_2.removePropertyObserver(cResources.POPULATION_CHANGE, this);
            super.dispose();
        }


    }
}
