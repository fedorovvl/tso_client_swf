package Achievements.rewards.vo
{
    import Achievements.rewards.IAchievementReward;
    import GUI.Assets.gAssetManager;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;

    public class HardCurrencyAchievementRewardView extends AchievementRewardResourceView 
    {

        private var harCurrencyReward:HardCurrencyAchievementReward;


        override public function init(_arg_1:IAchievementReward):void
        {
            this.harCurrencyReward = (_arg_1 as HardCurrencyAchievementReward);
        }

        override protected function initComponent():void
        {
            handleInitStage();
            viewComponent.resourceImage.source = gAssetManager.GetResourceIcon(this.harCurrencyReward.getName());
            viewComponent.resourceAmount.text = this.harCurrencyReward.getAmount().toString();
            viewComponent.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.RESOURCES, this.harCurrencyReward.getName());
        }


    }
}
