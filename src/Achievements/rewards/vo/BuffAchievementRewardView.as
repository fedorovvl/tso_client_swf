package Achievements.rewards.vo
{
    import Achievements.rewards.IAchievementReward;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;

    public class BuffAchievementRewardView extends AchievementRewardResourceView 
    {

        private var buffAchievementReward:BuffAchievementReward;


        override public function init(_arg_1:IAchievementReward):void
        {
            this.buffAchievementReward = (_arg_1 as BuffAchievementReward);
        }

        override protected function initComponent():void
        {
            handleInitStage();
            viewComponent.resourceImage.source = "";
            viewComponent.resourceAmount.text = ((cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "Buff") + " - ") + cLocaManager.GetInstance().GetText(LOCA_GROUP.RESOURCES, this.buffAchievementReward.getItem(), [this.buffAchievementReward.getAmount(), this.buffAchievementReward.getName()]));
            viewComponent.toolTip = this.buffAchievementReward.getName();
        }


    }
}
