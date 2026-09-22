package Trigger
{
    import Communication.VO.TriggerVO;
    import nLib.cLog;

    public class InstantTrigger implements Trigger 
    {

        protected var triggerable:Triggerable;
        public var definition:TriggerVO;
        protected var para:Object;
        protected var updateTrigger:IUpdateTrigger;
        protected var currentAmount:Number = 1;

        public function InstantTrigger(_arg_1:Triggerable, _arg_2:TriggerVO, _arg_3:Object)
        {
            super();
            this.triggerable = _arg_1;
            if ((this.triggerable is IUpdateTrigger))
            {
                this.updateTrigger = (_arg_1 as IUpdateTrigger);
            };
            this.definition = _arg_2;
            this.para = _arg_3;
        }

        protected function sendTriggerValueUpdated():void
        {
            if (this.updateTrigger != null)
            {
                this.updateTrigger.triggerUpdated(this);
            };
        }

        public function getCurrentAmount():Number
        {
            return (this.currentAmount);
        }

        public function check():Boolean
        {
            cLog.error(("Empty Trigger! Need Override! Trigger: " + this.definition));
            return (false);
        }

        public function getDefinition():TriggerVO
        {
            return (this.definition);
        }

        public function setTriggerable(_arg_1:Triggerable):void
        {
            this.triggerable = _arg_1;
            if ((this.triggerable is IUpdateTrigger))
            {
                this.updateTrigger = (_arg_1 as IUpdateTrigger);
            };
        }

        protected function checkSendTriggerValueUpdated(_arg_1:Number, _arg_2:Number):void
        {
            if (_arg_1 != _arg_2)
            {
                this.sendTriggerValueUpdated();
            };
        }

        public function getTriggerable():Triggerable
        {
            return (this.triggerable);
        }

        protected function updateCurrentAmount():void
        {
            var _local_1:Number = this.currentAmount;
            this.currentAmount = this.computeCurrentAmount();
            this.checkSendTriggerValueUpdated(_local_1, this.currentAmount);
        }

        public function dispose():void
        {
            this.triggerable = null;
            this.updateTrigger = null;
            this.definition = null;
            this.para = null;
        }

        public function isRunning():Boolean
        {
            return (true);
        }

        protected function trigger():void
        {
            if (this.triggerable != null)
            {
                this.triggerable.trigger(this);
            };
        }

        protected function computeCurrentAmount():Number
        {
            return (this.currentAmount);
        }

        public function isReversible():Boolean
        {
            return (false);
        }


    }
}
