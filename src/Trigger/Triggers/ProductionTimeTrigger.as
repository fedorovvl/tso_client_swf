package Trigger.Triggers
{
    import Trigger.InstantTrigger;
    import Model.Observer;
    import Interface.cGeneralInterface;
    import ServerState.cComputeResourceCreation;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Model.Notifiers.Channel;
    import GO.cBuilding;
    import __AS3__.vec.Vector;
    import Model.Notifier;

    public class ProductionTimeTrigger extends InstantTrigger implements Observer 
    {

        private var generalInterface:cGeneralInterface;

        public function ProductionTimeTrigger(_arg_1:Triggerable, _arg_2:TriggerVO, _arg_3:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3.channels.PRODUCTION);
            _arg_3.channels.PRODUCTION.addPropertyObserver(cComputeResourceCreation.PRODUCTION_TIMES_CHANGED, this);
            this.generalInterface = _arg_3;
        }

        override public function dispose():void
        {
            (para as Channel).removePropertyObserver(cComputeResourceCreation.PRODUCTION_TIMES_CHANGED, this);
            super.dispose();
        }

        override public function check():Boolean
        {
            var _local_2:cBuilding;
            var _local_3:Number;
            var _local_1:Vector.<cBuilding> = this.generalInterface.mCurrentPlayerZone.mStreetDataMap.getBuildingsByName_vector(definition.item_string);
            if (_local_1 != null)
            {
                for each (_local_2 in _local_1)
                {
                    _local_3 = _local_2.CalculateWays();
                    if (_local_3 == -1)
                    {
                        return (false);
                    };
                    if (_local_3 < ((definition.max * 1000) / this.generalInterface.mGlobalTimeScale))
                    {
                        trigger();
                        return (true);
                    };
                };
            };
            return (false);
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            if ((_arg_3 as cBuilding).GetBuildingName_string() == definition.item_string)
            {
                this.check();
            };
        }


    }
}
