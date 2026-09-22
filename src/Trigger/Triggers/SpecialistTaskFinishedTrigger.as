package Trigger.Triggers
{
    import Trigger.DeltaTrigger;
    import Model.Observer;
    import Interface.cGeneralInterface;
    import Utils.StringUtils;
    import Model.Notifiers.SpecialistNotifier;
    import Trigger.TriggerDeltaValue;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Utils.TriggerUtils;
    import Enums.SPECIALIST_TASK_TYPES;
    import Model.Notifier;

    public class SpecialistTaskFinishedTrigger extends DeltaTrigger implements Observer 
    {

        private var specialistTaskType:Array;
        private var gi:cGeneralInterface;

        public function SpecialistTaskFinishedTrigger(_arg_1:TriggerDeltaValue, _arg_2:Triggerable, _arg_3:TriggerVO, _arg_4:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3, _arg_4.channels.SPECIALIST);
            this.gi = _arg_4;
            this.specialistTaskType = StringUtils.split(_arg_3.item_string, StringUtils.COMMA);
            _arg_4.channels.SPECIALIST.addPropertyObserver(SpecialistNotifier.SPECIALIST_TASK_FINISHED_string, this);
        }

        override public function dispose():void
        {
            (para as SpecialistNotifier).removePropertyObserver(SpecialistNotifier.SPECIALIST_TASK_FINISHED_string, this);
            super.dispose();
        }

        override public function check():Boolean
        {
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
            var _local_4:String = (_arg_3 as String);
            if (_arg_2 == SpecialistNotifier.SPECIALIST_TASK_FINISHED_string)
            {
                if (((TriggerUtils.contains(this.specialistTaskType, _local_4)) || (this.specialistTaskType.length == 0)))
                {
                    if (TriggerUtils.contains(SPECIALIST_TASK_TYPES.getSpecialistTaskTypeArray(), _local_4))
                    {
                        getDelta().add(1);
                        sendTriggerValueUpdated();
                        this.check();
                    };
                };
            };
        }


    }
}
