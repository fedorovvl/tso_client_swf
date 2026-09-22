package Achievements.rewards
{
    import Utils.HashMapWrapper;
    import Achievements.rewards.vo.ResourceAchievementReward;
    import Achievements.rewards.vo.HardCurrencyAchievementReward;
    import Achievements.rewards.vo.BuffAchievementReward;
    import Achievements.rewards.vo.AchievementRewardResourceView;
    import Achievements.rewards.vo.HardCurrencyAchievementRewardView;
    import Achievements.rewards.vo.BuffAchievementRewardView;
    import nLib.cXML;

    public class AchievementRewardFactory 
    {

        public static const ATTRIBUTE_ITEM:String = "item";
        public static const ATTRIBUTE_NAME:String = "name";
        public static const ATTRIBUTE_AMOUNT:String = "amount";
        public static const ATTRIBUTE_RECURRING_CHANCE:String = "recurringChance";
        private static var rewardHashMap:HashMapWrapper = new HashMapWrapper();

        private const rewardClass1:ResourceAchievementReward = null;
        private const rewardClass2:HardCurrencyAchievementReward = null;
        private const rewardClass3:BuffAchievementReward = null;
        private const rewardClass4:AchievementRewardResourceView = null;
        private const rewardClass5:HardCurrencyAchievementRewardView = null;
        private const rewardClass6:BuffAchievementRewardView = null;


        public function getReward(_arg_1:String, _arg_2:cXML):IAchievementReward
        {
            var _local_3:AchievementRewardHashMapVO = (rewardHashMap.getItem(_arg_1) as AchievementRewardHashMapVO);
            return (_local_3.createRewardVO(_arg_2));
        }

        public function addReward(_arg_1:String, _arg_2:String, _arg_3:String):void
        {
            rewardHashMap.putItem(_arg_1, new AchievementRewardHashMapVO(_arg_2, _arg_3));
        }

        public function getUIRewardView(_arg_1:String, _arg_2:IAchievementReward):IAchievementRewardView
        {
            var _local_3:AchievementRewardHashMapVO = (rewardHashMap.getItem(_arg_1) as AchievementRewardHashMapVO);
            return (_local_3.createRewardViewComponent(_arg_2));
        }


    }
}
