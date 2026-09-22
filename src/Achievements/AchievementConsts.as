package Achievements
{
    public class AchievementConsts 
    {

        public static const FACEBOOK_POST_ENABLED:Boolean = true;
        public static const ACHIEVEMENT_PANEL_MEDIATOR_NAME:String = "achievementPanelMediator";
        public static const ACHIEVEMENT_PANEL_CATEGORY_LIST_MEDIATOR_NAME:String = "achievementPanelCategoryListMediator";
        public static const ACHIEVEMENT_PANEL_CATEGORY_CONTAINER_MEDIATOR_NAME:String = "achievementPanelCategoryContainerMediator";
        public static const ACHIEVEMENT_PANEL_ACHIEVEMENT_CATEGORY_MEDIATOR_NAME:String = "achievementPanelAchievementCategoryMediator";
        public static const SHOW_HIDE_ACHIEVEMENT_PANEL:String = "showHideAchievementPanel";
        public static const CATEGORY_CONTAINER_SELECTED:String = "categoryContainerSelected";
        public static const ACHIEVEMENT_CATEGORY_SELECTED:String = "achievementCategorySelected";
        public static const USER_ACHIEVEMENT_TREE_UPDATED:String = "userAchievementTreeUpdated";
        public static const UPDATE_LIST_HEIGHT:String = "updateListHeight";
        public static const COMPARED_TREE_RECEIVED:String = "comparedTreeReceived";
        public static const SHOW_ACHIEVEMENT:String = "showAchievement";
        public static const EVENT_CHANGED:String = "eventChanged";
        public static const NORMAL_MODE:String = "normalMode";
        public static const COMPARE_MODE:String = "compareMode";
        public static const DETAIL_VIEW_TYPE_CATEGORY_CONTAINER:String = "detailViewCategoryContainer";
        public static const DETAIL_VIEW_TYPE_ACHIEVEMENT_CATEGORY:String = "detailViewAchievementCategory";
        public static const ACHIEVEMENT_PANEL_HEIGHT:int = 500;
        public static const ACHIEVEMENT_PANEL_WIDTH:int = 900;
        public static const CATEGORY_PROGRESS_TEXT_FORMAT:String = "{childrenFinished}/{childrenCount} ({progress}%)";
        public static const ACHIEVEMENT_LABEL_ID:String = "Achievements";
        public static const ROOT_CATEGORY_NAME:String = "Overview";
        public static const CLOSE_ACHIEVEMENT_PANEL_LABEL_ID:String = "CloseAchievementPanel";
        public static const SHARE_ACHIEVEMENT:String = "ShareAchievement";
        public static const ACHIEVEMENT_REWARD_ID:String = "Reward";
        public static const TRIGGER_TYPE_PROGRESS:String = "progress";
        public static const TRIGGER_TYPE_CHECKBOX:String = "checkbox";
        public static const CURRENT_USER_ACHIEVEMENT_BACKGROUND:String = "AchievementCurrentUserBackground";
        public static const COMPARED_USER_ACHIEVEMENT_BACKGROUND:String = "AchievementComparedUserBackground";
        public static const ACHIEVEMENT_ICON_BACKGROUND_NORMAL:String = "AchievementIconNormalBackground";
        public static const ACHIEVEMENT_ICON_BACKGROUND_FINISHED:String = "AchievementIconFinishedBackground";
        public static const ACHIEVEMENT_POINTS_BACKGROUND_NORMAL:String = "AchievementCategoryRing";
        public static const ACHIEVEMENT_POINTS_BACKGROUND_FINISHED:String = "AchievementCategoryRingFinished";
        public static const ACHIEVEMENT_REWARD_BACKGROUND:String = "AchievementRewardBoxBackground";
        public static const HELP_DEFINITION_NAME:String = "Help_window_achievements_0";
        public static const COMPARED_USER_ACHIEVEMENTS_REFRESH_TIME_MILLIS:Number = 30000;

        public function AchievementConsts()
        {
            super();
            throw (new Error("Do not instanciate this, just use the consts!"));
        }

    }
}
