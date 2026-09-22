package GUI.achievement.view.detail
{
    import GUI.Components.achievement.detail.SubcategoryDetailViewComponent;
    import GUI.helpers.UIComponentHelpers;
    import mx.events.FlexEvent;
    import Achievements.AchievementsManager;
    import GUI.Assets.gAssetManager;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import flash.events.MouseEvent;
    import GUI.ApplicationFacade;
    import Achievements.AchievementConsts;
    import flash.display.DisplayObject;

    public class SubcategoryDetailView extends AbstractDetailSubView 
    {

        public static const VIEW_COMPONENT_WIDTH:int = 270;
        public static const VIEW_COMPONENT_HEIGHT:int = 77;

        private const VIEW_COMPONENT_HIDE_PROGRESS_STATE:String = "hideProgress";
        private const VIEW_COMPONENT_EVENT_STATE_SUFFIX:String = "_event";
        private const CATEGORY_COUNT_PATTERN:String = "{childrenCount}";
        private const VIEW_COMPONENT_SHOW_PROGRESS_STATE:String = "showProgress";
        private const CATEGORIES_FINISHED_PATTERN:String = "{childrenFinished}";
        private const PROGRESS_REPLACE_PATTERN:String = "{progress}";

        private var categoriesCount:int;
        private var hideProgress:Boolean;
        private var hasSubcategories:Boolean;
        private var points:int;
        private var categoryName:String;
        private var categoriesFinished:int;
        private var progress:Number;
        private var categoryId:int;
        private var subcategoryViewComponent:SubcategoryDetailViewComponent;


        override public function updateDetails(... _args):void
        {
            this.categoriesFinished = _args[0];
            this.categoriesCount = _args[1];
            this.progress = _args[2];
            this.points = _args[3];
            if (!initialized)
            {
                return;
            };
            this.updateViewComponentDetails(this.categoriesFinished, this.categoriesCount, this.progress, this.points);
        }

        private function updateViewComponentDetails(_arg_1:int, _arg_2:int, _arg_3:Number, _arg_4:int):void
        {
            this.computeCategoryProgress(_arg_1, _arg_2, _arg_3);
            this.subcategoryViewComponent.pointsLabel.text = _arg_4.toString();
            this.subcategoryViewComponent.pointsLabel.setStyle("fontSize", ((_arg_4 >= 10000) ? 14 : 20));
        }

        private function enableMouseInteraction():void
        {
            UIComponentHelpers.enableMouseInteraction(this.subcategoryViewComponent.categoryNameLabel, false);
        }

        override protected function handleSetActiveParent():void
        {
            this.enableMouseInteraction();
        }

        override protected function handleCreationComplete(_arg_1:FlexEvent):void
        {
            super.handleCreationComplete(_arg_1);
            this.setViewComponentDetails(this.categoryName, this.categoriesFinished, this.categoriesCount, this.progress, this.hideProgress, this.points);
        }

        private function setViewComponentDetails(_arg_1:String, _arg_2:int, _arg_3:int, _arg_4:Number, _arg_5:Boolean, _arg_6:int):void
        {
            var _local_7:String = AchievementsManager.getInstance().getCategoryGUIDetailVO(this.categoryId).getSubcategoryIcon();
            var _local_8:String = ((_arg_5) ? this.VIEW_COMPONENT_HIDE_PROGRESS_STATE : this.VIEW_COMPONENT_SHOW_PROGRESS_STATE);
            this.subcategoryViewComponent.categoryImage.visible = false;
            if (((!(_local_7 == null)) && (_local_7.length > 0)))
            {
                this.subcategoryViewComponent.categoryImage.source = gAssetManager.GetAchievementUrl(_local_7);
                this.subcategoryViewComponent.categoryImage.visible = true;
                _local_8 = (_local_8 + this.VIEW_COMPONENT_EVENT_STATE_SUFFIX);
            };
            this.subcategoryViewComponent.categoryNameLabel.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.ACHIEVEMENT_LABELS, _arg_1);
            this.subcategoryViewComponent.setCurrentState(_local_8);
            this.updateViewComponentDetails(_arg_2, _arg_3, _arg_4, _arg_6);
            this.subcategoryViewComponent.addEventListener(MouseEvent.CLICK, this.handleMouseClick);
        }

        private function handleMouseClick(_arg_1:MouseEvent):void
        {
            ApplicationFacade.getInstance().sendNotification(((this.hasSubcategories) ? AchievementConsts.CATEGORY_CONTAINER_SELECTED : AchievementConsts.ACHIEVEMENT_CATEGORY_SELECTED), this.categoryId);
        }

        private function computeProgressBar(_arg_1:Number):void
        {
            this.subcategoryViewComponent.progressBarMask.x = this.subcategoryViewComponent.progressBar.x;
            this.subcategoryViewComponent.progressBarMask.y = this.subcategoryViewComponent.progressBar.y;
            this.subcategoryViewComponent.progressBarMask.height = this.subcategoryViewComponent.progressBar.height;
            this.subcategoryViewComponent.progressBarMask.width = (this.subcategoryViewComponent.progressBar.width * _arg_1);
        }

        private function computeCategoryProgress(_arg_1:int, _arg_2:int, _arg_3:Number):void
        {
            var _local_4:int = Math.round((_arg_3 * 100));
            var _local_5:String = AchievementConsts.CATEGORY_PROGRESS_TEXT_FORMAT;
            this.computeProgressBar(_arg_3);
            _local_5 = _local_5.replace(this.CATEGORIES_FINISHED_PATTERN, _arg_1);
            _local_5 = _local_5.replace(this.CATEGORY_COUNT_PATTERN, _arg_2);
            _local_5 = _local_5.replace(this.PROGRESS_REPLACE_PATTERN, _local_4);
            this.subcategoryViewComponent.categoryProgressLabel.text = _local_5;
        }

        override public function populateDetails(... _args):void
        {
            this.categoryName = _args[0];
            this.categoriesFinished = _args[1];
            this.categoriesCount = _args[2];
            this.progress = _args[3];
            this.points = _args[4];
            this.categoryId = _args[5];
            this.hasSubcategories = _args[6];
            this.hideProgress = _args[7];
            if (!initialized)
            {
                return;
            };
            this.setViewComponentDetails(this.categoryName, this.categoriesFinished, this.categoriesCount, this.progress, this.hideProgress, this.points);
        }

        override protected function createViewComponent():DisplayObject
        {
            this.subcategoryViewComponent = new SubcategoryDetailViewComponent();
            return (this.subcategoryViewComponent);
        }


    }
}
