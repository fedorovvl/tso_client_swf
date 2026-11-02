package Trigger.Triggers
{
    import Communication.VO.TriggerVO;
    import Interface.cGeneralInterface;
    import Trigger.DeltaTrigger;
    import Trigger.Triggerable;
    import Trigger.TriggerDeltaValue;

    // Quest progress is supplied by the server through PersistedQuestTriggerDeltaValue.
    public class DepositDepletedTrigger extends DeltaTrigger
    {
        public static const XML_string:String = "depositdepleted";

        public function DepositDepletedTrigger(delta:TriggerDeltaValue, target:Triggerable,
            definition:TriggerVO, gi:cGeneralInterface)
        {
            super(delta, target, definition, gi);
        }

        override public function check():Boolean
        {
            if (getDelta().getValue() >= definition.min)
            {
                trigger();
                return (true);
            }
            return (false);
        }
    }
}
