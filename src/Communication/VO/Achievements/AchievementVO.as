package Communication.VO.Achievements
{
    import Utils.Disposable;
    import __AS3__.vec.Vector;
    import Communication.VO.TriggerVO;
    import Achievements.rewards.IAchievementReward;
    import Achievements.rewards.IAchievementRewardView;

    public class AchievementVO implements Disposable 
    {

        private var achievementID:int;
        private var requiresYear:int;
        private var requiresEvent:String;
        private var categoryID:int;
        private var achievementName:String;
        private var maxPlayerLevel:int;
        private var points:int;
        private var triggers_Vector:Vector.<TriggerVO>;
        private var rewards:Vector.<IAchievementReward>;
        private var minPlayerLevel:int;
        private var visible:Boolean;
        private var disabled:Boolean;
        private var rewardViews:Vector.<IAchievementRewardView>;

        public function AchievementVO(_arg_1:int, _arg_2:String, _arg_3:int, _arg_4:int, _arg_5:Boolean, _arg_6:Boolean, _arg_7:String, _arg_8:int, _arg_9:Vector.<TriggerVO>, _arg_10:Vector.<IAchievementReward>, _arg_11:Vector.<IAchievementRewardView>, _arg_12:int, _arg_13:int)
        {
            super();
            this.achievementID = _arg_1;
            this.achievementName = _arg_2;
            this.categoryID = _arg_3;
            this.points = _arg_4;
            this.visible = _arg_5;
            this.disabled = _arg_6;
            this.requiresEvent = _arg_7;
            this.requiresYear = _arg_8;
            this.triggers_Vector = _arg_9;
            this.rewards = _arg_10;
            this.rewardViews = _arg_11;
            this.minPlayerLevel = _arg_12;
            this.maxPlayerLevel = _arg_13;
        }

        public function getTriggers():Vector.<TriggerVO>
        {
            return (this.triggers_Vector);
        }

        public function getDisabled():Boolean
        {
            return (this.disabled);
        }

        public function getRewardViews():Vector.<IAchievementRewardView>
        {
            return (this.rewardViews);
        }

        public function getCategoryID():int
        {
            return (this.categoryID);
        }

        public function getRequiresYear():int
        {
            return (this.requiresYear);
        }

        public function getAchievementName():String
        {
            return (this.achievementName);
        }

        public function getMaxPlayerLevel():int
        {
            return (this.maxPlayerLevel);
        }

        public function getAchievementID():int
        {
            return (this.achievementID);
        }

        public function getRequiresEvent():String
        {
            return (this.requiresEvent);
        }

        public function getPoints():int
        {
            return (this.points);
        }

        public function dispose():void
        {
            this.achievementName = null;
            this.triggers_Vector = null;
            this.rewards = null;
            this.rewardViews = null;
        }

        public function isVisible():Boolean
        {
            return (this.visible);
        }

        public function getRewards():Vector.<IAchievementReward>
        {
            return (this.rewards);
        }

        public function getMinPlayerLevel():int
        {
            return (this.minPlayerLevel);
        }

        public function IsEventAchievement():Boolean
        {
            if (((!(this.requiresEvent == null)) && (this.requiresEvent.length > 0)))
            {
                return (true);
            };
            return (false);
        }


    }
}
