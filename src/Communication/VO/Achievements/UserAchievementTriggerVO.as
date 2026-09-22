package Communication.VO.Achievements
{
    public class UserAchievementTriggerVO 
    {

        public static var INVALID_TRIGGER_UNIQUE_ID:int = -1;

        public var achievementID:int;
        public var userID:int;
        public var value:Number;
        public var finished:int;
        public var triggerID:int;


        public function clone():UserAchievementTriggerVO
        {
            var _local_1:UserAchievementTriggerVO = new UserAchievementTriggerVO();
            _local_1.userID = this.userID;
            _local_1.achievementID = this.achievementID;
            _local_1.triggerID = this.triggerID;
            _local_1.finished = this.finished;
            _local_1.value = this.value;
            return (this);
        }


    }
}
