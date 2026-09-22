package Communication.VO.Achievements
{
    import mx.collections.ArrayCollection;

    public class UserAchievementDataVO 
    {

        public var achievementTriggerValueUpdates:ArrayCollection = new ArrayCollection();
        public var userID:int = -1;
        public var finishedAchievementTriggers:ArrayCollection = new ArrayCollection();


        public function isInitialized():Boolean
        {
            return (!(this.userID == -1));
        }


    }
}
