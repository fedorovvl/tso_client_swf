package Communication.VO
{
    import Trigger.TriggerDeltaValue;
    import Trigger.Triggerable;
    import Interface.cGeneralInterface;
    import Trigger.Trigger;

    public class TriggerHashMapVO 
    {

        private var isDeltaValue:Boolean;
        private var classInstance:Class;

        public function TriggerHashMapVO(_arg_1:Class, _arg_2:Boolean)
        {
            super();
            this.classInstance = _arg_1;
            this.isDeltaValue = _arg_2;
        }

        public function createInstance(_arg_1:TriggerDeltaValue, _arg_2:Triggerable, _arg_3:TriggerVO, _arg_4:cGeneralInterface):Trigger
        {
            if (this.isDeltaValue)
            {
                return (new this.classInstance(_arg_1, _arg_2, _arg_3, _arg_4));
            };
            return (new this.classInstance(_arg_2, _arg_3, _arg_4));
        }

        public function getClassInstance():Class
        {
            return (this.classInstance);
        }


    }
}
