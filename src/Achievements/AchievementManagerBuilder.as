package Achievements
{
    import Interface.cGeneralInterface;
    import Achievements.trigger.AchievementTriggerFactory;
    import Communication.VO.Achievements.UserAchievementTriggerVO;
    import Communication.VO.TriggerVO;
    import __AS3__.vec.Vector;
    import flash.utils.Dictionary;
    import Communication.VO.Achievements.AchievementCategoriesVO;
    import Communication.VO.Achievements.UserAchievementCategoryVO;
    import Enums.DIRTY_INDICATOR;
    import mx.collections.ArrayCollection;
    import Communication.VO.Achievements.AchievementVO;
    import Communication.VO.Achievements.UserAchievementVO;
    import nLib.gMisc;
    import __AS3__.vec.*;

    public class AchievementManagerBuilder 
    {

        private const BOOL_TRUE_INT:int = 1;

        private var gi:cGeneralInterface;
        private var factory:AchievementTriggerFactory;
        private var achievementManager:AchievementsManager;

        public function AchievementManagerBuilder(_arg_1:AchievementsManager, _arg_2:cGeneralInterface)
        {
            super();
            this.achievementManager = _arg_1;
            this.gi = _arg_2;
            this.factory = new AchievementTriggerFactory(this.gi);
        }

        private function buildTriggers(_arg_1:UserAchievement, _arg_2:Dictionary, _arg_3:int, _arg_4:Boolean):Vector.<UserAchievementTriggerWrapper>
        {
            var _local_5:UserAchievementTriggerVO;
            var _local_6:TriggerVO;
            var _local_7:UserAchievementTriggerWrapper;
            var _local_10:String;
            var _local_8:Vector.<UserAchievementTriggerWrapper> = new Vector.<UserAchievementTriggerWrapper>();
            var _local_9:int = _arg_1.getAchievementVO().getAchievementID();
            var _local_11:Vector.<TriggerVO> = _arg_1.getAchievementVO().getTriggers();
            var _local_12:Boolean;
            for each (_local_6 in _local_11)
            {
                _local_7 = new UserAchievementTriggerWrapper(_local_6, this.gi);
                _local_10 = ((_local_9 + "_") + _local_6.triggerIdx);
                if (_arg_1.getFinished())
                {
                    _local_7.init(null, this.factory, _arg_1, false);
                }
                else
                {
                    if (((!(_arg_2 == null)) && (!(_arg_2[_local_10] == null))))
                    {
                        _local_5 = _arg_2[_local_10];
                        _local_7.init(_local_5, this.factory, _arg_1, _local_12);
                    }
                    else
                    {
                        _local_7.init(null, this.factory, _arg_1, _local_12);
                    };
                };
                _local_8.push(_local_7);
            };
            return (_local_8);
        }

        private function buildCategories(_arg_1:ArrayCollection, _arg_2:int):Dictionary
        {
            var _local_3:AchievementCategoriesVO;
            var _local_4:UserAchievementCategoryVO;
            var _local_5:UserAchievementCategory;
            var _local_6:Dictionary = new Dictionary(false);
            var _local_7:Vector.<AchievementCategoriesVO> = this.achievementManager.getAchievementCategoriesVector();
            var _local_8:Dictionary = new Dictionary();
            for each (_local_4 in _arg_1)
            {
                _local_8[_local_4.achievementCategoryID] = _local_4;
            };
            for each (_local_3 in _local_7)
            {
                _local_5 = new UserAchievementCategory(_local_3, _arg_2);
                _local_4 = _local_8[_local_3.getCategoryID()];
                if (_local_4 != null)
                {
                    _local_5.setFinished((_local_4.finished == this.BOOL_TRUE_INT));
                    if (_local_4.isDirty)
                    {
                        if (((_local_4.achievementsList == null) || (_local_4.achievementsList.length == 0)))
                        {
                            _local_5.mDirtyIndicator = DIRTY_INDICATOR.DELETED_BIT;
                        }
                        else
                        {
                            _local_5.mDirtyIndicator = DIRTY_INDICATOR.MODIFIED_BIT;
                        };
                        _local_4.isDirty = false;
                    };
                }
                else
                {
                    _local_5.mDirtyIndicator = DIRTY_INDICATOR.DELETED_BIT;
                };
                _local_6[_local_3.getCategoryID()] = _local_5;
            };
            return (_local_6);
        }

        private function buildAchievements(_arg_1:Dictionary, _arg_2:ArrayCollection, _arg_3:ArrayCollection, _arg_4:int):Dictionary
        {
            var _local_5:AchievementVO;
            var _local_6:UserAchievementVO;
            var _local_7:UserAchievement;
            var _local_8:UserAchievementCategory;
            var _local_9:Boolean;
            var _local_13:UserAchievementTriggerVO;
            var _local_14:Dictionary;
            var _local_10:Dictionary = new Dictionary(false);
            var _local_11:Vector.<AchievementVO> = this.achievementManager.getAchievementsVector();
            var _local_12:Dictionary = new Dictionary();
            for each (_local_6 in _arg_2)
            {
                _local_12[_local_6.achievementID] = _local_6;
            };
            _local_14 = new Dictionary();
            for each (_local_13 in _arg_3)
            {
                _local_14[((_local_13.achievementID + "_") + _local_13.triggerID)] = _local_13;
            };
            for each (_local_5 in _local_11)
            {
                _local_7 = new UserAchievement(_local_5, _arg_4, this.gi);
                _local_6 = _local_12[_local_5.getAchievementID()];
                _local_9 = true;
                if ((((_local_5.getDisabled()) || ((!(_local_5.getRequiresEvent() == "")) && (!(this.gi.mEventManager.isEventStartedWithYear(_local_5.getRequiresEvent(), _local_5.getRequiresYear()))))) || (!(_local_7.checkPlayerLevelVisibility()))))
                {
                    _local_7.setVisible(false);
                    _local_9 = false;
                };
                if (_local_6 != null)
                {
                    _local_7.setFinished((_local_6.finished == this.BOOL_TRUE_INT));
                    if (_local_7.getFinished())
                    {
                        _local_7.setVisible(true);
                    };
                    if (((_local_5.getDisabled()) || ((!(_local_5.getRequiresEvent() == "")) && (!(this.gi.mEventManager.isEventStarted(_local_5.getRequiresEvent()))))))
                    {
                        if (!_local_7.getFinished())
                        {
                            _local_7.setVisible(false);
                        };
                        _local_9 = false;
                    };
                }
                else
                {
                    _local_8 = _arg_1[_local_5.getCategoryID()];
                    gMisc.Assert((!(_local_8 == null)), ((("Achievement category not found! achievmentID: " + _local_5.getAchievementID()) + ", categoryId: ") + _local_5.getCategoryID()));
                    _local_7.setFinished(_local_8.getFinished());
                };
                _local_7.setTriggers(this.buildTriggers(_local_7, _local_14, _arg_4, _local_9));
                _local_10[_local_5.getAchievementID()] = _local_7;
            };
            return (_local_10);
        }

        public function buildUserAchievementManager(_arg_1:cGeneralInterface, _arg_2:int, _arg_3:ArrayCollection, _arg_4:ArrayCollection, _arg_5:ArrayCollection):UserAchievementManager
        {
            var _local_6:Dictionary = this.buildCategories(_arg_3, _arg_2);
            var _local_7:Dictionary = this.buildAchievements(_local_6, _arg_4, _arg_5, _arg_2);
            var _local_8:UserAchievementManager = new UserAchievementManager(_arg_1, _local_7, _local_6, _arg_2);
            return (_local_8);
        }


    }
}
