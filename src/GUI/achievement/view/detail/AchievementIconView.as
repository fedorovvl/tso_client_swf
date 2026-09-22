package GUI.achievement.view.detail
{
    import Utils.Disposable;
    import GUI.Components.achievement.detail.AchievementIconViewComponent;
    import GUI.achievement.vo.AchievementGUIDetailVO;
    import flash.events.Event;
    import flash.display.DisplayObject;
    import GUI.Assets.gAssetManager;

    public class AchievementIconView implements Disposable 
    {

        private var iconName:String;
        private var achievementIconViewComponent:AchievementIconViewComponent;
        private var guiVO:AchievementGUIDetailVO;

        public function AchievementIconView(_arg_1:AchievementIconViewComponent)
        {
            super();
            this.achievementIconViewComponent = _arg_1;
        }

        public function getViewComponent():AchievementIconViewComponent
        {
            return (this.achievementIconViewComponent);
        }

        private function handleAchievementSmallIconComplete(_arg_1:Event):void
        {
            this.achievementIconViewComponent.achievementSmallIcon.removeEventListener(Event.COMPLETE, this.handleAchievementSmallIconComplete);
            var _local_2:DisplayObject = this.achievementIconViewComponent.achievementSmallIcon.content;
            this.achievementIconViewComponent.achievementSmallIcon.x = (((this.achievementIconViewComponent.achievementIcon.x + this.achievementIconViewComponent.achievementIcon.width) - _local_2.width) - this.guiVO.getIconRightOffset());
            this.achievementIconViewComponent.achievementSmallIcon.y = (((this.achievementIconViewComponent.achievementIcon.y + this.achievementIconViewComponent.achievementIcon.height) - _local_2.height) - this.guiVO.getIconBottomOffset());
            this.achievementIconViewComponent.achievementSmallIcon.visible = true;
        }

        public function init(_arg_1:AchievementGUIDetailVO, _arg_2:Boolean):void
        {
            this.guiVO = _arg_1;
            this.iconName = _arg_1.getIcon();
            if (((!(this.iconName == null)) && (this.iconName.length > 0)))
            {
                this.achievementIconViewComponent.achievementIcon.addEventListener(Event.COMPLETE, this.handleAchievementIconImageComplete, false, 0, true);
                this.achievementIconViewComponent.achievementIcon.source = gAssetManager.GetAchievementUrl(this.iconName);
            };
        }

        public function updateAchievementFinished(_arg_1:Boolean):void
        {
            this.achievementIconViewComponent.finishedIcon.visible = _arg_1;
        }

        public function getIconName():String
        {
            return (this.iconName);
        }

        private function handleAchievementIconImageComplete(_arg_1:Event):void
        {
            this.achievementIconViewComponent.achievementIcon.removeEventListener(Event.COMPLETE, this.handleAchievementIconImageComplete);
            var _local_2:DisplayObject = this.achievementIconViewComponent.achievementIcon.content;
            this.achievementIconViewComponent.achievementIcon.x = ((this.achievementIconViewComponent.width - _local_2.width) / 2);
            this.achievementIconViewComponent.achievementIcon.y = ((this.achievementIconViewComponent.height - _local_2.height) / 2);
            var _local_3:String = this.guiVO.getSmallIcon();
            if (((!(_local_3 == null)) && (_local_3.length > 0)))
            {
                this.achievementIconViewComponent.achievementSmallIcon.addEventListener(Event.COMPLETE, this.handleAchievementSmallIconComplete, false, 0, true);
                this.achievementIconViewComponent.achievementSmallIcon.source = gAssetManager.GetAchievementUrl(_local_3);
            };
        }

        public function dispose():void
        {
            this.achievementIconViewComponent.achievementIcon.removeEventListener(Event.COMPLETE, this.handleAchievementIconImageComplete);
            this.achievementIconViewComponent.achievementSmallIcon.removeEventListener(Event.COMPLETE, this.handleAchievementSmallIconComplete);
            this.achievementIconViewComponent.achievementSmallIcon.visible = false;
            this.achievementIconViewComponent.achievementIcon.source = null;
            this.achievementIconViewComponent.achievementSmallIcon.source = null;
        }


    }
}
