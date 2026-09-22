package Trigger.Triggers
{
    import Trigger.InstantTrigger;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Interface.cGeneralInterface;
    import Communication.VO.dQuestElementVO;

    public class QuestTriggerValueTrigger extends InstantTrigger 
    {

        public static const XML_string:String = "questtriggervalue";

        public function QuestTriggerValueTrigger(_arg_1:Triggerable, _arg_2:TriggerVO, _arg_3:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3);
        }

        override public function check():Boolean
        {
            var _local_1:dQuestElementVO = (para as cGeneralInterface).mNewQuestManager.getQuest(definition.name_string);
            if (((!(_local_1 == null)) && (_local_1.GetTriggerStatus(definition.id) == definition.state)))
            {
                trigger();
                return (true);
            };
            return (false);
        }


    }
}
