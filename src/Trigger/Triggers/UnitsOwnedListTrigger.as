package Trigger.Triggers
{
    import Trigger.InstantTrigger;
    import Model.Observer;
    import Map.cPlayerZoneScreen;
    import Utils.StringUtils;
    import Utils.TriggerUtils;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Interface.cGeneralInterface;
    import Specialists.cSpecialist;
    import MilitarySystem.cArmy;
    import MilitarySystem.cSquad;
    import Model.Notifier;

    public class UnitsOwnedListTrigger extends InstantTrigger implements Observer 
    {

        private var unitsList:Array;
        private var playerZone:cPlayerZoneScreen;

        public function UnitsOwnedListTrigger(_arg_1:Triggerable, _arg_2:TriggerVO, _arg_3:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3);
            this.unitsList = StringUtils.split(_arg_2.item_string, StringUtils.COMMA);
            this.playerZone = _arg_3.mCurrentPlayerZone;
            this.playerZone.addPropertyObserver(TriggerUtils.UNITS_OWNED_NOTIFICATION_PROPERTY_NAME, this);
        }

        override protected function computeCurrentAmount():Number
        {
            var _local_2:cSpecialist;
            var _local_3:cArmy;
            var _local_1:int;
            var _local_4:* = (this.unitsList.length > 0);
            for each (_local_2 in this.playerZone.GetSpecialists_vector())
            {
                if (_local_4)
                {
                    _local_3 = _local_2.GetArmy();
                    _local_1 = (_local_1 + this.countUnitsInArmy(_local_3));
                }
                else
                {
                    _local_1 = (_local_1 + _local_2.GetArmy().GetUnitsCount());
                };
            };
            _local_3 = this.playerZone.GetArmy((para as cGeneralInterface).mCurrentPlayer.GetPlayerId());
            if (_local_4)
            {
                _local_1 = (_local_1 + this.countUnitsInArmy(_local_3));
            }
            else
            {
                _local_1 = (_local_1 + this.playerZone.GetArmy((para as cGeneralInterface).mCurrentPlayer.GetPlayerId()).GetUnitsCount());
            };
            return (_local_1);
        }

        private function countUnitsInArmy(_arg_1:cArmy):int
        {
            var _local_2:String;
            var _local_3:cSquad;
            var _local_4:int;
            for each (_local_2 in this.unitsList)
            {
                _local_3 = _arg_1.GetSquad(_local_2);
                if (_local_3 != null)
                {
                    _local_4 = (_local_4 + _local_3.amount);
                };
            };
            return (_local_4);
        }

        override public function check():Boolean
        {
            updateCurrentAmount();
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
            this.check();
        }

        override public function dispose():void
        {
            if (this.playerZone != null)
            {
                this.playerZone.removePropertyObserver(TriggerUtils.UNITS_OWNED_NOTIFICATION_PROPERTY_NAME, this);
                this.playerZone = null;
            };
            this.unitsList = null;
            super.dispose();
        }


    }
}
