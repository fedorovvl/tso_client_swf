package Achievements.trigger
{
    import Trigger.PersistedTriggerDeltaValue;
    import Utils.Disposable;
    import Communication.VO.Achievements.UserAchievementTriggerVO;
    import Achievements.UserAchievement;
    import Enums.DIRTY_INDICATOR;

    public class PersistedAchievementTriggerDeltaValue implements PersistedTriggerDeltaValue, Disposable 
    {

        public var mDirtyIndicator:int;
        protected var userAchievementTriggerVO:UserAchievementTriggerVO;

        public function PersistedAchievementTriggerDeltaValue(_arg_1:UserAchievement, _arg_2:UserAchievementTriggerVO)
        {
            super();
            this.userAchievementTriggerVO = _arg_2;
        }

        public function getFinished():Boolean
        {
            return (this.userAchievementTriggerVO.finished == 1);
        }

        public function getValue():Number
        {
            return (this.userAchievementTriggerVO.value);
        }

        public function persist():void
        {
            if (this.userAchievementTriggerVO.userID < 0)
            {
                return;
            };
            this.mDirtyIndicator = DIRTY_INDICATOR.MODIFIED_BIT;
        }

        public function add(_arg_1:Number):void
        {
            this.userAchievementTriggerVO.value = (this.userAchievementTriggerVO.value + _arg_1);
            this.persist();
        }

        public function readPersistence():void
        {
        }

        public function getUserAchievementTriggerVO():UserAchievementTriggerVO
        {
            return (this.userAchievementTriggerVO);
        }

        public function setValue(_arg_1:Number):void
        {
            this.userAchievementTriggerVO.value = _arg_1;
            this.persist();
        }

        public function setFinished():void
        {
            this.userAchievementTriggerVO.finished = 1;
            this.persist();
        }

        public function dispose():void
        {
            this.userAchievementTriggerVO = null;
        }


    }
}
