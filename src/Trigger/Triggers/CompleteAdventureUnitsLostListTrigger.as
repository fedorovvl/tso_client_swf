package Trigger.Triggers
{
    import Trigger.InstantTrigger;
    import Model.Observer;
    import Map.cPlayerZoneScreen;
    import flash.utils.Dictionary;
    import Utils.TriggerUtils;
    import Enums.ADVENTURE_MODE;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Interface.cGeneralInterface;
    import Trigger.vo.CompleteAdventureUnitsLostTriggerVO;
    import Utils.StringUtils;
    import Model.Notifier;
    import AdventureSystem.cAdventureDefinition;

    public class CompleteAdventureUnitsLostListTrigger extends InstantTrigger implements Observer 
    {

        private var playerZone:cPlayerZoneScreen;
        private var casualties:Dictionary;
        private var modes:int;

        public function CompleteAdventureUnitsLostListTrigger(_arg_1:Triggerable, _arg_2:TriggerVO, _arg_3:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3);
            this.playerZone = _arg_3.mCurrentPlayerZone;
            this.playerZone.addPropertyObserver(TriggerUtils.ADVENTURE_COMPLETED_CHECK_UNITS_PROPERTY_NAME, this);
            this.modes = ADVENTURE_MODE.stringToBitField(_arg_2.mode_string);
        }

        override protected function computeCurrentAmount():Number
        {
            var _local_2:String;
            var _local_1:int;
            if (this.casualties == null)
            {
                return (int.MAX_VALUE);
            };
            for (_local_2 in this.casualties)
            {
                if (definition.typeContains(_local_2))
                {
                    _local_1 = (_local_1 + this.casualties[_local_2]);
                };
            };
            return (_local_1);
        }

        override public function dispose():void
        {
            if (this.playerZone != null)
            {
                this.playerZone.removePropertyObserver(TriggerUtils.ADVENTURE_COMPLETED_CHECK_UNITS_PROPERTY_NAME, this);
                this.playerZone = null;
            };
            this.casualties = null;
            super.dispose();
        }

        override public function check():Boolean
        {
            updateCurrentAmount();
            var _local_1:Number = getCurrentAmount();
            if (_local_1 <= definition.max)
            {
                trigger();
                return (true);
            };
            return (false);
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            var _local_5:String;
            var _local_4:CompleteAdventureUnitsLostTriggerVO = (_arg_3 as CompleteAdventureUnitsLostTriggerVO);
            if (_local_4 == null)
            {
                return;
            };
            _local_5 = _local_4.getAdventureName();
            if (!this.checkMode(_local_5))
            {
                return;
            };
            if (((StringUtils.isEmpty(definition.item_string)) || (definition.item_string == _local_5)))
            {
                this.casualties = _local_4.getCasualties();
                this.check();
                this.casualties = null;
            };
        }

        private function checkMode(_arg_1:String):Boolean
        {
            var _local_2:cAdventureDefinition = cAdventureDefinition.FindAdventureDefinition(_arg_1);
            var _local_3:* = (1 << _local_2.GetMode());
            return ((this.modes & _local_3) == _local_3);
        }


    }
}
