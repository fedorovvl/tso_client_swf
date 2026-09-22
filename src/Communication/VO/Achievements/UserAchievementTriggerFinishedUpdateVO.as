package Communication.VO.Achievements
{
    public class UserAchievementTriggerFinishedUpdateVO 
    {

        public var triggerId:int;
        public var achievementId:int;


        public function init(_arg_1:int, _arg_2:int):UserAchievementTriggerFinishedUpdateVO
        {
            this.achievementId = _arg_1;
            this.triggerId = _arg_2;
            return (this);
        }


    }
}
