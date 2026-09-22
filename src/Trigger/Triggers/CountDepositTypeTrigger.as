package Trigger.Triggers
{
    import Trigger.InstantTrigger;
    import Model.Observer;
    import Interface.cGeneralInterface;
    import Utils.StringUtils;
    import Model.Notifiers.SpecialistNotifier;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Model.Notifier;
    import __AS3__.vec.Vector;
    import GO.cDeposit;
    import Enums.DEPOSIT_ACCESSIBLE_TYPES;

    public class CountDepositTypeTrigger extends InstantTrigger implements Observer 
    {

        private var gi:cGeneralInterface;
        private var mDepositTypes:Array;

        public function CountDepositTypeTrigger(_arg_1:Triggerable, _arg_2:TriggerVO, _arg_3:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3.channels.SPECIALIST);
            this.gi = _arg_3;
            this.mDepositTypes = StringUtils.split(_arg_2.item_string, StringUtils.COMMA);
            _arg_3.channels.SPECIALIST.addPropertyObserver(SpecialistNotifier.COUNT_DEPOSIT_TYPE_string, this);
        }

        override public function dispose():void
        {
            (para as SpecialistNotifier).removePropertyObserver(SpecialistNotifier.COUNT_DEPOSIT_TYPE_string, this);
            super.dispose();
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            if (_arg_2 == SpecialistNotifier.COUNT_DEPOSIT_TYPE_string)
            {
                this.check();
            };
        }

        override protected function computeCurrentAmount():Number
        {
            var _local_2:Vector.<cDeposit>;
            var _local_3:String;
            var _local_4:cDeposit;
            var _local_1:int;
            if (this.mDepositTypes.length > 0)
            {
                for each (_local_3 in this.mDepositTypes)
                {
                    _local_1 = (_local_1 + this.gi.mCurrentPlayerZone.mStreetDataMap.getDeposits_vectorByType(_local_3).length);
                };
            }
            else
            {
                _local_2 = this.gi.mCurrentPlayerZone.mStreetDataMap.getDeposits_vectorByType("");
                for each (_local_4 in _local_2)
                {
                    if (_local_4.GetAccessibleType() == DEPOSIT_ACCESSIBLE_TYPES.ACCESSIBLE)
                    {
                        _local_1++;
                    };
                };
            };
            return (_local_1);
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


    }
}
