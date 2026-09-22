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
    import Communication.VO.dQuestTriggerVO;
    import converted.bluebyte.tso.quests.logic.QuestManagerStatic;
    import Model.Notifier;
    import Model.Notifiers.Channel;

    public class DailyLoginBonusCounterTrigger extends DeltaTrigger implements Observer 
    {

        public function DailyLoginBonusCounterTrigger(_arg_1:TriggerDeltaValue, _arg_2:Triggerable, _arg_3:TriggerVO, _arg_4:cGeneralInterface)
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
            var _local_5:int;
            var _local_6:dQuestTriggerVO;
            if (_arg_2 == TriggerUtils.DAILY_LOGIN_PROPERTY_NAME)
            {
                _local_4 = (_arg_3 as dQuestElementVO);
                if (_local_4.GetQuestDefinition().questTyp == QuestManagerStatic.QUEST_TYPE_DAILY_LOGIN_QUEST)
                {
                    _local_5 = _local_4.GetQuestDefinition().FindTriggerWithType(QuestManagerStatic.TYPE_DAILYLOGIN);
                    _local_6 = _local_4.mQuestTriggersFinished_vector[_local_5];
                    if (_local_6.status > 0)
                    {
                        getDelta().add(1);
                        sendTriggerValueUpdated();
                        this.check();
                    }
                    else
                    {
                        getDelta().setValue(1);
                        sendTriggerValueUpdated();
                    };
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
