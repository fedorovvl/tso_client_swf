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
    import converted.bluebyte.tso.quests.logic.QuestManagerStatic;
    import Model.Notifier;
    import Model.Notifiers.Channel;

    public class TimeInGameTrigger extends DeltaTrigger implements Observer 
    {

        public function TimeInGameTrigger(_arg_1:TriggerDeltaValue, _arg_2:Triggerable, _arg_3:TriggerVO, _arg_4:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3, _arg_4.channels.QUEST);
            _arg_4.channels.QUEST.addPropertyObserver(TriggerUtils.DAILY_LOGIN_PROPERTY_NAME, this);
        }

        override public function check():Boolean
        {
            if (getCurrentAmount() >= definition.amount)
            {
                trigger();
                return (true);
            };
            return (false);
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            var _local_4:dQuestElementVO;
            if (_arg_2 == TriggerUtils.DAILY_LOGIN_PROPERTY_NAME)
            {
                _local_4 = (_arg_3 as dQuestElementVO);
                if (_local_4.GetQuestDefinition().questTyp == QuestManagerStatic.QUEST_TYPE_DAILY_LOGIN_QUEST)
                {
                    getDelta().add(1);
                    sendTriggerValueUpdated();
                    this.check();
                };
            };
        }

        override public function dispose():void
        {
            (para as Channel).removePropertyObserver(TriggerUtils.DAILY_LOGIN_PROPERTY_NAME, this);
            super.dispose();
        }


    }
}
