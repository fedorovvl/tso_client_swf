package Achievements.rewards
{
    import mx.containers.Canvas;

    public interface IAchievementRewardView 
    {

        function init(_arg_1:IAchievementReward):void;
        function getViewComponent():Canvas;

    }
}
