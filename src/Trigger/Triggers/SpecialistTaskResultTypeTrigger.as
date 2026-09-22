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
    import Communication.VO.SpecialistTaskResultTypeVO;
    import Utils.TriggerUtils;
    import Enums.SPECIALIST_TASK_TYPES;
    import Model.Notifier;

    public class SpecialistTaskResultTypeTrigger extends DeltaTrigger implements Observer 
    {

        private var specialistTaskType:Array;
        private var gi:cGeneralInterface;

        public function SpecialistTaskResultTypeTrigger(_arg_1:TriggerDeltaValue, _arg_2:Triggerable, _arg_3:TriggerVO, _arg_4:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3, _arg_4.channels.SPECIALIST);
            this.gi = _arg_4;
            this.specialistTaskType = StringUtils.split(_arg_3.item_string, StringUtils.COMMA);
            _arg_4.channels.SPECIALIST.addPropertyObserver(SpecialistNotifier.SPECIALIST_TASK_RESULT_TYPE_string, this);
        }

        override public function dispose():void
        {
            (para as SpecialistNotifier).removePropertyObserver(SpecialistNotifier.SPECIALIST_TASK_RESULT_TYPE_string, this);
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
            var _local_4:SpecialistTaskResultTypeVO = (_arg_3 as SpecialistTaskResultTypeVO);
            if (_arg_2 == SpecialistNotifier.SPECIALIST_TASK_RESULT_TYPE_string)
            {
                if (TriggerUtils.contains(this.specialistTaskType, _local_4.taskType_string))
                {
                    if (TriggerUtils.contains(SPECIALIST_TASK_TYPES.getSpecialistTaskTypeArray(), _local_4.taskType_string))
                    {
                        if (definition.isTypeEmpty())
                        {
                            getDelta().add(_local_4.amount);
                            sendTriggerValueUpdated();
                            this.check();
                        }
                        else
                        {
                            if (definition.typeContains(_local_4.resourceType_string))
                            {
                                getDelta().add(_local_4.amount);
                                sendTriggerValueUpdated();
                                this.check();
                            };
                        };
                    };
                };
            };
        }

        public function isTreasureSearch(_arg_1:String):Boolean
        {
            return (((((_arg_1 == SPECIALIST_TASK_TYPES.FIND_TREASURE_SHORT) || (_arg_1 == SPECIALIST_TASK_TYPES.FIND_TREASURE_MEDIUM)) || (_arg_1 == SPECIALIST_TASK_TYPES.FIND_TREASURE_LONG)) || (_arg_1 == SPECIALIST_TASK_TYPES.FIND_TREASURE_EVEN_LONGER)) || (_arg_1 == SPECIALIST_TASK_TYPES.FIND_TREASURE_BEANACOLLADA));
        }


    }
}
