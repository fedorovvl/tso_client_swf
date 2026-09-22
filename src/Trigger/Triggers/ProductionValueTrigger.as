package Trigger.Triggers
{
    import Trigger.InstantTrigger;
    import Model.Observer;
    import Interface.cGeneralInterface;
    import ServerState.cComputeResourceCreation;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Model.Notifiers.Channel;
    import ServerState.cEconomyOverviewData;
    import ServerState.dEconomyOverviewDataResult;
    import Model.Notifier;

    public class ProductionValueTrigger extends InstantTrigger implements Observer 
    {

        private var running:Boolean;
        private var generalInterface:cGeneralInterface;
        private var productionTimesRecentlyChanged:Boolean;

        public function ProductionValueTrigger(_arg_1:Triggerable, _arg_2:TriggerVO, _arg_3:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3.channels.PRODUCTION);
            _arg_3.channels.PRODUCTION.addPropertyObserver(cComputeResourceCreation.PRODUCTION_TIMES_CHANGED, this);
            _arg_3.channels.PRODUCTION.addPropertyObserver(cComputeResourceCreation.PRODUCTION_VALUES, this);
            this.productionTimesRecentlyChanged = false;
            this.running = true;
            this.generalInterface = _arg_3;
        }

        override public function isReversible():Boolean
        {
            return (true);
        }

        override public function dispose():void
        {
            (para as Channel).removePropertyObserver(cComputeResourceCreation.PRODUCTION_TIMES_CHANGED, this);
            (para as Channel).removePropertyObserver(cComputeResourceCreation.PRODUCTION_VALUES, this);
            super.dispose();
        }

        override public function check():Boolean
        {
            var _local_1:int = int((global.economyCalculationTime / 3600));
            var _local_2:cEconomyOverviewData = new cEconomyOverviewData(this.generalInterface);
            var _local_3:dEconomyOverviewDataResult = _local_2.GetResourceProductionAndConsumptionValues(null, definition.item_string);
            if ((_local_3.mBuffedProductionValue - _local_3.mConsumptionValue) >= (definition.min * _local_1))
            {
                trigger();
                this.running = false;
                return (true);
            };
            triggerable.reset();
            this.running = true;
            return (false);
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            if (this.generalInterface.mSpoolingIsActive)
            {
                return;
            };
            if (_arg_2 == cComputeResourceCreation.PRODUCTION_TIMES_CHANGED)
            {
                this.productionTimesRecentlyChanged = true;
            }
            else
            {
                if (((_arg_2 == cComputeResourceCreation.PRODUCTION_VALUES) && (this.productionTimesRecentlyChanged)))
                {
                    this.productionTimesRecentlyChanged = false;
                    this.check();
                };
            };
        }

        override public function isRunning():Boolean
        {
            return (this.running);
        }


    }
}
