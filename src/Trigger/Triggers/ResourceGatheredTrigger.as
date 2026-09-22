package Trigger.Triggers
{
    import Trigger.DeltaTrigger;
    import Model.Observer;
    import ServerState.cResources;
    import Utils.TriggerUtils;
    import Trigger.TriggerDeltaValue;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Interface.cGeneralInterface;
    import Communication.VO.dResourceVO;
    import Model.Notifier;

    public class ResourceGatheredTrigger extends DeltaTrigger implements Observer 
    {

        public function ResourceGatheredTrigger(_arg_1:TriggerDeltaValue, _arg_2:Triggerable, _arg_3:TriggerVO, _arg_4:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3, _arg_4.mCurrentPlayerZone.GetResources(_arg_4.mCurrentPlayer));
            if (_arg_3.min == 0)
            {
                _arg_3.min = 1;
            };
            if (_arg_3.max == 0)
            {
                _arg_3.max = 100100100;
            };
            (para as cResources).addPropertyObserver(TriggerUtils.ADD_RESOURCE_NAME, this);
        }

        override public function check():Boolean
        {
            var _local_1:Number = getDelta().getValue();
            if (((_local_1 <= definition.max) && (_local_1 >= definition.min)))
            {
                trigger();
                return (true);
            };
            return (false);
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            var _local_4:dResourceVO = (_arg_3 as dResourceVO);
            if (((_local_4.amount > 0) && (definition.typeContains(_local_4.name_string))))
            {
                getDelta().add(_local_4.amount);
                sendTriggerValueUpdated();
                this.check();
            };
        }

        override public function dispose():void
        {
            (para as cResources).removePropertyObserver(TriggerUtils.ADD_RESOURCE_NAME, this);
            super.dispose();
        }


    }
}
