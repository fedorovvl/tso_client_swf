package Trigger.Triggers
{
    import Trigger.InstantTrigger;
    import Model.Observer;
    import Map.cPlayerZoneScreen;
    import Utils.TriggerUtils;
    import Enums.ADVENTURE_MODE;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Interface.cGeneralInterface;
    import Utils.StringUtils;
    import Communication.VO.UpdateVO.dRemovedAdventureVO;
    import Model.Notifier;
    import AdventureSystem.cAdventureDefinition;

    public class CompleteAdventureInTimeTrigger extends InstantTrigger implements Observer 
    {

        private var playerZone:cPlayerZoneScreen;
        private var modes:int;
        private var adventureTime:Number;

        public function CompleteAdventureInTimeTrigger(_arg_1:Triggerable, _arg_2:TriggerVO, _arg_3:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3);
            this.playerZone = _arg_3.mCurrentPlayerZone;
            this.playerZone.addPropertyObserver(TriggerUtils.ADVENTURE_COMPLETED_PROPERTY_NAME, this);
            this.initAdventureTime();
            this.modes = ADVENTURE_MODE.stringToBitField(_arg_2.mode_string);
        }

        private function checkName(_arg_1:dRemovedAdventureVO):Boolean
        {
            return ((StringUtils.isEmpty(definition.item_string)) || (_arg_1.adventureName == definition.item_string));
        }

        override public function check():Boolean
        {
            if (this.adventureTime <= definition.max)
            {
                trigger();
                return (true);
            };
            return (false);
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            var _local_4:dRemovedAdventureVO = (_arg_3 as dRemovedAdventureVO);
            if ((((this.checkName(_local_4)) && (this.checkType(_local_4))) && (this.checkMode(_local_4))))
            {
                this.check();
                this.initAdventureTime();
            };
        }

        private function checkMode(_arg_1:dRemovedAdventureVO):Boolean
        {
            var _local_2:cAdventureDefinition = cAdventureDefinition.FindAdventureDefinition(_arg_1.adventureName);
            var _local_3:* = (1 << _local_2.GetMode());
            return ((this.modes & _local_3) == _local_3);
        }

        private function checkType(_arg_1:dRemovedAdventureVO):Boolean
        {
            return ((definition.isTypeEmpty()) || (TriggerUtils.CheckAdventureSize(definition.GetTypeString(), _arg_1.mapLevel)));
        }

        private function initAdventureTime():void
        {
            this.adventureTime = int.MAX_VALUE;
        }

        override public function dispose():void
        {
            if (this.playerZone != null)
            {
                this.playerZone.removePropertyObserver(TriggerUtils.ADVENTURE_COMPLETED_PROPERTY_NAME, this);
                this.playerZone = null;
            };
            super.dispose();
        }


    }
}
