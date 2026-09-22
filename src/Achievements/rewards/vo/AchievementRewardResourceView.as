package Achievements.rewards.vo
{
    import Achievements.rewards.IAchievementRewardView;
    import GUI.helpers.ObjectPool;
    import GUI.achievement.reward.AchievementRewardViewComponent;
    import flash.events.Event;
    import mx.events.FlexEvent;
    import mx.containers.Canvas;
    import GUI.Assets.gAssetManager;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import Achievements.rewards.IAchievementReward;

    public class AchievementRewardResourceView implements IAchievementRewardView 
    {

        protected static var viewComponentPool:ObjectPool;

        protected var reward:ResourceAchievementReward;
        protected var viewComponent:AchievementRewardViewComponent;

        public function AchievementRewardResourceView()
        {
            super();
            createPool();
        }

        protected static function createPool():void
        {
            if (viewComponentPool == null)
            {
                viewComponentPool = new ObjectPool(AchievementRewardViewComponent, ObjectPool.DEFAULT_INSTANCES);
            };
        }


        protected function isComponentInitialized():Boolean
        {
            return ((!(this.viewComponent.resourceImage == null)) && (!(this.viewComponent.resourceAmount == null)));
        }

        protected function handleInitStage():void
        {
            if (this.viewComponent.stage != null)
            {
                this.handleAddedToStage(null);
            }
            else
            {
                this.viewComponent.addEventListener(Event.ADDED_TO_STAGE, this.handleAddedToStage, false, 0, true);
            };
        }

        public function getViewComponent():Canvas
        {
            this.viewComponent = (viewComponentPool.getObject() as AchievementRewardViewComponent);
            if (this.isComponentInitialized())
            {
                this.initComponent();
            }
            else
            {
                this.viewComponent.addEventListener(FlexEvent.CREATION_COMPLETE, this.handleComponentCreation, false, 0, true);
            };
            return (this.viewComponent);
        }

        protected function handleAddedToStage(_arg_1:Event):void
        {
            this.viewComponent.removeEventListener(Event.ADDED_TO_STAGE, this.handleAddedToStage);
            this.viewComponent.addEventListener(Event.REMOVED_FROM_STAGE, this.handleRemovedFromStage, false, 0, true);
        }

        protected function initComponent():void
        {
            this.handleInitStage();
            this.viewComponent.resourceImage.source = gAssetManager.GetResourceIcon(this.reward.getName());
            this.viewComponent.resourceAmount.text = this.reward.getAmount().toString();
            this.viewComponent.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.RESOURCES, this.reward.getName());
        }

        protected function handleComponentCreation(_arg_1:FlexEvent):void
        {
            this.viewComponent.removeEventListener(FlexEvent.CREATION_COMPLETE, this.handleComponentCreation);
            this.initComponent();
        }

        protected function handleRemovedFromStage(_arg_1:Event):void
        {
            if (this.viewComponent != null)
            {
                this.viewComponent.removeEventListener(Event.ADDED_TO_STAGE, this.handleAddedToStage);
                this.viewComponent.removeEventListener(Event.REMOVED_FROM_STAGE, this.handleRemovedFromStage);
                viewComponentPool.releaseObject(this.viewComponent);
                this.viewComponent = null;
            };
        }

        public function init(_arg_1:IAchievementReward):void
        {
            this.reward = (_arg_1 as ResourceAchievementReward);
        }


    }
}
