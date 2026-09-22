package Trigger.Triggers
{
    import Trigger.DeltaTrigger;
    import Model.Observer;
    import Trigger.TriggerDeltaValue;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Interface.cGeneralInterface;
    import Communication.VO.AdventureQuestTriggeredVO;
    import Model.Notifier;

    public class QuestAdventureCompletedTrigger extends DeltaTrigger implements Observer 
    {

        public static var QUEST_ADVENTURE:String = "QUEST_ADVENTURE";

        public function QuestAdventureCompletedTrigger(_arg_1:TriggerDeltaValue, _arg_2:Triggerable, _arg_3:TriggerVO, _arg_4:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3, _arg_4);
            _arg_4.channels.QUEST.addPropertyObserver(QUEST_ADVENTURE, this);
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
            var _local_4:AdventureQuestTriggeredVO;
            if (_arg_2 == QUEST_ADVENTURE)
            {
                _local_4 = (_arg_3 as AdventureQuestTriggeredVO);
                if (((_local_4.adventureName == definition.name_string) && (_local_4.questName == definition.item_string)))
                {
                    getDelta().add(1);
                    sendTriggerValueUpdated();
                    this.check();
                };
            };
        }

        override public function dispose():void
        {
            (para as cGeneralInterface).channels.QUEST.removePropertyObserver(QUEST_ADVENTURE, this);
            super.dispose();
        }


    }
}
