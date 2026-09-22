package GUI.achievement.view.detail
{
    import Utils.Disposable;
    import GUI.Components.achievement.detail.DetailHeaderCategoryViewComponent;
    import GUI.Components.achievement.detail.DetailHeaderPlayerViewComponent;
    import GUI.Components.achievement.detail.CategoryDetailHeaderViewComponent;
    import flash.display.DisplayObjectContainer;
    import mx.events.FlexEvent;
    import GUI.helpers.UIComponentHelpers;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import Achievements.AchievementsManager;
    import GUI.achievement.vo.CategoryGUIDetailVO;
    import GUI.Assets.gAssetManager;
    import Enums.AVATAR_SIZE;
    import Achievements.AchievementConsts;

    public class CategoryDetailHeaderView implements Disposable 
    {

        public static const DETAIL_CATEGORY_VIEW_WIDTH:int = 489;
        public static const DETAIL_CATEGORY_VIEW_BACKGROUND_WIDTH_OFFSET:int = 46;

        private const VIEW_COMPONENT_HIDE_PROGRESS_STATE:String = "hideProgress";
        private const CATEGORY_COUNT_PATTERN:String = "{childrenCount}";
        private const VIEW_COMPONENT_SHOW_PROGRESS_STATE:String = "showProgress";
        private const CATEGORIES_FINISHED_PATTERN:String = "{childrenFinished}";
        private const PROGRESS_REPLACE_PATTERN:String = "{progress}";

        private var componentWidth:int;
        private var categoryViewSubComponent:DetailHeaderCategoryViewComponent;
        private var playerViewSubComponent:DetailHeaderPlayerViewComponent;
        private var viewComponent:CategoryDetailHeaderViewComponent;
        private var parentContainer:DisplayObjectContainer;

        public function CategoryDetailHeaderView(_arg_1:DisplayObjectContainer)
        {
            super();
            this.parentContainer = _arg_1;
            this.viewComponent = new CategoryDetailHeaderViewComponent();
            this.viewComponent.visible = false;
            this.viewComponent.addEventListener(FlexEvent.CREATION_COMPLETE, this.handleCreationComplete, false, 0, true);
            _arg_1.addChild(this.viewComponent);
        }

        public function hide():void
        {
            this.viewComponent.visible = false;
        }

        public function setWidth(_arg_1:int):void
        {
            if (this.componentWidth == _arg_1)
            {
                return;
            };
            this.componentWidth = _arg_1;
            this.categoryViewSubComponent.width = (this.componentWidth - UIComponentHelpers.getStyleAsInt(this.categoryViewSubComponent, UIComponentHelpers.LEFT));
            this.categoryViewSubComponent.background.width = (this.categoryViewSubComponent.width - DETAIL_CATEGORY_VIEW_BACKGROUND_WIDTH_OFFSET);
            this.categoryViewSubComponent.categoryNameLabel.maxWidth = (this.categoryViewSubComponent.background.width - (this.categoryViewSubComponent.pointsCanvas.width / 2));
        }

        public function populateHeaderCategoryDetails(_arg_1:String, _arg_2:int, _arg_3:int, _arg_4:int, _arg_5:Number, _arg_6:Boolean, _arg_7:int):void
        {
            this.categoryViewSubComponent.categoryNameLabel.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.ACHIEVEMENT_LABELS, _arg_1);
            UIComponentHelpers.enableMouseInteraction(this.categoryViewSubComponent.categoryNameLabel);
            this.viewComponent.categoryViewComponent.setCurrentState(((_arg_6) ? this.VIEW_COMPONENT_HIDE_PROGRESS_STATE : this.VIEW_COMPONENT_SHOW_PROGRESS_STATE));
            var _local_8:CategoryGUIDetailVO = AchievementsManager.getInstance().getCategoryGUIDetailVO(_arg_2);
            this.categoryViewSubComponent.headerIcon.visible = false;
            if ((((!(_local_8 == null)) && (!(_local_8.getHeaderIcon() == null))) && (!(_local_8.getHeaderIcon() == ""))))
            {
                this.categoryViewSubComponent.headerIcon.source = gAssetManager.GetAchievementUrl(_local_8.getHeaderIcon());
                this.categoryViewSubComponent.headerIcon.visible = true;
            };
            this.updateHeaderCategoryDetails(_arg_3, _arg_4, _arg_5, _arg_7);
        }

        public function updateHeaderCategoryDetails(_arg_1:int, _arg_2:int, _arg_3:Number, _arg_4:int):void
        {
            this.computeCategoryProgress(_arg_1, _arg_2, _arg_3);
            this.categoryViewSubComponent.pointsLabel.text = _arg_4.toString();
        }

        public function dispose():void
        {
            if (this.viewComponent != null)
            {
                this.viewComponent.removeEventListener(FlexEvent.CREATION_COMPLETE, this.handleCreationComplete);
                if (this.viewComponent.parent)
                {
                    this.viewComponent.parent.removeChild(this.viewComponent);
                };
                this.viewComponent = null;
            };
            this.parentContainer = null;
            this.categoryViewSubComponent = null;
            this.playerViewSubComponent = null;
        }

        public function populateHeaderUserDetails(_arg_1:String, _arg_2:int):void
        {
            this.playerViewSubComponent.avatar.source = gAssetManager.GetAvatarUrl(_arg_2, AVATAR_SIZE.SMALL);
            this.playerViewSubComponent.playerName.text = _arg_1;
        }

        private function handleCreationComplete(_arg_1:FlexEvent):void
        {
            this.viewComponent.removeEventListener(FlexEvent.CREATION_COMPLETE, this.handleCreationComplete);
            UIComponentHelpers.removeMouseInteraction(this.viewComponent);
            this.categoryViewSubComponent = this.viewComponent.categoryViewComponent;
            this.playerViewSubComponent = this.viewComponent.playerViewComponent;
        }

        public function setXOffset(_arg_1:int):void
        {
            this.viewComponent.x = _arg_1;
        }

        private function computeProgressBar(_arg_1:Number):void
        {
            this.categoryViewSubComponent.progressBarMask.x = this.categoryViewSubComponent.progressBar.x;
            this.categoryViewSubComponent.progressBarMask.y = this.categoryViewSubComponent.progressBar.y;
            this.categoryViewSubComponent.progressBarMask.height = this.categoryViewSubComponent.progressBar.height;
            this.categoryViewSubComponent.progressBarMask.width = (this.categoryViewSubComponent.progressBar.width * _arg_1);
        }

        private function computeCategoryProgress(_arg_1:int, _arg_2:int, _arg_3:Number):void
        {
            var _local_4:int = Math.round((_arg_3 * 100));
            var _local_5:String = AchievementConsts.CATEGORY_PROGRESS_TEXT_FORMAT;
            this.computeProgressBar(_arg_3);
            _local_5 = _local_5.replace(this.CATEGORIES_FINISHED_PATTERN, _arg_1);
            _local_5 = _local_5.replace(this.CATEGORY_COUNT_PATTERN, _arg_2);
            _local_5 = _local_5.replace(this.PROGRESS_REPLACE_PATTERN, _local_4);
            this.categoryViewSubComponent.categoryProgressLabel.text = _local_5;
        }

        public function show():void
        {
            this.viewComponent.visible = true;
        }


    }
}
