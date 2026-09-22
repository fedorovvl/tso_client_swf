package Trigger
{
    import Communication.VO.TriggerVO;

    public class InvertTriggerWrapper implements Trigger, Triggerable, InteractivityTrigger 
    {

        private var triggerable:Triggerable;
        private var inner:Trigger;

        public function InvertTriggerWrapper(_arg_1:Trigger)
        {
            super();
            this.inner = _arg_1;
            this.triggerable = this.inner.getTriggerable();
            this.inner.setTriggerable(this);
        }

        public function getDefinition():TriggerVO
        {
            return (this.inner.getDefinition());
        }

        public function reset():void
        {
        }

        public function createUIObserver():void
        {
            if ((this.inner is InteractivityTrigger))
            {
                (this.inner as InteractivityTrigger).createUIObserver();
            };
        }

        public function check():Boolean
        {
            return (!(this.inner.check()));
        }

        public function dispose():void
        {
            this.inner.dispose();
            this.inner = null;
            this.triggerable = null;
        }

        public function getTriggerable():Triggerable
        {
            return (this.triggerable);
        }

        public function setTriggerable(_arg_1:Triggerable):void
        {
            this.triggerable = _arg_1;
        }

        public function trigger(_arg_1:Trigger):void
        {
            if (this.triggerable != null)
            {
                this.triggerable.trigger(this);
            };
        }

        public function getCurrentAmount():Number
        {
            return (this.inner.getCurrentAmount());
        }

        public function isRunning():Boolean
        {
            return (this.inner.isRunning());
        }

        public function isReversible():Boolean
        {
            return (this.inner.isReversible());
        }


    }
}
