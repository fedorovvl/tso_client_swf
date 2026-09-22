package GUI.achievement.view.detail
{
    import flash.filters.GlowFilter;
    import GUI.achievement.vo.AchievementGUIDetailVO;
    import flash.utils.Dictionary;
    import __AS3__.vec.Vector;
    import Achievements.UserAchievementTriggerWrapper;
    import GUI.Components.achievement.detail.AchievementDetailViewComponent;
    import GUI.helpers.ObjectPool;
    import mx.events.EffectEvent;
    import mx.events.FlexEvent;
    import flash.events.MouseEvent;
    import GUI.helpers.UIComponentHelpers;
    import Achievements.AchievementConsts;
    import Communication.VO.Achievements.AchievementCategoriesVO;
    import mx.controls.Alert;
    import Achievements.AchievementsManager;
    import GUI.share.ShareManager;
    import Enums.AVATAR_MESSAGE_TYPE;
    import mx.events.CloseEvent;
    import mx.effects.Sequence;
    import Communication.VO.dPartnerSettingsVO;
    import flash.events.Event;
    import GUI.Assets.gAssetManager;
    import flash.display.DisplayObject;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import nLib.gMisc;
    import mx.containers.HBox;
    import Communication.VO.Achievements.AchievementVO;
    import GUI.Components.CustomAlert;
    import Achievements.rewards.IAchievementRewardView;
    import flash.text.TextLineMetrics;
    import Utils.StringUtils;

    public class AchievementDetailView extends AbstractDetailSubView 
    {

        public static const TRIGGER_CHECK_BOX_VIEW_COMPONENT_WIDTH:int = 485;
        public static const TRIGGER_CHECK_BOX_VIEW_COMPONENT_HEIGHT:int = 40;
        public static const TRIGGER_PROGRESS_VIEW_COMPONENT_HEIGHT:int = 45;
        public static const TRIGGER_CHECK_BOX_NAME_LABEL_LEFT_OFFSET:int = 35;
        public static const TRIGGER_CHECK_BOX_NAME_LABEL_RIGHT_OFFSET:int = 10;
        public static const TRIGGER_PROGRESS_VIEW_WIDTH_OFFSET:int = 55;
        public static const TRIGGER_PROGRESS_LABEL_PROGRESS_LEFT_OFFSET:int = 5;
        public static const ACHIEVEMENT_NAME_LABEL_PADDING:int = 5;
        public static const TRIGGER_BOX_VERTICAL_GAP:int = 5;
        public static const TRIGGER_BOX_HORIZONTAL_GAP:int = 4;
        public static const ACHIEVEMENT_VIEW_BACKGROUND_HEIGHT:int = 74;
        public static const ACHIEVEMENT_VIEW_BACKGROUND_TOP:int = 10;
        public static const ACHIEVEMENT_DESCRIPTION_OFFSET:int = 35;
        public static const ACHIEVEMENT_DESCRIPTION_TEXT_OFFSET:int = 15;
        public static const ACHIEVEMENT_DESCRIPTION_TEXT_HEIGHT:int = 40;
        public static const ACHIEVEMENT_REWARD_BOX_HEIGHT:int = 42;
        public static const ACHIEVEMENT_REWARD_BOX_HEIGHT_NEGATIVE_OFFSET:int = -10;
        public static const GLOW:GlowFilter = new GlowFilter(16441444, 1, 10, 10, 4);

        private var currentHeight:Number;
        private var expanding:Boolean;
        private var achievementDetailVO:AchievementGUIDetailVO;
        private var achievementId:int;
        private var triggerPoolDictionary:Dictionary;
        private var rewardBoxVisible:Boolean;
        private var allocatedCheckTriggerViews:Array;
        private var currentPlayer:Boolean;
        private var triggers:Vector.<UserAchievementTriggerWrapper>;
        private var iconView:AchievementIconView;
        private var expandedHeight:Number;
        private var achievementFinished:int;
        private var expanded:Boolean;
        private var componentWidth:int;
        private var allocatedProgressTriggerViews:Array;
        private var achievementName:String;
        private var points:int;
        private var collapsedHeight:Number;
        private var achievementViewComponent:AchievementDetailViewComponent;
        private var viewMode:String;
        private var triggerViewComponentsMouseEnabled:Boolean;
        private var triggerBoxHeight:Number;
        private var expandable:Boolean;

        public function AchievementDetailView()
        {
            super();
            this.allocatedCheckTriggerViews = [];
            this.allocatedProgressTriggerViews = [];
            this.triggerViewComponentsMouseEnabled = false;
        }

        public function setWidth(_arg_1:int):void
        {
            if (this.componentWidth == _arg_1)
            {
                return;
            };
            this.componentWidth = _arg_1;
            if (!initialized)
            {
                return;
            };
            this.setViewComponentWidth();
        }

        private function initBoxes():void
        {
            this.achievementViewComponent.triggerBox.alpha = ((this.expanded) ? 1 : 0);
            this.achievementViewComponent.rewardContainer.visible = this.rewardBoxVisible;
            this.achievementViewComponent.rewardContainer.alpha = ((this.expanded) ? 0 : 1);
        }

        override protected function handleSetActiveParent():void
        {
            this.enableMouseInteraction();
        }

        private function releaseAllocatedObjects(_arg_1:Array, _arg_2:String):void
        {
            var _local_3:ObjectPool;
            var _local_4:Object;
            if (_arg_1)
            {
                _local_3 = this.triggerPoolDictionary[_arg_2];
                for each (_local_4 in _arg_1)
                {
                    _local_3.releaseObject(_local_4);
                };
                _arg_1 = null;
            };
        }

        private function handleCollapseFadeEnd(_arg_1:EffectEvent):void
        {
            this.achievementViewComponent.triggerBox.alpha = 0;
            this.setTriggerBoxState();
        }

        override protected function handleCreationComplete(_arg_1:FlexEvent):void
        {
            this.iconView = new AchievementIconView(this.achievementViewComponent.iconBox);
            super.handleCreationComplete(_arg_1);
            this.setViewComponentDetails(this.achievementName, this.triggers);
            this.setViewComponentWidth();
        }

        private function removeListeners():void
        {
            this.achievementViewComponent.backgroundCanvas.removeEventListener(MouseEvent.CLICK, this.handleExpandCollapse);
            this.achievementViewComponent.pointsCanvas.removeEventListener(MouseEvent.CLICK, this.handleExpandCollapse);
            this.achievementViewComponent.collapseFade.removeEventListener(EffectEvent.EFFECT_END, this.handleCollapseFadeEnd);
            this.achievementViewComponent.expandResize.removeEventListener(EffectEvent.EFFECT_END, this.handleCollapseExpandResizeEnd);
            this.achievementViewComponent.collapseResize.removeEventListener(EffectEvent.EFFECT_END, this.handleCollapseExpandResizeEnd);
            this.achievementViewComponent.fbPostButton.removeEventListener(MouseEvent.CLICK, this.handleFacebookPost);
        }

        private function setTriggerBoxState():void
        {
            var _local_1:AchievementCheckBoxTriggerView;
            var _local_2:AchievementProgressTriggerView;
            this.achievementViewComponent.triggerBox.visible = this.expanded;
            this.achievementViewComponent.triggerBox.includeInLayout = this.expanded;
            this.achievementViewComponent.triggerBox.mouseEnabled = true;
            this.achievementViewComponent.triggerBox.mouseChildren = true;
            if (((this.expanded) && (!(this.triggerViewComponentsMouseEnabled))))
            {
                for each (_local_1 in this.allocatedCheckTriggerViews)
                {
                    UIComponentHelpers.enableMouseInteraction(_local_1.getViewComponent(), false);
                };
                for each (_local_2 in this.allocatedProgressTriggerViews)
                {
                    UIComponentHelpers.enableMouseInteraction(_local_2.getViewComponent(), false);
                };
                UIComponentHelpers.enableMouseInteraction(this.achievementViewComponent.triggerBox, false);
                this.triggerViewComponentsMouseEnabled = true;
            };
        }

        public function forceExpand():void
        {
            this.expanded = false;
            this.handleExpandCollapse(null);
        }

        override public function dispose():void
        {
            super.dispose();
            this.removeListeners();
            this.releaseAllocatedObjects(this.allocatedCheckTriggerViews, AchievementConsts.TRIGGER_TYPE_CHECKBOX);
            this.allocatedCheckTriggerViews = null;
            this.releaseAllocatedObjects(this.allocatedProgressTriggerViews, AchievementConsts.TRIGGER_TYPE_PROGRESS);
            this.allocatedProgressTriggerViews = null;
            this.achievementName = null;
            this.achievementDetailVO = null;
            this.triggerPoolDictionary = null;
            this.achievementViewComponent = null;
            this.triggers = null;
            this.achievementViewComponent = null;
        }

        private function handleFacebookPostCloseHandler(_arg_1:CloseEvent):void
        {
            var _local_2:int;
            var _local_3:AchievementCategoriesVO;
            if (_arg_1.detail == Alert.YES)
            {
                _local_2 = AchievementsManager.getInstance().getAchievementCategoryById(this.achievementId).getCategoryParentID();
                _local_3 = AchievementsManager.getInstance().getAchievementCategoryByCategoryId(_local_2);
                while (_local_3.getCategoryUseParentOnFacebookPost())
                {
                    _local_3 = AchievementsManager.getInstance().getAchievementCategoryByCategoryId(_local_3.getCategoryParentID());
                };
                ShareManager.getInstance().post(this.achievementViewComponent.nameLabel.text, _local_3.getCategoryName(), this.points, this.iconView.getIconName());
                globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.ACHIEVEMENT_FACEBOOK_SENT);
                global.ui.mClientMessages.sendClientUITrack(this.achievementName, defines.TRACK_FACEBOOK_ACHIEVEMENT, 0);
            };
        }

        private function initSequences():void
        {
            var _local_1:int = (ACHIEVEMENT_REWARD_BOX_HEIGHT + ACHIEVEMENT_REWARD_BOX_HEIGHT_NEGATIVE_OFFSET);
            this.expandedHeight = ((this.achievementViewComponent.backgroundCanvas.x + this.achievementViewComponent.backgroundCanvas.height) + this.triggerBoxHeight);
            this.expandedHeight = (this.expandedHeight + ((this.rewardBoxVisible) ? _local_1 : 0));
            this.achievementViewComponent.expandResize.heightTo = this.expandedHeight;
            this.collapsedHeight = (this.achievementViewComponent.backgroundCanvas.x + this.achievementViewComponent.backgroundCanvas.height);
            this.collapsedHeight = (this.collapsedHeight + ((this.rewardBoxVisible) ? _local_1 : 0));
            this.achievementViewComponent.collapseResize.heightTo = this.collapsedHeight;
            this.currentHeight = ((this.expanded) ? this.expandedHeight : this.collapsedHeight);
            this.achievementViewComponent.height = this.currentHeight;
        }

        private function addListeners():void
        {
            if (this.expandable)
            {
                this.achievementViewComponent.backgroundCanvas.addEventListener(MouseEvent.CLICK, this.handleExpandCollapse, false, 0, true);
                this.achievementViewComponent.pointsCanvas.addEventListener(MouseEvent.CLICK, this.handleExpandCollapse, false, 0, true);
                this.achievementViewComponent.collapseFade.addEventListener(EffectEvent.EFFECT_END, this.handleCollapseFadeEnd, false, 0, true);
                this.achievementViewComponent.expandResize.addEventListener(EffectEvent.EFFECT_END, this.handleCollapseExpandResizeEnd, false, 0, true);
                this.achievementViewComponent.collapseResize.addEventListener(EffectEvent.EFFECT_END, this.handleCollapseExpandResizeEnd, false, 0, true);
            };
            this.achievementViewComponent.fbPostButton.addEventListener(MouseEvent.CLICK, this.handleFacebookPost);
        }

        public function getCollapsedHeight():Number
        {
            return (this.collapsedHeight);
        }

        private function handleExpandCollapse(_arg_1:MouseEvent):void
        {
            if (((this.expanding) || (!(this.expandable))))
            {
                return;
            };
            this.expanding = true;
            this.expanded = (!(this.expanded));
            this.currentHeight = ((this.expanded) ? this.expandedHeight : this.collapsedHeight);
            var _local_2:Sequence = ((this.expanded) ? this.achievementViewComponent.expand : this.achievementViewComponent.collapse);
            _local_2.play();
        }

        override public function updateDetails(... _args):void
        {
            this.achievementFinished = _args[0];
            this.points = _args[1];
            this.triggers = _args[2];
            if (!initialized)
            {
                return;
            };
            this.updateViewComponentDetails(this.triggers);
        }

        public function getExpandedHeight():Number
        {
            return (this.expandedHeight);
        }

        private function updateComponents():void
        {
            var achievementFinishedBoolean:Boolean = (this.achievementFinished == 1);
            var iconBackground:String = ((achievementFinishedBoolean) ? AchievementConsts.ACHIEVEMENT_ICON_BACKGROUND_FINISHED : AchievementConsts.ACHIEVEMENT_ICON_BACKGROUND_NORMAL);
            var background:String = ((this.currentPlayer) ? AchievementConsts.CURRENT_USER_ACHIEVEMENT_BACKGROUND : AchievementConsts.COMPARED_USER_ACHIEVEMENT_BACKGROUND);
            var pointsBackground:String = ((achievementFinishedBoolean) ? AchievementConsts.ACHIEVEMENT_POINTS_BACKGROUND_FINISHED : AchievementConsts.ACHIEVEMENT_POINTS_BACKGROUND_NORMAL);
            this.achievementViewComponent.pointsLabel.text = this.points.toString();
            this.achievementViewComponent.pointsLabel.setStyle("fontSize", ((this.points >= 10000) ? 14 : 20));
            this.achievementViewComponent.fbPostButton.visible = ((((AchievementConsts.FACEBOOK_POST_ENABLED) && (achievementFinishedBoolean)) && (this.currentPlayer)) && ((global.partner == "") || (!((global.partnerSettings[global.partner] as dPartnerSettingsVO).hideShareAchievement))));
            this.achievementViewComponent.fbPostButton.addEventListener(MouseEvent.ROLL_OVER, function (_arg_1:Event):void
            {
                achievementViewComponent.fbPostButton.filters = [GLOW];
            });
            this.achievementViewComponent.fbPostButton.addEventListener(MouseEvent.ROLL_OUT, function (_arg_1:Event):void
            {
                achievementViewComponent.fbPostButton.filters = null;
            });
            this.iconView.updateAchievementFinished(achievementFinishedBoolean);
            this.achievementViewComponent.iconBox.setStyle(UIComponentHelpers.BACKGROUND_IMAGE, gAssetManager.GetClass(iconBackground));
            this.achievementViewComponent.bkCanvas.setStyle(UIComponentHelpers.BACKGROUND_IMAGE, gAssetManager.GetClass(background));
            this.achievementViewComponent.pointsCanvas.setStyle(UIComponentHelpers.BACKGROUND_IMAGE, gAssetManager.GetClass(pointsBackground));
            this.updateDescription();
        }

        private function updateViewComponentDetails(_arg_1:Vector.<UserAchievementTriggerWrapper>):void
        {
            var _local_2:UserAchievementTriggerWrapper;
            var _local_3:AchievementCheckBoxTriggerView;
            var _local_4:AchievementProgressTriggerView;
            var _local_5:int;
            var _local_6:int;
            this.updateComponents();
            for each (_local_2 in _arg_1)
            {
                switch (_local_2.getType())
                {
                    case AchievementConsts.TRIGGER_TYPE_CHECKBOX:
                        _local_3 = this.allocatedCheckTriggerViews[_local_6];
                        _local_3.init(_local_2);
                        _local_6++;
                        break;
                    case AchievementConsts.TRIGGER_TYPE_PROGRESS:
                        _local_4 = this.allocatedProgressTriggerViews[_local_5];
                        _local_4.init(_local_2);
                        _local_5++;
                        break;
                };
            };
        }

        override protected function createViewComponent():DisplayObject
        {
            this.achievementViewComponent = new AchievementDetailViewComponent();
            return (this.achievementViewComponent);
        }

        override protected function handleSetNullParent():void
        {
            this.releaseAllocatedObjects(this.allocatedCheckTriggerViews, AchievementConsts.TRIGGER_TYPE_CHECKBOX);
            this.allocatedCheckTriggerViews = [];
            this.releaseAllocatedObjects(this.allocatedProgressTriggerViews, AchievementConsts.TRIGGER_TYPE_PROGRESS);
            this.allocatedProgressTriggerViews = [];
            if (this.iconView)
            {
                this.iconView.dispose();
            };
            this.achievementViewComponent.triggerBox.removeAllChildren();
            this.achievementViewComponent.rewardBox.removeAllChildren();
            this.triggerViewComponentsMouseEnabled = false;
            if (this.achievementViewComponent.expand.isPlaying)
            {
                this.achievementViewComponent.expand.stop();
            };
            if (this.achievementViewComponent.collapse.isPlaying)
            {
                this.achievementViewComponent.collapse.stop();
            };
            this.expanding = false;
            this.expanded = false;
        }

        private function setViewComponentDetails(_arg_1:String, _arg_2:Vector.<UserAchievementTriggerWrapper>):void
        {
            var _local_3:UserAchievementTriggerWrapper;
            var _local_4:ObjectPool;
            var _local_5:Object;
            var _local_6:Array;
            this.achievementViewComponent.nameLabel.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.ACHIEVEMENT_LABELS, _arg_1);
            this.achievementViewComponent.descriptionLabel.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.ACHIEVEMENT_DESCRIPTIONS, _arg_1);
            this.achievementViewComponent.fbPostButton.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, AchievementConsts.SHARE_ACHIEVEMENT);
            if (this.achievementDetailVO != null)
            {
                this.iconView.init(this.achievementDetailVO, (this.achievementFinished == 1));
            };
            this.updateComponents();
            for each (_local_3 in _arg_2)
            {
                _local_4 = this.triggerPoolDictionary[_local_3.getType()];
                gMisc.Assert((!(_local_4 == null)), (("Unknown trigger type[" + _local_3.getType()) + "]"));
                _local_5 = _local_4.getObject();
                _local_5.init(_local_3);
                _local_5.setWidth(this.componentWidth);
                _local_6 = ((_local_3.getType() == AchievementConsts.TRIGGER_TYPE_CHECKBOX) ? this.allocatedCheckTriggerViews : this.allocatedProgressTriggerViews);
                _local_6.push(_local_5);
            };
            this.addViews();
        }

        private function addViews():void
        {
            var _local_1:AchievementCheckBoxTriggerView;
            var _local_2:AchievementProgressTriggerView;
            var _local_4:HBox;
            var _local_5:int;
            var _local_3:int = 1;
            var _local_6:int;
            var _local_7:int = this.allocatedCheckTriggerViews.length;
            var _local_8:int = UIComponentHelpers.getStyleAsInt(this.achievementViewComponent.triggerBox, UIComponentHelpers.VERTICAL_GAP);
            var _local_9:AchievementVO = AchievementsManager.getInstance().getAchievementById(this.achievementId);
            this.triggerBoxHeight = UIComponentHelpers.getStyleAsInt(this.achievementViewComponent.triggerBox, UIComponentHelpers.BOTTOM);
            this.triggerBoxHeight = (this.triggerBoxHeight + UIComponentHelpers.getStyleAsInt(this.achievementViewComponent.triggerBox, UIComponentHelpers.TOP));
            for each (_local_2 in this.allocatedProgressTriggerViews)
            {
                this.achievementViewComponent.triggerBox.addChild(_local_2.getViewComponent());
                this.triggerBoxHeight = (this.triggerBoxHeight + (TRIGGER_PROGRESS_VIEW_COMPONENT_HEIGHT + _local_8));
            };
            while (_local_6 < _local_7)
            {
                _local_1 = this.allocatedCheckTriggerViews[_local_6];
                if ((_local_6 % _local_3) == 0)
                {
                    _local_4 = new HBox();
                    _local_4.setStyle(UIComponentHelpers.HORIZONTAL_GAP, TRIGGER_BOX_HORIZONTAL_GAP);
                    this.achievementViewComponent.triggerBox.addChild(_local_4);
                    this.triggerBoxHeight = (this.triggerBoxHeight + (TRIGGER_CHECK_BOX_VIEW_COMPONENT_HEIGHT + _local_8));
                };
                _local_4.addChild(_local_1.getViewComponent());
                _local_6++;
            };
            _local_5 = UIComponentHelpers.getStyleAsInt(this.achievementViewComponent.triggerBox, UIComponentHelpers.VERTICAL_GAP);
            this.triggerBoxHeight = (this.triggerBoxHeight + (_local_5 * ((_local_7 + this.allocatedProgressTriggerViews.length) - 1)));
            this.rewardBoxVisible = ((_local_9.getRewards().length > 0) && (this.expandable));
            this.initBoxes();
            this.setTriggerBoxState();
            if (this.rewardBoxVisible)
            {
                this.setRewardBox();
            };
            this.initSequences();
            this.addListeners();
        }

        private function handleFacebookPost(_arg_1:MouseEvent):void
        {
            _arg_1.stopImmediatePropagation();
            if (AchievementConsts.FACEBOOK_POST_ENABLED)
            {
                CustomAlert.show("FacebookPostAchievement", "FacebookPostAchievement", (Alert.YES | Alert.NO), null, this.handleFacebookPostCloseHandler);
            };
        }

        private function setViewComponentWidth():void
        {
            var _local_1:int;
            var _local_2:AchievementProgressTriggerView;
            this.achievementViewComponent.width = this.componentWidth;
            _local_1 = int(((this.achievementViewComponent.width - UIComponentHelpers.getLeftValue(this.achievementViewComponent.backgroundCanvas)) - (this.achievementViewComponent.pointsCanvas.width / 2)));
            this.achievementViewComponent.backgroundCanvas.width = _local_1;
            _local_1 = int((((this.achievementViewComponent.backgroundCanvas.width - UIComponentHelpers.getLeftValue(this.achievementViewComponent.nameLabel)) - (this.achievementViewComponent.pointsCanvas.width / 2)) - ACHIEVEMENT_NAME_LABEL_PADDING));
            this.achievementViewComponent.nameLabel.width = _local_1;
            this.achievementViewComponent.descriptionLabel.width = _local_1;
            this.updateDescription();
            for each (_local_2 in this.allocatedProgressTriggerViews)
            {
                _local_2.setWidth(this.componentWidth);
            };
        }

        private function handleCollapseExpandResizeEnd(_arg_1:EffectEvent):void
        {
            this.expanding = false;
            if (this.expanded)
            {
                this.achievementViewComponent.triggerBox.alpha = 0;
                this.setTriggerBoxState();
            };
        }

        private function enableMouseInteraction():void
        {
            if (this.expandable)
            {
                UIComponentHelpers.enableMouseInteractionForListWithStopAtFirstParentOption(false, this.achievementViewComponent.backgroundCanvas, this.achievementViewComponent.pointsCanvas);
            };
            UIComponentHelpers.enableMouseInteractionForListWithStopAtFirstParentOption(false, this.achievementViewComponent.nameLabel, this.achievementViewComponent.descriptionLabel);
            UIComponentHelpers.enableMouseInteraction(this.achievementViewComponent.fbPostButton, false);
            UIComponentHelpers.enableMouseInteraction(this.achievementViewComponent.triggerBox, false);
        }

        private function setRewardBox():void
        {
            var _local_2:IAchievementRewardView;
            this.achievementViewComponent.rewardBox.removeAllChildren();
            var _local_1:Vector.<IAchievementRewardView> = AchievementsManager.getInstance().getAchievementById(this.achievementId).getRewardViews();
            for each (_local_2 in _local_1)
            {
                this.achievementViewComponent.rewardBox.addChild(_local_2.getViewComponent());
            };
        }

        private function updateDescription():void
        {
            var _local_1:TextLineMetrics;
            var _local_2:int;
            var _local_5:int;
            var _local_3:int = int((((this.achievementViewComponent.backgroundCanvas.width - UIComponentHelpers.getLeftValue(this.achievementViewComponent.nameLabel)) - (this.achievementViewComponent.pointsCanvas.width / 2)) - ACHIEVEMENT_NAME_LABEL_PADDING));
            var _local_4:String = cLocaManager.GetInstance().GetText(LOCA_GROUP.ACHIEVEMENT_DESCRIPTIONS, this.achievementName);
            _local_3 = (_local_3 - (((this.currentPlayer) && (this.achievementFinished == 1)) ? ACHIEVEMENT_DESCRIPTION_OFFSET : 0));
            this.achievementViewComponent.nameLabel.width = _local_3;
            this.achievementViewComponent.nameLabel.toolTip = _local_4;
            if (this.viewMode == AchievementConsts.NORMAL_MODE)
            {
                this.achievementViewComponent.descriptionLabel.width = _local_3;
                this.achievementViewComponent.descriptionLabel.height = ACHIEVEMENT_DESCRIPTION_TEXT_HEIGHT;
                _local_1 = this.achievementViewComponent.descriptionLabel.measureText(_local_4);
                _local_2 = int(Math.floor((this.achievementViewComponent.descriptionLabel.height / _local_1.height)));
                if (_local_1.width > ((this.achievementViewComponent.descriptionLabel.width * _local_2) - ACHIEVEMENT_DESCRIPTION_TEXT_OFFSET))
                {
                    _local_5 = int(((((this.achievementViewComponent.descriptionLabel.width * _local_2) / _local_1.width) * _local_4.length) - ACHIEVEMENT_DESCRIPTION_TEXT_OFFSET));
                    this.achievementViewComponent.descriptionLabel.text = StringUtils.truncateText(_local_4, _local_5);
                    this.achievementViewComponent.descriptionLabel.toolTip = _local_4;
                }
                else
                {
                    this.achievementViewComponent.descriptionLabel.text = _local_4;
                    this.achievementViewComponent.descriptionLabel.toolTip = null;
                };
            }
            else
            {
                if (this.viewMode == AchievementConsts.COMPARE_MODE)
                {
                    this.achievementViewComponent.descriptionLabel.height = 0;
                    this.achievementViewComponent.nameLabel.height = this.achievementViewComponent.height;
                    this.achievementViewComponent.nameLabel.toolTip = _local_4;
                    this.achievementViewComponent.descriptionLabel.text = null;
                };
            };
        }

        public function setTriggerPoolDictionary(_arg_1:Dictionary):void
        {
            this.triggerPoolDictionary = _arg_1;
        }

        override public function populateDetails(... _args):void
        {
            this.achievementId = _args[0];
            this.achievementName = _args[1];
            this.achievementDetailVO = _args[2];
            this.achievementFinished = _args[3];
            this.points = _args[4];
            this.triggers = _args[5];
            this.expanded = ((_args[6]) ? false : this.expanded);
            this.expandable = ((_args.length > 7) ? _args[7] : true);
            this.currentPlayer = ((_args.length > 8) ? _args[8] : true);
            this.viewMode = ((_args.length > 9) ? _args[9] : AchievementConsts.NORMAL_MODE);
            this.triggerViewComponentsMouseEnabled = false;
            if (!initialized)
            {
                return;
            };
            this.setViewComponentDetails(this.achievementName, this.triggers);
        }


    }
}
