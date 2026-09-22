package Trigger.Triggers
{
    import Trigger.DeltaTrigger;
    import Model.Observer;
    import Utils.TriggerUtils;
    import Trigger.TriggerDeltaValue;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Interface.cGeneralInterface;
    import Communication.VO.dQuestElementVO;
    import Model.Notifier;

    public class QuestTypeCompletedTrigger extends DeltaTrigger implements Observer 
    {

        public function QuestTypeCompletedTrigger(_arg_1:TriggerDeltaValue, _arg_2:Triggerable, _arg_3:TriggerVO, _arg_4:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3, _arg_4);
            _arg_4.channels.QUEST.addPropertyObserver(TriggerUtils.QUEST_TYPE_COMPLETED_NAME, this);
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
            var _local_4:dQuestElementVO = (_arg_3 as dQuestElementVO);
            if (_arg_2 == TriggerUtils.QUEST_TYPE_COMPLETED_NAME)
            {
                if (definition.typeContains(_local_4.mQuestDefinition.type_string))
                {
                    getDelta().add(1);
                    sendTriggerValueUpdated();
                    this.check();
                };
            };
        }

        override public function dispose():void
        {
            (para as cGeneralInterface).channels.QUEST.removePropertyObserver(TriggerUtils.QUEST_TYPE_COMPLETED_NAME, this);
            super.dispose();
        }


    }
}
