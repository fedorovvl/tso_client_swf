package GUI.achievement.view.detail
{
    import Utils.Disposable;
    import Achievements.UserAchievementTriggerWrapper;
    import GUI.Components.achievement.detail.TriggerCheckViewComponent;
    import mx.events.FlexEvent;
    import GUI.helpers.UIComponentHelpers;
    import flash.events.Event;
    import GUI.Loca.TriggerLocaManager;

    public class AchievementCheckBoxTriggerView implements Disposable 
    {

        private var componentWidth:int;
        private var initVO:UserAchievementTriggerWrapper;
        private var viewComponent:TriggerCheckViewComponent;

        public function AchievementCheckBoxTriggerView()
        {
            super();
            this.viewComponent = new TriggerCheckViewComponent();
        }

        public function getViewComponent():TriggerCheckViewComponent
        {
            return (this.viewComponent);
        }

        public function setWidth(_arg_1:int):void
        {
            this.componentWidth = _arg_1;
        }

        public function dispose():void
        {
            if (this.viewComponent != null)
            {
                this.viewComponent.removeEventListener(FlexEvent.CREATION_COMPLETE, this.handleTriggerCreationComplete);
                UIComponentHelpers.removeFromParent(this.viewComponent);
                this.viewComponent = null;
            };
            this.initVO = null;
        }

        private function handleComponentAddedToStage(_arg_1:Event):void
        {
            this.viewComponent.removeEventListener(Event.ADDED_TO_STAGE, this.handleComponentAddedToStage);
            this.viewComponent.toolTip = this.viewComponent.triggerName.text;
            UIComponentHelpers.enableMouseInteraction(this.viewComponent, false);
        }

        private function handleTriggerCreationComplete(_arg_1:FlexEvent):void
        {
            this.viewComponent.removeEventListener(FlexEvent.CREATION_COMPLETE, this.handleTriggerCreationComplete);
            this.init(this.initVO);
            this.initVO = null;
        }

        public function getIsInitialized():Boolean
        {
            return ((!(this.viewComponent.triggerName == null)) && (!(this.viewComponent.checkbox == null)));
        }

        public function init(_arg_1:UserAchievementTriggerWrapper):void
        {
            this.removeListeners();
            if (this.getIsInitialized())
            {
                this.setWidth(this.componentWidth);
                this.viewComponent.triggerName.text = TriggerLocaManager.getInstance().getTriggerLocaText(_arg_1.getAchievementTriggerVO());
                this.viewComponent.toolTip = this.viewComponent.triggerName.text;
                this.viewComponent.checkbox.visible = _arg_1.getFinished();
                if (this.viewComponent.stage)
                {
                    UIComponentHelpers.enableMouseInteraction(this.viewComponent, false);
                }
                else
                {
                    this.viewComponent.addEventListener(Event.ADDED_TO_STAGE, this.handleComponentAddedToStage, false, 0, true);
                };
            }
            else
            {
                this.initVO = _arg_1;
                this.viewComponent.addEventListener(FlexEvent.CREATION_COMPLETE, this.handleTriggerCreationComplete, false, 0, true);
            };
        }

        private function removeListeners():void
        {
            this.viewComponent.removeEventListener(Event.ADDED_TO_STAGE, this.handleComponentAddedToStage);
            this.viewComponent.removeEventListener(FlexEvent.CREATION_COMPLETE, this.handleTriggerCreationComplete);
        }


    }
}
