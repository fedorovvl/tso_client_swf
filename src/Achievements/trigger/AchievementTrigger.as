package Achievements.trigger
{
    import Trigger.Trigger;
    import Trigger.Triggerable;
    import Trigger.IUpdateTrigger;
    import Achievements.UserAchievement;
    import Trigger.DeltaTrigger;
    import Enums.DIRTY_INDICATOR;
    import Communication.VO.TriggerVO;

    public class AchievementTrigger implements Trigger, Triggerable, IUpdateTrigger 
    {

        protected var innerTrigger:Trigger;
        protected var triggerable:Triggerable;
        protected var dirtyIndicator:int;
        protected var userAchievement:UserAchievement;
        protected var delta:PersistedAchievementTriggerDeltaValue;

        public function AchievementTrigger(_arg_1:Trigger)
        {
            var _local_2:DeltaTrigger;
            super();
            this.innerTrigger = _arg_1;
            if ((_arg_1 is DeltaTrigger))
            {
                _local_2 = (_arg_1 as DeltaTrigger);
                this.delta = (_local_2.getDelta() as PersistedAchievementTriggerDeltaValue);
            };
            this.triggerable = _arg_1.getTriggerable();
            this.userAchievement = (this.triggerable as UserAchievement);
            _arg_1.setTriggerable(this);
            this.dirtyIndicator = DIRTY_INDICATOR.CLEAN;
        }

        public function isReversible():Boolean
        {
            return (false);
        }

        public function trigger(_arg_1:Trigger):void
        {
            if (this.delta != null)
            {
                this.delta.setFinished();
            }
            else
            {
                this.dirtyIndicator = DIRTY_INDICATOR.CREATED_BIT;
            };
            if (this.triggerable != null)
            {
                this.triggerable.trigger(this);
            };
        }

        public function check():Boolean
        {
            return (this.innerTrigger.check());
        }

        public function getDefinition():TriggerVO
        {
            return (this.innerTrigger.getDefinition());
        }

        public function getCurrentAmount():Number
        {
            return (this.innerTrigger.getCurrentAmount());
        }

        public function getDelta():PersistedAchievementTriggerDeltaValue
        {
            return (this.delta);
        }

        public function getDirtyIndicator():int
        {
            return (this.dirtyIndicator);
        }

        public function reset():void
        {
        }

        public function getTriggerable():Triggerable
        {
            return (this.triggerable);
        }

        public function setDirtyIndicator(_arg_1:int):void
        {
            this.dirtyIndicator = _arg_1;
        }

        public function dispose():void
        {
            this.innerTrigger.dispose();
            this.innerTrigger = null;
            if (this.delta != null)
            {
                this.delta.dispose();
                this.delta = null;
            };
            this.triggerable = null;
            this.userAchievement = null;
        }

        public function setTriggerable(_arg_1:Triggerable):void
        {
            this.triggerable = _arg_1;
        }

        public function triggerUpdated(_arg_1:Trigger):void
        {
            this.userAchievement.triggerUpdated(this);
        }

        public function isRunning():Boolean
        {
            return (true);
        }

        public function getInnerTrigger():Trigger
        {
            return (this.innerTrigger);
        }


    }
}
