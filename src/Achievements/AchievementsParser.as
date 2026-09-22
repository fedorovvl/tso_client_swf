package Achievements
{
    import __AS3__.vec.Vector;
    import Communication.VO.Achievements.AchievementCategoriesVO;
    import Communication.VO.Achievements.AchievementVO;
    import Achievements.rewards.AchievementRewardFactory;
    import flash.utils.Dictionary;
    import Utils.HashMapWrapper;
    import nLib.cXML;
    import GUI.achievement.vo.AchievementGUIDetailVO;
    import Communication.VO.Achievements.AchievementTriggerUIDetailVO;
    import GUI.achievement.vo.CategoryGUIDetailVO;
    import Communication.VO.TriggerVO;
    import Achievements.rewards.IAchievementReward;
    import Achievements.rewards.IAchievementRewardView;
    import nLib.gMisc;
    import __AS3__.vec.*;

    public class AchievementsParser 
    {

        private static const NAME_ELEMENT_ACHIEVEMENT_CATEGORIES:String = "categories";
        private static const NAME_ELEMENT_ACHIEVEMENT_REWARDS:String = "achievementRewards";
        private static const NAME_ELEMENT_ACHIEVEMENTS:String = "achievements";
        private static const NAME_ELEMENT_TRIGGER_UI_DETAILS:String = "triggerUIDetails";
        private static const NAME_ELEMENT_GUI:String = "GUI";
        private static const NAME_CATEGORY_ID:String = "id";
        private static const NAME_CATEGORY_NAME:String = "name";
        private static const NAME_CATEGORY_PARENT_ID:String = "parentId";
        private static const NAME_CATEGORY_IGNORE_PROGRESS:String = "ignoreProgress";
        private static const NAME_CATEGORY_HIDE_PROGRESS:String = "hideProgress";
        private static const NAME_CATEGORY_USE_PARENT_ON_FACEBOOK:String = "useParentOnFacebook";
        private static const NAME_ACHIEVEMENT_ID:String = "id";
        private static const NAME_DUPLICATE_OF:String = "duplicateOf";
        private static const NAME_ACHIEVEMENT_NAME:String = "name";
        private static const NAME_ACHIEVEMENT_CATEGORY_ID:String = "categoryId";
        private static const NAME_ACHIEVEMENT_POINTS:String = "points";
        private static const NAME_ACHIEVEMENT_VISIBLE:String = "visible";
        private static const NAME_ACHIEVEMENT_DISABLED:String = "disabled";
        private static const NAME_ACHIEVEMENT_REQUIRES_EVENT:String = "requiresEvent";
        private static const NAME_ACHIEVEMENT_REQUIRES_YEAR:String = "requiresYear";
        private static const NAME_ACHIEVEMENT_TRIGGER_SUBNODE:String = "triggers";
        private static const NAME_ACHIEVEMENT_REWARDS_SUBNODE:String = "rewards";
        private static const NAME_ACHIEVEMENT_MIN_PLAYER_LEVEL:String = "minPlayerLevel";
        private static const NAME_ACHIEVEMENT_MAX_PLAYER_LEVEL:String = "maxPlayerLevel";
        private static const NAME_REWARD_TYPE:String = "type";
        private static const NAME_REWARD_CLASS_NAME_VO:String = "voClass";
        private static const NAME_REWARD_CLASS_NAME_UI:String = "uiClass";
        private static const NAME_TRIGGER_UI_DETAIL_NAME:String = "name";
        private static const NAME_TRIGGER_UI_DETAIL_TYPE:String = "type";
        private static const NAME_TRIGGER_UI_DETAIL_PROGRESS:String = "progress";
        private static const NAME_GUI_CATEGORY_SUB_NODE_NAME:String = "categories";
        private static const NAME_GUI_CATEGORY_ID:String = "id";
        private static const NAME_GUI_CATEGORY_LIST_ICON:String = "listIcon";
        private static const NAME_GUI_CATEGORY_SUBCATEGORY_ICON:String = "subcategoryIcon";
        private static const NAME_GUI_CATEGORY_HEADER_ICON:String = "headerIcon";
        private static const NAME_GUI_ACHIEVEMENT_SUB_NODE_NAME:String = "achievements";
        private static const NAME_GUI_ACHIEVEMENT_ID:String = "id";
        private static const NAME_GUI_ACHIEVEMENT_ICON:String = "icon";
        private static const NAME_GUI_ACHIEVEMENT_SMALL_ICON:String = "smallIcon";
        private static const NAME_GUI_ACHIEVEMENT_SMALL_ICON_RIGHT_OFFSET:String = "smallIconRightOffset";
        private static const NAME_GUI_ACHIEVEMENT_SMALL_ICON_BOTTOM_OFFSET:String = "smallIconBottomOffset";
        private static const NAME_GUI_ACHIEVEMENT_MAX_NUMBER_OF_AVATARS:String = "maxNumberOfAvatars";

        private var maxNumberOfAvatars:int;

        private var categoriesVector:Vector.<AchievementCategoriesVO> = new Vector.<AchievementCategoriesVO>();
        private var achievements_vector:Vector.<AchievementVO> = new Vector.<AchievementVO>();
        private var achievementRewardFactory:AchievementRewardFactory = new AchievementRewardFactory();
        private var achievementGUIHashMap:Dictionary = new Dictionary();
        private var categoryGUIHashMap:Dictionary = new Dictionary();
        private var achievementsIdMap:HashMapWrapper = new HashMapWrapper();
        private var achievementsDuplicationMap:HashMapWrapper = new HashMapWrapper();

        public function AchievementsParser(_arg_1:cXML)
        {
            super();
            this.parseXML(_arg_1);
        }

        private function parseGUI(_arg_1:cXML):void
        {
            this.maxNumberOfAvatars = _arg_1.GetAttributeInt(NAME_GUI_ACHIEVEMENT_MAX_NUMBER_OF_AVATARS);
            this.parseCategoryGUI(_arg_1.MoveToSubNode(NAME_GUI_CATEGORY_SUB_NODE_NAME));
            this.parseAchievementsGUI(_arg_1.MoveToSubNode(NAME_GUI_ACHIEVEMENT_SUB_NODE_NAME));
        }

        private function parseAchievementsGUI(_arg_1:cXML):void
        {
            var _local_3:int;
            var _local_4:String;
            var _local_5:String;
            var _local_6:int;
            var _local_7:int;
            var _local_8:cXML;
            var _local_9:int;
            var _local_10:int;
            var _local_11:AchievementGUIDetailVO;
            var _local_2:Vector.<cXML> = _arg_1.CreateChildrenArray();
            for each (_local_8 in _local_2)
            {
                _local_3 = _local_8.GetAttributeInt(NAME_GUI_ACHIEVEMENT_ID);
                _local_4 = _local_8.GetAttributeString_string(NAME_GUI_ACHIEVEMENT_ICON);
                _local_5 = _local_8.GetAttributeString_string(NAME_GUI_ACHIEVEMENT_SMALL_ICON);
                _local_6 = _local_8.GetAttributeInt(NAME_GUI_ACHIEVEMENT_SMALL_ICON_RIGHT_OFFSET);
                _local_7 = _local_8.GetAttributeInt(NAME_GUI_ACHIEVEMENT_SMALL_ICON_BOTTOM_OFFSET);
                this.achievementGUIHashMap[_local_3] = new AchievementGUIDetailVO(_local_4, _local_5, _local_6, _local_7);
            };
            for each (_local_9 in this.achievementsDuplicationMap.keySet())
            {
                _local_10 = (this.achievementsDuplicationMap.getItem(_local_9) as int);
                if (((!(_local_9 in this.achievementGUIHashMap)) && (_local_10 in this.achievementGUIHashMap)))
                {
                    _local_11 = (this.achievementGUIHashMap[_local_10] as AchievementGUIDetailVO);
                    this.achievementGUIHashMap[_local_9] = new AchievementGUIDetailVO(_local_11.getIcon(), _local_11.getSmallIcon(), _local_11.getIconRightOffset(), _local_11.getIconBottomOffset());
                };
            };
        }

        private function parseAchievementRewards(_arg_1:cXML):void
        {
            var _local_3:String;
            var _local_4:String;
            var _local_5:String;
            var _local_6:cXML;
            var _local_2:Vector.<cXML> = _arg_1.CreateChildrenArray();
            for each (_local_6 in _local_2)
            {
                _local_3 = _local_6.GetAttributeString_string(NAME_REWARD_TYPE);
                _local_4 = _local_6.GetAttributeString_string(NAME_REWARD_CLASS_NAME_VO);
                _local_5 = _local_6.GetAttributeString_string(NAME_REWARD_CLASS_NAME_UI);
                this.achievementRewardFactory.addReward(_local_3, _local_4, _local_5);
            };
        }

        public function buildAchievementsManager():AchievementsManager
        {
            var _local_1:AchievementsManager = new AchievementsManager(this.achievements_vector, this.categoriesVector);
            _local_1.setGUIDetails(this.achievementGUIHashMap, this.categoryGUIHashMap, this.maxNumberOfAvatars);
            return (_local_1);
        }

        private function parseXML(_arg_1:cXML):AchievementsParser
        {
            this.parseCategories(_arg_1.MoveToSubNode(NAME_ELEMENT_ACHIEVEMENT_CATEGORIES));
            this.parseAchievementRewards(_arg_1.MoveToSubNode(NAME_ELEMENT_ACHIEVEMENT_REWARDS));
            this.parseAchievements(_arg_1.MoveToSubNode(NAME_ELEMENT_ACHIEVEMENTS));
            this.parseTriggerUIDetails(_arg_1.MoveToSubNode(NAME_ELEMENT_TRIGGER_UI_DETAILS));
            this.parseGUI(_arg_1.MoveToSubNode(NAME_ELEMENT_GUI));
            return (this);
        }

        private function parseTriggerUIDetails(_arg_1:cXML):void
        {
            var _local_4:String;
            var _local_5:String;
            var _local_6:String;
            var _local_7:cXML;
            var _local_2:HashMapWrapper = new HashMapWrapper();
            var _local_3:Vector.<cXML> = _arg_1.CreateChildrenArray();
            for each (_local_7 in _local_3)
            {
                _local_4 = _local_7.GetAttributeString_string(NAME_TRIGGER_UI_DETAIL_NAME);
                _local_5 = _local_7.GetAttributeString_string(NAME_TRIGGER_UI_DETAIL_TYPE);
                _local_6 = _local_7.GetAttributeString_string(NAME_TRIGGER_UI_DETAIL_PROGRESS);
                _local_2.putItem(_local_4, new AchievementTriggerUIDetailVO(_local_4, _local_5, _local_6));
            };
            UserAchievementTriggerHelper.setTriggerHashmap(_local_2);
        }

        private function parseCategoryGUI(_arg_1:cXML):void
        {
            var _local_3:int;
            var _local_4:String;
            var _local_5:String;
            var _local_6:String;
            var _local_7:cXML;
            var _local_2:Vector.<cXML> = _arg_1.CreateChildrenArray();
            for each (_local_7 in _local_2)
            {
                _local_3 = _local_7.GetAttributeInt(NAME_GUI_CATEGORY_ID);
                _local_4 = _local_7.GetAttributeString_string(NAME_GUI_CATEGORY_LIST_ICON);
                _local_5 = _local_7.GetAttributeString_string(NAME_GUI_CATEGORY_SUBCATEGORY_ICON);
                _local_6 = _local_7.GetAttributeString_string(NAME_GUI_CATEGORY_HEADER_ICON);
                this.categoryGUIHashMap[_local_3] = new CategoryGUIDetailVO(_local_4, _local_5, _local_6);
            };
        }

        private function parseCategories(_arg_1:cXML):void
        {
            var _local_3:int;
            var _local_4:String;
            var _local_5:int;
            var _local_6:Boolean;
            var _local_7:Boolean;
            var _local_8:Boolean;
            var _local_9:cXML;
            var _local_2:Vector.<cXML> = _arg_1.CreateChildrenArray();
            for each (_local_9 in _local_2)
            {
                _local_3 = _local_9.GetAttributeInt(NAME_CATEGORY_ID);
                _local_4 = _local_9.GetAttributeString_string(NAME_CATEGORY_NAME);
                _local_5 = _local_9.GetAttributeInt(NAME_CATEGORY_PARENT_ID);
                _local_6 = _local_9.GetAttributeBool(NAME_CATEGORY_IGNORE_PROGRESS);
                _local_7 = _local_9.GetAttributeBool(NAME_CATEGORY_HIDE_PROGRESS);
                _local_8 = _local_9.GetAttributeBool(NAME_CATEGORY_USE_PARENT_ON_FACEBOOK);
                this.categoriesVector.push(new AchievementCategoriesVO(_local_3, _local_4, _local_5, _local_6, _local_7, _local_8));
            };
        }

        private function parseAchievements(_arg_1:cXML):void
        {
            var _local_3:int;
            var _local_4:int;
            var _local_5:String;
            var _local_6:int;
            var _local_7:int;
            var _local_8:Boolean;
            var _local_9:Boolean;
            var _local_10:String;
            var _local_11:int;
            var _local_12:int;
            var _local_13:int;
            var _local_14:cXML;
            var _local_15:TriggerVO;
            var _local_17:Vector.<cXML>;
            var _local_18:Vector.<cXML>;
            var _local_19:String;
            var _local_20:IAchievementReward;
            var _local_21:cXML;
            var _local_22:Vector.<TriggerVO>;
            var _local_23:Vector.<IAchievementReward>;
            var _local_24:Vector.<IAchievementRewardView>;
            var _local_25:AchievementVO;
            var _local_26:AchievementVO;
            var _local_27:cXML;
            var _local_28:cXML;
            var _local_2:Vector.<cXML> = _arg_1.CreateChildrenArray();
            var _local_16:int;
            for each (_local_21 in _local_2)
            {
                _local_22 = new Vector.<TriggerVO>();
                _local_23 = new Vector.<IAchievementReward>();
                _local_24 = new Vector.<IAchievementRewardView>();
                _local_3 = _local_21.GetAttributeInt(NAME_ACHIEVEMENT_ID);
                _local_4 = _local_21.GetAttributeInt(NAME_DUPLICATE_OF);
                if (_local_4 > 0)
                {
                    this.achievementsDuplicationMap.putItem(_local_3, _local_4);
                    _local_26 = (this.achievementsIdMap.getItem(_local_4) as AchievementVO);
                    if (_local_26 == null)
                    {
                        gMisc.Assert((_local_3 > _local_4), "Achievement to copy from requires lower ID");
                        gMisc.Assert(false, ("Can't find achievement with id " + _local_4));
                    };
                    _local_5 = _local_21.GetAttributeString_string(NAME_ACHIEVEMENT_NAME, _local_26.getAchievementName());
                    _local_6 = _local_21.GetAttributeInt(NAME_ACHIEVEMENT_CATEGORY_ID, _local_26.getCategoryID());
                    _local_7 = _local_21.GetAttributeInt(NAME_ACHIEVEMENT_POINTS, _local_26.getPoints());
                    _local_8 = _local_21.GetAttributeBool(NAME_ACHIEVEMENT_VISIBLE, _local_26.isVisible());
                    _local_9 = _local_21.GetAttributeBool(NAME_ACHIEVEMENT_DISABLED, _local_26.getDisabled());
                    _local_12 = _local_21.GetAttributeInt(NAME_ACHIEVEMENT_MIN_PLAYER_LEVEL, _local_26.getMinPlayerLevel());
                    _local_13 = _local_21.GetAttributeInt(NAME_ACHIEVEMENT_MAX_PLAYER_LEVEL, _local_26.getMaxPlayerLevel());
                    _local_10 = _local_21.GetAttributeString_string(NAME_ACHIEVEMENT_REQUIRES_EVENT, _local_26.getRequiresEvent());
                    _local_11 = _local_21.GetAttributeInt(NAME_ACHIEVEMENT_REQUIRES_YEAR, _local_26.getRequiresYear());
                    _local_17 = _local_21.MoveToSubNode(NAME_ACHIEVEMENT_TRIGGER_SUBNODE).CreateChildrenArray();
                    if (_local_17.length > 0)
                    {
                        _local_16 = 0;
                        for each (_local_14 in _local_17)
                        {
                            _local_15 = TriggerVO.createFromXML(_local_14, _local_16);
                            _local_22.push(_local_15);
                            _local_16++;
                        };
                    }
                    else
                    {
                        _local_22 = _local_26.getTriggers();
                    };
                    _local_18 = _local_21.MoveToSubNode(NAME_ACHIEVEMENT_REWARDS_SUBNODE).CreateChildrenArray();
                    if (_local_18.length > 0)
                    {
                        for each (_local_27 in _local_18)
                        {
                            _local_19 = _local_27.GetAttributeString_string(NAME_REWARD_TYPE);
                            _local_20 = this.achievementRewardFactory.getReward(_local_19, _local_27);
                            _local_23.push(_local_20);
                            _local_24.push(this.achievementRewardFactory.getUIRewardView(_local_19, _local_20));
                        };
                    }
                    else
                    {
                        _local_23 = _local_26.getRewards();
                        _local_24 = _local_26.getRewardViews();
                    };
                }
                else
                {
                    _local_5 = _local_21.GetAttributeString_string(NAME_ACHIEVEMENT_NAME);
                    _local_6 = _local_21.GetAttributeInt(NAME_ACHIEVEMENT_CATEGORY_ID);
                    _local_7 = _local_21.GetAttributeInt(NAME_ACHIEVEMENT_POINTS);
                    _local_8 = _local_21.GetAttributeBool(NAME_ACHIEVEMENT_VISIBLE, true);
                    _local_9 = _local_21.GetAttributeBool(NAME_ACHIEVEMENT_DISABLED);
                    _local_12 = _local_21.GetAttributeInt(NAME_ACHIEVEMENT_MIN_PLAYER_LEVEL);
                    _local_13 = _local_21.GetAttributeInt(NAME_ACHIEVEMENT_MAX_PLAYER_LEVEL, gMisc.GetMaxIntValue());
                    _local_10 = _local_21.GetAttributeString_string(NAME_ACHIEVEMENT_REQUIRES_EVENT);
                    _local_11 = _local_21.GetAttributeInt(NAME_ACHIEVEMENT_REQUIRES_YEAR, -1);
                    _local_17 = _local_21.MoveToSubNode(NAME_ACHIEVEMENT_TRIGGER_SUBNODE).CreateChildrenArray();
                    _local_16 = 0;
                    for each (_local_14 in _local_17)
                    {
                        _local_15 = TriggerVO.createFromXML(_local_14, _local_16);
                        _local_22.push(_local_15);
                        _local_16++;
                    };
                    _local_18 = _local_21.MoveToSubNode(NAME_ACHIEVEMENT_REWARDS_SUBNODE).CreateChildrenArray();
                    for each (_local_28 in _local_18)
                    {
                        _local_19 = _local_28.GetAttributeString_string(NAME_REWARD_TYPE);
                        _local_20 = this.achievementRewardFactory.getReward(_local_19, _local_28);
                        _local_23.push(_local_20);
                        _local_24.push(this.achievementRewardFactory.getUIRewardView(_local_19, _local_20));
                    };
                };
                _local_25 = new AchievementVO(_local_3, _local_5, _local_6, _local_7, _local_8, _local_9, _local_10, _local_11, _local_22, _local_23, _local_24, _local_12, _local_13);
                this.achievements_vector.push(_local_25);
                this.achievementsIdMap.putItem(_local_3, _local_25);
            };
        }


    }
}
