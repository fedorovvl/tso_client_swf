package GUI.achievement.view.detail
{
    import Utils.Disposable;
    import Achievements.UserAchievementTriggerWrapper;
    import GUI.Components.achievement.detail.TriggerProgressViewComponent;
    import GUI.helpers.UIComponentHelpers;
    import mx.events.FlexEvent;
    import flash.events.Event;
    import GUI.Loca.cLocaManager;
    import GUI.Loca.TriggerLocaManager;

    public class AchievementProgressTriggerView implements Disposable 
    {

        private var componentWidth:int;
        private var initVO:UserAchievementTriggerWrapper;
        private var progressTooltip:String;
        private var viewComponent:TriggerProgressViewComponent;

        public function AchievementProgressTriggerView()
        {
            super();
            this.viewComponent = new TriggerProgressViewComponent();
        }

        public function getViewComponent():TriggerProgressViewComponent
        {
            return (this.viewComponent);
        }

        public function setWidth(_arg_1:int):void
        {
            var _local_2:int;
            var _local_3:int;
            this.componentWidth = _arg_1;
            if (!this.getIsInitialized())
            {
                return;
            };
            this.viewComponent.width = (_arg_1 - AchievementDetailView.TRIGGER_PROGRESS_VIEW_WIDTH_OFFSET);
            _local_2 = UIComponentHelpers.getLeftValue(this.viewComponent.progressBarCanvas);
            _local_3 = ((this.viewComponent.width - _local_2) - UIComponentHelpers.getRightValue(this.viewComponent.progressBarCanvas));
            this.viewComponent.triggerName.width = (this.viewComponent.width - UIComponentHelpers.getLeftValue(this.viewComponent.triggerName));
            this.viewComponent.progressLabel.setStyle(UIComponentHelpers.LEFT, ((_local_2 + _local_3) + AchievementDetailView.TRIGGER_PROGRESS_LABEL_PROGRESS_LEFT_OFFSET));
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
            this.viewComponent.progressBarCanvas.toolTip = this.progressTooltip;
            this.viewComponent.progressLabel.toolTip = this.progressTooltip;
            UIComponentHelpers.enableMouseInteractionForListWithStopAtFirstParentOption(false, this.viewComponent.progressBarCanvas, this.viewComponent.progressLabel, this.viewComponent.triggerName, this.viewComponent);
        }

        private function handleTriggerCreationComplete(_arg_1:FlexEvent):void
        {
            this.viewComponent.removeEventListener(FlexEvent.CREATION_COMPLETE, this.handleTriggerCreationComplete);
            this.init(this.initVO);
            this.initVO = null;
        }

        public function getIsInitialized():Boolean
        {
            return (((!(this.viewComponent.triggerName == null)) && (!(this.viewComponent.progressLabel == null))) && (!(this.viewComponent.progressBarMask == null)));
        }

        public function init(_arg_1:UserAchievementTriggerWrapper):void
        {
            var _local_2:Boolean;
            var _local_3:int;
            var _local_4:int;
            var _local_5:cLocaManager;
            this.removeListeners();
            if (this.getIsInitialized())
            {
                _local_2 = _arg_1.getFinished();
                _local_3 = _arg_1.getValue();
                _local_4 = _arg_1.getMaxValue();
                _local_5 = cLocaManager.GetInstance();
                this.setWidth(this.componentWidth);
                this.viewComponent.triggerName.text = TriggerLocaManager.getInstance().getTriggerLocaText(_arg_1.getAchievementTriggerVO());
                this.viewComponent.progressLabel.text = ((((_local_2) ? _local_5.FormatAmount(_local_4) : _local_5.FormatAmount(_local_3)) + "/") + _local_5.FormatAmount(_local_4));
                this.progressTooltip = ((((_local_2) ? _local_4 : _local_3) + "/") + _local_4);
                this.viewComponent.progressBarCanvas.toolTip = this.progressTooltip;
                this.viewComponent.progressLabel.toolTip = this.progressTooltip;
                this.viewComponent.progressBarMask.x = this.viewComponent.progressBar.x;
                this.viewComponent.progressBarMask.y = this.viewComponent.progressBar.y;
                this.viewComponent.progressBarMask.height = this.viewComponent.progressBar.height;
                this.viewComponent.progressBarMask.width = ((_arg_1.getFinished()) ? this.viewComponent.progressBar.width : (this.viewComponent.progressBar.width * _arg_1.getProgress()));
                if (this.viewComponent.stage)
                {
                    UIComponentHelpers.enableMouseInteractionForListWithStopAtFirstParentOption(false, this.viewComponent.progressBarCanvas, this.viewComponent.progressLabel, this.viewComponent.triggerName, this.viewComponent);
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
