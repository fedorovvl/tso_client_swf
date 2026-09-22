package Trigger.Triggers
{
    import Trigger.DeltaTrigger;
    import Model.Observer;
    import mx.collections.ArrayCollection;
    import Communication.VO.dQuestElementVO;
    import Utils.StringUtils;
    import Communication.VO.dQuestPoolVO;
    import converted.bluebyte.tso.quests.logic.QuestManagerStatic;
    import Trigger.TriggerDeltaValue;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Interface.cGeneralInterface;
    import Model.Notifier;

    public final class CompleteQuestListTrigger extends DeltaTrigger implements Observer 
    {

        private var questList:Array;
        private var waitingForQuests:ArrayCollection;

        public function CompleteQuestListTrigger(_arg_1:TriggerDeltaValue, _arg_2:Triggerable, _arg_3:TriggerVO, _arg_4:cGeneralInterface)
        {
            var _local_7:dQuestElementVO;
            var _local_8:String;
            super(_arg_1, _arg_2, _arg_3, _arg_4.mNewQuestManager.GetQuestPool());
            this.waitingForQuests = new ArrayCollection();
            this.questList = StringUtils.split(_arg_3.item_string, StringUtils.COMMA);
            var _local_5:dQuestPoolVO = _arg_4.mNewQuestManager.GetQuestPool();
            _local_5.addPropertyObserver(dQuestPoolVO.POOL_NOTIFICATION_string, this);
            var _local_6:* = (getDelta().getValue() == 0);
            for each (_local_8 in this.questList)
            {
                _local_7 = _local_5.GetQuestFromName(_local_8);
                if (_local_7 != null)
                {
                    if (_local_7.mQuestMode <= QuestManagerStatic.QUEST_MODE_DEACTIVATED)
                    {
                        this.waitingForQuests.addItem(_local_7);
                        _local_7.addPropertyObserver(QuestManagerStatic.QUEST_MODE_string, this);
                    }
                    else
                    {
                        if (_local_6)
                        {
                            getDelta().add(1);
                        };
                    };
                };
            };
            this.check();
        }

        override public function dispose():void
        {
            var _local_1:dQuestElementVO;
            for each (_local_1 in this.waitingForQuests)
            {
                _local_1.removePropertyObserver(QuestManagerStatic.QUEST_MODE_string, this);
            };
            (para as dQuestPoolVO).removePropertyObserver(dQuestPoolVO.POOL_NOTIFICATION_string, this);
            this.waitingForQuests = null;
            this.questList = null;
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
            var _local_4:dQuestElementVO;
            var _local_5:int;
            var _local_6:dQuestPoolVO;
            var _local_7:dQuestElementVO;
            var _local_8:String;
            if (_arg_2 == QuestManagerStatic.QUEST_MODE_string)
            {
                _local_4 = null;
                _local_5 = this.waitingForQuests.getItemIndex(_arg_1);
                if (_local_5 > -1)
                {
                    _local_4 = (this.waitingForQuests.getItemAt(_local_5) as dQuestElementVO);
                };
                if (((!(_local_4 == null)) && (_local_4.mQuestMode >= QuestManagerStatic.QUEST_MODE_DEACTIVATED)))
                {
                    if (_local_4.mQuestMode > QuestManagerStatic.QUEST_MODE_DEACTIVATED)
                    {
                        getDelta().add(1);
                        sendTriggerValueUpdated();
                    };
                    _local_4.removePropertyObserver(QuestManagerStatic.QUEST_MODE_string, this);
                    this.waitingForQuests.removeItemAt(_local_5);
                };
                this.check();
            }
            else
            {
                if (_arg_2 == dQuestPoolVO.POOL_NOTIFICATION_string)
                {
                    _local_6 = (_arg_1 as dQuestPoolVO);
                    _local_7 = (_arg_3 as dQuestElementVO);
                    if (((!(_local_7 == null)) && (this.waitingForQuests.getItemIndex(_local_7) == -1)))
                    {
                        for each (_local_8 in this.questList)
                        {
                            if (_local_8 == _local_7.getQuestName_string())
                            {
                                _local_7.addPropertyObserver(QuestManagerStatic.QUEST_MODE_string, this);
                                this.waitingForQuests.addItem(_local_7);
                            };
                        };
                    };
                };
            };
        }


    }
}
