package Communication.VO
{
    import Model.Notifier;
    import Model.Observer;
    import mx.collections.ArrayCollection;
    import Utils.HashMapWrapper;
    import converted.bluebyte.tso.quests.logic.QuestManagerStatic;
    import __AS3__.vec.Vector;
    import Utils.StringUtils;
    import __AS3__.vec.*;

    public class dQuestPoolVO extends Notifier implements Observer 
    {

        public static const POOL_NOTIFICATION_string:String = "mQuestVO_vector";

        public var mQuestVO_vector:ArrayCollection = new ArrayCollection();
        [Transient]
        public const mQuestName2QuestElement:HashMapWrapper = new HashMapWrapper();
        [Transient]
        public const mActiveQuestsMap:HashMapWrapper = new HashMapWrapper();
        [Transient]
        public const mQuestUID2QuestElement:HashMapWrapper = new HashMapWrapper();

        public function dQuestPoolVO()
        {
            super();
            this.mQuestVO_vector.disableAutoUpdate();
        }

        public function GetQuestFromName(_arg_1:String):dQuestElementVO
        {
            return (this.mQuestName2QuestElement.getItem(_arg_1) as dQuestElementVO);
        }

        public function GetNofQuestsActive():int
        {
            return (this.mQuestVO_vector.length);
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            var _local_4:dQuestElementVO;
            if (_arg_2 == "mQuestMode")
            {
                _local_4 = (_arg_1 as dQuestElementVO);
                if (QuestManagerStatic.isQuestActive(_local_4.mQuestMode))
                {
                    this.mActiveQuestsMap.putItem(_local_4.getQuestName_string(), _local_4);
                }
                else
                {
                    if (this.mActiveQuestsMap.hasKey(_local_4.getQuestName_string()))
                    {
                        this.mActiveQuestsMap.remove(_local_4.getQuestName_string());
                    };
                };
            };
        }

        public function RemoveAllQuests():void
        {
            var _local_1:dQuestElementVO;
            for each (_local_1 in this.mQuestName2QuestElement.valueSet())
            {
                _local_1.removePropertyObserver("mQuestMode", this);
            };
            this.mQuestVO_vector.removeAll();
            this.mQuestName2QuestElement.clear();
            this.mActiveQuestsMap.clear();
            this.mQuestUID2QuestElement.clear();
        }

        public function GetRunningQuestSeriesInPool(_arg_1:String):Vector.<dQuestElementVO>
        {
            var _local_3:dQuestElementVO;
            var _local_2:Vector.<dQuestElementVO> = new Vector.<dQuestElementVO>();
            for each (_local_3 in this.mQuestVO_vector)
            {
                if (_local_3.mQuestMode < QuestManagerStatic.QUEST_MODE_DEACTIVATED)
                {
                    if (_local_3.getQuestName_string() == _arg_1)
                    {
                        _local_2.push(_local_3);
                    }
                    else
                    {
                        if (QuestManagerStatic.CheckPreviousQuestDefinitionRecursiv(_local_3.mQuestDefinition, _arg_1))
                        {
                            _local_2.push(_local_3);
                        };
                    };
                };
            };
            return (_local_2);
        }

        public function IsTriggerInAtLeastOneQuestAndQuestRunning(_arg_1:int):Boolean
        {
            var _local_2:dQuestElementVO;
            if (!QuestManagerStatic.IsActive())
            {
                return (false);
            };
            for each (_local_2 in this.mQuestVO_vector)
            {
                if (_local_2.mQuestMode < QuestManagerStatic.QUEST_MODE_DEACTIVATED)
                {
                    if (_local_2.IsTriggerInQuest(_arg_1))
                    {
                        return (true);
                    };
                };
            };
            return (false);
        }

        public function GetQuest_vector():ArrayCollection
        {
            return (this.mQuestVO_vector);
        }

        public function IsAnyQuestsActive():Boolean
        {
            return (this.mQuestVO_vector.length > 0);
        }

        public function GetQuestFromIndex(_arg_1:int):dQuestElementVO
        {
            return (this.mQuestVO_vector.getItemAt(_arg_1) as dQuestElementVO);
        }

        public function RemoveQuest(_arg_1:dQuestElementVO):void
        {
            var _local_3:dQuestElementVO;
            var _local_2:int;
            while (_local_2 < this.mQuestVO_vector.length)
            {
                _local_3 = (this.mQuestVO_vector.getItemAt(_local_2) as dQuestElementVO);
                if (_arg_1.mUniqueID.eq(_local_3.mUniqueID))
                {
                    this.mQuestVO_vector.removeItemAt(_local_2);
                    break;
                };
                _local_2++;
            };
            this.mQuestUID2QuestElement.remove(_arg_1.GetUniqueId().toKeyString());
            this.mQuestName2QuestElement.remove(_arg_1.getQuestName_string());
            _arg_1.removePropertyObserver("mQuestMode", this);
            if (this.mActiveQuestsMap.hasKey(_arg_1.getQuestName_string()))
            {
                this.mActiveQuestsMap.remove(_arg_1.getQuestName_string());
            };
            notifyPropertyObserver(POOL_NOTIFICATION_string, _arg_1);
        }

        public function IsQuestActiveList(_arg_1:String):Boolean
        {
            var _local_2:String;
            for each (_local_2 in _arg_1.split(","))
            {
                if (this.mActiveQuestsMap.hasKey(_local_2))
                {
                    return (true);
                };
            };
            return (false);
        }

        override public function dispose():void
        {
            super.dispose();
            this.RemoveAllQuests();
        }

        public function GetQuestFromUniqueID(_arg_1:dUniqueID):dQuestElementVO
        {
            var _local_2:dQuestElementVO;
            if (((this.mQuestUID2QuestElement.isEmpty()) && (this.mQuestVO_vector.length > 0)))
            {
                for each (_local_2 in this.mQuestVO_vector)
                {
                    this.mQuestUID2QuestElement.putItem(_local_2.GetUniqueId().toKeyString(), _local_2);
                };
            };
            return (this.mQuestUID2QuestElement.getItem(_arg_1.toKeyString()) as dQuestElementVO);
        }

        public function GetQuestThatStartsWith(_arg_1:String):dQuestElementVO
        {
            var _local_2:dQuestElementVO;
            for each (_local_2 in this.mQuestVO_vector)
            {
                if (_local_2.getQuestName_string().indexOf(_arg_1) >= 0)
                {
                    return (_local_2);
                };
            };
            return (null);
        }

        public function GetQuestsFromWildcard(_arg_1:String, _arg_2:Boolean):Vector.<dQuestElementVO>
        {
            var _local_4:dQuestElementVO;
            var _local_3:Vector.<dQuestElementVO> = new Vector.<dQuestElementVO>();
            for each (_local_4 in this.mQuestVO_vector)
            {
                if (_arg_2)
                {
                    if (_local_4.getQuestName_string().indexOf(_arg_1) == 0)
                    {
                        _local_3.push(_local_4);
                    };
                }
                else
                {
                    if (_local_4.getQuestName_string().indexOf(_arg_1) != -1)
                    {
                        _local_3.push(_local_4);
                    };
                };
            };
            return (_local_3);
        }

        public function IsQuestTriggerInAtLeastOneQuestValid(_arg_1:int):Boolean
        {
            var _local_2:dQuestElementVO;
            if (!QuestManagerStatic.IsActive())
            {
                return (false);
            };
            for each (_local_2 in this.mQuestVO_vector)
            {
                if (_local_2.IsQuestTriggerValid(_arg_1))
                {
                    return (true);
                };
            };
            return (false);
        }

        public function ContainsTriggerCondition(_arg_1:int, _arg_2:int, _arg_3:String, _arg_4:String, _arg_5:String, _arg_6:String):Boolean
        {
            var _local_7:dQuestElementVO;
            if (!QuestManagerStatic.IsActive())
            {
                return (false);
            };
            for each (_local_7 in this.mQuestVO_vector)
            {
                if (_local_7.mQuestMode < QuestManagerStatic.QUEST_MODE_DEACTIVATED)
                {
                    if (((_local_7.IsATriggerConditionName(_arg_1, _arg_2, _arg_3)) || (_local_7.ContainsNewTrigger(_arg_4, _arg_5, _arg_6))))
                    {
                        return (true);
                    };
                };
            };
            return (false);
        }

        public function AddOrUpdateQuest(_arg_1:dQuestElementVO):void
        {
            var _local_2:dQuestElementVO = this.GetQuestFromUniqueID(_arg_1.GetUniqueId());
            if ((((_local_2 == null) && (!(_arg_1.getQuestName_string() == null))) && (!(_arg_1.mQuestDefinition == null))))
            {
                if (((StringUtils.startsWith(_arg_1.getQuestName_string(), "Birthday2018plus")) && (!(_arg_1.mQuestDefinition.questTyp == QuestManagerStatic.QUEST_TYPE_DAILY_QUEST))))
                {
                    _local_2 = this.GetQuestFromName(_arg_1.getQuestName_string());
                };
            };
            if (_local_2 != null)
            {
                if (_arg_1.NewerThan(_local_2))
                {
                    _local_2.updateFrom(_arg_1);
                    return;
                };
                _local_2.mQuestTriggersFinished_vector = _arg_1.mQuestTriggersFinished_vector;
                _local_2.mQuestTriggersFinishedGuiRefreshCache_vector = _arg_1.mQuestTriggersFinishedGuiRefreshCache_vector;
                return;
            };
            this.mQuestVO_vector.addItem(_arg_1);
            this.mQuestUID2QuestElement.putItem(_arg_1.GetUniqueId().toKeyString(), _arg_1);
            if (!this.mQuestName2QuestElement.hasKey(_arg_1.getQuestName_string()))
            {
                _arg_1.addPropertyObserver("mQuestMode", this);
                this.update(_arg_1, "mQuestMode", null);
            };
            this.mQuestName2QuestElement.putItem(_arg_1.getQuestName_string(), _arg_1);
            notifyPropertyObserver(POOL_NOTIFICATION_string, _arg_1);
        }

        public function IsQuestCompleted(_arg_1:String):Boolean
        {
            var _local_2:dQuestElementVO = (this.mQuestName2QuestElement.getItem(_arg_1) as dQuestElementVO);
            if (_local_2 != null)
            {
                return (_local_2.mQuestMode == QuestManagerStatic.QUEST_MODE_REWARD_COLLECTED_IDLE);
            };
            return (false);
        }

        public function IsQuestDefinitionInPool(_arg_1:dQuestDefinitionVO):Boolean
        {
            var _local_2:dQuestElementVO;
            for each (_local_2 in this.mQuestVO_vector)
            {
                if (_local_2.mQuestDefinition == _arg_1)
                {
                    return (true);
                };
            };
            return (false);
        }

        public function CheckQuestTrigger(_arg_1:int, _arg_2:int, _arg_3:String):void
        {
            var _local_4:dQuestElementVO;
            for each (_local_4 in this.mQuestVO_vector)
            {
                if (_local_4.mQuestMode < QuestManagerStatic.QUEST_MODE_DEACTIVATED)
                {
                    _local_4.CheckTriggerConditionName(_arg_1, _arg_2, _arg_3);
                };
            };
        }


    }
}
