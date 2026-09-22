package Trigger.Triggers
{
    import Trigger.InstantTrigger;
    import Model.Observer;
    import Utils.StringUtils;
    import ServerState.cResources;
    import Utils.TriggerUtils;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Interface.cGeneralInterface;
    import ServerState.dResource;
    import Model.Notifier;

    public class OwnResourceListTrigger extends InstantTrigger implements Observer 
    {

        private var resourceList:Array;

        public function OwnResourceListTrigger(_arg_1:Triggerable, _arg_2:TriggerVO, _arg_3:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3.mCurrentPlayerZone.GetResources(_arg_3.mCurrentPlayer));
            this.resourceList = StringUtils.split(_arg_2.item_string, StringUtils.COMMA);
            (para as cResources).addPropertyObserver(TriggerUtils.OWN_RESOURCE_PROPERTY_NAME, this);
        }

        override public function dispose():void
        {
            (para as cResources).removePropertyObserver(TriggerUtils.OWN_RESOURCE_PROPERTY_NAME, this);
            this.resourceList = null;
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

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            var _local_4:String = (_arg_3 as dResource).name_string;
            if (((this.resourceList.length == 0) || (TriggerUtils.contains(this.resourceList, _local_4))))
            {
                this.check();
            };
        }

        override protected function computeCurrentAmount():Number
        {
            var _local_3:String;
            var _local_1:int;
            var _local_2:cResources = (para as cResources);
            if (this.resourceList.length > 0)
            {
                for each (_local_3 in this.resourceList)
                {
                    _local_1 = (_local_1 + _local_2.GetResourceAmount(_local_3));
                };
            }
            else
            {
                _local_1 = _local_2.GetAllResourceAmount();
            };
            return (_local_1);
        }


    }
}
