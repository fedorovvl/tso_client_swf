package Trigger
{
    public class RuntimeTriggerDeltaValue implements TriggerDeltaValue 
    {

        private var deltaValue:Number;

        public function RuntimeTriggerDeltaValue()
        {
            super();
            this.deltaValue = 0;
        }

        public function add(_arg_1:Number):void
        {
            this.deltaValue = (this.deltaValue + _arg_1);
        }

        public function getValue():Number
        {
            return (this.deltaValue);
        }

        public function setValue(_arg_1:Number):void
        {
            this.deltaValue = _arg_1;
        }


    }
}
