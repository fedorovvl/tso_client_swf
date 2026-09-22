package converted.bluebyte.tso.quests.trigger
{
    import Trigger.Trigger;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import nLib.cLog;

    public class QuestTrigger implements Trigger, Triggerable 
    {

        protected var innerTrigger:Trigger;
        protected var delta:PersistedQuestTriggerDeltaValue;
        protected var triggerable:Triggerable;

        public function QuestTrigger(_arg_1:Trigger, _arg_2:PersistedQuestTriggerDeltaValue)
        {
            super();
            this.delta = _arg_2;
            this.innerTrigger = _arg_1;
            this.triggerable = _arg_1.getTriggerable();
            _arg_1.setTriggerable(this);
        }

        public function isReversible():Boolean
        {
            return (this.innerTrigger.isReversible());
        }

        public function getCurrentAmount():Number
        {
            return (this.innerTrigger.getCurrentAmount());
        }

        public function check():Boolean
        {
            if (!this.delta.isRunning())
            {
                return (true);
            };
            return (this.innerTrigger.check());
        }

        public function getDefinition():TriggerVO
        {
            return (this.innerTrigger.getDefinition());
        }

        public function reset():void
        {
            if (!this.isRunning())
            {
                this.setRunning();
                if (this.triggerable != null)
                {
                    this.triggerable.reset();
                };
            };
        }

        public function setTriggerable(_arg_1:Triggerable):void
        {
            this.triggerable = _arg_1;
        }

        public function trigger(_arg_1:Trigger):void
        {
            if (this.isRunning())
            {
                this.delta.setWon();
                if (cLog.isInfoEnabled())
                {
                    cLog.info(("Quest Trigger finished: " + _arg_1.getDefinition()));
                };
                if (this.triggerable != null)
                {
                    this.triggerable.trigger(this);
                };
            };
        }

        public function dispose():void
        {
            this.innerTrigger.dispose();
            this.innerTrigger = null;
            this.delta.dispose();
            this.delta = null;
            this.triggerable = null;
        }

        public function getTriggerable():Triggerable
        {
            return (this.triggerable);
        }

        public function isRunning():Boolean
        {
            return (this.delta.isRunning());
        }

        public function setRunning():void
        {
            this.delta.setRunning();
        }

        public function getInnerTrigger():Trigger
        {
            return (this.innerTrigger);
        }


    }
}
