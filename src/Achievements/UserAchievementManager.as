package Achievements
{
    import Utils.Disposable;
    import Model.Observer;
    import flash.utils.Dictionary;
    import __AS3__.vec.Vector;
    import Interface.cGeneralInterface;
    import flash.utils.getTimer;
    import Events.EventManager;
    import Communication.VO.Achievements.AchievementCategoriesVO;
    import GUI.ApplicationFacade;
    import Communication.VO.Achievements.UserAchievementFinishedUpdateVO;
    import Model.Notifier;
    import Communication.VO.Achievements.UserAchievementTriggerFinishedUpdateVO;
    import Communication.VO.Achievements.UserAchievementTriggerValueUpdateVO;
    import mx.collections.ArrayCollection;
    import GUI.GAME.cHelpWindow;
    import __AS3__.vec.*;

    public class UserAchievementManager implements Disposable, Observer 
    {

        private var userAchievements:Dictionary;
        private var userAchievementTriggerWrappers:Vector.<UserAchievementTriggerWrapper>;
        private var userAchievementCategories:Dictionary;
        private var treeRoot:IAchievementTreeNode;
        private var userAchievementsToDelete:Vector.<int>;
        private var playerID:int;
        private var initialized:Boolean = false;
        private var gi:cGeneralInterface;
        private var userAchievementTriggersToDelete:Vector.<int>;
        private var finishedAchievementsCounter:int = 0;

        private var createdTime:Number = getTimer();
        private var recentlyFinishedAchievements:Vector.<UserAchievement> = new Vector.<UserAchievement>();
        private var finishedAchievementVOs:Dictionary = new Dictionary();

        public function UserAchievementManager(_arg_1:cGeneralInterface, _arg_2:Dictionary, _arg_3:Dictionary, _arg_4:int)
        {
            super();
            this.userAchievements = _arg_2;
            this.userAchievementCategories = _arg_3;
            this.playerID = _arg_4;
            this.gi = _arg_1;
            this.createRoot();
            this.buildTree();
            this.initialized = false;
            this.createdTime = getTimer();
            _arg_1.mEventManager.addPropertyObserver(EventManager.EVENT_STARTED, this);
            _arg_1.mEventManager.addPropertyObserver(EventManager.EVENT_STOPPED, this);
        }

        private function createRoot():void
        {
            var _local_1:AchievementCategoriesVO = new AchievementCategoriesVO(0, AchievementConsts.ROOT_CATEGORY_NAME, 0, false, false, false);
            this.treeRoot = new UserAchievementCategory(_local_1, this.playerID);
        }

        private function updateTree():void
        {
            var _local_2:Boolean;
            var _local_3:UserAchievement;
            var _local_1:int;
            this.treeRoot.setRank(0);
            for each (_local_3 in this.userAchievements)
            {
                _local_2 = _local_3.getFinished();
                if (this.shouldCheckAchievement(_local_1))
                {
                    _local_3.checkForUpdates();
                    if (((_local_3.getFinished()) && (!(_local_2))))
                    {
                        _local_1++;
                    };
                };
                _local_3.updateProgress();
            };
        }

        public function disposeFinishedTriggers():void
        {
            var _local_1:UserAchievement;
            for each (_local_1 in this.userAchievements)
            {
                _local_1.disposeFinishedTriggers();
            };
        }

        public function setInitialized(_arg_1:Boolean):void
        {
            this.initialized = _arg_1;
        }

        public function allUpdatesHandled():void
        {
            ApplicationFacade.getInstance().sendNotification(AchievementConsts.USER_ACHIEVEMENT_TREE_UPDATED, this.treeRoot);
            this.recentlyFinishedAchievements = new Vector.<UserAchievement>();
        }

        public function consumeAchievementFinishedVOs():void
        {
            var _local_1:String;
            var _local_2:UserAchievement;
            for (_local_1 in this.finishedAchievementVOs)
            {
                _local_2 = this.getAchievementByID(int(_local_1));
                _local_2.addPlayerRewards(this.finishedAchievementVOs[_local_1]);
                delete this.finishedAchievementVOs[_local_1];
            };
        }

        public function addAchievementFinishedVO(_arg_1:UserAchievementFinishedUpdateVO):void
        {
            this.finishedAchievementVOs[_arg_1.achievementId] = _arg_1;
        }

        public function getAchievements():Dictionary
        {
            return (this.userAchievements);
        }

        public function getTree():IAchievementTreeNode
        {
            return (this.treeRoot);
        }

        public function checkForAchievementUpdates():void
        {
            var _local_1:UserAchievement;
            var _local_2:String;
            for (_local_2 in this.userAchievements)
            {
                _local_1 = this.getAchievementByID(int(_local_2));
                _local_1.checkForUpdates();
            };
        }

        public function getInitialized():Boolean
        {
            return (this.initialized);
        }

        public function getCreatedTime():Number
        {
            return (this.createdTime);
        }

        public function setUserAchievementTriggersToDelete(_arg_1:Vector.<int>):void
        {
            this.userAchievementTriggersToDelete = _arg_1;
        }

        public function dispose():void
        {
            this.gi.mEventManager.removePropertyObserver(EventManager.EVENT_STARTED, this);
            this.gi.mEventManager.removePropertyObserver(EventManager.EVENT_STOPPED, this);
            this.userAchievements = null;
            this.userAchievementCategories = null;
            this.userAchievementTriggerWrappers = null;
            if (this.treeRoot != null)
            {
                this.treeRoot.dispose();
                this.treeRoot = null;
            };
        }

        public function getUserAchievementsToDelete():Vector.<int>
        {
            return (this.userAchievementsToDelete);
        }

        public function getFinishedAchievements():Vector.<UserAchievement>
        {
            return (this.recentlyFinishedAchievements);
        }

        public function getPlayerID():int
        {
            return (this.playerID);
        }

        public function getAllActiveTriggers():Vector.<UserAchievementTriggerWrapper>
        {
            var _local_1:UserAchievement;
            var _local_2:UserAchievementTriggerWrapper;
            if (this.userAchievementTriggerWrappers == null)
            {
                this.userAchievementTriggerWrappers = new Vector.<UserAchievementTriggerWrapper>();
                for each (_local_1 in this.userAchievements)
                {
                    for each (_local_2 in _local_1.getTriggers())
                    {
                        this.userAchievementTriggerWrappers.push(_local_2);
                    };
                };
            };
            return (this.userAchievementTriggerWrappers);
        }

        public function getUserAchievementTriggersToDelete():Vector.<int>
        {
            return (this.userAchievementTriggersToDelete);
        }

        public function setUserAchievementsToDelete(_arg_1:Vector.<int>):void
        {
            this.userAchievementsToDelete = _arg_1;
        }

        private function buildTree():void
        {
            var _local_1:int;
            var _local_2:UserAchievementCategory;
            var _local_3:UserAchievement;
            for each (_local_2 in this.userAchievementCategories)
            {
                _local_1 = _local_2.getAchievementCategoryVO().getCategoryParentID();
                if (_local_1 == 0)
                {
                    this.treeRoot.addChild(_local_2);
                }
                else
                {
                    this.userAchievementCategories[_local_1].addChild(_local_2);
                };
            };
            for each (_local_3 in this.userAchievements)
            {
                _local_1 = _local_3.getAchievementVO().getCategoryID();
                if (_local_1 != 0)
                {
                    this.userAchievementCategories[_local_1].addChild(_local_3);
                };
            };
            this.updateTree();
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            var _local_5:UserAchievement;
            var _local_6:Boolean;
            var _local_7:Boolean;
            var _local_8:Boolean;
            if (((!(_arg_2 == EventManager.EVENT_STARTED)) && (!(_arg_2 == EventManager.EVENT_STOPPED))))
            {
                return;
            };
            var _local_4:Boolean;
            for each (_local_5 in this.userAchievements)
            {
                _local_6 = this.gi.mEventManager.isEventStartedWithYear(_local_5.getAchievementVO().getRequiresEvent(), _local_5.getAchievementVO().getRequiresYear());
                _local_7 = ((!(_local_5.getAchievementVO() == null)) && (_local_5.getAchievementVO().IsEventAchievement()));
                if (((_local_7) && (!(_local_5.getFinished()))))
                {
                    _local_8 = _local_5.isVisible();
                    _local_5.setVisible(_local_6);
                    _local_5.updateVisibility();
                    _local_4 = ((_local_4) || (!(_local_5.isVisible() == _local_8)));
                };
            };
            if (((!(this.treeRoot == null)) && (_local_4)))
            {
                this.updateTree();
                ApplicationFacade.getInstance().sendNotification(AchievementConsts.EVENT_CHANGED, this.treeRoot);
            };
        }

        public function getAchievementByID(_arg_1:int):UserAchievement
        {
            return (this.userAchievements[_arg_1] as UserAchievement);
        }

        public function getAchievementTriggerUpdates(_arg_1:ArrayCollection, _arg_2:ArrayCollection):void
        {
            var _local_3:UserAchievement;
            var _local_4:UserAchievementTriggerWrapper;
            for each (_local_3 in this.userAchievements)
            {
                for each (_local_4 in _local_3.getTriggers())
                {
                    if (_local_4.getFinished())
                    {
                        _arg_1.addItem(new UserAchievementTriggerFinishedUpdateVO().init(_local_4.getAchievementId(), _local_4.getTriggerId()));
                    }
                    else
                    {
                        if (((!(_arg_2 == null)) && (!(_local_4.getValue() == 0))))
                        {
                            _arg_2.addItem(new UserAchievementTriggerValueUpdateVO().init(_local_4.getAchievementId(), _local_4.getTriggerId(), _local_4.getValue()));
                        };
                    };
                };
            };
        }

        private function shouldCheckAchievement(_arg_1:int):Boolean
        {
            if (defines.ACHIEVEMENT_THROTTLE_MODE_ACTIVE)
            {
                return (_arg_1 < defines.ACHIEVEMENT_THROTTLE_MODE_MAX_NUMBER_OF_FINISHED_ACHIEVEMENTS);
            };
            return (true);
        }

        public function isTriggerActive(_arg_1:String):Boolean
        {
            var _local_3:UserAchievement;
            var _local_4:UserAchievementTriggerWrapper;
            var _local_2:String = _arg_1.toLocaleLowerCase();
            for each (_local_3 in this.userAchievements)
            {
                for each (_local_4 in _local_3.getTriggers())
                {
                    if (_local_4.getAchievementTriggerVO().action_string == _local_2)
                    {
                        return (true);
                    };
                };
            };
            return (false);
        }

        public function getAchievementCategoryForName(_arg_1:String):UserAchievementCategory
        {
            var _local_3:UserAchievementCategory;
            var _local_2:String;
            for each (_local_3 in this.userAchievementCategories)
            {
                _local_2 = _local_3.getAchievementCategoryVO().getCategoryName();
                if (_arg_1 == _local_2)
                {
                    return (_local_3);
                };
            };
            return (null);
        }

        public function updateAchievementValue(_arg_1:UserAchievementTriggerValueUpdateVO):void
        {
            var _local_2:UserAchievement = this.getAchievementByID(_arg_1.achievementId);
            if (_local_2 != null)
            {
                _local_2.updateTriggerValue(_arg_1.triggerId, _arg_1.updatedValue);
            };
        }

        public function toString():String
        {
            return (this.treeRoot.toString());
        }

        public function setTriggerAchievementFinished(_arg_1:UserAchievementTriggerFinishedUpdateVO):void
        {
            var _local_2:UserAchievement = this.getAchievementByID(_arg_1.achievementId);
            if (_local_2 != null)
            {
                _local_2.setTriggerFinished(_arg_1.triggerId);
            };
        }

        public function getAchievementCategories():Dictionary
        {
            return (this.userAchievementCategories);
        }

        public function handleAchievementFinished(_arg_1:UserAchievement):void
        {
            var _local_2:cHelpWindow;
            this.finishedAchievementsCounter++;
            if (this.initialized)
            {
                this.recentlyFinishedAchievements.push(_arg_1);
            };
            if (!defines.ACHIEVEMENT_THROTTLE_MODE_ACTIVE)
            {
                if (this.finishedAchievementsCounter == 1)
                {
                    _local_2 = globalFlash.gui.mHelpWindow;
                    _local_2.SetDataByString(AchievementConsts.HELP_DEFINITION_NAME);
                    globalFlash.gui.TryShowPanel(_local_2);
                };
            };
        }


    }
}
