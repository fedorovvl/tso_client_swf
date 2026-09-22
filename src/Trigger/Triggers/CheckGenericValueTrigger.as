package Trigger.Triggers
{
    import Trigger.InstantTrigger;
    import Model.Observer;
    import Interface.cGeneralInterface;
    import com.bluebyte.tso.genericvalues.GenericValueManager;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Communication.VO.GenericValueVO;
    import Model.Notifier;

    public class CheckGenericValueTrigger extends InstantTrigger implements Observer 
    {

        public function CheckGenericValueTrigger(_arg_1:Triggerable, _arg_2:TriggerVO, _arg_3:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3);
            (para as cGeneralInterface).genericValueManager.addPropertyObserver(GenericValueManager.UPDATED_string, this);
        }

        override public function check():Boolean
        {
            var _local_1:GenericValueVO = (para as cGeneralInterface).genericValueManager.get(definition.name_string);
            if (((_local_1.value >= definition.min) && (_local_1.value <= definition.max)))
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
            (para as cGeneralInterface).genericValueManager.removePropertyObserver(GenericValueManager.UPDATED_string, this);
            super.dispose();
        }


    }
}
