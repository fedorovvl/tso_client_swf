package Trigger.Triggers
{
    import Trigger.InstantTrigger;
    import Model.Observer;
    import Utils.StringUtils;
    import BuffSystem.cBuff;
    import Model.Notifiers.SpecialistNotifier;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Interface.cGeneralInterface;
    import Model.Notifiers.BuffAppliedNotification;
    import GO.cDeposit;
    import Utils.TriggerUtils;
    import Model.Notifier;
    import __AS3__.vec.Vector;
    import Enums.DEPOSIT_ACCESSIBLE_TYPES;

    public class HaveDepositsTrigger extends InstantTrigger implements Observer 
    {

        private var mDepositsNumber:int;
        private var mDepositsType:Array;

        public function HaveDepositsTrigger(_arg_1:Triggerable, _arg_2:TriggerVO, _arg_3:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3);
            this.mDepositsType = StringUtils.split(_arg_2.item_string, StringUtils.COMMA);
            this.mDepositsNumber = ((_arg_2.min != 0) ? _arg_2.min : 1);
            _arg_3.channels.BUFF.addPropertyObserver(cBuff.BUFF_APPLIED_string, this);
            _arg_3.channels.SPECIALIST.addPropertyObserver(SpecialistNotifier.COUNT_DEPOSIT_TYPE_string, this);
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            var _local_4:BuffAppliedNotification;
            var _local_5:String;
            var _local_6:String;
            if (_arg_2 == cBuff.BUFF_APPLIED_string)
            {
                _local_4 = (_arg_3 as BuffAppliedNotification);
                _local_5 = "";
                if ((_local_4.target is cDeposit))
                {
                    _local_5 = (_local_4.target as cDeposit).GetName_string();
                    if (TriggerUtils.contains(this.mDepositsType, _local_5))
                    {
                        this.check();
                    };
                };
            };
            if (_arg_2 == SpecialistNotifier.COUNT_DEPOSIT_TYPE_string)
            {
                if (_arg_3 != null)
                {
                    _local_6 = (_arg_3 as String);
                    if (TriggerUtils.contains(this.mDepositsType, _local_6))
                    {
                        this.check();
                    };
                };
            };
        }

        override protected function computeCurrentAmount():Number
        {
            var _local_3:cDeposit;
            var _local_1:Vector.<cDeposit> = (para as cGeneralInterface).mCurrentPlayerZone.mStreetDataMap.GetDeposits_vector();
            var _local_2:int;
            for each (_local_3 in _local_1)
            {
                if (_local_3.GetAccessibleType() == DEPOSIT_ACCESSIBLE_TYPES.ACCESSIBLE)
                {
                    if (TriggerUtils.contains(this.mDepositsType, _local_3.GetName_string()))
                    {
                        if (_local_3.GetAmount() >= definition.amount)
                        {
                            _local_2++;
                        };
                    };
                };
            };
            return (_local_2);
        }

        override public function dispose():void
        {
            (para as cGeneralInterface).channels.BUFF.removePropertyObserver(cBuff.BUFF_APPLIED_string, this);
            (para as cGeneralInterface).channels.SPECIALIST.removePropertyObserver(SpecialistNotifier.COUNT_DEPOSIT_TYPE_string, this);
            super.dispose();
        }

        override public function check():Boolean
        {
            updateCurrentAmount();
            var _local_1:Number = getCurrentAmount();
            if (_local_1 >= this.mDepositsNumber)
            {
                trigger();
                return (true);
            };
            return (false);
        }


    }
}
