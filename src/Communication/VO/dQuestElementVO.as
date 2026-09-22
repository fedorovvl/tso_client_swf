package Communication.VO
{
    import Model.Notifier;
    import Communication.VO.UpdateVO.dLootItemsVO;
    import mx.collections.ArrayCollection;
    import converted.bluebyte.tso.quests.logic.QuestManagerStatic;
    import Enums.DIRTY_INDICATOR;
    import Interface.cGeneralInterface;
    import nLib.gMisc;
    import ServerState.cPlayerData;
    import mx.events.PropertyChangeEvent;
    import Utils.StringUtils;

    public class dQuestElementVO extends Notifier 
    {

        private static const CREATE_MISSING_TRIGGERS:Boolean = false;
        private static const dummy1:dLootItemsVO = null;

        public var mQuestFailed:Boolean = false;
        public var mRandomSeed:int;
        public var mCreatedTime:Number = 0;
        public var mDirtyIndicator:int;
        public var mLastUpdateTime:Number = 0;
        public var isReset:Boolean = false;
        public var mUniqueID:dUniqueID;
        public var mQuestWindowShowState:Boolean = false;
        public var mRewardTrials:int = 0;
        public var mIsTrackedMission:Boolean = false;
        public var mLastBuildingUpgraded:String = null;
        public var mStartTime:Number;
        public var instantFinishInProgress:Boolean = false;
        public var mNewTriggersFinished:Boolean = true;
        public var lastResetStartDelay:int;
        private var _1812175400mSelected:Boolean = false;
        public var mIsFirstRandomQuest:Boolean = false;
        public var mQuestDefinition:dQuestDefinitionVO = null;
        public var mQuestMode:int;
        public var mRandomPosition:int;
        public var mRewardWindowShowState:Boolean = false;

        public var mQuestTriggersFinished_vector:ArrayCollection = new ArrayCollection();
        public var mQuestTriggersFinishedGuiRefreshCache_vector:ArrayCollection = new ArrayCollection();
        public var mUniqueIDs_vector:ArrayCollection = new ArrayCollection();
        public var mLootItemsVO_vector:ArrayCollection = new ArrayCollection();
        public var mOtherQuestDefinition_vector:ArrayCollection = new ArrayCollection();


        public function isFailed():Boolean
        {
            return ((this.mQuestFailed) || (this.mQuestMode == QuestManagerStatic.QUEST_MODE_QUEST_FAILED));
        }

        public function GetQuestMode():int
        {
            return (this.mQuestMode);
        }

        public function updateFrom(_arg_1:dQuestElementVO):void
        {
            this.SetQuestMode(_arg_1.GetQuestMode());
            this.SetQuestStartTime(_arg_1.GetQuestStartTime());
            this.SetRandomPosition(_arg_1.GetRandomPosition());
            this.SetRandomSeed(_arg_1.GetRandomSeed());
            this.SetUniqueId(_arg_1.GetUniqueId());
            this.mCreatedTime = _arg_1.mCreatedTime;
            this.mLastUpdateTime = _arg_1.mLastUpdateTime;
            this.mDirtyIndicator = _arg_1.mDirtyIndicator;
            this.mIsTrackedMission = _arg_1.mIsTrackedMission;
            this.mLastBuildingUpgraded = _arg_1.mLastBuildingUpgraded;
            this.mLootItemsVO_vector = _arg_1.mLootItemsVO_vector;
            this.mOtherQuestDefinition_vector = _arg_1.mOtherQuestDefinition_vector;
            this.mQuestDefinition = _arg_1.mQuestDefinition;
            this.mQuestTriggersFinished_vector = _arg_1.mQuestTriggersFinished_vector;
            this.mQuestTriggersFinishedGuiRefreshCache_vector = _arg_1.mQuestTriggersFinishedGuiRefreshCache_vector;
            this.mQuestWindowShowState = _arg_1.mQuestWindowShowState;
            this.mRewardTrials = _arg_1.mRewardTrials;
            this.mSelected = _arg_1.mSelected;
            this.mUniqueIDs_vector = _arg_1.mUniqueIDs_vector;
            this.mNewTriggersFinished = _arg_1.mNewTriggersFinished;
            this.mQuestFailed = _arg_1.mQuestFailed;
            this.isReset = _arg_1.isReset;
            this.lastResetStartDelay = _arg_1.lastResetStartDelay;
        }

        public function IsRunning():Boolean
        {
            return ((this.mQuestMode == QuestManagerStatic.QUEST_MODE_RUNNING) || (this.mQuestMode == QuestManagerStatic.QUEST_MODE_START_WINDOW_DESCRIPTION_WAIT_FOR_BUTTON_PRESSED));
        }

        public function CheckGreaterEqualWin(_arg_1:dQuestDefinitionTriggerVO):void
        {
            this.CheckCounterWin(_arg_1, QuestManagerStatic.CONDITION_GREATER_OR_EQUAL);
        }

        public function SetQuestFailed(_arg_1:Boolean):void
        {
        }

        public function GetUniqueId():dUniqueID
        {
            return (this.mUniqueID);
        }

        public function IsEqualTo(_arg_1:dQuestElementVO):Boolean
        {
            if (((((!(this.mUniqueID.uniqueID1 == _arg_1.mUniqueID.uniqueID1)) || (!(this.mUniqueID.uniqueID2 == _arg_1.mUniqueID.uniqueID2))) || (!(this.mQuestMode == _arg_1.mQuestMode))) || (!(this.mQuestDefinition.questName_string == _arg_1.mQuestDefinition.questName_string))))
            {
                return (false);
            };
            return (true);
        }

        public function IsTriggerAndConditionInQuest(_arg_1:int, _arg_2:int):Boolean
        {
            var _local_3:dQuestDefinitionTriggerVO;
            for each (_local_3 in this.mQuestDefinition.questTriggers_vector)
            {
                if (((_local_3.type == _arg_1) && (_local_3.condition == _arg_2)))
                {
                    return (true);
                };
            };
            return (false);
        }

        public function SetUniqueId(_arg_1:dUniqueID):void
        {
            this.mUniqueID = _arg_1;
            this.mDirtyIndicator = (this.mDirtyIndicator | DIRTY_INDICATOR.DATA_MODIFIED_BIT);
            notifyPropertyObserver("mUniqueID", _arg_1);
        }

        [Bindable(event="propertyChange")]
        public function get mSelected():Boolean
        {
            return (this._1812175400mSelected);
        }

        public function IsRewardCollected():Boolean
        {
            return (this.mQuestMode == QuestManagerStatic.QUEST_MODE_REWARD_COLLECTED_IDLE);
        }

        public function IsQuestModeAllowedForQuestList(_arg_1:cGeneralInterface):Boolean
        {
            if (!((((((this.mQuestMode == QuestManagerStatic.QUEST_MODE_RUNNING) || (this.mQuestMode == QuestManagerStatic.QUEST_MODE_START_WINDOW_DESCRIPTION_WAIT_FOR_BUTTON_PRESSED)) || (this.mQuestMode == QuestManagerStatic.QUEST_MODE_PENDING_NEXT_RANDOM_DAILY_QUEST)) || (this.mQuestMode == QuestManagerStatic.QUEST_MODE_REWARD_WINDOW_WAIT_FOR_BUTTON_ACTIVE)) || (this.mQuestMode == QuestManagerStatic.QUEST_MODE_WAIT_FOR_FINISH)) || (this.mQuestMode == QuestManagerStatic.QUEST_MODE_QUEST_FAILED)))
            {
                return (false);
            };
            if (((QuestManagerStatic.IsPartialGuildQuest(this.mQuestDefinition)) && (_arg_1.mCurrentPlayerGuild == null)))
            {
                return (false);
            };
            if (this.mQuestDefinition.FindTriggerWithType(QuestManagerStatic.TYPE_DAILYLOGIN) != -1)
            {
                return (false);
            };
            if (this.mQuestDefinition.FindTriggerWithType(QuestManagerStatic.TYPE_DAILYTIME) != -1)
            {
                return (false);
            };
            return (true);
        }

        public function GetTriggerStatus(_arg_1:int):int
        {
            return (this.GetQuestTriggerFinished(_arg_1).status);
        }

        public function FailQuest(_arg_1:cGeneralInterface):void
        {
            this.SetQuestMode(QuestManagerStatic.QUEST_MODE_QUEST_FAILED);
            this.mQuestFailed = true;
            _arg_1.channels.QUEST.questModeChanged(this);
            this.isReset = false;
            this.lastResetStartDelay = 0;
        }

        public function CheckTriggerCondition(_arg_1:int, _arg_2:int):void
        {
            var _local_3:dQuestDefinitionTriggerVO;
            if (!this.IsRunning())
            {
                return;
            };
            for each (_local_3 in this.mQuestDefinition.questTriggers_vector)
            {
                if ((((_local_3.type == _arg_1) && ((_local_3.condition == _arg_2) || (_arg_2 == QuestManagerStatic.CONDITION_UNSET))) && (!(this.GetQuestTriggerFinished(_local_3.triggerIdx).status == 1))))
                {
                    this.SetTriggerWon(_local_3.triggerIdx);
                    return;
                };
            };
        }

        public function CheckCounterWin(_arg_1:dQuestDefinitionTriggerVO, _arg_2:int):void
        {
            var _local_3:int;
            if (_arg_1.condition == _arg_2)
            {
                _local_3 = (this.GetDeltaStart(_arg_1.triggerIdx) as int);
                if (_local_3 >= _arg_1.amount)
                {
                    this.SetTriggerWon(_arg_1.triggerIdx);
                };
            };
        }

        public function IsATriggerConditionName(_arg_1:int, _arg_2:int, _arg_3:String):Boolean
        {
            var _local_4:dQuestDefinitionTriggerVO;
            for each (_local_4 in this.mQuestDefinition.questTriggers_vector)
            {
                if ((((_local_4.type == _arg_1) && ((_local_4.condition == _arg_2) || (_arg_2 == QuestManagerStatic.CONDITION_UNSET))) && (!(this.GetQuestTriggerFinished(_local_4.triggerIdx).status == 1))))
                {
                    if (((_local_4.name_string == _arg_3) || (_local_4.name_string.length == 0)))
                    {
                        return (true);
                    };
                };
            };
            return (false);
        }

        private function GetQuestTriggerFinished(_arg_1:int):dQuestTriggerVO
        {
            if (CREATE_MISSING_TRIGGERS)
            {
                while (_arg_1 >= this.mQuestTriggersFinished_vector.length)
                {
                    this.mQuestTriggersFinished_vector.addItem(new dQuestTriggerVO());
                    this.mQuestTriggersFinishedGuiRefreshCache_vector.addItem(new dQuestTriggerVO());
                    this.mDirtyIndicator = (this.mDirtyIndicator | DIRTY_INDICATOR.DATA_MODIFIED_BIT);
                };
            }
            else
            {
                gMisc.Assert((_arg_1 < this.mQuestTriggersFinished_vector.length), ("Quest has a new trigger not covered by an update script! " + this.getQuestName_string()));
            };
            return (this.mQuestTriggersFinished_vector[_arg_1]);
        }

        public function GetDeltaStart(_arg_1:int):Number
        {
            return (this.GetQuestTriggerFinished(_arg_1).deltaStart);
        }

        public function SetAllTriggersToWon(_arg_1:int):void
        {
            var _local_2:int;
            while (_local_2 < this.mQuestDefinition.questTriggers_vector.length)
            {
                if (this.mQuestDefinition.questTriggers_vector[_local_2].type == _arg_1)
                {
                    this.SetTriggerWon(this.mQuestDefinition.questTriggers_vector[_local_2].triggerIdx);
                };
                _local_2++;
            };
        }

        public function GetQuestStartTime():Number
        {
            return (this.mStartTime);
        }

        public function CreateNewQuest(_arg_1:cPlayerData, _arg_2:dQuestDefinitionVO):void
        {
            var _local_3:int;
            var _local_4:dQuestDefinitionPostrequisitsVO;
            if (((!(QuestManagerStatic.IsActive())) || (_arg_2 == null)))
            {
                return;
            };
            this.mQuestDefinition = _arg_2;
            this.mQuestWindowShowState = false;
            this.mRewardWindowShowState = false;
            this.mUniqueID = _arg_1.GetNewUniqueID();
            this.CreateOtherQuestDefinition(_arg_1.GetPlayerId());
            this.ResetQuestFinishedTriggers(this.GetQuestDefinition().questTriggers_vector);
            this.StartQuest();
            if (_arg_2.questTyp == QuestManagerStatic.QUEST_TYPE_DAILY_QUEST)
            {
                _local_3 = gMisc.GetRandomMinMaxInt(1, 2147483647);
                this.SetRandomSeed(_local_3);
                this.mIsFirstRandomQuest = true;
            }
            else
            {
                if (_arg_2.questTyp == QuestManagerStatic.QUEST_TYPE_DEFAULT)
                {
                    for each (_local_4 in _arg_2.questPostrequisits)
                    {
                        if (_local_4.type == QuestManagerStatic.TYPE_RANDOM_QUEST_LIST)
                        {
                            this.mIsFirstRandomQuest = true;
                            this.SetRandomSeed(gMisc.GetRandomMinMaxInt(1, 2147483647));
                            break;
                        };
                    };
                };
            };
            this.isReset = false;
            this.lastResetStartDelay = 0;
            this.mDirtyIndicator = DIRTY_INDICATOR.CREATED_BIT;
        }

        public function ResetQuestFinishedTriggers(_arg_1:ArrayCollection):void
        {
            var _local_2:dQuestDefinitionTriggerVO;
            var _local_3:dQuestTriggerVO;
            var _local_4:dQuestTriggerVO;
            this.mLastBuildingUpgraded = null;
            this.mQuestTriggersFinished_vector.removeAll();
            this.mQuestTriggersFinishedGuiRefreshCache_vector.removeAll();
            for each (_local_2 in _arg_1)
            {
                _local_3 = new dQuestTriggerVO();
                _local_3.status = 0;
                _local_3.deltaStart = 0;
                this.mQuestTriggersFinished_vector.addItem(_local_3);
                _local_4 = new dQuestTriggerVO();
                _local_4.status = 0;
                _local_4.deltaStart = 0;
                this.mQuestTriggersFinishedGuiRefreshCache_vector.addItem(_local_4);
            };
        }

        public function SetNewTriggersFinished(_arg_1:Boolean):void
        {
        }

        public function SetDeltaStart(_arg_1:int, _arg_2:Number):void
        {
            var _local_3:dQuestTriggerVO = this.GetQuestTriggerFinished(_arg_1);
            var _local_4:Number = Math.abs((_arg_2 - _local_3.deltaStart));
            if (_local_4 > 0.0001)
            {
                _local_3.deltaStart = _arg_2;
                this.mDirtyIndicator = (this.mDirtyIndicator | DIRTY_INDICATOR.DATA_MODIFIED_BIT);
            };
        }

        public function NewerThan(_arg_1:dQuestElementVO):Boolean
        {
            if (((((!(this.mUniqueID.uniqueID1 == _arg_1.mUniqueID.uniqueID1)) || (!(this.mUniqueID.uniqueID2 == _arg_1.mUniqueID.uniqueID2))) || (!(this.mQuestDefinition.questName_string == _arg_1.mQuestDefinition.questName_string))) || (QuestManagerStatic.GetQuestStatusPosition(this.mQuestMode) <= QuestManagerStatic.GetQuestStatusPosition(_arg_1.mQuestMode))))
            {
                return (false);
            };
            return (true);
        }

        public function SetQuestStartTime(_arg_1:Number):void
        {
            this.mStartTime = _arg_1;
            this.mDirtyIndicator = (this.mDirtyIndicator | DIRTY_INDICATOR.MODIFIED_BIT);
            notifyPropertyObserver("mStartTime", _arg_1);
        }

        public function IsInFinishedState():Boolean
        {
            return (this.mQuestMode == QuestManagerStatic.QUEST_MODE_REWARD_WINDOW_WAIT_FOR_BUTTON_ACTIVE);
        }

        override public function toString():String
        {
            var _local_2:dQuestTriggerVO;
            var _local_1:* = "";
            for each (_local_2 in this.mQuestTriggersFinished_vector)
            {
                if (_local_1 != "")
                {
                    _local_1 = (_local_1 + ", ");
                };
                _local_1 = (_local_1 + _local_2);
            };
            return (((((((((((((((((("<dQuestElementVO mQuestDefinition='" + this.mQuestDefinition) + "' activeQuest='") + this.mQuestDefinition.questName_string) + "' questMode='") + this.mQuestMode) + "' startTime='") + this.mStartTime) + "' randomSeed='") + this.mRandomSeed) + "' randomPosition='") + this.mRandomPosition) + "' mQuestWindowShowState='") + this.mQuestWindowShowState) + "' mRewardWindowShowState='") + this.mRewardWindowShowState) + "' mQuestTriggersFinished='") + _local_1) + "' />");
        }

        public function CheckTriggerConditionName(_arg_1:int, _arg_2:int, _arg_3:String):Boolean
        {
            var _local_4:dQuestDefinitionTriggerVO;
            if (!this.IsRunning())
            {
                return (false);
            };
            for each (_local_4 in this.mQuestDefinition.questTriggers_vector)
            {
                if ((((_local_4.type == _arg_1) && ((_local_4.condition == _arg_2) || (_arg_2 == QuestManagerStatic.CONDITION_UNSET))) && (!(this.GetQuestTriggerFinished(_local_4.triggerIdx).status == 1))))
                {
                    if (((_local_4.name_string == _arg_3) || (_local_4.name_string.length == 0)))
                    {
                        this.SetTriggerWon(_local_4.triggerIdx);
                        return (true);
                    };
                };
            };
            return (false);
        }

        public function set mSelected(_arg_1:Boolean):void
        {
            var _local_2:Object = this._1812175400mSelected;
            if (_local_2 !== _arg_1)
            {
                this._1812175400mSelected = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "mSelected", _local_2, _arg_1));
            };
        }

        public function SetQuestMode(_arg_1:int):void
        {
            this.mQuestMode = _arg_1;
            this.mDirtyIndicator = (this.mDirtyIndicator | DIRTY_INDICATOR.MODIFIED_BIT);
            notifyPropertyObserver(QuestManagerStatic.QUEST_MODE_string, _arg_1);
            this.instantFinishInProgress = false;
        }

        public function CheckGreaterEqualDeltaWin(_arg_1:dQuestDefinitionTriggerVO):void
        {
            this.CheckCounterWin(_arg_1, QuestManagerStatic.CONDITION_GREATER_OR_EQUAL_DELTA);
        }

        public function getQuestName_string():String
        {
            if (this.mQuestDefinition == null)
            {
                if (this.mUniqueID != null)
                {
                    return (this.mUniqueID.toString());
                };
                return ("");
            };
            return (this.mQuestDefinition.questName_string);
        }

        public function GetQuestTriggersFinished_vector():ArrayCollection
        {
            return (this.mQuestTriggersFinished_vector);
        }

        public function InitQuestFromSaveGame(_arg_1:int, _arg_2:dQuestDefinitionVO, _arg_3:dQuestElementVO):void
        {
            var _local_4:dQuestTriggerVO;
            var _local_5:dQuestTriggerVO;
            this.mUniqueID = _arg_3.mUniqueID;
            this.mQuestDefinition = _arg_2;
            this.mLastBuildingUpgraded = null;
            this.mQuestWindowShowState = _arg_3.mQuestWindowShowState;
            this.mRewardWindowShowState = _arg_3.mRewardWindowShowState;
            this.mIsTrackedMission = _arg_3.mIsTrackedMission;
            this.mQuestMode = _arg_3.mQuestMode;
            this.mStartTime = _arg_3.mStartTime;
            this.mCreatedTime = _arg_3.mCreatedTime;
            this.mLastUpdateTime = _arg_3.mLastUpdateTime;
            this.mRandomSeed = _arg_3.mRandomSeed;
            this.mRandomPosition = _arg_3.mRandomPosition;
            this.isReset = _arg_3.isReset;
            this.lastResetStartDelay = _arg_3.lastResetStartDelay;
            this.CreateOtherQuestDefinition(_arg_1);
            this.mQuestTriggersFinished_vector.removeAll();
            this.mQuestTriggersFinishedGuiRefreshCache_vector.removeAll();
            for each (_local_4 in _arg_3.mQuestTriggersFinished_vector)
            {
                this.mQuestTriggersFinished_vector.addItem(_local_4);
                _local_5 = new dQuestTriggerVO();
                _local_5.deltaStart = _local_4.deltaStart;
                _local_5.status = _local_4.status;
                this.mQuestTriggersFinishedGuiRefreshCache_vector.addItem(_local_5);
            };
        }

        public function IncreaseDeltaStart(_arg_1:int, _arg_2:Number):void
        {
            if (Math.abs(_arg_2) > 0.0001)
            {
                this.GetQuestTriggerFinished(_arg_1).deltaStart = (this.GetQuestTriggerFinished(_arg_1).deltaStart + _arg_2);
                this.mDirtyIndicator = (this.mDirtyIndicator | DIRTY_INDICATOR.DATA_MODIFIED_BIT);
            };
        }

        public function isTriggerIdxValid(_arg_1:int):Boolean
        {
            return (((_arg_1 >= 0) || (_arg_1 < this.mQuestTriggersFinished_vector.length)) && (!(this.mQuestTriggersFinished_vector[_arg_1] == null)));
        }

        public function ContainsNewTrigger(_arg_1:String, _arg_2:String, _arg_3:String):Boolean
        {
            var _local_4:TriggerVO;
            if ((((_arg_1 == null) && (_arg_2 == null)) && (_arg_3 == null)))
            {
                return (false);
            };
            for each (_local_4 in this.mQuestDefinition.endConditions_vector)
            {
                if ((((((StringUtils.isEmpty(_local_4.action_string)) && (StringUtils.isEmpty(_arg_1))) || (_local_4.action_string == _arg_1)) && (((StringUtils.isEmpty(_local_4.item_string)) && (StringUtils.isEmpty(_arg_2))) || (_local_4.item_string.indexOf(_arg_2) > -1))) && (((StringUtils.isEmpty(_local_4.target_string)) && (StringUtils.isEmpty(_arg_3))) || (_local_4.target_string == _arg_3))))
                {
                    return (true);
                };
            };
            return (false);
        }

        public function SetTriggerWon(_arg_1:int):void
        {
            var _local_2:dQuestDefinitionTriggerVO = this.mQuestDefinition.questTriggers_vector[_arg_1];
            var _local_3:cGeneralInterface = global.ui;
            if ((((!(_local_3 == null)) && (!(_local_3.mTriggerEffects == null))) && (!(_local_2 == null))))
            {
                _local_3.mTriggerEffects.startOnCompleteEffects(_local_2);
            };
            this.SetTriggerStatus(_arg_1, 1);
        }

        public function GetRandomSeed():int
        {
            return (this.mRandomSeed);
        }

        public function SetTriggerStatus(_arg_1:int, _arg_2:int):void
        {
            if (this.GetQuestTriggerFinished(_arg_1).status != _arg_2)
            {
                this.GetQuestTriggerFinished(_arg_1).status = _arg_2;
                this.mDirtyIndicator = (this.mDirtyIndicator | DIRTY_INDICATOR.DATA_MODIFIED_BIT);
            };
            notifyPropertyObserver("mQuestTriggersFinished_vector", this.GetQuestTriggerFinished(_arg_1));
        }

        public function DeActivate():void
        {
        }

        public function SetRandomSeed(_arg_1:int):void
        {
            this.mRandomSeed = _arg_1;
            this.mDirtyIndicator = (this.mDirtyIndicator | DIRTY_INDICATOR.MODIFIED_BIT);
            notifyPropertyObserver("mRandomSeed", _arg_1);
        }

        public function IsADailyLoginQuest():Boolean
        {
            return (!(this.mQuestDefinition.FindTriggerWithType(QuestManagerStatic.TYPE_DAILYLOGIN) == -1));
        }

        public function GetQuestDefinition():dQuestDefinitionVO
        {
            return (this.mQuestDefinition);
        }

        public function isFinished():Boolean
        {
            if (QuestManagerStatic.IsLastPartialGuildQuest(this.mQuestDefinition))
            {
                return (this.GetQuestMode() == QuestManagerStatic.QUEST_MODE_WAIT_FOR_FINISH);
            };
            if (this.GetQuestMode() == QuestManagerStatic.QUEST_MODE_REWARD_WINDOW_WAIT_FOR_BUTTON_ACTIVE)
            {
                return (true);
            };
            if (this.GetQuestDefinition().showRewardWindow)
            {
                return (this.GetQuestMode() == QuestManagerStatic.QUEST_MODE_INIT_REWARD_WINDOW);
            };
            return (this.GetQuestMode() == QuestManagerStatic.QUEST_MODE_PRESS_REWARD_BUTTON);
        }

        public function StartQuest():void
        {
            if (this.GetQuestDefinition().showQuestWindow)
            {
                this.SetQuestMode(QuestManagerStatic.QUEST_MODE_SHOW_WINDOW_DESCRIPTION);
            }
            else
            {
                this.SetQuestMode(QuestManagerStatic.QUEST_MODE_RUNNING);
            };
        }

        public function IsTriggerInQuest(_arg_1:int):Boolean
        {
            var _local_2:dQuestDefinitionTriggerVO;
            for each (_local_2 in this.mQuestDefinition.questTriggers_vector)
            {
                if (_local_2.type == _arg_1)
                {
                    return (true);
                };
            };
            return (false);
        }

        public function ResetQuestFinishedTriggersRestartMode():void
        {
            this.mLastBuildingUpgraded = null;
            var _local_1:int;
            while (_local_1 < this.mQuestTriggersFinished_vector.length)
            {
                this.mQuestTriggersFinished_vector[_local_1].status = 0;
                this.mQuestTriggersFinishedGuiRefreshCache_vector[_local_1].status = 0;
                notifyPropertyObserver("mQuestTriggersFinished_vector", this.mQuestTriggersFinished_vector[_local_1]);
                _local_1++;
            };
            this.mDirtyIndicator = (this.mDirtyIndicator | DIRTY_INDICATOR.DATA_MODIFIED_BIT);
        }

        public function resetQuest(_arg_1:cGeneralInterface, _arg_2:int):void
        {
            this.isReset = true;
            this.lastResetStartDelay = _arg_2;
            this.mRewardTrials = 0;
            this.ResetQuestFinishedTriggers(this.mQuestDefinition.questTriggers_vector);
            this.mStartTime = (_arg_1.GetClientTime() + (_arg_2 * 1000));
            this.SetQuestMode(QuestManagerStatic.QUEST_MODE_START_DELAY);
            this.mDirtyIndicator = (this.mDirtyIndicator | DIRTY_INDICATOR.DATA_MODIFIED_BIT);
        }

        public function IsQuestActive():Boolean
        {
            return (this.mQuestMode <= QuestManagerStatic.QUEST_MODE_WAIT_FOR_FINISH);
        }

        public function CreateOtherQuestDefinition(_arg_1:int):void
        {
            var _local_2:dQuestDefinitionVO;
            var _local_3:dQuestDefinitionVO;
            var _local_4:dQuestDefinitionPostrequisitsVO;
            if (this.IsADailyLoginQuest())
            {
                _local_2 = this.mQuestDefinition;
                while (true)
                {
                    _local_3 = null;
                    for each (_local_4 in _local_2.questPostrequisits)
                    {
                        if (_local_4.type == QuestManagerStatic.TYPE_STARTQUEST)
                        {
                            if (_local_4.name_string != null)
                            {
                                _local_3 = QuestManagerStatic.GetQuestFromName(_arg_1, _local_4.name_string);
                                break;
                            };
                        }
                        else
                        {
                            gMisc.Assert(false, ("Error: Only StartQuest is allowed in Daily quest Postrequisits!" + _local_4));
                        };
                    };
                    gMisc.Assert((!(_local_3 == null)), "Error: No Circular Quest Definition for daily Login");
                    if (_local_3.questName_string == this.mQuestDefinition.questName_string) break;
                    _local_2 = _local_3;
                    this.mOtherQuestDefinition_vector.addItem(_local_2);
                };
            };
        }

        public function GetRandomPosition():int
        {
            return (this.mRandomPosition);
        }

        public function IsMotherQuestOf(_arg_1:dQuestElementVO):Boolean
        {
            if (_arg_1.mQuestDefinition.dailyMotherQuest != null)
            {
                return (_arg_1.mQuestDefinition.dailyMotherQuest.questName_string == this.mQuestDefinition.questName_string);
            };
            return (false);
        }

        public function SetRandomPosition(_arg_1:int):void
        {
            this.mRandomPosition = _arg_1;
            this.mDirtyIndicator = (this.mDirtyIndicator | DIRTY_INDICATOR.MODIFIED_BIT);
            notifyPropertyObserver("mRandomPosition", _arg_1);
        }

        public function FinishQuest(_arg_1:cGeneralInterface):void
        {
            if (QuestManagerStatic.IsLastPartialGuildQuest(this.mQuestDefinition))
            {
                this.SetQuestMode(QuestManagerStatic.QUEST_MODE_WAIT_FOR_FINISH);
            }
            else
            {
                if (this.GetQuestDefinition().showRewardWindow)
                {
                    this.SetQuestMode(QuestManagerStatic.QUEST_MODE_INIT_REWARD_WINDOW);
                }
                else
                {
                    this.SetQuestMode(QuestManagerStatic.QUEST_MODE_PRESS_REWARD_BUTTON);
                };
            };
            _arg_1.channels.QUEST.questModeChanged(this);
            this.isReset = false;
            this.lastResetStartDelay = 0;
        }

        public function IsActive():Boolean
        {
            return (!(this.mQuestDefinition == null));
        }

        public function SetTriggerFailed(_arg_1:int):void
        {
            this.SetTriggerStatus(_arg_1, -1);
        }

        public function IsQuestTriggerValid(_arg_1:int):Boolean
        {
            if (_arg_1 == QuestManagerStatic.SERVER_STACK_REWARD_BUTTON_OK)
            {
                if (this.GetQuestMode() != QuestManagerStatic.QUEST_MODE_REWARD_WINDOW_WAIT_FOR_BUTTON_ACTIVE)
                {
                    return (false);
                };
            };
            return (true);
        }


    }
}
