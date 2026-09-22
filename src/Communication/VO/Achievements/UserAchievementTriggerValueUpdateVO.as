package Communication.VO.Achievements
{
    public class UserAchievementTriggerValueUpdateVO 
    {

        public var triggerId:int;
        public var updatedValue:int;
        public var achievementId:int;


        public function init(_arg_1:int, _arg_2:int, _arg_3:int):UserAchievementTriggerValueUpdateVO
        {
            this.achievementId = _arg_1;
            this.triggerId = _arg_2;
            this.updatedValue = _arg_3;
            return (this);
        }


    }
}
