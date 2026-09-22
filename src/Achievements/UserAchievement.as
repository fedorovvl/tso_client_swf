package Achievements
{
    import Trigger.Triggerable;
    import Trigger.IUpdateTrigger;
    import Trigger.Trigger;
    import Communication.VO.Achievements.AchievementVO;
    import Interface.cGeneralInterface;
    import __AS3__.vec.Vector;
    import Utils.Tree.ITreeNode;
    import Achievements.trigger.PersistedAchievementTriggerDeltaValue;
    import nLib.gMisc;
    import Enums.DIRTY_INDICATOR;
    import Communication.VO.TriggerVO;
    import Enums.TRIGGER_ACTION;
    import Trigger.TriggerFactory;
    import Achievements.rewards.IAchievementReward;
    import Communication.VO.dUniqueID;
    import Communication.VO.Achievements.UserAchievementFinishedUpdateVO;
    import __AS3__.vec.*;

    public class UserAchievement implements IAchievementTreeNode, Triggerable, IUpdateTrigger 
    {

        public var triggersFinishedAndDeletedFlag:Boolean = false;
        private var playerLevelTrigger:Trigger;
        private var categoryID:int;
        public var mDirtyIndicator:int;
        private var progress:Number;
        private var achievementVO:AchievementVO;
        private var generalInterface:cGeneralInterface;
        private var parent:IAchievementTreeNode;
        private var triggers:Vector.<UserAchievementTriggerWrapper>;
        private var rank:int;
        private var playerId:int;
        private var points:int;
        private var finished:Boolean;
        private var visible:Boolean;

        public function UserAchievement(_arg_1:AchievementVO, _arg_2:int, _arg_3:cGeneralInterface)
        {
            super();
            this.achievementVO = _arg_1;
            this.visible = _arg_1.isVisible();
            this.playerId = _arg_2;
            this.generalInterface = _arg_3;
        }

        public function getAchievementVO():AchievementVO
        {
            return (this.achievementVO);
        }

        public function getAchievementId():int
        {
            return (this.achievementVO.getAchievementID());
        }

        private function sendTriggerFinishedUpdateVO(_arg_1:UserAchievementTriggerWrapper):void
        {
        }

        public function setTriggerFinished(_arg_1:int):void
        {
            var _local_2:UserAchievementTriggerWrapper;
            for each (_local_2 in this.triggers)
            {
                if (_local_2.getTriggerId() == _arg_1)
                {
                    _local_2.setFinished(true);
                    break;
                };
            };
            this.localUpdateProgress(null);
        }

        public function updateTriggerValue(_arg_1:int, _arg_2:int):void
        {
            var _local_3:UserAchievementTriggerWrapper;
            for each (_local_3 in this.triggers)
            {
                if (_local_3.getTriggerId() == _arg_1)
                {
                    _local_3.updateValue(_arg_2);
                    break;
                };
            };
        }

        public function disposeFinishedTriggers():void
        {
            var _local_1:UserAchievementTriggerWrapper;
            for each (_local_1 in this.triggers)
            {
                _local_1.disposeFinishedTrigger();
            };
        }

        public function getCategoryID():int
        {
            return (this.categoryID);
        }

        private function rewardPlayer():void
        {
        }

        private function handleAchievementJustFinished():void
        {
            var _local_1:UserAchievementManager = this.generalInterface.getCurrentUserAchievementManager();
            if (_local_1.getPlayerID() == this.getPlayerId())
            {
                _local_1.handleAchievementFinished(this);
            };
        }

        public function updateProgress():void
        {
            this.localUpdateProgress(null);
        }

        public function setCategoryID(_arg_1:int):void
        {
            this.categoryID = _arg_1;
        }

        public function dispose():void
        {
            var _local_1:UserAchievementTriggerWrapper;
            this.achievementVO = null;
            this.parent = null;
            this.generalInterface = null;
            if (this.triggers != null)
            {
                for each (_local_1 in this.triggers)
                {
                    _local_1.dispose();
                };
                this.triggers = null;
            };
        }

        public function getParent():ITreeNode
        {
            return (this.parent);
        }

        public function getRank():int
        {
            return (this.rank);
        }

        public function getProgress():Number
        {
            return (this.progress);
        }

        public function setParent(_arg_1:ITreeNode):void
        {
            this.parent = (_arg_1 as IAchievementTreeNode);
        }

        public function setRank(_arg_1:int):void
        {
            this.rank = _arg_1;
        }

        public function getTriggerCount():int
        {
            return (this.triggers.length);
        }

        public function isLeaf():Boolean
        {
            return (true);
        }

        public function setTriggers(_arg_1:Vector.<UserAchievementTriggerWrapper>):void
        {
            this.triggers = _arg_1;
        }

        public function setVisible(_arg_1:Boolean):void
        {
            this.visible = _arg_1;
        }

        public function getTriggers():Vector.<UserAchievementTriggerWrapper>
        {
            return (this.triggers);
        }

        public function updateVisibility():void
        {
            this.parent.updateVisibility();
        }

        public function getDeltaValues():Vector.<PersistedAchievementTriggerDeltaValue>
        {
            var _local_2:PersistedAchievementTriggerDeltaValue;
            var _local_3:UserAchievementTriggerWrapper;
            var _local_1:Vector.<PersistedAchievementTriggerDeltaValue> = new Vector.<PersistedAchievementTriggerDeltaValue>();
            for each (_local_3 in this.triggers)
            {
                _local_2 = _local_3.getPersistedDeltaValue();
                if (_local_2 != null)
                {
                    _local_1.push(_local_2);
                };
            };
            return (_local_1);
        }

        public function reset():void
        {
        }

        public function getPlayerId():int
        {
            return (this.playerId);
        }

        public function getPoints():int
        {
            return (this.points);
        }

        private function localUpdateProgress(_arg_1:Trigger):void
        {
            var _local_4:Boolean;
            var _local_5:UserAchievementTriggerWrapper;
            var _local_2:int = this.triggers.length;
            var _local_3:int;
            this.points = 0;
            var _local_6:Boolean = this.finished;
            for each (_local_5 in this.triggers)
            {
                if (((!(_arg_1 == null)) && (_local_5.getAchievementTrigger() == _arg_1)))
                {
                    _local_4 = _local_5.getFinished();
                    _local_5.setFinished(true);
                    if (!_local_4)
                    {
                        this.sendTriggerFinishedUpdateVO(_local_5);
                    };
                };
                if (_local_5.getFinished())
                {
                    _local_3++;
                };
            };
            gMisc.Assert((_local_2 > 0), (("No triggers specified for achievement '" + this.achievementVO.getAchievementName()) + "'"));
            this.progress = (_local_3 / _local_2);
            this.finished = (this.progress == 1);
            this.points = this.achievementVO.getPoints();
            if (((!(_local_6)) && (this.finished)))
            {
                if (this.playerId < 0)
                {
                    return;
                };
                this.mDirtyIndicator = DIRTY_INDICATOR.CREATED_BIT;
                this.handleAchievementJustFinished();
                if (!this.visible)
                {
                    this.setVisible(true);
                    this.parent.updateVisibility();
                };
            };
            if (this.parent != null)
            {
                this.parent.updateProgress();
            };
            if (((!(_local_6)) && (this.finished)))
            {
            };
        }

        public function trigger(_arg_1:Trigger):void
        {
            if (_arg_1 == this.playerLevelTrigger)
            {
                this.setVisible(true);
                this.playerLevelTrigger.dispose();
                this.playerLevelTrigger = null;
                this.updateVisibility();
                this.updateProgress();
            }
            else
            {
                if (this.triggers != null)
                {
                    this.localUpdateProgress(_arg_1);
                };
            };
        }

        public function isVisible():Boolean
        {
            return (this.visible);
        }

        public function hasSubcategories():Boolean
        {
            return (false);
        }

        public function triggerUpdated(_arg_1:Trigger):void
        {
            var _local_2:UserAchievementTriggerWrapper;
            for each (_local_2 in this.triggers)
            {
                if (_local_2.getAchievementTrigger() == _arg_1)
                {
                    _local_2.handleValueUpdated();
                };
            };
        }

        public function toString():String
        {
            var _local_4:UserAchievementTriggerWrapper;
            var _local_1:* = "";
            var _local_2:int;
            while (_local_2 < this.rank)
            {
                _local_1 = (_local_1 + "\t");
                _local_2++;
            };
            var _local_3:* = ((((((((((((((((((_local_1 + '<ACHIEVEMENT id="') + this.achievementVO.getAchievementID()) + '" name="') + this.achievementVO.getAchievementName()) + '" categoryID="') + this.achievementVO.getCategoryID()) + '" rank="') + this.rank) + '" playerID="') + this.playerId) + '" progress="') + this.progress) + '" finished="') + this.finished) + '" points="') + this.achievementVO.getPoints()) + '" ') + ">\n");
            for each (_local_4 in this.triggers)
            {
                _local_3 = (_local_3 + ((_local_1 + "\t") + _local_4.toString()));
            };
            return (_local_3 + (_local_1 + "</ACHIEVEMENT>\n"));
        }

        public function checkPlayerLevelVisibility():Boolean
        {
            var _local_1:TriggerVO;
            if (((this.achievementVO.getMinPlayerLevel() > 0) || (this.achievementVO.getMaxPlayerLevel() < gMisc.GetMaxIntValue())))
            {
                if (this.playerLevelTrigger == null)
                {
                    _local_1 = new TriggerVO();
                    _local_1.action_string = TRIGGER_ACTION.ACTION_PLAYERLEVEL_string;
                    _local_1.min = this.achievementVO.getMinPlayerLevel();
                    _local_1.max = this.achievementVO.getMaxPlayerLevel();
                    this.playerLevelTrigger = new TriggerFactory(this.generalInterface).createTrigger(_local_1, null);
                    if (this.playerLevelTrigger.check())
                    {
                        this.playerLevelTrigger.dispose();
                        this.playerLevelTrigger = null;
                    }
                    else
                    {
                        this.playerLevelTrigger.setTriggerable(this);
                    };
                };
            }
            else
            {
                this.playerLevelTrigger = null;
            };
            return (this.playerLevelTrigger == null);
        }

        public function checkForUpdates():void
        {
            var _local_1:UserAchievementTriggerWrapper;
            for each (_local_1 in this.triggers)
            {
                _local_1.checkForUpdate();
            };
        }

        public function setFinished(_arg_1:Boolean):void
        {
            this.finished = _arg_1;
        }

        public function getChildren():Vector.<ITreeNode>
        {
            return (null);
        }

        public function getFinished():Boolean
        {
            return (this.finished);
        }

        public function addPlayerRewards(_arg_1:UserAchievementFinishedUpdateVO):void
        {
            var _local_2:Vector.<IAchievementReward> = this.achievementVO.getRewards();
            var _local_3:int;
            while (_local_3 < _local_2.length)
            {
                _local_2[_local_3].reward(this.generalInterface, (_arg_1.uniqueIDs.getItemAt(_local_3) as dUniqueID));
                _local_3++;
            };
        }

        public function addChild(_arg_1:ITreeNode):void
        {
            throw (new Error("This is a leaf! It cannot have children!"));
        }

        public function removeChild(_arg_1:ITreeNode):void
        {
            throw (new Error("This is a leaf! It cannot have children!"));
        }


    }
}
