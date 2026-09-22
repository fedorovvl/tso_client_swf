package converted.bluebyte.tso.quests.trigger
{
    import Trigger.ITriggerFactory;
    import Trigger.TriggerFactory;
    import Communication.VO.dQuestElementVO;
    import Interface.cGeneralInterface;
    import Trigger.Trigger;
    import Communication.VO.TriggerVO;
    import Trigger.Triggerable;

    public class QuestTriggerFactory implements ITriggerFactory 
    {

        private var triggerFactory:TriggerFactory;
        private var questElement:dQuestElementVO;

        public function QuestTriggerFactory(_arg_1:cGeneralInterface, _arg_2:dQuestElementVO)
        {
            super();
            this.triggerFactory = new TriggerFactory(_arg_1);
            this.questElement = _arg_2;
        }

        public function createTrigger(_arg_1:TriggerVO, _arg_2:Triggerable):Trigger
        {
            var _local_3:PersistedQuestTriggerDeltaValue = new PersistedQuestTriggerDeltaValue(this.questElement, _arg_1.triggerIdx);
            this.triggerFactory.setDeltaValue(_local_3);
            var _local_4:Trigger = this.triggerFactory.createTrigger(_arg_1, _arg_2);
            return (new QuestTrigger(_local_4, _local_3));
        }


    }
}
