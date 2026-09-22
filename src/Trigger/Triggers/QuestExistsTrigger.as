package Trigger.Triggers
{
    import Trigger.InstantTrigger;
    import Model.Observer;
    import Communication.VO.dQuestPoolVO;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Interface.cGeneralInterface;
    import Model.Notifier;

    public final class QuestExistsTrigger extends InstantTrigger implements Observer 
    {

        public static const XML_string:String = "questexists";

        public function QuestExistsTrigger(_arg_1:Triggerable, _arg_2:TriggerVO, _arg_3:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3);
            _arg_2.min = (_arg_2.max = 1);
            _arg_3.mNewQuestManager.GetQuestPool().addPropertyObserver(dQuestPoolVO.POOL_NOTIFICATION_string, this);
        }

        override public function check():Boolean
        {
            var _local_1:String;
            for each (_local_1 in definition.item_string.split(","))
            {
                if ((para as cGeneralInterface).mNewQuestManager.hasQuest(_local_1))
                {
                    trigger();
                    return (true);
                };
            };
            return (false);
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            this.check();
        }

        override public function dispose():void
        {
            (para as cGeneralInterface).mNewQuestManager.GetQuestPool().removePropertyObserver(dQuestPoolVO.POOL_NOTIFICATION_string, this);
            super.dispose();
        }


    }
}
