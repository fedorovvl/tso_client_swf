package Trigger.Triggers
{
    import Trigger.InstantTrigger;
    import Model.Observer;
    import ServerState.cResources;
    import Utils.TriggerUtils;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Interface.cGeneralInterface;
    import ServerState.dResource;
    import Model.Notifier;

    public final class ResourceTrigger extends InstantTrigger implements Observer 
    {

        public function ResourceTrigger(_arg_1:Triggerable, _arg_2:TriggerVO, _arg_3:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3.mCurrentPlayerZone.GetResources(_arg_3.mCurrentPlayer));
            if (_arg_2.min == 0)
            {
                _arg_2.min = 0;
            };
            if (_arg_2.max == 0)
            {
                _arg_2.max = 100100100;
            };
            (para as cResources).addPropertyObserver(TriggerUtils.OWN_RESOURCE_PROPERTY_NAME, this);
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
            var _local_4:dResource = (_arg_3 as dResource);
            if (_local_4.name_string == definition.item_string)
            {
                this.check();
            };
        }

        override protected function computeCurrentAmount():Number
        {
            return ((para as cResources).GetResourceAmount(definition.item_string));
        }

        override public function dispose():void
        {
            (para as cResources).removePropertyObserver(TriggerUtils.OWN_RESOURCE_PROPERTY_NAME, this);
            super.dispose();
        }


    }
}
