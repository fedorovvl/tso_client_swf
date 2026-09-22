package Trigger.Triggers
{
    import Trigger.InstantTrigger;
    import Model.Observer;
    import Communication.VO.dQuestElementVO;
    import Communication.VO.dQuestPoolVO;
    import converted.bluebyte.tso.quests.logic.QuestManagerStatic;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Interface.cGeneralInterface;
    import Model.Notifier;

    public final class QuestActiveTrigger extends InstantTrigger implements Observer 
    {

        private var waitingForQuest:dQuestElementVO;

        public function QuestActiveTrigger(_arg_1:Triggerable, _arg_2:TriggerVO, _arg_3:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3.mNewQuestManager.GetQuestPool());
            _arg_2.min = (_arg_2.max = 1);
            var _local_4:dQuestPoolVO = _arg_3.mNewQuestManager.GetQuestPool();
            var _local_5:dQuestElementVO = _local_4.GetQuestFromName(_arg_2.item_string);
            if (_local_5 != null)
            {
                this.waitingForQuest = _local_5;
                if (!this.check())
                {
                    _local_5.addPropertyObserver(QuestManagerStatic.QUEST_MODE_string, this);
                };
            }
            else
            {
                _local_4.addPropertyObserver(dQuestPoolVO.POOL_NOTIFICATION_string, this);
            };
        }

        override public function check():Boolean
        {
            if (((!(this.waitingForQuest == null)) && (this.waitingForQuest.mQuestMode == QuestManagerStatic.QUEST_MODE_RUNNING)))
            {
                trigger();
                return (true);
            };
            return (false);
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            var _local_4:dQuestPoolVO;
            var _local_5:dQuestElementVO;
            if (_arg_2 == QuestManagerStatic.QUEST_MODE_string)
            {
                this.check();
            }
            else
            {
                if (_arg_2 == dQuestPoolVO.POOL_NOTIFICATION_string)
                {
                    _local_4 = (_arg_1 as dQuestPoolVO);
                    _local_5 = (_local_4.GetQuestFromName(definition.item_string) as dQuestElementVO);
                    if (((this.waitingForQuest == null) && (!(_local_5 == null))))
                    {
                        this.waitingForQuest = _local_4.GetQuestFromName(definition.item_string);
                        if (!this.check())
                        {
                            this.waitingForQuest.addPropertyObserver(QuestManagerStatic.QUEST_MODE_string, this);
                        };
                        _local_4.removePropertyObserver(dQuestPoolVO.POOL_NOTIFICATION_string, this);
                    };
                };
            };
        }

        override public function dispose():void
        {
            (para as dQuestPoolVO).removePropertyObserver(dQuestPoolVO.POOL_NOTIFICATION_string, this);
            if (this.waitingForQuest != null)
            {
                this.waitingForQuest.removePropertyObserver(QuestManagerStatic.QUEST_MODE_string, this);
                this.waitingForQuest = null;
            };
            super.dispose();
        }


    }
}
