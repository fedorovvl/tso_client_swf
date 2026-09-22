package Trigger.Triggers
{
    import Trigger.InstantTrigger;
    import Model.Observer;
    import Utils.TriggerUtils;
    import Enums.ADVENTURE_MODE;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Interface.cGeneralInterface;
    import AdventureSystem.cAdventureDefinition;
    import Utils.StringUtils;
    import Communication.VO.UpdateVO.dRemovedAdventureVO;
    import Map.cPlayerZoneScreen;
    import Model.Notifier;

    public class AdventureLostTrigger extends InstantTrigger implements Observer 
    {

        private var modes:int;

        public function AdventureLostTrigger(_arg_1:Triggerable, _arg_2:TriggerVO, _arg_3:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3.mCurrentPlayerZone);
            _arg_3.mCurrentPlayerZone.addPropertyObserver(TriggerUtils.ADVENTURE_LOST_string, this);
            this.modes = ADVENTURE_MODE.stringToBitField(_arg_2.mode_string);
        }

        private function checkType(_arg_1:dRemovedAdventureVO):Boolean
        {
            var _local_2:cAdventureDefinition = cAdventureDefinition.FindAdventureDefinition(_arg_1.adventureName);
            var _local_3:* = (1 << _local_2.GetMode());
            if ((this.modes & _local_3) != _local_3)
            {
                return (false);
            };
            if (!StringUtils.isEmpty(definition.type_string))
            {
                return (definition.type_string == _local_2.GetType_string());
            };
            return (true);
        }

        override public function dispose():void
        {
            if (para != null)
            {
                (para as cPlayerZoneScreen).removePropertyObserver(TriggerUtils.ADVENTURE_LOST_string, this);
            };
            super.dispose();
        }

        override public function check():Boolean
        {
            return (false);
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            var _local_4:dRemovedAdventureVO = (_arg_3 as dRemovedAdventureVO);
            if (((this.checkName(_local_4)) && (this.checkType(_local_4))))
            {
                trigger();
            };
        }

        private function checkName(_arg_1:dRemovedAdventureVO):Boolean
        {
            return ((StringUtils.isEmpty(definition.item_string)) || (definition.item_string == _arg_1.adventureName));
        }


    }
}
