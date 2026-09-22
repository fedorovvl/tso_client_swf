package Trigger
{
    import Communication.VO.TriggerVO;

    public class DeltaTrigger extends InstantTrigger 
    {

        private var delta:TriggerDeltaValue;

        public function DeltaTrigger(_arg_1:TriggerDeltaValue, _arg_2:Triggerable, _arg_3:TriggerVO, _arg_4:Object)
        {
            super(_arg_2, _arg_3, _arg_4);
            this.delta = _arg_1;
            if (this.delta == null)
            {
                this.delta = new RuntimeTriggerDeltaValue();
            };
        }

        public function getDelta():TriggerDeltaValue
        {
            return (this.delta);
        }

        public function setDelta(_arg_1:TriggerDeltaValue):void
        {
            this.delta = _arg_1;
        }

        override public function getCurrentAmount():Number
        {
            return (this.delta.getValue());
        }


    }
}
