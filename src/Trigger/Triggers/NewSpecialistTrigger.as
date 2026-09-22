package Trigger.Triggers
{
    import Trigger.InstantTrigger;
    import Model.Observer;
    import Utils.HashSetWrapper;
    import Enums.SPECIALIST_TYPE;
    import Model.Notifiers.SpecialistNotifier;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Interface.cGeneralInterface;
    import Specialists.cSpecialist;
    import Model.Notifier;

    public final class NewSpecialistTrigger extends InstantTrigger implements Observer 
    {

        private var typemap:HashSetWrapper = new HashSetWrapper();

        public function NewSpecialistTrigger(_arg_1:Triggerable, _arg_2:TriggerVO, _arg_3:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3);
            if (_arg_2.item_string.indexOf("explorer") > -1)
            {
                this.typemap.add(SPECIALIST_TYPE.EXPLORER);
            };
            if (_arg_2.item_string.indexOf("general") > -1)
            {
                this.typemap.add(SPECIALIST_TYPE.GENERAL);
            };
            if (_arg_2.item_string.indexOf("geologist") > -1)
            {
                this.typemap.add(SPECIALIST_TYPE.GEOLOGIST);
            };
            if (_arg_2.item_string.indexOf("admiral") > -1)
            {
                this.typemap.add(SPECIALIST_TYPE.ADMIRAL);
            };
            if (_arg_2.item_string.indexOf("TransporterGeneral") > -1)
            {
                this.typemap.add(SPECIALIST_TYPE.TRANSPORTER_GENERAL);
            };
            _arg_3.channels.SPECIALIST.addPropertyObserver(SpecialistNotifier.SPECIALIST_OWNED_LIST_string, this);
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            var _local_4:cSpecialist = (_arg_3 as cSpecialist);
            if (_local_4 != null)
            {
                this.checkSpecialist(_local_4);
            };
        }

        override public function dispose():void
        {
            (para as cGeneralInterface).channels.SPECIALIST.removePropertyObserver(SpecialistNotifier.SPECIALIST_OWNED_LIST_string, this);
            super.dispose();
        }

        override public function check():Boolean
        {
            return (false);
        }

        private function checkSpecialist(_arg_1:cSpecialist):Boolean
        {
            if (this.typemap.contains(_arg_1.GetBaseType()))
            {
                trigger();
                return (true);
            };
            return (false);
        }


    }
}
