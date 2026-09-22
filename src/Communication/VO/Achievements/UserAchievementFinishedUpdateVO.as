package Communication.VO.Achievements
{
    import mx.collections.ArrayCollection;

    public class UserAchievementFinishedUpdateVO 
    {

        public var uniqueIDs:ArrayCollection = new ArrayCollection();
        public var achievementId:int;


        public function init(_arg_1:int, _arg_2:ArrayCollection):UserAchievementFinishedUpdateVO
        {
            this.achievementId = _arg_1;
            this.uniqueIDs = _arg_2;
            return (this);
        }


    }
}
