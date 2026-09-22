package com.bluebyte.tso.quests.logic
{
    import converted.bluebyte.tso.quests.logic.IQuestManager;
    import Communication.VO.dQuestPoolVO;
    import Communication.VO.dQuestElementVO;
    import Interface.cGeneralInterface;
    import Interface.cGameInterface;
    import converted.bluebyte.tso.quests.logic.QuestManagerStatic;
    import Communication.VO.dUniqueID;
    import Communication.VO.dQuestDefinitionVO;
    import Communication.VO.dServerAction;
    import Enums.COMMAND;
    import converted.bluebyte.tso.quests.trigger.QuestTriggerFactory;
    import Communication.VO.TriggerVO;
    import converted.bluebyte.tso.quests.trigger.QuestTrigger;
    import Trigger.InteractivityTrigger;
    import Fulfilments.Trigger.FulfilmentTrigger;
    import Trigger.Triggers.GlobalDonationTrigger;
    import Trigger.Triggers.EventTimeTrigger;
    import Enums.TRIGGER_ACTION;
    import Trigger.Trigger;
    import nLib.cLog;
    import Communication.VO.dAdventCalendarDoorVO;
    import BuffSystem.cBuffDefinition;
    import Specialists.cSpecialistDescription;
    import Utils.StringUtils;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import Specialists.cSpecialist;
    import Skill.SkillDefinition;
    import Trigger.Triggers.ResourceDonatedTrigger;
    import com.bluebyte.tso.util.TimeUtil;
    import Trigger.Triggers.BuffActiveTrigger;
    import Communication.VO.Guild.dGuildPlayerListItemVO;
    import Communication.VO.dQuestDefinitionTriggerVO;
    import Communication.VO.dQuestTriggerVO;
    import Communication.VO.Guild.dGuildVO;
    import GO.cBuilding;
    import Enums.AVATAR_MESSAGE_TYPE;
    import GUI.Effects.gHintManager;
    import Communication.VO.dZoneVO;
    import Collections.CollectionsConsts;
    import ServerState.cPlayerData;
    import Communication.VO.UpdateVO.dAdventureClientInfoVO;
    import Communication.VO.dGameTickCommandVO;
    import com.bluebyte.tso.adventure.logic.AdventureManager;
    import AdventureSystem.cAdventureDefinition;
    import Colony.cColony;
    import Model.Observers.OneHitUIObserver;
    import Communication.VO.UpdateVO.dQuestUpdateVO;
    import ServerState.cResources;
    import Skill.cSkillList;
    import Skill.cSkillTree;
    import Skill.cSkill;
    import __AS3__.vec.Vector;
    import MilitarySystem.cSquad;
    import BuffSystem.cBuff;
    import ServerState.cEconomyOverviewData;
    import ServerState.dEconomyOverviewDataResult;
    import MilitarySystem.cArmy;
    import Enums.SPECIALIST_TYPE;
    import Utils.HashMapWrapper;
    import Communication.VO.dQuestDefinitionPostrequisitsVO;
    import flash.utils.Dictionary;

    public class QuestClientCallbacks implements IQuestManager 
    {

        public static var TRIGGER_UNSUPPORTED:int = -200000;

        private var mHomeQuestPool:dQuestPoolVO;
        private var mLastActiveQuestWindow:dQuestElementVO;
        private var mGeneralInterface:cGeneralInterface;
        private var needsRefreshQuestList:Boolean;
        private var observer:QuestObserver;
        private var dailyLoginAlreadyShowed:Boolean = false;
        private var mClientQuestPool:dQuestPoolVO;

        public function QuestClientCallbacks(_arg_1:cGeneralInterface)
        {
            super();
            this.mGeneralInterface = _arg_1;
            this.mHomeQuestPool = new dQuestPoolVO();
            this.observer = new QuestObserver((this.mGeneralInterface as cGameInterface), this.mHomeQuestPool);
            this.needsRefreshQuestList = false;
        }

        public function hasQuest(_arg_1:String):Boolean
        {
            return (!(this.getQuest(_arg_1) == null));
        }

        public function SaveQuestPool():void
        {
            this.mHomeQuestPool = this.mClientQuestPool;
        }

        public function GetQuestPool():dQuestPoolVO
        {
            return (this.mClientQuestPool);
        }

        public function cancelQuest(_arg_1:String, _arg_2:String):void
        {
            this.resetQuest(_arg_1, 0);
        }

        public function InitiatePayForQuestFinish(_arg_1:dUniqueID):void
        {
            if (((!(this.IsActive())) || (!(this.mGeneralInterface.IsCurrentPlayerQuestPlayer()))))
            {
                return;
            };
            this.SendServerQuestTrigger(QuestManagerStatic.SERVER_STACK_PAY_FOR_QUEST_FINISH, _arg_1);
        }

        public function finishQuest(_arg_1:String):void
        {
        }

        public function startQuest(_arg_1:dQuestDefinitionVO, _arg_2:int):void
        {
        }

        private function SendServerQuestTrigger(_arg_1:int, _arg_2:Object):void
        {
            var _local_3:dServerAction;
            _local_3 = new dServerAction();
            _local_3.type = _arg_1;
            _local_3.data = _arg_2;
            this.mGeneralInterface.mClientMessages.SendMessagetoServer(COMMAND.QUEST_TRIGGER, this.mGeneralInterface.mCurrentViewedZoneID, _local_3);
        }

        private function RefreshQuestList(_arg_1:dQuestPoolVO):void
        {
            var _local_2:dQuestElementVO;
            var _local_3:int;
            var _local_4:QuestTriggerFactory;
            var _local_5:int;
            var _local_6:TriggerVO;
            var _local_7:QuestTrigger;
            var _local_8:InteractivityTrigger;
            var _local_9:dQuestElementVO;
            _local_3 = 0;
            while (_local_3 < _arg_1.mQuestVO_vector.length)
            {
                _local_2 = (_arg_1.mQuestVO_vector.getItemAt(_local_3) as dQuestElementVO);
                this.ShowCurrentQuestWindow(_local_2, true, false);
                this.mClientQuestPool.AddOrUpdateQuest(_local_2);
                if (_local_2.IsRunning())
                {
                    _local_4 = new QuestTriggerFactory(this.mGeneralInterface, _local_2);
                    if (_local_2.GetQuestDefinition().endConditions_vector != null)
                    {
                        _local_5 = 0;
                        while (_local_5 < _local_2.GetQuestDefinition().endConditions_vector.length)
                        {
                            _local_6 = _local_2.GetQuestDefinition().endConditions_vector[_local_5];
                            _local_7 = (_local_4.createTrigger(_local_6, null) as QuestTrigger);
                            _local_8 = (_local_7.getInnerTrigger() as InteractivityTrigger);
                            if (((!(_local_8 == null)) && (!(_local_7.check()))))
                            {
                                _local_8.createUIObserver();
                            };
                            _local_7.dispose();
                            _local_5++;
                        };
                    };
                };
                _local_3++;
            };
            _local_3 = 0;
            while (_local_3 < this.mClientQuestPool.mQuestVO_vector.length)
            {
                _local_2 = (this.mClientQuestPool.mQuestVO_vector.getItemAt(_local_3) as dQuestElementVO);
                if (((!(_local_2.mQuestDefinition.connectedToQuest_string == "")) && (!(QuestManagerStatic.IsPartialGuildQuest(_local_2.mQuestDefinition)))))
                {
                    _local_9 = this.mClientQuestPool.GetQuestFromName(_local_2.mQuestDefinition.connectedToQuest_string);
                    if (((_local_9 == null) || (!(_local_9.IsRunning()))))
                    {
                        _local_2.mQuestDefinition.connectedToQuest_string = "";
                    };
                };
                _local_3++;
            };
            _local_3 = 0;
            while (_local_3 < this.mClientQuestPool.mQuestVO_vector.length)
            {
                _local_2 = (this.mClientQuestPool.mQuestVO_vector.getItemAt(_local_3) as dQuestElementVO);
                if (_arg_1.GetQuestFromUniqueID(_local_2.mUniqueID) == null)
                {
                    this.mClientQuestPool.RemoveQuest(_local_2);
                    _local_3--;
                };
                _local_3++;
            };
            this.RefreshLastQuestList(null);
        }

        public function getNewTriggerRemaining(_arg_1:Trigger):int
        {
            var _local_4:Number;
            var _local_5:QuestTrigger;
            var _local_6:FulfilmentTrigger;
            var _local_2:Number = this.getNewTriggerTotal(_arg_1.getDefinition());
            var _local_3:int;
            if ((_arg_1 is QuestTrigger))
            {
                _local_5 = (_arg_1 as QuestTrigger);
                if (!_local_5.isRunning())
                {
                    return (0);
                };
                _local_3 = 1;
                _local_4 = _local_5.getCurrentAmount();
            }
            else
            {
                if ((_arg_1 is FulfilmentTrigger))
                {
                    _local_6 = (_arg_1 as FulfilmentTrigger);
                    if (((!(_local_6.isRunning())) || (_local_6.getFinished())))
                    {
                        return (0);
                    };
                    _local_3 = 1;
                    _local_4 = _local_6.getCurrentAmount();
                };
            };
            switch (_arg_1.getDefinition().action_string)
            {
                case GlobalDonationTrigger.XML_string:
                    return (global.eventDonations.getPhaseRemaining(_arg_1.getDefinition().id, (_arg_1.getDefinition().target_string == "lost")));
                case EventTimeTrigger.XML_string:
                    return (1);
                case TRIGGER_ACTION.ACTION_HOURS_ELAPSED_string:
                    return (Math.max(_local_3, (_local_2 - _arg_1.getCurrentAmount())));
            };
            if ((((_arg_1.getDefinition().min == 0) && (_arg_1.getDefinition().max > 0)) && (_arg_1.getDefinition().max < 100100100)))
            {
                return ((_arg_1.check()) ? 0 : 1);
            };
            return (Math.max(_local_3, (_local_2 - _local_4)));
        }

        public function CheckKeyPress(_arg_1:String):void
        {
            if (((!(this.IsActive())) || (!(this.mGeneralInterface.IsCurrentPlayerQuestPlayer()))))
            {
                return;
            };
            if (this.mClientQuestPool.ContainsTriggerCondition(QuestManagerStatic.TYPE_KEY_PRESS, QuestManagerStatic.CONDITION_UNSET, _arg_1, null, null, null))
            {
                this.SendServerQuestTrigger(QuestManagerStatic.SERVER_STACK_KEYPRESS, _arg_1);
                this.mClientQuestPool.CheckQuestTrigger(QuestManagerStatic.TYPE_KEY_PRESS, QuestManagerStatic.CONDITION_UNSET, _arg_1);
            };
        }

        public function getQuestByUID(_arg_1:dUniqueID):dQuestElementVO
        {
            return ((_arg_1 == null) ? null : this.mClientQuestPool.GetQuestFromUniqueID(_arg_1));
        }

        public function RefreshLastQuestListDeferred():void
        {
            if (this.needsRefreshQuestList)
            {
                this.needsRefreshQuestList = false;
                globalFlash.gui.mQuestBook.SetQuestData(this.mClientQuestPool);
            };
        }

        public function RefreshLastQuestList(_arg_1:dQuestElementVO):void
        {
            if (_arg_1 != null)
            {
                this.mClientQuestPool.AddOrUpdateQuest(_arg_1);
            };
            this.needsRefreshQuestList = true;
        }

        public function RewardOkButtonPressedFromGui(_arg_1:dQuestElementVO):void
        {
            if (((!(this.IsActive())) || (!(this.mGeneralInterface.IsCurrentPlayerQuestPlayer()))))
            {
                return;
            };
            var _local_2:dUniqueID;
            if (_arg_1 != null)
            {
                _arg_1.SetQuestMode(QuestManagerStatic.QUEST_MODE_LOOP_UNTIL_QUEST_REWARD_COULD_BE_ASSIGNED);
                _local_2 = _arg_1.GetUniqueId();
            }
            else
            {
                cLog.error("RewardOkButtonPressedFromGui: Quest is null or not found!");
            };
            this.SendServerQuestTrigger(QuestManagerStatic.SERVER_STACK_REWARD_BUTTON_OK, _local_2);
        }

        public function JustRefresh():void
        {
            if (((!(this.IsActive())) || (!(this.mGeneralInterface.IsCurrentPlayerQuestPlayer()))))
            {
                return;
            };
            this.SendServerQuestTrigger(QuestManagerStatic.SERVER_STACK_JUST_REFRESH, null);
        }

        public function getNewTriggerText(_arg_1:TriggerVO, _arg_2:Trigger=null):String
        {
            var _local_5:Array;
            var _local_6:int;
            var _local_7:dAdventCalendarDoorVO;
            var _local_8:String;
            var _local_9:cBuffDefinition;
            var _local_10:Array;
            var _local_11:String;
            var _local_12:Number;
            var _local_13:int;
            var _local_14:String;
            var _local_15:cSpecialistDescription;
            var _local_3:String = _arg_1.action_string;
            var _local_4:* = "";
            switch (_arg_1.action_string)
            {
                case TRIGGER_ACTION.ACTION_SPECIALIST_TASK_RESULT_TYPE_string:
                    _local_5 = [_arg_1.amount, _arg_1.item_string, _arg_1.type_string];
                    break;
                case TRIGGER_ACTION.ACTION_LOOTED_RESOURCE_string:
                    _local_5 = [_arg_1.amount, _arg_1.type_string];
                    break;
                case TRIGGER_ACTION.ACTION_CLICK_string:
                case TRIGGER_ACTION.ACTION_WINDOW_OPEN_string:
                case TRIGGER_ACTION.ACTION_WINDOW_CLOSE_string:
                    _local_3 = ("ui_" + _arg_1.item_string);
                    _local_5 = [_arg_1.loca_string];
                    _local_4 = ("WindowOpen_" + _arg_1.item_string);
                    break;
                case TRIGGER_ACTION.ACTION_BUILDING_SELECTED_string:
                case TRIGGER_ACTION.ACTION_QUEST_ACTIVE_string:
                case TRIGGER_ACTION.ACTION_QUEST_COMPLETE_string:
                    _local_5 = [_arg_1.item_string];
                    break;
                case TRIGGER_ACTION.ACTION_PRODUCTION_TIME_string:
                    _local_5 = [_arg_1.item_string, int((_arg_1.max / 60)), (_arg_1.max % 60)];
                    break;
                case TRIGGER_ACTION.ACTION_PRODUCTION_VALUE_string:
                    _local_6 = int((global.economyCalculationTime / 3600));
                    _local_5 = [_arg_1.item_string, (_arg_1.min * _local_6), _local_6];
                    break;
                case TRIGGER_ACTION.ACTION_PLAYERPVPLEVEL_string:
                    _local_5 = [_arg_1.min];
                    break;
                case TRIGGER_ACTION.ACTION_BUFF_APPLIED_string:
                    _local_5 = [_arg_1.min, _arg_1.item_string];
                    _arg_1.item_string = _arg_1.item_string.replace("*", "");
                    if (StringUtils.isEmpty(_arg_1.item_string))
                    {
                        _local_3 = (_local_3 + "_any");
                    };
                    if (!StringUtils.isEmpty(_arg_1.target_string))
                    {
                        _local_5.push(_arg_1.target_string);
                        _local_3 = (_local_3 + "_on");
                    };
                    if (!StringUtils.isEmpty(_arg_1.type_string))
                    {
                        _local_5.push(_arg_1.type_string);
                    };
                    break;
                case TRIGGER_ACTION.ACTION_BUILDING_LIST_UPGRADE_LEVEL_string:
                case TRIGGER_ACTION.ACTION_BUILDING_UPGRADELEVEL_string:
                    _local_5 = [_arg_1.amount, _arg_1.min];
                    if (StringUtils.isEmpty(_arg_1.item_string))
                    {
                        _local_3 = (_local_3 + "_any");
                    }
                    else
                    {
                        _local_5.push(_arg_1.item_string);
                    };
                    break;
                case TRIGGER_ACTION.ACTION_POPULATION_string:
                    _local_3 = (_local_3 + ("_" + _arg_1.item_string));
                    _local_5 = [_arg_1.min];
                    break;
                case TRIGGER_ACTION.ACTION_CALENDAR_DOOR_OPENED_string:
                    _local_7 = this.mGeneralInterface.mAdventCalendarManager.GetDoorById(_arg_1.item_string);
                    if (_local_7)
                    {
                        _local_5 = [cLocaManager.GetInstance().FormatDate(_local_7.openDateTimestamp)];
                    };
                    break;
                case TRIGGER_ACTION.ACTION_GARRISON_ON_MAP_string:
                    _local_5 = [this.getNewTriggerTotal(_arg_1), "Garrison"];
                    break;
                case TRIGGER_ACTION.ACTION_HAS_ACHIEVEMENT_POINTS_string:
                    _local_8 = cLocaManager.GetInstance().GetText(LOCA_GROUP.ACHIEVEMENT_LABELS, _arg_1.item_string);
                    _local_5 = [_local_8, _arg_1.min];
                    break;
                case TRIGGER_ACTION.ACTION_BUFF_APPLIED_ON_ADVENTURE_string:
                    if (!StringUtils.isEmpty(_arg_1.target_string))
                    {
                        _local_3 = (_local_3 + "_target");
                    };
                    _local_5 = [this.getNewTriggerTotal(_arg_1), _arg_1.item_string, _arg_1.target_string];
                    break;
                case TRIGGER_ACTION.ACTION_BUFF_RECEIVED_FROM_FRIEND_string:
                    if (!StringUtils.isEmpty(_arg_1.item_string))
                    {
                        _local_3 = (_local_3 + "_item");
                    };
                    if (!StringUtils.isEmpty(_arg_1.target_string))
                    {
                        _local_3 = (_local_3 + "_on");
                    };
                    _local_5 = [this.getNewTriggerTotal(_arg_1), _arg_1.item_string, _arg_1.target_string];
                    break;
                case TRIGGER_ACTION.ACTION_BUFF_PRODUCED_string:
                    _local_5 = [this.getNewTriggerTotal(_arg_1), _arg_1.item_string];
                    _local_9 = (global.map_BuffName_BuffDefinition[_arg_1.item_string] as cBuffDefinition);
                    if (_local_9)
                    {
                        _local_5.push(_local_9.GetResourceName_string());
                    };
                    if (StringUtils.startsWith(_arg_1.item_string, defines.ADD_RESOURCE_BUFF))
                    {
                        _local_3 = (_local_3 + "_convert");
                    };
                    break;
                case TRIGGER_ACTION.ACTION_BUFF_INSUFFICIENT_FOR_ENEMIES_string:
                    _local_5 = [_arg_1.target_string, _arg_1.item_string];
                    break;
                case TRIGGER_ACTION.ACTION_BUFF_INSUFFICIENT_TARGET_BUILDINGS_string:
                    _local_5 = [_arg_1.item_string];
                    break;
                case TRIGGER_ACTION.ACTION_TIMED_PRODUCED_ITEM_LIST_string:
                case TRIGGER_ACTION.ACTION_PAY_TO_FINISH_string:
                    _local_5 = [_arg_1.amount, _arg_1.item_string];
                    break;
                case TRIGGER_ACTION.ACTION_COMPLETE_ADVENTURE_LIST_string:
                    if (_arg_1.loca_string == "Adv_Single")
                    {
                        _local_5 = [_arg_1.type_string];
                    }
                    else
                    {
                        _local_5 = [_arg_1.amount, _arg_1.item_string];
                    };
                    break;
                case TRIGGER_ACTION.ACTION_COMPLETE_QUEST_LIST_string:
                    _local_10 = [];
                    for each (_local_14 in _arg_1.item_string.split(","))
                    {
                        _local_10.push(cLocaManager.GetInstance().GetText(LOCA_GROUP.QUEST_LABELS, _local_14));
                    };
                    _local_5 = [_arg_1.amount, _local_10.join(", ")];
                    break;
                case TRIGGER_ACTION.ACTION_RESOURCE_GATHERED_string:
                    _local_5 = [_arg_1.min, _arg_1.type_string];
                    break;
                case TRIGGER_ACTION.ACTION_SKILLTREEPOINTS_string:
                    _local_11 = "";
                    for each (_local_15 in cSpecialist.GetAllSpecialistDescriptions())
                    {
                        if (((_local_15.GetType() == _local_15.getBaseType()) && (_local_15.GetSkillType_string() == _arg_1.item_string)))
                        {
                            _local_11 = _local_15.getName_string();
                            break;
                        };
                    };
                    _local_5 = [_arg_1.min, SkillDefinition.getResourceByType_string(_arg_1.type_string), _local_11];
                    break;
                case ResourceDonatedTrigger.XML_string:
                    if (_arg_1.type_string == "guildbank")
                    {
                        _local_3 = (_local_3 + "_guildbank");
                    };
                    _local_5 = [this.getNewTriggerTotal(_arg_1), _arg_1.name_string];
                    break;
                case EventTimeTrigger.XML_string:
                    _local_12 = 0;
                    if (_arg_1.type_string == "start")
                    {
                        _local_3 = (_local_3 + "_start");
                        _local_12 = Math.max(0, (this.mGeneralInterface.mEventManager.GetEventStartDate(_arg_1.name_string) - TimeUtil.getServerTime()));
                    }
                    else
                    {
                        _local_3 = (_local_3 + "_end");
                        _local_12 = Math.max(0, (this.mGeneralInterface.mEventManager.GetEventStopDate(_arg_1.name_string) - TimeUtil.getServerTime()));
                    };
                    _local_5 = [cLocaManager.GetInstance().FormatDuration(_local_12), _arg_1.name_string];
                    break;
                case TRIGGER_ACTION.ACTION_HOURS_ELAPSED_string:
                    _local_13 = ((_arg_2) ? this.getNewTriggerRemaining(_arg_2) : this.getNewTriggerTotal(_arg_1));
                    _local_5 = [cLocaManager.GetInstance().FormatDuration((((_local_13 * 60) * 60) * 1000))];
                    break;
                case TRIGGER_ACTION.ACTION_ZONE_BUFF_ACTIVE:
                    _local_5 = [this.getNewTriggerTotal(_arg_1), _arg_1.name_string];
                    break;
                case BuffActiveTrigger.XML_string:
                    _local_5 = [this.getNewTriggerTotal(_arg_1), _arg_1.name_string, _arg_1.target_string];
                    break;
                case TRIGGER_ACTION.ACTION_ONMAP_string:
                case TRIGGER_ACTION.ACTION_BUFF_OWNED_string:
                case TRIGGER_ACTION.ACTION_RESOURCE_string:
                case TRIGGER_ACTION.ACTION_BANDITS_string:
                default:
                    _local_5 = [this.getNewTriggerTotal(_arg_1), _arg_1.item_string];
            };
            if (!StringUtils.isEmpty(_arg_1.loca_string))
            {
                _local_3 = (_local_3 + ("_" + _arg_1.loca_string));
                if (_local_4 != "")
                {
                    _local_4 = (_local_4 + ("_" + _arg_1.loca_string));
                };
            };
            if (_arg_1.isFailTrigger)
            {
                _local_3 = (_local_3 + "_fail");
            };
            if (((!(cLocaManager.GetInstance().hasText(LOCA_GROUP.QUEST_TRIGGERS, _local_3))) && (!(_local_4 == ""))))
            {
                return (cLocaManager.GetInstance().GetText(LOCA_GROUP.QUEST_TRIGGERS, _local_4, _local_5));
            };
            return (cLocaManager.GetInstance().GetText(LOCA_GROUP.QUEST_TRIGGERS, _local_3, _local_5));
        }

        public function GetGuildQuestTriggerData(_arg_1:int):Object
        {
            var _local_9:dGuildPlayerListItemVO;
            var _local_2:dQuestDefinitionTriggerVO = new dQuestDefinitionTriggerVO();
            _local_2.type = QuestManagerStatic.TYPE_FINISHPERCENTAGE;
            _local_2.condition = QuestManagerStatic.CONDITION_UNSET;
            var _local_3:dQuestTriggerVO = new dQuestTriggerVO();
            var _local_4:int;
            var _local_5:int;
            var _local_6:dGuildVO = this.mGeneralInterface.GetCurrentPlayerGuild();
            var _local_7:Boolean;
            if (_local_6 != null)
            {
                for each (_local_9 in _local_6.members)
                {
                    if (_local_9.quest.status >= QuestManagerStatic.GUILD_QUEST_MODE_RUNNING_DAILY)
                    {
                        _local_5++;
                    };
                    if (_local_9.quest.status == QuestManagerStatic.GUILD_QUEST_MODE_FINISHED)
                    {
                        _local_4++;
                        if (_local_9.id == this.mGeneralInterface.mCurrentPlayer.getPlayerID())
                        {
                            _local_7 = true;
                        };
                    };
                };
            }
            else
            {
                _local_4 = 0;
                _local_5 = 1;
            };
            var _local_8:int = (_local_5 - _local_4);
            _local_3.status = ((_local_8 > 0) ? 0 : 1);
            return ({
                "definition":_local_2,
                "trigger":_local_3,
                "remaining":((_local_8 < 0) ? 0 : _local_8),
                "total":_local_5,
                "contributed":_local_7
            });
        }

        public function GetLatestQuestList():void
        {
            if (((!(this.IsActive())) || (!(this.mGeneralInterface.IsCurrentPlayerQuestPlayer()))))
            {
                return;
            };
            this.SendServerQuestTrigger(QuestManagerStatic.SERVER_STACK_GET_LATEST_QUEST_LIST, null);
        }

        public function BuildingSelectedGui(_arg_1:cBuilding):void
        {
            if (((!(this.IsActive())) || (!(this.mGeneralInterface.IsCurrentPlayerQuestPlayer()))))
            {
                return;
            };
            if (this.mClientQuestPool.ContainsTriggerCondition(QuestManagerStatic.TYPE_BUILDING, QuestManagerStatic.CONDITION_SELECTED, _arg_1.GetBuildingName_string(), TRIGGER_ACTION.ACTION_BUILDING_SELECTED_string, _arg_1.GetBuildingName_string(), null))
            {
                this.SendServerQuestTrigger(QuestManagerStatic.SERVER_STACK_BUILDING_SELECTED, _arg_1.GetGrid());
                this.mClientQuestPool.CheckQuestTrigger(QuestManagerStatic.TYPE_BUILDING, QuestManagerStatic.CONDITION_SELECTED, _arg_1.GetBuildingName_string());
            };
        }

        public function ShowCurrentQuestWindow(_arg_1:dQuestElementVO, _arg_2:Boolean, _arg_3:Boolean):Boolean
        {
            var _local_5:Boolean;
            var _local_6:dQuestElementVO;
            var _local_7:int;
            var _local_8:dQuestTriggerVO;
            var _local_4:Boolean;
            this.mLastActiveQuestWindow = null;
            if (_arg_1.mQuestDefinition != null)
            {
                switch (_arg_1.GetQuestMode())
                {
                    case QuestManagerStatic.QUEST_MODE_RUNNING:
                        if (_arg_1.mQuestDefinition.showQuestWindow)
                        {
                            if (_arg_2)
                            {
                                this.mLastActiveQuestWindow = _arg_1;
                                _local_4 = true;
                            };
                        };
                        break;
                    case QuestManagerStatic.QUEST_MODE_START_WINDOW_DESCRIPTION_WAIT_FOR_BUTTON_PRESSED:
                        if (_arg_1.mQuestDefinition.showQuestWindow)
                        {
                            if (_arg_2)
                            {
                                _local_5 = true;
                                for each (_local_6 in this.mClientQuestPool.mQuestVO_vector)
                                {
                                    if (_arg_1.mUniqueID.eq(_local_6.mUniqueID))
                                    {
                                        if (!_arg_1.NewerThan(_local_6))
                                        {
                                            _local_5 = false;
                                            break;
                                        };
                                    };
                                };
                                if (((_local_5) || (_arg_3)))
                                {
                                    if (!globalFlash.gui.mAvatarMessageList.IsMessageInList(AVATAR_MESSAGE_TYPE.NEW_QUEST))
                                    {
                                        gHintManager.ShowNewQuestNotification(_arg_1);
                                        globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.NEW_QUEST);
                                    };
                                    this.mLastActiveQuestWindow = _arg_1;
                                    _local_4 = true;
                                };
                            };
                        };
                        break;
                    case QuestManagerStatic.QUEST_MODE_REWARD_WINDOW_WAIT_FOR_BUTTON_ACTIVE:
                        if (((_arg_2) && (_arg_1.mQuestDefinition.showRewardWindow)))
                        {
                            _local_7 = _arg_1.GetQuestDefinition().FindTriggerWithType(QuestManagerStatic.TYPE_DAILYLOGIN);
                            if (_local_7 != -1)
                            {
                                this.mLastActiveQuestWindow = _arg_1;
                                _local_8 = _arg_1.mQuestTriggersFinished_vector[_local_7];
                                if (_local_8.status < 0)
                                {
                                    globalFlash.gui.mDailyLoginPanel.SetData(_arg_1, -(_local_8.status));
                                }
                                else
                                {
                                    globalFlash.gui.mDailyLoginPanel.SetData(_arg_1, 0);
                                };
                                if (!this.dailyLoginAlreadyShowed)
                                {
                                    globalFlash.gui.TryShowPanel(globalFlash.gui.mDailyLoginPanel);
                                    this.dailyLoginAlreadyShowed = true;
                                };
                            }
                            else
                            {
                                _local_5 = true;
                                for each (_local_6 in this.mClientQuestPool.mQuestVO_vector)
                                {
                                    if (_arg_1.mUniqueID.eq(_local_6.mUniqueID))
                                    {
                                        if (!_arg_1.NewerThan(_local_6))
                                        {
                                            _local_5 = false;
                                            break;
                                        };
                                    };
                                };
                                if (((_local_5) || (_arg_3)))
                                {
                                    this.mLastActiveQuestWindow = _arg_1;
                                    gHintManager.ShowCompletedQuestNotification(_arg_1);
                                    _local_4 = true;
                                };
                            };
                        };
                        break;
                    case QuestManagerStatic.QUEST_MODE_WAIT_FOR_FINISH:
                        if (_arg_2)
                        {
                            this.mLastActiveQuestWindow = _arg_1;
                            _local_4 = true;
                        };
                        break;
                    case QuestManagerStatic.QUEST_MODE_QUEST_FAILED:
                        if (_arg_2)
                        {
                            this.mLastActiveQuestWindow = _arg_1;
                            gHintManager.ShowFailedQuestNotification(_arg_1);
                            _local_4 = true;
                        };
                        break;
                };
            };
            if (_local_4)
            {
                this.RefreshLastQuestList(_arg_1);
            };
            return (_local_4);
        }

        public function SetColorSchema(_arg_1:dQuestPoolVO):void
        {
            var _local_2:dQuestElementVO;
            if (((!(defines.FILTER_ACTIVATED)) || (!(this.mGeneralInterface.mCurrentPlayerZone.mZoneColorSchema == null))))
            {
                return;
            };
            var _local_3:String;
            var _local_4:String;
            for each (_local_2 in _arg_1.GetQuest_vector())
            {
                if (_local_2.mQuestMode == QuestManagerStatic.QUEST_MODE_RUNNING)
                {
                    _local_3 = _local_2.mQuestDefinition.colorSchema_string;
                    if (_local_3 != "")
                    {
                        _local_4 = _local_3;
                        gGfxResource.applyFilter(_local_4, this.mGeneralInterface);
                        break;
                    };
                };
            };
        }

        public function ZoneRefreshed(_arg_1:int, _arg_2:Boolean, _arg_3:Boolean, _arg_4:dZoneVO):void
        {
            var _local_5:dQuestElementVO;
            if (!QuestManagerStatic.IsActive())
            {
                return;
            };
            this.mClientQuestPool.dispose();
            this.RefreshQuestList(_arg_4.clientQuestPool);
            if (this.mGeneralInterface.IsCurrentPlayerQuestPlayer())
            {
                if (!_arg_2)
                {
                    this.mLastActiveQuestWindow = null;
                    for each (_local_5 in this.mClientQuestPool.GetQuest_vector())
                    {
                        if (_local_5.IsADailyLoginQuest())
                        {
                            if (this.ShowCurrentQuestWindow(_local_5, _arg_3, true)) break;
                        };
                    };
                    for each (_local_5 in this.mClientQuestPool.GetQuest_vector())
                    {
                        if ((((!(_local_5.IsADailyLoginQuest())) && (!(_local_5.mQuestMode == QuestManagerStatic.QUEST_MODE_WAIT_FOR_FINISH))) && (!(_local_5.mQuestMode == QuestManagerStatic.QUEST_MODE_RUNNING))))
                        {
                            if (this.ShowCurrentQuestWindow(_local_5, _arg_3, true)) break;
                        };
                    };
                }
                else
                {
                    for each (_local_5 in this.mClientQuestPool.GetQuest_vector())
                    {
                        if (!_local_5.IsADailyLoginQuest())
                        {
                            if (_local_5.mQuestMode != QuestManagerStatic.QUEST_MODE_RUNNING)
                            {
                                if (((this.mLastActiveQuestWindow == null) || (!(this.mLastActiveQuestWindow.IsEqualTo(_local_5)))))
                                {
                                    if (this.ShowCurrentQuestWindow(_local_5, true, true)) break;
                                };
                            };
                        };
                    };
                };
            };
        }

        public function GetTotalValuesForQuestTrigger(_arg_1:cPlayerData, _arg_2:dQuestElementVO, _arg_3:int):int
        {
            var _local_5:dQuestTriggerVO;
            var _local_6:int;
            var _local_4:dQuestDefinitionTriggerVO = _arg_2.mQuestDefinition.questTriggers_vector[_arg_3];
            switch (_local_4.type)
            {
                case QuestManagerStatic.TYPE_BUILDING:
                    if (_local_4.condition == QuestManagerStatic.CONDITION_ONMAP)
                    {
                        return (Math.max(_local_4.amount, 1));
                    };
                    if (_local_4.condition == QuestManagerStatic.CONDITION_LESS)
                    {
                        _local_5 = _arg_2.mQuestTriggersFinished_vector[_arg_3];
                        return (_local_5.deltaStart);
                    };
                    break;
                case QuestManagerStatic.TYPE_PLAYERLEVEL:
                    if (_local_4.condition == QuestManagerStatic.CONDITION_LESS)
                    {
                        _local_6 = (_arg_1.GetPlayerLevel() - (_local_4.amount - 1));
                        if (_local_6 < 0)
                        {
                            _local_6 = 0;
                        };
                        return (_local_6);
                    };
                    break;
                case QuestManagerStatic.TYPE_SECTOR:
                    if (_local_4.condition == QuestManagerStatic.CONDITION_CLAIMED)
                    {
                        return (1);
                    };
                    break;
                case QuestManagerStatic.TYPE_BANDITS:
                    if (_local_4.condition == QuestManagerStatic.CONDITION_LESS_OR_EQUAL)
                    {
                        return (1);
                    };
                    break;
                case QuestManagerStatic.TYPE_PRODUCTION_VALUE:
                    if (_local_4.condition == QuestManagerStatic.CONDITION_GREATER_OR_EQUAL)
                    {
                        return (1);
                    };
                    break;
                case QuestManagerStatic.TYPE_PRODUCTION_TIME:
                    if (_local_4.condition == QuestManagerStatic.CONDITION_LESS)
                    {
                        return (1);
                    };
                    break;
                case QuestManagerStatic.TYPE_COLLECTIONS:
                    return (this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.getInitialNbOfPickups(CollectionsConsts.COLLECTIBLE_BUILDING_NORMAL));
                case QuestManagerStatic.TYPE_EVENT_COLLECTIONS:
                    return (this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.getInitialNbOfPickups(CollectionsConsts.COLLECTIBLE_BUILDING_EVENT));
            };
            return (_local_4.amount);
        }

        public function RestoreQuestPool():void
        {
            if (this.mClientQuestPool != null)
            {
                this.mClientQuestPool.removeAllObservers();
            };
            this.mClientQuestPool = this.mHomeQuestPool;
        }

        public function cleanUpQuestNew(_arg_1:String, _arg_2:String):void
        {
        }

        public function resetQuest(_arg_1:String, _arg_2:int):void
        {
            var _local_3:dQuestElementVO = this.mClientQuestPool.GetQuestFromName(_arg_1);
            if (_local_3 != null)
            {
                this.mClientQuestPool.RemoveQuest(_local_3);
            };
        }

        public function ReceivedMessagesFromServer(_arg_1:dQuestUpdateVO):void
        {
            var _local_2:dQuestElementVO;
            var _local_3:dAdventureClientInfoVO;
            var _local_4:dAdventureClientInfoVO;
            var _local_5:dGameTickCommandVO;
            var _local_6:String;
            var _local_7:String;
            if (!this.mGeneralInterface.IsCurrentPlayerQuestPlayer())
            {
                return;
            };
            switch (_arg_1.mode)
            {
                case QuestManagerStatic.QUEST_UPDATE_APPLY_EFFECTS:
                case QuestManagerStatic.QUEST_UPDATE_APPLY_REWARD_EFFECTS:
                    this.mGeneralInterface.AddGameTickCommand((_arg_1._object as dGameTickCommandVO));
                    return;
                case QuestManagerStatic.QUEST_UPDATE_REFRESH_QUEST_LIST:
                    this.RefreshQuestList((_arg_1._object as dQuestPoolVO));
                    return;
                case QuestManagerStatic.QUEST_UPDATE_ADVENTURE_FINISHED:
                    _local_3 = (_arg_1._object as dAdventureClientInfoVO);
                    _local_4 = AdventureManager.getInstance().getAdventure(_local_3.zoneID);
                    if (_local_4 != null)
                    {
                        _local_4.status = _local_3.status;
                        _local_4.colonyDuration = _local_3.colonyDuration;
                        if (cAdventureDefinition.FindAdventureDefinition(_local_4.adventureName).IsColony())
                        {
                            _local_4.colonyStatus = cColony.STATUS_READY_FOR_DEFENSE_MODE;
                        };
                        globalFlash.gui.mAdventurePanel.SetData(_local_4);
                        globalFlash.gui.mAdventurePanel.Show();
                    }
                    else
                    {
                        globalFlash.gui.mAdventurePanel.SetData(_local_3);
                        globalFlash.gui.mAdventurePanel.Show();
                    };
                    return;
                case QuestManagerStatic.QUEST_UPDATE_SET_HINT_DATA:
                    _local_2 = (_arg_1._object as dQuestElementVO);
                    gHintManager.ShowHints(_local_2.GetQuestDefinition().questHints);
                    return;
                case QuestManagerStatic.QUEST_UPDATE_SHOW_QUEST_WINDOW:
                    _local_2 = (_arg_1._object as dQuestElementVO);
                    if (((this.mLastActiveQuestWindow == null) || (!(this.mLastActiveQuestWindow.IsEqualTo(_local_2)))))
                    {
                        this.ShowCurrentQuestWindow(_local_2, true, false);
                    };
                    return;
                case QuestManagerStatic.QUEST_UPDATE_QUEST_TRIGGER_CHANGED:
                    _local_2 = (_arg_1._object as dQuestElementVO);
                    if (((_local_2.mQuestMode == QuestManagerStatic.QUEST_MODE_REWARD_WINDOW_WAIT_FOR_BUTTON_ACTIVE) || (_local_2.mQuestMode == QuestManagerStatic.QUEST_MODE_QUEST_FAILED)))
                    {
                        this.ShowCurrentQuestWindow(_local_2, true, false);
                    }
                    else
                    {
                        this.RefreshLastQuestList(_local_2);
                    };
                    return;
                case QuestManagerStatic.QUEST_UPDATE_HIDE_QUEST_WINDOW:
                    _local_2 = (_arg_1._object as dQuestElementVO);
                    this.RefreshLastQuestList(_local_2);
                    return;
                case QuestManagerStatic.QUEST_UPDATE_PAY_FOR_QUEST:
                    _local_5 = (_arg_1._object as dGameTickCommandVO);
                    this.mGeneralInterface.AddGameTickCommand(_local_5);
                    return;
                case QuestManagerStatic.QUEST_UPDATE_UINOTIFICATION:
                    _local_6 = (_arg_1._object as String);
                    _local_7 = _local_6.substr((_local_6.indexOf(":") + 1));
                    _local_6 = _local_6.substr(0, _local_6.indexOf(":"));
                    OneHitUIObserver.create(_local_6, _local_7);
                    return;
            };
        }

        public function GetRemainingValuesForQuestTrigger(_arg_1:cPlayerData, _arg_2:dQuestElementVO, _arg_3:int):int
        {
            var _local_5:cBuilding;
            var _local_6:cResources;
            var _local_7:cSpecialist;
            var _local_8:cSkillList;
            var _local_9:cSkillTree;
            var _local_10:cSkill;
            var _local_11:int;
            var _local_12:int;
            var _local_13:int;
            var _local_14:cPlayerData;
            var _local_15:int;
            var _local_16:Vector.<cBuilding>;
            var _local_17:cBuilding;
            var _local_18:int;
            var _local_19:Vector.<cBuilding>;
            var _local_20:int;
            var _local_21:cResources;
            var _local_22:int;
            var _local_23:int;
            var _local_24:int;
            var _local_25:int;
            var _local_26:int;
            var _local_27:int;
            var _local_28:int;
            var _local_29:int;
            var _local_30:String;
            var _local_31:int;
            var _local_32:cSquad;
            var _local_33:cSquad;
            var _local_34:int;
            var _local_35:cBuff;
            var _local_36:Vector.<cBuff>;
            var _local_37:int;
            var _local_38:int;
            var _local_39:cBuff;
            var _local_40:cAdventureDefinition;
            var _local_41:Number;
            var _local_42:cEconomyOverviewData;
            var _local_43:dEconomyOverviewDataResult;
            var _local_44:int;
            var _local_45:int;
            var _local_46:Number;
            var _local_47:cArmy;
            var _local_48:cResources;
            var _local_49:int;
            var _local_50:int;
            var _local_51:cSquad;
            var _local_4:dQuestDefinitionTriggerVO = _arg_2.mQuestDefinition.questTriggers_vector[_arg_3];
            switch (_local_4.type)
            {
                case QuestManagerStatic.TYPE_KEY_PRESS:
                    if (_local_4.condition == QuestManagerStatic.CONDITION_KEY_PRESS)
                    {
                        return (_local_4.amount);
                    };
                    break;
                case QuestManagerStatic.TYPE_REFILL_BUFF:
                    if (_local_4.condition == QuestManagerStatic.CONDITION_CONSUME)
                    {
                        return (_local_4.amount);
                    };
                    break;
                case QuestManagerStatic.TYPE_BUILDING:
                    switch (_local_4.condition)
                    {
                        case QuestManagerStatic.CONDITION_ONMAP:
                            _local_11 = 0;
                            if (_local_4.name_string == "")
                            {
                                _local_11 = _arg_1.GetBuildingCountAll();
                            }
                            else
                            {
                                _local_11 = _arg_1.GetBuildingCount(_local_4.name_string);
                            };
                            _local_12 = Math.max(_local_4.amount, 1);
                            if (_local_11 >= _local_12)
                            {
                                return (0);
                            };
                            return (_local_12 - _local_11);
                        case QuestManagerStatic.CONDITION_ONMAP_VISITOR:
                            _local_13 = this.mGeneralInterface.mHomePlayer.GetPlayerId();
                            for each (_local_14 in this.mGeneralInterface.GetPlayerList_vector())
                            {
                                if (_local_14.GetPlayerId() != _local_13)
                                {
                                    return ((_local_14.GetBuildingCount(_local_4.name_string) > 0) ? 0 : 1);
                                };
                            };
                            break;
                        case QuestManagerStatic.CONDITION_GREATER_OR_EQUAL:
                            _local_15 = 0;
                            if (_local_4.name_string == "Deco")
                            {
                                _local_16 = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.GetBuildings_vector();
                                for each (_local_5 in _local_16)
                                {
                                    if (null != _local_5)
                                    {
                                        if (((_local_5.IsDecoration()) && (("" == _local_4.actionType_string) || (_local_4.actionType_string == _local_5.GetDecorationType()))))
                                        {
                                            _local_15++;
                                        };
                                    };
                                };
                            }
                            else
                            {
                                _local_15 = _arg_1.GetBuildingCount(_local_4.name_string);
                            };
                            return (_local_4.amount - _local_15);
                        case QuestManagerStatic.CONDITION_LESS:
                            return (global.ui.mHomePlayer.GetBuildingCount(_local_4.name_string) - (_local_4.amount - 1));
                        case QuestManagerStatic.CONDITION_ASSIGNED_UNITS:
                            _local_17 = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.getBuildingByName(_local_4.name_string);
                            if (_local_17 != null)
                            {
                                return ((_local_5.GetArmy().HasUnits()) ? 0 : 1);
                            };
                            break;
                        case QuestManagerStatic.CONDITION_SELECTED:
                        case QuestManagerStatic.CONDITION_DESTROYED:
                        case QuestManagerStatic.CONDITION_UPGRADED:
                            return (1 - _arg_2.GetTriggerStatus(_local_4.triggerIdx));
                        case QuestManagerStatic.CONDITION_LEVEL_UPGRADE:
                            _local_18 = 0;
                            if (_local_4.name_string != "")
                            {
                                _local_19 = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.getBuildingsByName_vector(_local_4.name_string);
                                if (_local_19 != null)
                                {
                                    for each (_local_5 in _local_19)
                                    {
                                        if (_local_5.GetUpgradeLevel() >= _local_4.buildingUpgradeLevel)
                                        {
                                            _local_18++;
                                        };
                                    };
                                };
                            }
                            else
                            {
                                _local_19 = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.GetBuildings_vector();
                                for each (_local_5 in _local_19)
                                {
                                    if (_local_5.GetUpgradeLevel() >= _local_4.buildingUpgradeLevel)
                                    {
                                        _local_18++;
                                    };
                                };
                            };
                            return (_local_4.amount - _local_18);
                    };
                    break;
                case QuestManagerStatic.TYPE_RESOURCE:
                    if (_local_4.condition == QuestManagerStatic.CONDITION_GREATER_OR_EQUAL)
                    {
                        _local_6 = this.mGeneralInterface.mCurrentPlayerZone.GetResources(_arg_1);
                        return (_local_4.amount - _local_6.GetPlayerResource(_local_4.name_string).amount);
                    };
                    if (_local_4.condition == QuestManagerStatic.CONDITION_GREATER_OR_EQUAL_DELTA)
                    {
                        if (_arg_2.GetTriggerStatus(_local_4.triggerIdx) == 1)
                        {
                            return (0);
                        };
                        _local_20 = (_arg_2.GetDeltaStart(_local_4.triggerIdx) as int);
                        _local_21 = this.mGeneralInterface.mCurrentPlayerZone.GetResources(_arg_1);
                        _local_22 = _local_21.GetPlayerResource(_local_4.name_string).amount;
                        _local_23 = (_local_22 - _local_20);
                        return (_local_4.amount - _local_23);
                    };
                    if (((_local_4.condition == QuestManagerStatic.CONDITION_BUY) || (_local_4.condition == QuestManagerStatic.CONDITION_SELL)))
                    {
                        return (_local_4.amount - (_arg_2.GetDeltaStart(_local_4.triggerIdx) as int));
                    };
                    if (_local_4.condition == QuestManagerStatic.CONDITION_PRODUCE)
                    {
                        _local_24 = (_arg_2.GetDeltaStart(_local_4.triggerIdx) as int);
                        _local_25 = (_local_4.amount - _local_24);
                        return (_local_25);
                    };
                    if (_local_4.condition == QuestManagerStatic.CONDITION_CHK_RESOURCES)
                    {
                        _local_6 = this.mGeneralInterface.mCurrentPlayerZone.GetResources(_arg_1);
                        return (_local_4.amount - (_arg_2.GetDeltaStart(_local_4.triggerIdx) as int));
                    };
                    break;
                case QuestManagerStatic.TYPE_XP:
                    if (_local_4.condition == QuestManagerStatic.CONDITION_GREATER_OR_EQUAL)
                    {
                        return (_local_4.amount - _arg_1.GetXP());
                    };
                    break;
                case QuestManagerStatic.TYPE_PLAYERLEVEL:
                    if (_local_4.condition == QuestManagerStatic.CONDITION_GREATER_OR_EQUAL)
                    {
                        return (_local_4.amount - _arg_1.GetPlayerLevel());
                    };
                    if (_local_4.condition == QuestManagerStatic.CONDITION_LESS)
                    {
                        return (0);
                    };
                    break;
                case QuestManagerStatic.TYPE_SECTOR:
                    if ((((_local_4.condition == QuestManagerStatic.CONDITION_CLAIMED) || (_local_4.condition == QuestManagerStatic.CONDITION_CLAIMED_GREATER_OR_EQUAL)) || (_local_4.condition == QuestManagerStatic.CONDITION_CLAIMED_LESS)))
                    {
                        _local_26 = this.mGeneralInterface.mCurrentPlayerZone.GetSectorsClaimedAmount(this.mGeneralInterface.mHomePlayer.GetPlayerId());
                        _local_27 = 99999;
                        if (_local_4.condition == QuestManagerStatic.CONDITION_CLAIMED)
                        {
                            _local_27 = ((_local_4.amount - _local_26) + 1);
                        }
                        else
                        {
                            if (_local_4.condition == QuestManagerStatic.CONDITION_CLAIMED_GREATER_OR_EQUAL)
                            {
                                _local_27 = (_local_4.amount - _local_26);
                            }
                            else
                            {
                                if (_local_4.condition == QuestManagerStatic.CONDITION_CLAIMED_LESS)
                                {
                                    _local_27 = ((_local_26 - _local_4.amount) + 1);
                                };
                            };
                        };
                        _local_27 = Math.max(0, _local_27);
                        return (_local_27);
                    };
                    if (_local_4.condition == QuestManagerStatic.CONDITION_EXPLORED)
                    {
                        return (1 - _arg_2.GetTriggerStatus(_local_4.triggerIdx));
                    };
                    if (_local_4.condition == QuestManagerStatic.CONDITION_EXPLORE_GREATER_OR_EQUAL)
                    {
                        _local_28 = _arg_1.GetSectorsDiscAmount();
                        _local_29 = Math.max(0, (_local_4.amount - _local_28));
                        return (_local_29);
                    };
                    if (_local_4.condition == QuestManagerStatic.CONDITION_EXPLORE_GREATER_OR_EQUAL_DELTA)
                    {
                        return ((_local_4.amount - _arg_2.GetDeltaStart(_local_4.triggerIdx)) as int);
                    };
                    break;
                case QuestManagerStatic.TYPE_SPECIALIST:
                    if (_local_4.condition == QuestManagerStatic.CONDITION_ASSIGNED_UNITS)
                    {
                        if (((!(_local_4.name_string == null)) && (_local_4.name_string.length > 0)))
                        {
                            for each (_local_7 in this.mGeneralInterface.mCurrentPlayerZone.GetSpecialists_vector())
                            {
                                if (SPECIALIST_TYPE.toString(_local_7.GetType()) == _local_4.name_string)
                                {
                                    if (_local_7.HasUnits())
                                    {
                                        return (0);
                                    };
                                };
                            };
                            return (1);
                        };
                        for each (_local_7 in this.mGeneralInterface.mCurrentPlayerZone.GetSpecialists_vector())
                        {
                            if (_local_7.HasUnits())
                            {
                                return (0);
                            };
                        };
                        return (1);
                    };
                    if (_local_4.condition == QuestManagerStatic.CONDITION_CREATED)
                    {
                        if (((!(_local_4.name_string == null)) && (_local_4.name_string.length > 0)))
                        {
                            for each (_local_7 in this.mGeneralInterface.mCurrentPlayerZone.GetSpecialists_vector())
                            {
                                _local_30 = SPECIALIST_TYPE.toString(_local_7.GetType());
                                if (((_local_4.name_string == _local_30) || (_local_4.name_string.length == 0)))
                                {
                                    return (0);
                                };
                            };
                            return (1);
                        };
                    }
                    else
                    {
                        if (_local_4.condition == QuestManagerStatic.CONDITION_FOUND_DEPOSIT)
                        {
                            return (1 - _arg_2.GetTriggerStatus(_local_4.triggerIdx));
                        };
                        if (_local_4.condition == QuestManagerStatic.CONDITION_GREATER_OR_EQUAL)
                        {
                            return (_local_4.amount - QuestManagerStatic.GetAmountOfSpecialistsForTriggerName(this.mGeneralInterface, _arg_1.GetPlayerId(), _local_4.name_string));
                        };
                    };
                    break;
                case QuestManagerStatic.TYPE_MILITARYUNIT:
                    if (_local_4.condition == QuestManagerStatic.CONDITION_GREATER_OR_EQUAL)
                    {
                        _local_31 = 0;
                        for each (_local_7 in this.mGeneralInterface.mCurrentPlayerZone.GetSpecialists_vector())
                        {
                            if (_local_7.HasUnits())
                            {
                                _local_33 = _local_7.GetArmy().GetSquad(_local_4.name_string);
                                if (_local_33 != null)
                                {
                                    _local_31 = (_local_31 + _local_33.amount);
                                };
                            };
                        };
                        _local_32 = this.mGeneralInterface.mCurrentPlayerZone.GetArmy(_arg_1.GetPlayerId()).GetSquad(_local_4.name_string);
                        if (_local_32 != null)
                        {
                            _local_31 = (_local_31 + _local_32.amount);
                        };
                        return (_local_4.amount - _local_31);
                    };
                    break;
                case QuestManagerStatic.TYPE_BUFF:
                    if (_local_4.condition == QuestManagerStatic.CONDITION_GREATER_OR_EQUAL)
                    {
                        _local_34 = 0;
                        for each (_local_35 in _arg_1.getAvailableBuffs_vector())
                        {
                            if (_local_35.GetBuffDefinition().GetName_string() == _local_4.name_string)
                            {
                                _local_34 = (_local_34 + _local_35.GetAmount());
                            };
                        };
                        return (_local_4.amount - _local_34);
                    };
                    if (((_local_4.condition == QuestManagerStatic.CONDITION_PRODUCE) || (_local_4.condition == QuestManagerStatic.CONDITION_CONSUME)))
                    {
                        return (_local_4.amount - (_arg_2.GetDeltaStart(_local_4.triggerIdx) as int));
                    };
                    if (_local_4.condition == QuestManagerStatic.CONDITION_USED)
                    {
                        return (1 - _arg_2.GetTriggerStatus(_local_4.triggerIdx));
                    };
                    if (_local_4.condition == QuestManagerStatic.CONDITION_GREATER_OR_EQUAL_DELTA)
                    {
                        return (_local_4.amount - (_arg_2.GetDeltaStart(_local_4.triggerIdx) as int));
                    };
                    break;
                case QuestManagerStatic.TYPE_BUFF_ON_FRIEND:
                case QuestManagerStatic.TYPE_BUFF_BY_FRIEND:
                    if (_local_4.condition == QuestManagerStatic.CONDITION_GREATER_OR_EQUAL_DELTA)
                    {
                        return (_local_4.amount - (_arg_2.GetDeltaStart(_local_4.triggerIdx) as int));
                    };
                    break;
                case QuestManagerStatic.TYPE_FRIENDS:
                    if (_local_4.condition == QuestManagerStatic.CONDITION_GREATER_OR_EQUAL)
                    {
                        return (_local_4.amount - (_arg_2.GetDeltaStart(_local_4.triggerIdx) as int));
                    };
                    if (_local_4.condition == QuestManagerStatic.CONDITION_ADD_FRIEND_FRIENDS_LIST)
                    {
                        return (_local_4.amount - (_arg_2.GetDeltaStart(_local_4.triggerIdx) as int));
                    };
                    break;
                case QuestManagerStatic.TYPE_ADVENTURE:
                    if (_local_4.condition == QuestManagerStatic.CONDITION_GREATER_OR_EQUAL)
                    {
                        _local_36 = this.mGeneralInterface.mCurrentPlayer.getAvailableBuffs_vector();
                        _local_37 = 0;
                        _local_38 = 0;
                        while (_local_38 < _local_36.length)
                        {
                            _local_39 = (_local_36[_local_38] as cBuff);
                            if (_local_39.GetBuffDefinition().GetName_string() == "Adventure")
                            {
                                if (_local_4.actionType_string != "")
                                {
                                    _local_40 = cAdventureDefinition.FindAdventureDefinition(_local_39.GetResourceName_string());
                                    if (_local_4.actionType_string == _local_40.GetType_string())
                                    {
                                        _local_37++;
                                    };
                                }
                                else
                                {
                                    _local_37++;
                                };
                            };
                            _local_38++;
                        };
                        return (_local_4.amount - _local_37);
                    };
                    if (_local_4.condition == QuestManagerStatic.CONDITION_LESS)
                    {
                        _local_41 = (_arg_2.GetDeltaStart(_local_4.triggerIdx) as int);
                        if (_local_41 < _local_4.amount)
                        {
                            return (_local_4.amount - (_arg_2.GetDeltaStart(_local_4.triggerIdx) as int));
                        };
                        return (_local_4.amount);
                    };
                    if (_local_4.condition == QuestManagerStatic.CONDITION_FOUND)
                    {
                        return (_local_4.amount);
                    };
                    if (_local_4.condition == QuestManagerStatic.CONDITION_GREATER_OR_EQUAL_DELTA)
                    {
                        return (_local_4.amount - (_arg_2.GetDeltaStart(_local_4.triggerIdx) as int));
                    };
                    break;
                case QuestManagerStatic.TYPE_PRODUCTION_VALUE:
                    if (_local_4.condition == QuestManagerStatic.CONDITION_GREATER_OR_EQUAL)
                    {
                        _local_42 = new cEconomyOverviewData();
                        _local_43 = _local_42.GetResourceProductionAndConsumptionValues(null, _local_4.name_string);
                        _local_44 = int(((_local_4.amount * global.economyCalculationTime) / 3600));
                        _local_45 = (_local_43.mBuffedProductionValue - _local_43.mConsumptionValue);
                        return ((_local_45 >= _local_44) ? 0 : 1);
                    };
                    break;
                case QuestManagerStatic.TYPE_FRIEND_VISIT:
                    if (_local_4.condition == QuestManagerStatic.CONDITION_VISITED)
                    {
                        return (_local_4.amount - (_arg_2.GetDeltaStart(_local_4.triggerIdx) as int));
                    };
                    break;
                case QuestManagerStatic.TYPE_MOVE_BUILDING:
                    if (_local_4.condition == QuestManagerStatic.CONDITION_MOVED)
                    {
                        return (_local_4.amount - (_arg_2.GetDeltaStart(_arg_3) as int));
                    };
                    break;
                case QuestManagerStatic.TYPE_SHOP_ITEM:
                    if (_local_4.condition == QuestManagerStatic.CONDITION_BOUGHT)
                    {
                        return (_local_4.amount);
                    };
                    break;
                case QuestManagerStatic.TYPE_OPEN_WINDOW:
                    if (_local_4.condition == QuestManagerStatic.CONDITION_UNSET)
                    {
                        return (_local_4.amount);
                    };
                    break;
                case QuestManagerStatic.TYPE_PRODUCTION_TIME:
                    if (_local_4.condition == QuestManagerStatic.CONDITION_LESS)
                    {
                        return (1);
                    };
                    break;
                case QuestManagerStatic.TYPE_SPECIALIST_TASK:
                    if (_local_4.condition == QuestManagerStatic.CONDITION_FOUND)
                    {
                        return ((_local_4.amount - _arg_2.GetDeltaStart(_local_4.triggerIdx)) as int);
                    };
                    break;
                case QuestManagerStatic.TYPE_CHECK_POPULATION:
                    if (_local_4.condition == QuestManagerStatic.CONDITION_GREATER_OR_EQUAL)
                    {
                        if (_local_4.name_string == "maxCapacity")
                        {
                            _local_6 = this.mGeneralInterface.mCurrentPlayerZone.GetResources(_arg_1);
                            return (_local_4.amount - _local_6.GetPlayerResource(defines.POPULATION_RESOURCE_NAME_string).maxLimit);
                        };
                    };
                    break;
                case QuestManagerStatic.TYPE_CHECK_ARMY:
                    if (_local_4.condition == QuestManagerStatic.CONDITION_GREATER_OR_EQUAL)
                    {
                        _local_46 = 0;
                        for each (_local_7 in this.mGeneralInterface.mCurrentPlayerZone.GetSpecialists_vector())
                        {
                            if (_local_7.HasUnits())
                            {
                                _local_46 = (_local_46 + _local_7.GetArmy().GetUnitsCount());
                            };
                        };
                        _local_47 = this.mGeneralInterface.mCurrentPlayerZone.GetArmy(_arg_1.GetPlayerId());
                        _local_46 = (_local_46 + _local_47.GetUnitsCount());
                        return (_local_4.amount - _local_46);
                    };
                    break;
                case QuestManagerStatic.TYPE_WIN_BATTLE_WITH_UNITS:
                    if (_local_4.condition == QuestManagerStatic.CONDITION_WIN_BATTLE_WITH_UNITS)
                    {
                        return (_local_4.amount);
                    };
                    break;
                case QuestManagerStatic.TYPE_QUEST_COMPLETE:
                    return (_local_4.amount);
                case QuestManagerStatic.TYPE_BANDITS:
                    if (_local_4.condition == QuestManagerStatic.CONDITION_LESS_OR_EQUAL)
                    {
                        return ((_arg_2.GetDeltaStart(_local_4.triggerIdx) <= _local_4.amount) ? 0 : 1);
                    };
                    break;
                case QuestManagerStatic.TYPE_REFILL_DEPOSIT:
                    if (_local_4.condition == QuestManagerStatic.CONDITION_GREATER_OR_EQUAL_DELTA)
                    {
                        return (_local_4.amount - _arg_2.GetDeltaStart(_local_4.triggerIdx));
                    };
                    break;
                case QuestManagerStatic.TYPE_QUEST_COMPLETE:
                    return (_local_4.amount);
                case QuestManagerStatic.TYPE_CHECK_STORAGE:
                    _local_48 = this.mGeneralInterface.mCurrentPlayerZone.GetResources(_arg_1);
                    if (_local_4.condition == QuestManagerStatic.CONDITION_CHK_STORAGE)
                    {
                        _local_49 = 0;
                        _local_49 = _local_48.GetWareHouseCapacity();
                        return (_local_4.amount - _local_49);
                    };
                    break;
                case QuestManagerStatic.TYPE_PAY_FOR_QUEST_FINISH:
                    if (global.resourceDefinitions_vector.indexOf(_local_4.name_string) != -1)
                    {
                        if (_local_4.name_string == defines.POPULATION_RESOURCE_NAME_string)
                        {
                            return (_local_4.amount - this.mGeneralInterface.mCurrentPlayerZone.GetResources(this.mGeneralInterface.mCurrentPlayer).GetFree());
                        };
                        return (_local_4.amount - this.mGeneralInterface.mCurrentPlayerZone.GetResources(this.mGeneralInterface.mCurrentPlayer).GetPlayerResource(_local_4.name_string).amount);
                    }
                    else
                    {
                        _local_50 = 0;
                        _local_51 = this.mGeneralInterface.mCurrentPlayerZone.GetArmy(this.mGeneralInterface.mCurrentPlayer.GetPlayerId()).GetSquad(_local_4.name_string);
                        if (_local_51 != null)
                        {
                            _local_50 = _local_51.amount;
                        };
                        return (_local_4.amount - _local_50);
                    };
                case QuestManagerStatic.TYPE_COLLECTIONS:
                    return (this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.getCurrentNbOfPickups(CollectionsConsts.COLLECTIBLE_BUILDING_NORMAL));
                case QuestManagerStatic.TYPE_EVENT_COLLECTIONS:
                    return (this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.getCurrentNbOfPickups(CollectionsConsts.COLLECTIBLE_BUILDING_EVENT));
                case QuestManagerStatic.TYPE_SKILL_LEVEL:
                    switch (_local_4.condition)
                    {
                        case QuestManagerStatic.CONDITION_GREATER_OR_EQUAL:
                            _local_50 = 0;
                            for each (_local_8 in this.mGeneralInterface.skillLists_vector)
                            {
                                for each (_local_10 in _local_8.getItems_vector())
                                {
                                    if (_local_10.getName() == _local_4.name_string)
                                    {
                                        if (_local_10.getOriginalVO().level > _local_50)
                                        {
                                            _local_50 = _local_10.getOriginalVO().level;
                                        };
                                    };
                                };
                            };
                            return (_local_4.amount - _local_50);
                        case QuestManagerStatic.CONDITION_LESS:
                            _local_50 = 100;
                            for each (_local_8 in this.mGeneralInterface.skillLists_vector)
                            {
                                for each (_local_10 in _local_8.getItems_vector())
                                {
                                    if (_local_10.getName() == _local_4.name_string)
                                    {
                                        _local_50 = _local_10.getMaxLevel();
                                        if (_local_10.getOriginalVO().level < _local_50)
                                        {
                                            _local_50 = _local_10.getOriginalVO().level;
                                        };
                                    };
                                };
                            };
                            return (_local_4.amount - _local_50);
                    };
                    break;
                case QuestManagerStatic.TYPE_BRONZE_SKILLTREE_POINTS:
                    switch (_local_4.condition)
                    {
                        case QuestManagerStatic.CONDITION_GREATER_OR_EQUAL:
                            _local_50 = 0;
                            for each (_local_8 in this.mGeneralInterface.skillLists_vector)
                            {
                                _local_9 = null;
                                if ((_local_8 is cSkillTree))
                                {
                                    _local_9 = (_local_8 as cSkillTree);
                                }
                                else
                                {
                                    continue;
                                };
                                if ((((!(_local_9 == null)) && (_local_9.getDefinition().name_string == _local_4.name_string)) && (_local_50 < _local_9.getSumPointsByType(SkillDefinition.TYPE_BRONZE))))
                                {
                                    _local_50 = _local_9.getSumPointsByType(SkillDefinition.TYPE_BRONZE);
                                };
                            };
                            return (_local_4.amount - _local_50);
                        case QuestManagerStatic.CONDITION_LESS:
                            _local_50 = 100;
                            for each (_local_8 in this.mGeneralInterface.skillLists_vector)
                            {
                                _local_9 = null;
                                if ((_local_8 is cSkillTree))
                                {
                                    _local_9 = (_local_8 as cSkillTree);
                                }
                                else
                                {
                                    continue;
                                };
                                if ((((!(_local_9 == null)) && (_local_9.getDefinition().name_string == _local_4.name_string)) && (_local_50 > _local_9.getSumPointsByType(SkillDefinition.TYPE_BRONZE))))
                                {
                                    _local_50 = _local_9.getSumPointsByType(SkillDefinition.TYPE_BRONZE);
                                };
                            };
                            return (_local_4.amount - _local_50);
                    };
                    break;
                case QuestManagerStatic.TYPE_SILVER_SKILLTREE_POINTS:
                    switch (_local_4.condition)
                    {
                        case QuestManagerStatic.CONDITION_GREATER_OR_EQUAL:
                            _local_50 = 0;
                            for each (_local_8 in this.mGeneralInterface.skillLists_vector)
                            {
                                _local_9 = null;
                                if ((_local_8 is cSkillTree))
                                {
                                    _local_9 = (_local_8 as cSkillTree);
                                }
                                else
                                {
                                    continue;
                                };
                                if ((((!(_local_9 == null)) && (_local_9.getDefinition().name_string == _local_4.name_string)) && (_local_50 < _local_9.getSumPointsByType(SkillDefinition.TYPE_SILVER))))
                                {
                                    _local_50 = _local_9.getSumPointsByType(SkillDefinition.TYPE_SILVER);
                                };
                            };
                            return (_local_4.amount - _local_50);
                        case QuestManagerStatic.CONDITION_LESS:
                            _local_50 = 100;
                            for each (_local_8 in this.mGeneralInterface.skillLists_vector)
                            {
                                _local_9 = null;
                                if ((_local_8 is cSkillTree))
                                {
                                    _local_9 = (_local_8 as cSkillTree);
                                }
                                else
                                {
                                    continue;
                                };
                                if ((((!(_local_9 == null)) && (_local_9.getDefinition().name_string == _local_4.name_string)) && (_local_50 > _local_9.getSumPointsByType(SkillDefinition.TYPE_SILVER))))
                                {
                                    _local_50 = _local_9.getSumPointsByType(SkillDefinition.TYPE_SILVER);
                                };
                            };
                            return (_local_4.amount - _local_50);
                    };
                    break;
                case QuestManagerStatic.TYPE_GOLD_SKILLTREE_POINTS:
                    switch (_local_4.condition)
                    {
                        case QuestManagerStatic.CONDITION_GREATER_OR_EQUAL:
                            _local_50 = 0;
                            for each (_local_8 in this.mGeneralInterface.skillLists_vector)
                            {
                                _local_9 = null;
                                if ((_local_8 is cSkillTree))
                                {
                                    _local_9 = (_local_8 as cSkillTree);
                                }
                                else
                                {
                                    continue;
                                };
                                if ((((!(_local_9 == null)) && (_local_9.getDefinition().name_string == _local_4.name_string)) && (_local_50 < _local_9.getSumPointsByType(SkillDefinition.TYPE_GOLD))))
                                {
                                    _local_50 = _local_9.getSumPointsByType(SkillDefinition.TYPE_GOLD);
                                };
                            };
                            return (_local_4.amount - _local_50);
                        case QuestManagerStatic.CONDITION_LESS:
                            _local_50 = 100;
                            for each (_local_8 in this.mGeneralInterface.skillLists_vector)
                            {
                                _local_9 = null;
                                if ((_local_8 is cSkillTree))
                                {
                                    _local_9 = (_local_8 as cSkillTree);
                                }
                                else
                                {
                                    continue;
                                };
                                if ((((!(_local_9 == null)) && (_local_9.getDefinition().name_string == _local_4.name_string)) && (_local_50 > _local_9.getSumPointsByType(SkillDefinition.TYPE_GOLD))))
                                {
                                    _local_50 = _local_9.getSumPointsByType(SkillDefinition.TYPE_GOLD);
                                };
                            };
                            return (_local_4.amount - _local_50);
                    };
                    break;
            };
            return (TRIGGER_UNSUPPORTED);
        }

        public function IsQuestActive(_arg_1:int):Boolean
        {
            return (this.mClientQuestPool.IsTriggerInAtLeastOneQuestAndQuestRunning(_arg_1));
        }

        public function QuestOkButtonPressedFromGui(_arg_1:dQuestElementVO):void
        {
            if (((!(this.IsActive())) || (!(this.mGeneralInterface.IsCurrentPlayerQuestPlayer()))))
            {
                return;
            };
            var _local_2:dUniqueID;
            if (_arg_1 != null)
            {
                _local_2 = _arg_1.GetUniqueId();
                _arg_1.SetQuestMode(QuestManagerStatic.QUEST_MODE_RUNNING);
            }
            else
            {
                cLog.error("QuestOkButtonPressedFromGui: Quest is null or not found!");
            };
            this.SendServerQuestTrigger(QuestManagerStatic.SERVER_STACK_QUEST_BUTTON_OK, _local_2);
        }

        public function RemoveFailedQuest(_arg_1:dUniqueID):void
        {
            if (((!(this.IsActive())) || (!(this.mGeneralInterface.IsCurrentPlayerQuestPlayer()))))
            {
                return;
            };
            this.SendServerQuestTrigger(QuestManagerStatic.SERVER_STACK_REMOVE_FAILED_QUEST, _arg_1);
        }

        public function getQuest(_arg_1:String):dQuestElementVO
        {
            return (this.mClientQuestPool.GetQuestFromName(_arg_1));
        }

        public function CancelQuest(_arg_1:dUniqueID):void
        {
            if (((!(this.IsActive())) || (!(this.mGeneralInterface.IsCurrentPlayerQuestPlayer()))))
            {
                return;
            };
            this.SendServerQuestTrigger(QuestManagerStatic.SERVER_STACK_CANCEL_QUEST, _arg_1);
        }

        public function GetCompletedAdventureSquads():HashMapWrapper
        {
            return (null);
        }

        public function GetTriggerText(_arg_1:dQuestDefinitionTriggerVO, _arg_2:int):String
        {
            var _local_3:Array;
            var _local_4:int;
            if (_arg_1.type == QuestManagerStatic.TYPE_PRODUCTION_TIME)
            {
                _local_3 = [int((_arg_1.amount / 60)), (_arg_1.amount % 60)];
            }
            else
            {
                if (_arg_1.type == QuestManagerStatic.TYPE_PRODUCTION_VALUE)
                {
                    _local_4 = int((global.economyCalculationTime / 3600));
                    _local_3 = [(_arg_1.amount * _local_4), _local_4];
                }
                else
                {
                    if (_arg_1.type == QuestManagerStatic.TYPE_BANDITS)
                    {
                        _local_3 = [_arg_1.amount];
                    }
                    else
                    {
                        _local_3 = [_arg_2, _arg_1.buildingUpgradeLevel.toString()];
                    };
                };
            };
            return (cLocaManager.GetInstance().GetText(LOCA_GROUP.QUEST_TRIGGERS, _arg_1.toString(), _local_3));
        }

        public function IsActive():Boolean
        {
            return ((QuestManagerStatic.IsActive()) && (!(this.mClientQuestPool == null)));
        }

        public function InitiateWindowOpen(_arg_1:String):void
        {
            if (((!(this.IsActive())) || (!(this.mGeneralInterface.IsCurrentPlayerQuestPlayer()))))
            {
                return;
            };
            if (this.mClientQuestPool.ContainsTriggerCondition(QuestManagerStatic.TYPE_OPEN_WINDOW, QuestManagerStatic.CONDITION_UNSET, _arg_1, null, null, null))
            {
                this.SendServerQuestTrigger(QuestManagerStatic.SERVER_STACK_WINDOW_OPEN, _arg_1);
                this.mClientQuestPool.CheckQuestTrigger(QuestManagerStatic.TYPE_OPEN_WINDOW, QuestManagerStatic.CONDITION_UNSET, _arg_1);
            };
        }

        public function IsADailyQuestFromRandomListRunning(_arg_1:dQuestElementVO):Boolean
        {
            var _local_3:dQuestElementVO;
            var _local_4:dQuestDefinitionPostrequisitsVO;
            var _local_5:dQuestDefinitionPostrequisitsVO;
            var _local_6:String;
            var _local_7:dQuestElementVO;
            var _local_2:Dictionary = new Dictionary();
            if (_arg_1.mQuestDefinition.questTyp == QuestManagerStatic.QUEST_TYPE_DAILY_QUEST)
            {
                for each (_local_4 in _arg_1.mQuestDefinition.questPostrequisits)
                {
                    if (_local_4.type == QuestManagerStatic.TYPE_RANDOM_QUEST_LIST)
                    {
                        for each (_local_5 in _local_4.postrequisits_vector)
                        {
                            _local_6 = _local_5.name_string;
                            _local_2[_local_6] = _arg_1;
                        };
                    };
                };
            };
            for each (_local_3 in this.mClientQuestPool.GetQuest_vector())
            {
                _local_7 = _local_2[_local_3.getQuestName_string()];
                if (_local_7 != null)
                {
                    if (_local_3.mQuestMode == QuestManagerStatic.QUEST_MODE_RUNNING)
                    {
                        return (true);
                    };
                };
            };
            return (false);
        }

        public function CleanQuestPool():void
        {
            if (this.mClientQuestPool != null)
            {
                this.mClientQuestPool.dispose();
            };
            this.mClientQuestPool = new dQuestPoolVO();
            if (this.observer)
            {
                this.observer.dispose();
            };
            this.observer = new QuestObserver((this.mGeneralInterface as cGameInterface), this.mClientQuestPool);
        }

        public function getNewTriggerTotal(_arg_1:TriggerVO):int
        {
            switch (_arg_1.action_string)
            {
                case TRIGGER_ACTION.ACTION_CLAIM_COLONY_string:
                case TRIGGER_ACTION.ACTION_COMPLETE_ADVENTURE_LIST_string:
                case TRIGGER_ACTION.ACTION_BUILDING_UPGRADELEVEL_string:
                case TRIGGER_ACTION.ACTION_CALENDAR_DOOR_OPENED_COUNT_string:
                case TRIGGER_ACTION.ACTION_TIMED_PRODUCED_ITEM_LIST_string:
                case TRIGGER_ACTION.ACTION_BUFF_RECEIVED_FROM_FRIEND_string:
                case TRIGGER_ACTION.ACTION_BUFF_APPLIED_ON_FRIEND_string:
                case TRIGGER_ACTION.ACTION_BOUGHT_GOODS_string:
                case TRIGGER_ACTION.ACTION_SOLD_GOODS_string:
                case TRIGGER_ACTION.ACTION_DAILY_LOGIN_BONUS_string:
                case TRIGGER_ACTION.ACTION_SPECIALIST_TASK_RESULT_TYPE_string:
                case TRIGGER_ACTION.ACTION_SPECIALIST_TASK_FINISHED_string:
                case TRIGGER_ACTION.ACTION_COLLECTED_PICKUPS_string:
                case TRIGGER_ACTION.ACTION_COLONY_YIELD_string:
                case TRIGGER_ACTION.ACTION_SUCCESSFULLY_DEFEND_COLONY_string:
                case TRIGGER_ACTION.ACTION_REFILL_DEPOSITS_string:
                case TRIGGER_ACTION.ACTION_BATTLE_WON_string:
                case TRIGGER_ACTION.ACTION_LOOTED_RESOURCE_string:
                case TRIGGER_ACTION.ACTION_COUNT_DEPOSIT_TYPE_string:
                case TRIGGER_ACTION.ACTION_ROLL_COLLECTION_TRIGGER:
                case TRIGGER_ACTION.ACTION_COMPLETE_COLLECTION_TRIGGER:
                case TRIGGER_ACTION.ACTION_PAY_TO_FINISH_string:
                case TRIGGER_ACTION.ACTION_BUILDING_LIST_UPGRADE_LEVEL_string:
                case TRIGGER_ACTION.ACTION_OWN_RESOURCE_LIST_string:
                case TRIGGER_ACTION.ACTION_ADMIRAL_TRAVEL_string:
                case TRIGGER_ACTION.ACTION_COMPLETE_QUEST_LIST_string:
                case TRIGGER_ACTION.ACTION_HOURS_ELAPSED_string:
                case ResourceDonatedTrigger.XML_string:
                    return (_arg_1.amount);
                case TRIGGER_ACTION.ACTION_PRODUCTION_VALUE_string:
                case TRIGGER_ACTION.ACTION_BUFF_INSUFFICIENT_TARGET_BUILDINGS_string:
                    return (1);
                case GlobalDonationTrigger.XML_string:
                    if (_arg_1.target_string == "lost")
                    {
                        return (1);
                    };
                    return (global.eventDonations.getPhaseTotal(_arg_1.id));
                case EventTimeTrigger.XML_string:
                    return (1);
                default:
                    if ((((_arg_1.min == 0) && (_arg_1.max < 100100100)) && (_arg_1.max > 0)))
                    {
                        return (1);
                    };
                    return (Math.max(1, _arg_1.min));
            };
        }

        public function GetNewTriggerProgressTooltip(_arg_1:TriggerVO, _arg_2:int, _arg_3:int):String
        {
            switch (_arg_1.action_string)
            {
                case TRIGGER_ACTION.ACTION_HOURS_ELAPSED_string:
                    return (cLocaManager.GetInstance().FormatDuration(((((_arg_3 - _arg_2) * 60) * 60) * 1000)));
            };
            return ((_arg_2 + " / ") + _arg_3);
        }

        public function BuildingCreated(_arg_1:String):void
        {
            this.JustRefresh();
        }

        public function GetClientQuestPool():dQuestPoolVO
        {
            return (this.mClientQuestPool);
        }

        public function cleanUpQuest(_arg_1:String, _arg_2:String):void
        {
        }


    }
}
