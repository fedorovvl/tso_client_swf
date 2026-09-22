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
    import Specialists.cSpecialist;
    import Utils.TriggerUtils;
    import Enums.SPECIALIST_TYPE;

    public class SpecialistOwnedListTrigger extends InstantTrigger implements Observer 
    {

        private var gi:cGeneralInterface;
        public var mSpecialistOwnedNumber:int = 0;
        private var mSpecialistBaseType:Array;

        public function SpecialistOwnedListTrigger(_arg_1:Triggerable, _arg_2:TriggerVO, _arg_3:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3.channels.SPECIALIST);
            this.mSpecialistBaseType = StringUtils.split(_arg_2.item_string, StringUtils.COMMA);
            this.gi = _arg_3;
            _arg_3.channels.SPECIALIST.addPropertyObserver(SpecialistNotifier.SPECIALIST_OWNED_LIST_string, this);
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            if (_arg_2 == SpecialistNotifier.SPECIALIST_OWNED_LIST_string)
            {
                this.check();
            };
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

        override protected function computeCurrentAmount():Number
        {
            var _local_1:Boolean;
            var _local_2:cSpecialist;
            this.mSpecialistOwnedNumber = 0;
            for each (_local_2 in this.gi.mCurrentPlayerZone.GetSpecialists_vector())
            {
                if (((!(definition.item_string == null)) && (!(definition.item_string == ""))))
                {
                    _local_1 = TriggerUtils.containsIgnoreCase(this.mSpecialistBaseType, SPECIALIST_TYPE.toString(_local_2.GetBaseType()));
                    if (_local_1)
                    {
                        if (!definition.isTypeEmpty())
                        {
                            if (definition.typeContains(SPECIALIST_TYPE.toString(_local_2.GetType())))
                            {
                                this.mSpecialistOwnedNumber++;
                            };
                        }
                        else
                        {
                            this.mSpecialistOwnedNumber++;
                        };
                    };
                }
                else
                {
                    this.mSpecialistOwnedNumber++;
                };
            };
            return (this.mSpecialistOwnedNumber);
        }

        override public function dispose():void
        {
            (para as SpecialistNotifier).removePropertyObserver(SpecialistNotifier.SPECIALIST_OWNED_LIST_string, this);
            super.dispose();
        }


    }
}
