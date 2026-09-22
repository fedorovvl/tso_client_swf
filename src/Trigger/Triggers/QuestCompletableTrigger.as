package Trigger.Triggers
{
    import Trigger.InstantTrigger;
    import Model.Observer;
    import Model.Notifiers.QuestChannel;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Interface.cGeneralInterface;
    import Communication.VO.dQuestElementVO;
    import Model.Notifier;

    public final class QuestCompletableTrigger extends InstantTrigger implements Observer 
    {

        public function QuestCompletableTrigger(_arg_1:Triggerable, _arg_2:TriggerVO, _arg_3:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3);
            _arg_2.min = (_arg_2.max = 1);
            _arg_3.channels.QUEST.addPropertyObserver(QuestChannel.QUEST_COMPLETABLE, this);
        }

        override public function dispose():void
        {
            (this.para as cGeneralInterface).channels.QUEST.removePropertyObserver(QuestChannel.QUEST_COMPLETABLE, this);
            super.dispose();
        }

        override public function check():Boolean
        {
            var _local_1:String;
            for each (_local_1 in definition.item_string.split(","))
            {
                if (this.checkQuest(_local_1))
                {
                    trigger();
                    return (true);
                };
            };
            return (false);
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            var _local_5:String;
            var _local_4:dQuestElementVO = (_arg_3 as dQuestElementVO);
            for each (_local_5 in definition.item_string.split(","))
            {
                if (_local_4.GetQuestDefinition().questName_string == _local_5)
                {
                    trigger();
                    break;
                };
            };
        }

        private function checkQuest(_arg_1:String):Boolean
        {
            var _local_2:dQuestElementVO = (para as cGeneralInterface).mNewQuestManager.GetQuestPool().GetQuestFromName(_arg_1);
            if (((!(_local_2 == null)) && (_local_2.isFinished())))
            {
                return (true);
            };
            return (false);
        }


    }
}
