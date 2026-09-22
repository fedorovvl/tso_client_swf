package Achievements.rewards
{
    import flash.system.ApplicationDomain;
    import nLib.cXML;

    public class AchievementRewardHashMapVO 
    {

        private const PACKAGE_PREFFIX:String = "Achievements.rewards.vo.";

        private var rewardVOClass:Class;
        private var uiClass:Class;

        public function AchievementRewardHashMapVO(_arg_1:String, _arg_2:String)
        {
            super();
            this.createClassInstances(_arg_1, _arg_2);
        }

        private function createClassInstances(_arg_1:String, _arg_2:String):void
        {
            this.rewardVOClass = (ApplicationDomain.currentDomain.getDefinition((this.PACKAGE_PREFFIX + _arg_1)) as Class);
            if (_arg_2.length > 0)
            {
                this.uiClass = (ApplicationDomain.currentDomain.getDefinition((this.PACKAGE_PREFFIX + _arg_2)) as Class);
            };
        }

        public function createRewardVO(_arg_1:cXML):IAchievementReward
        {
            var _local_2:IAchievementReward = new this.rewardVOClass();
            _local_2.init(_arg_1);
            return (_local_2);
        }

        public function createRewardViewComponent(_arg_1:IAchievementReward):IAchievementRewardView
        {
            var _local_2:IAchievementRewardView = new this.uiClass();
            _local_2.init(_arg_1);
            return (_local_2);
        }


    }
}
