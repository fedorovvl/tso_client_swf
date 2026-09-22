package Trigger.Triggers
{
    import Trigger.InstantTrigger;
    import Model.Observer;
    import Communication.VO.UpdateVO.dRemovedAdventureVO;
    import AdventureSystem.cAdventure;
    import Utils.TriggerUtils;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Interface.cGeneralInterface;
    import converted.bluebyte.tso.quests.logic.IQuestManager;
    import Model.Notifier;

    public class CompleteAdventureWithUnitTypeTrigger extends InstantTrigger implements Observer 
    {

        private static const dummy1:dRemovedAdventureVO = null;
        private static const dummy2:cAdventure = null;

        public function CompleteAdventureWithUnitTypeTrigger(_arg_1:Triggerable, _arg_2:TriggerVO, _arg_3:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3);
            _arg_3.mCurrentPlayerZone.addPropertyObserver(TriggerUtils.ADVENTURE_COMPLETED_PROPERTY_NAME, this);
        }

        override public function check():Boolean
        {
            var _local_1:IQuestManager = (para as cGeneralInterface).mNewQuestManager;
            return (false);
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
        }

        override public function dispose():void
        {
            (para as cGeneralInterface).mCurrentPlayerZone.removePropertyObserver(TriggerUtils.ADVENTURE_COMPLETED_PROPERTY_NAME, this);
            super.dispose();
        }


    }
}
