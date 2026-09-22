package converted.bluebyte.tso.quests.logic
{
    import flash.utils.Dictionary;
    import nLib.cStringIntDictionary;
    import __AS3__.vec.Vector;
    import nLib.gMisc;
    import Communication.VO.dQuestDefinitionVO;
    import ServerState.cResources;
    import Communication.VO.dQuestDefinitionRewardVO;
    import ServerState.dResource;
    import Communication.VO.dUniqueID;
    import Communication.VO.dBuffVO;
    import BuffSystem.cBuff;
    import XpConversion.ConvertedXp;
    import nLib.cLog;
    import Enums.AVATAR_MESSAGE_TYPE;
    import Enums.ModifyReason;
    import Tracks.TrackManager;
    import XpConversion.XpConversionCalculator;
    import Enums.SPECIALIST_TYPE;
    import Interface.cGameInterface;
    import Interface.cGeneralInterface;
    import Communication.VO.dQuestElementVO;
    import ServerState.cPlayerData;
    import Communication.VO.dQuestDefinitionContainerVO;
    import Utils.StringUtils;
    import Communication.VO.dQuestDefinitionPostrequisitsVO;
    import Communication.VO.dQuestDefinitionTriggerVO;
    import Communication.VO.dQuestTriggerVO;
    import MilitarySystem.cSquad;
    import mx.core.*;
    import flash.events.*;
    import flash.display.*;
    import flash.geom.*;
    import flash.text.*;
    import flash.media.*;
    import Interface.*;
    import ServerState.*;
    import GO.*;
    import __AS3__.vec.*;
    import Communication.VO.*;
    import nLib.*;
    import Specialists.*;
    import BuffSystem.*;
    import mx.utils.*;
    import flash.utils.*;
    import flash.net.*;
    import Map.*;
    import Tracks.*;
    import flash.system.*;
    import flash.ui.*;
    import Enums.*;

    public class QuestManagerStatic 
    {

        public static const QUEST_UPDATE_APPLY_REWARD_EFFECTS:int = 1;
        public static const QUEST_UPDATE_ADVENTURE_FINISHED:int = 2;
        public static const QUEST_UPDATE_SET_HINT_DATA:int = 3;
        public static const QUEST_UPDATE_APPLY_EFFECTS:int = 4;
        public static const QUEST_UPDATE_REFRESH_QUEST_LIST:int = 10;
        public static const QUEST_UPDATE_SHOW_QUEST_WINDOW:int = 11;
        public static const QUEST_UPDATE_HIDE_QUEST_WINDOW:int = 12;
        public static const QUEST_UPDATE_QUEST_TRIGGER_CHANGED:int = 13;
        public static const QUEST_UPDATE_PAY_FOR_QUEST:int = 14;
        public static const QUEST_UPDATE_UINOTIFICATION:int = 16;
        public static const SERVER_STACK_QUEST_BUTTON_OK:int = 0;
        public static const SERVER_STACK_REWARD_BUTTON_OK:int = 1;
        public static const SERVER_STACK_BUILDING_SELECTED:int = 2;
        public static const SERVER_STACK_JUST_REFRESH:int = 3;
        public static const SERVER_STACK_GET_LATEST_QUEST_LIST:int = 4;
        public static const SERVER_STACK_PAY_FOR_QUEST_FINISH:int = 5;
        public static const SERVER_STACK_CANCEL_QUEST:int = 6;
        public static const SERVER_STACK_WINDOW_OPEN:int = 7;
        public static const SERVER_STACK_KEYPRESS:int = 8;
        public static const SERVER_STACK_REMOVE_FAILED_QUEST:int = 9;
        public static const QUEST_TYPE_STORY:String = "Story";
        public static const QUEST_TYPE_DAILY:String = "Daily";
        public static const QUEST_TYPE_GUILD:String = "Guild";
        public static const QUEST_TYPE_EVENT:String = "Event";
        public static const QUEST_TYPE_OPTIONAL:String = "Optional";
        public static const QUEST_MODE_string:String = "mQuestMode";
        public static const QUEST_TYPE_DEFAULT:int = 0;
        public static const QUEST_TYPE_IS_IN_RANDOM_LIST_OF_DAILY_QUEST:int = 1;
        public static const QUEST_TYPE_DAILY_LOGIN_QUEST:int = 2;
        public static const QUEST_TYPE_DAILY_QUEST:int = 3;
        public static const QUEST_TYPE_DAILY_GUILD_QUEST:int = 4;
        public static const TYPE_UNSET:int = 0;
        public static const TYPE_BUILDING:int = 1;
        public static const TYPE_RESOURCE:int = 2;
        public static const TYPE_XP:int = 3;
        public static const TYPE_PLAYERLEVEL:int = 4;
        public static const TYPE_SECTOR:int = 5;
        public static const TYPE_SPECIALIST:int = 6;
        public static const TYPE_MILITARYUNIT:int = 7;
        public static const TYPE_BUFF:int = 8;
        public static const TYPE_BUILDINGS_WITH_UNITS:int = 9;
        public static const TYPE_ADVENTURE:int = 10;
        public static const TYPE_LOOT:int = 11;
        public static const TYPE_DAILYTIME:int = 12;
        public static const TYPE_DAILYLOGIN:int = 13;
        public static const TYPE_STARTQUEST:int = 14;
        public static const TYPE_RANDOM_QUEST_LIST:int = 15;
        public static const TYPE_BUFF_ON_FRIEND:int = 16;
        public static const TYPE_BUFF_BY_FRIEND:int = 17;
        public static const TYPE_PAY_FOR_QUEST_FINISH:int = 18;
        public static const TYPE_FRIENDS:int = 19;
        public static const TYPE_GUILD_DAILYTIME:int = 20;
        public static const TYPE_GUILDSIZE:int = 21;
        public static const TYPE_FINISHPERCENTAGE:int = 22;
        public static const TYPE_OPEN_WINDOW:int = 23;
        public static const TYPE_KEY_PRESS:int = 24;
        public static const TYPE_QUEST_COMPLETE:int = 25;
        public static const TYPE_WIN_BATTLE_WITH_UNITS:int = 26;
        public static const TYPE_CHECK_STORAGE:int = 27;
        public static const TYPE_CHECK_POPULATION:int = 28;
        public static const TYPE_CHECK_ARMY:int = 29;
        public static const TYPE_PLAY_SPECIFIC_ADVENTURE:int = 30;
        public static const TYPE_MOVE_BUILDING:int = 31;
        public static const TYPE_REFILL_DEPOSIT:int = 32;
        public static const TYPE_SHOP_ITEM:int = 33;
        public static const TYPE_SPECIALIST_TASK:int = 34;
        public static const TYPE_PRODUCTION_TIME:int = 35;
        public static const TYPE_BANDITS:int = 36;
        public static const TYPE_FRIEND_VISIT:int = 37;
        public static const TYPE_PRODUCTION_VALUE:int = 38;
        public static const TYPE_REFILL_BUFF:int = 39;
        public static const TYPE_COLLECTIONS:int = 40;
        public static const TYPE_SKILL_LEVEL:int = 41;
        public static const TYPE_BRONZE_SKILLTREE_POINTS:int = 42;
        public static const TYPE_SILVER_SKILLTREE_POINTS:int = 43;
        public static const TYPE_GOLD_SKILLTREE_POINTS:int = 44;
        public static const TYPE_NEW_QUEST_TRIGGER:int = 45;
        public static const TYPE_EVENT_COLLECTIONS:int = 46;
        public static const CONDITION_UNSET:int = 0;
        public static const CONDITION_ONMAP:int = 1;
        public static const CONDITION_CREATED:int = 2;
        public static const CONDITION_GREATER_OR_EQUAL:int = 3;
        public static const CONDITION_DESTROYED:int = 4;
        public static const CONDITION_EXPLORED:int = 5;
        public static const CONDITION_CLAIMED:int = 6;
        public static const CONDITION_ASSIGNED_UNITS:int = 7;
        public static const CONDITION_UPGRADED:int = 8;
        public static const CONDITION_SELECTED:int = 9;
        public static const CONDITION_FOUND_DEPOSIT:int = 10;
        public static const CONDITION_USED:int = 11;
        public static const CONDITION_LESS:int = 12;
        public static const CONDITION_ONMAP_VISITOR:int = 13;
        public static const CONDITION_GREATER_OR_EQUAL_DELTA:int = 14;
        public static const CONDITION_PRODUCE:int = 15;
        public static const CONDITION_CONSUME:int = 16;
        public static const CONDITION_BUY:int = 17;
        public static const CONDITION_SELL:int = 18;
        public static const CONDITION_CLAIMED_GREATER_OR_EQUAL:int = 19;
        public static const CONDITION_CLAIMED_LESS:int = 20;
        public static const CONDITION_COMPLETED:int = 21;
        public static const CONDITION_WIN_BATTLE_WITH_UNITS:int = 22;
        public static const CONDITION_ADD_FRIEND_FRIENDS_LIST:int = 23;
        public static const CONDITION_CHK_STORAGE:int = 24;
        public static const CONDITION_CHK_RESOURCES:int = 25;
        public static const CONDITION_CHK_ARMY:int = 26;
        public static const CONDITION_MOVED:int = 27;
        public static const CONDITION_BOUGHT:int = 28;
        public static const CONDITION_FOUND:int = 29;
        public static const CONDITION_LESS_OR_EQUAL:int = 30;
        public static const CONDITION_LEVEL_UPGRADE:int = 31;
        public static const CONDITION_VISITED:int = 32;
        public static const CONDITION_EXPLORE_GREATER_OR_EQUAL:int = 33;
        public static const CONDITION_EXPLORE_GREATER_OR_EQUAL_DELTA:int = 34;
        public static const CONDITION_KEY_PRESS:int = 35;
        public static const QUEST_TRIGGER_NAME_PICKUPS_string:String = "Pickups";
        public static const QUEST_MODE_LOOP_UNTIL_QUEST_REWARD_COULD_BE_ASSIGNED:int = 1;
        public static const QUEST_MODE_START_WINDOW_DESCRIPTION_WAIT_FOR_BUTTON_PRESSED:int = 2;
        public static const QUEST_MODE_RUNNING:int = 3;
        public static const QUEST_MODE_INIT_REWARD_WINDOW:int = 4;
        public static const QUEST_MODE_REWARD_WINDOW_WAIT_FOR_BUTTON_ACTIVE:int = 5;
        public static const QUEST_MODE_START_DELAY:int = 6;
        public static const QUEST_MODE_SHOW_WINDOW_DESCRIPTION:int = 7;
        public static const QUEST_MODE_PRESS_REWARD_BUTTON:int = 8;
        public static const QUEST_MODE_PENDING_NEXT_RANDOM_DAILY_QUEST:int = 9;
        public static const QUEST_MODE_WAIT_FOR_FINISH:int = 10;
        public static const QUEST_MODE_DEACTIVATED:int = 11;
        public static const QUEST_MODE_REWARD_COLLECTED_IDLE:int = 12;
        public static const QUEST_MODE_QUEST_FAILED:int = 0;
        public static const GUILD_QUEST_MODE_RUNNING_DAILY:int = 1;
        public static const GUILD_QUEST_MODE_FINISHED:int = 3;
        public static const GUILD_QUEST_MODE_DEACTIVATED:int = 4;
        public static const SPECIAL_TYPE_FIRST_QUEST:String = "firstQuest";
        public static const SPECIAL_TYPE_LAST_QUEST:String = "lastQuest";
        public static const SPECIAL_TYPE_FIRST_DAILY_QUEST:String = "firstDailyQuest";
        public static const SPECIAL_TYPE_GUILD_QUEST:String = "guildQuest";
        public static const SPECIAL_TYPE_REGULAR_DAILY_QUEST_LIST:String = "regularDailyQuestList";
        public static const NOQUEST_ACTIVE_TEXT:String = "no quest active";
        public static const ACTIVATE_LOGS:Boolean = false;
        public static const ACTIVATE_SIMPLE_LOGS:Boolean = true;
        private static const TRIGGER_NAME_ALL_GENERALS:String = "AllGenerals";
        private static const TRIGGER_NAME_ALL_EXPLORERS:String = "AllExplorers";
        private static const TRIGGER_NAME_ALL_GEOLOGISTS:String = "AllGeologists";
        public static const QUEST_TRIGGER_STATUS_RUNNING:int = 0;
        public static const QUEST_TRIGGER_STATUS_WON:int = 1;
        public static const QUEST_TRIGGER_STATUS_FAILED:int = -1;
        public static var mQuestContainer_map:Dictionary = new Dictionary();
        private static const mActivateQuestSystem:Boolean = true;
        private static var mTypeDictionary:cStringIntDictionary = new cStringIntDictionary();
        private static var mType_vector:Vector.<String> = new Vector.<String>();
        private static var mConditionDictionary:cStringIntDictionary = new cStringIntDictionary();
        private static var mCondition_vector:Vector.<String> = new Vector.<String>();


        private static function AddToTypDictionary(_arg_1:String, _arg_2:int):void
        {
            gMisc.Assert((_arg_2 == mType_vector.length), ("AddToTypDictionary(): the elements should be added to the dictionary in the right order. Mismatch found for " + _arg_1));
            mTypeDictionary.Put(_arg_1, mType_vector.length);
            mType_vector.push(_arg_1);
        }

        public static function GetQuestModeString(_arg_1:int):String
        {
            switch (_arg_1)
            {
                case QUEST_MODE_LOOP_UNTIL_QUEST_REWARD_COULD_BE_ASSIGNED:
                    return ("LoopUntilQuestRewardCouldBeAssigned");
                case QUEST_MODE_START_WINDOW_DESCRIPTION_WAIT_FOR_BUTTON_PRESSED:
                    return ("QuestWindowWaitForButtonPressed");
                case QUEST_MODE_RUNNING:
                    return ("Running");
                case QUEST_MODE_INIT_REWARD_WINDOW:
                    return ("InitRewardWindow");
                case QUEST_MODE_REWARD_WINDOW_WAIT_FOR_BUTTON_ACTIVE:
                    return ("RewardWindowWaitForButtonActive");
                case QUEST_MODE_START_DELAY:
                    return ("StartDelay");
                case QUEST_MODE_SHOW_WINDOW_DESCRIPTION:
                    return ("ShowWindowDescription");
                case QUEST_MODE_PRESS_REWARD_BUTTON:
                    return ("PressRewardButton");
                case QUEST_MODE_PENDING_NEXT_RANDOM_DAILY_QUEST:
                    return ("PendingNextRandomDailyQuest");
                case QUEST_MODE_WAIT_FOR_FINISH:
                    return ("WaitForFinish");
                case QUEST_MODE_DEACTIVATED:
                    return ("Deactivated");
                case QUEST_MODE_REWARD_COLLECTED_IDLE:
                    return ("Finished");
                case QUEST_MODE_QUEST_FAILED:
                    return ("QuestFailed");
                default:
                    return ("" + _arg_1);
            };
        }

        public static function IsLastPartialGuildQuest(_arg_1:dQuestDefinitionVO):Boolean
        {
            return ((_arg_1.specialType_string == QuestManagerStatic.SPECIAL_TYPE_LAST_QUEST) && (IsPartialGuildQuest(_arg_1)));
        }

        public static function ApplyRewardEffects(_arg_1:cGeneralInterface, _arg_2:dQuestElementVO, _arg_3:cPlayerData):void
        {
            var _local_4:cResources;
            var _local_6:dQuestDefinitionRewardVO;
            var _local_7:dResource;
            var _local_8:int;
            var _local_9:int;
            var _local_10:int;
            var _local_11:int;
            var _local_12:int;
            var _local_13:dUniqueID;
            var _local_14:String;
            var _local_15:dUniqueID;
            var _local_16:dBuffVO;
            var _local_17:cBuff;
            var _local_18:int;
            var _local_19:ConvertedXp;
            var _local_20:int;
            _local_4 = null;
            var _local_5:dQuestDefinitionVO = _arg_2.mQuestDefinition;
            if (_local_5.questReward.length > 0)
            {
                _local_4 = _arg_1.mCurrentPlayerZone.GetResources(_arg_3);
            };
            for each (_local_6 in _local_5.questReward)
            {
                if (cLog.isInfoEnabled())
                {
                    cLog.info(((((("P:" + _arg_3.GetPlayerId()) + " QuestReward achieved for Quest: ") + _arg_2.getQuestName_string()) + " Reward: ") + _local_6));
                };
                switch (_local_6.type)
                {
                    case QuestManagerStatic.TYPE_RESOURCE:
                        _local_7 = _local_4.GetPlayerResource(_local_6.name_string);
                        if (_local_7 == null)
                        {
                            _local_14 = ((((("P:" + _arg_3.GetPlayerId()) + " Resource name in quest ") + _arg_2.getQuestName_string()) + " not found! Reward: ") + _local_6);
                            cLog.error(_local_14);
                            return;
                        };
                        _local_8 = (_local_7.maxLimit - _local_7.amount);
                        if (_local_6.amount <= _local_8)
                        {
                            _local_9 = _local_6.amount;
                        }
                        else
                        {
                            _local_9 = _local_8;
                            globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.QUEST_REWARD_LIMIT_REACHED, new dResource().Init(_local_6.name_string, _local_6.amount));
                            _local_15 = new dUniqueID();
                            if (_arg_2.mUniqueIDs_vector.length != 0)
                            {
                                _local_15 = (_arg_2.mUniqueIDs_vector.getItemAt(0) as dUniqueID);
                                _arg_2.mUniqueIDs_vector.removeItemAt(0);
                            }
                            else
                            {
                                cLog.error(((("ApplyRewardEffects have no Buff UniqueID defined! For: " + _arg_2.getQuestName_string()) + " with ") + _local_6));
                            };
                            _local_16 = new dBuffVO();
                            _local_16.buffName_string = "AddResource";
                            _local_16.amount = (_local_6.amount - _local_9);
                            _local_16.resourceName_string = _local_6.name_string;
                            _local_16.uniqueId1 = _local_15.uniqueID1;
                            _local_16.uniqueId2 = _local_15.uniqueID2;
                            _local_17 = cBuff.CreateBuffFromVO(_local_16);
                            _arg_1.mCurrentPlayer.addBuff(_local_17);
                        };
                        _local_4.AddResource(_local_6.name_string, _local_9, ModifyReason.QUEST_REWARD, null);
                        if (_local_6.name_string == defines.HARD_CURRENCY_RESOURCE_NAME_string)
                        {
                            _local_18 = _local_4.GetResourceAmount(defines.HARD_CURRENCY_RESOURCE_NAME_string);
                            TrackManager.getInstance().trackGemQuestRewarded(_arg_3, _arg_2.GetQuestDefinition().questName_string, _local_6.amount, _local_18, ((_local_5.questTyp == QUEST_TYPE_DAILY_LOGIN_QUEST) ? "DailyLogin" : "Quest"));
                        };
                        break;
                    case QuestManagerStatic.TYPE_XP:
                        _local_10 = _local_6.amount;
                        if (_local_6.name_string == "formula")
                        {
                            _local_10 = int(((global.playerLevelRewardXPs_vector[(_arg_3.GetPlayerLevel() - 1)] * _local_10) / 100));
                        };
                        _local_11 = _arg_3.AddXP(_local_10);
                        if (_local_11 > 0)
                        {
                            _local_19 = XpConversionCalculator.convertXp(_local_11);
                            _local_4.AddResource(_local_19.resourceName, _local_19.amount, ModifyReason.ADD_XP, null);
                        };
                        break;
                    case QuestManagerStatic.TYPE_SPECIALIST:
                        _local_12 = SPECIALIST_TYPE.parse(_local_6.name_string);
                        _local_13 = new dUniqueID();
                        _local_13.uniqueID1 = (gMisc.GetMaxIntValue() - 10000);
                        _local_13.uniqueID2 = (gMisc.GetMaxIntValue() - 10000);
                        _local_20 = 0;
                        while (_local_20 < _local_5.questName_string.length)
                        {
                            _local_13.uniqueID2 = (_local_13.uniqueID2 + _local_5.questName_string.charCodeAt(_local_20));
                            _local_20++;
                        };
                        (_arg_1 as cGameInterface).BuySpecialistDirect(_arg_3, _local_12, _local_13, false);
                        break;
                    case QuestManagerStatic.TYPE_MILITARYUNIT:
                        break;
                };
            };
        }

        public static function GetQuestInfo(_arg_1:dQuestDefinitionVO):String
        {
            if (_arg_1 != null)
            {
                return (("{" + _arg_1.questName_string) + "}");
            };
            return (" {null}");
        }

        public static function GetQuestTypeString(_arg_1:int):String
        {
            switch (_arg_1)
            {
                case QUEST_TYPE_DEFAULT:
                    return ("default");
                case QUEST_TYPE_IS_IN_RANDOM_LIST_OF_DAILY_QUEST:
                    return ("Is in random List of a Daily Quest");
                case QUEST_TYPE_DAILY_LOGIN_QUEST:
                    return ("Daily Login Quest");
                case QUEST_TYPE_DAILY_QUEST:
                    return ("Daily Quest");
                case QUEST_TYPE_DAILY_GUILD_QUEST:
                    return ("Daily Guild Quest");
                default:
                    return ("Unknown: " + _arg_1);
            };
        }

        public static function GetQuestsDefinitionsFromWildcard(_arg_1:int, _arg_2:String, _arg_3:Boolean):Vector.<dQuestDefinitionVO>
        {
            var _local_6:dQuestDefinitionVO;
            var _local_7:Boolean;
            var _local_8:dQuestDefinitionVO;
            var _local_4:Vector.<dQuestDefinitionVO> = new Vector.<dQuestDefinitionVO>();
            var _local_5:dQuestDefinitionContainerVO = QuestManagerStatic.mQuestContainer_map.get(_arg_1);
            if (((!(_local_5 == null)) && (!(_local_5.questDefinitions == null))))
            {
                for each (_local_6 in _local_5.questDefinitions)
                {
                    _local_7 = false;
                    if (((_arg_3) && (StringUtils.startsWith(_local_6.questName_string, _arg_2))))
                    {
                        _local_7 = true;
                    }
                    else
                    {
                        if (StringUtils.contains(_arg_2, _local_6.questName_string))
                        {
                            _local_7 = true;
                        };
                    };
                    if (_local_7)
                    {
                        for each (_local_8 in _local_5.questDefinitions)
                        {
                            if (_local_8.connectedToQuest_string == _local_6.questName_string)
                            {
                                _local_4.push(_local_8);
                            };
                        };
                        _local_4.push(_local_6);
                    };
                };
            };
            return (_local_4);
        }

        public static function CheckPreviousQuestDefinitionRecursiv(_arg_1:dQuestDefinitionVO, _arg_2:String):Boolean
        {
            if (_arg_1.previousQuestDefinition != null)
            {
                if (_arg_1.previousQuestDefinition.questName_string == _arg_2)
                {
                    return (true);
                };
                if (CheckPreviousQuestDefinitionRecursiv(_arg_1.previousQuestDefinition, _arg_2))
                {
                    return (true);
                };
            };
            return (false);
        }

        public static function GetRandomQuest(_arg_1:dQuestDefinitionPostrequisitsVO):dQuestDefinitionPostrequisitsVO
        {
            var _local_2:int = (gMisc.GetRandomMinMax(0, (_arg_1.postrequisits_vector.length - 1)) as int);
            return (_arg_1.postrequisits_vector[_local_2]);
        }

        public static function ConvertStringToCondition(_arg_1:String):int
        {
            return (mConditionDictionary.Get(_arg_1));
        }

        public static function GetQuestFromName(_arg_1:int, _arg_2:String):dQuestDefinitionVO
        {
            var _local_4:dQuestDefinitionVO;
            var _local_3:dQuestDefinitionContainerVO = QuestManagerStatic.mQuestContainer_map[_arg_1];
            if (((_local_3 == null) || (_local_3.questDefinitions == null)))
            {
                return (null);
            };
            for each (_local_4 in _local_3.questDefinitions)
            {
                if (_local_4.questName_string == _arg_2)
                {
                    return (_local_4);
                };
            };
            return (null);
        }

        public static function isQuestRunning(_arg_1:int):Boolean
        {
            if (((((_arg_1 == QuestManagerStatic.QUEST_MODE_START_WINDOW_DESCRIPTION_WAIT_FOR_BUTTON_PRESSED) || (_arg_1 == QuestManagerStatic.QUEST_MODE_RUNNING)) || (_arg_1 == QuestManagerStatic.QUEST_MODE_SHOW_WINDOW_DESCRIPTION)) || (_arg_1 == QuestManagerStatic.QUEST_MODE_QUEST_FAILED)))
            {
                return (true);
            };
            return (false);
        }

        public static function IsPartialGuildQuest(_arg_1:dQuestDefinitionVO):Boolean
        {
            var _local_2:dQuestDefinitionVO;
            if (((!(_arg_1 == null)) && (!(_arg_1.previousQuestDefinition == null))))
            {
                _local_2 = _arg_1.previousQuestDefinition;
                if (_local_2.specialType_string == QuestManagerStatic.SPECIAL_TYPE_GUILD_QUEST)
                {
                    return (true);
                };
                return (IsPartialGuildQuest(_local_2));
            };
            return (false);
        }

        public static function IsActive():Boolean
        {
            return (mActivateQuestSystem);
        }

        public static function isQuestActive(_arg_1:int):Boolean
        {
            if ((((((_arg_1 == QuestManagerStatic.QUEST_MODE_START_WINDOW_DESCRIPTION_WAIT_FOR_BUTTON_PRESSED) || (_arg_1 == QuestManagerStatic.QUEST_MODE_RUNNING)) || (_arg_1 == QuestManagerStatic.QUEST_MODE_START_DELAY)) || (_arg_1 == QuestManagerStatic.QUEST_MODE_SHOW_WINDOW_DESCRIPTION)) || (_arg_1 == QuestManagerStatic.QUEST_MODE_QUEST_FAILED)))
            {
                return (true);
            };
            return (false);
        }

        public static function ConvertTypeToString(_arg_1:int):String
        {
            if (((_arg_1 >= 0) && (_arg_1 < mType_vector.length)))
            {
                return (mType_vector[_arg_1]);
            };
            return ("<unknown Type>");
        }

        private static function InitDictionaries():void
        {
            mTypeDictionary.Reset();
            mType_vector.length = 0;
            AddToTypDictionary("Unset", TYPE_UNSET);
            AddToTypDictionary("Building", TYPE_BUILDING);
            AddToTypDictionary("Resource", TYPE_RESOURCE);
            AddToTypDictionary("XP", TYPE_XP);
            AddToTypDictionary("PlayerLevel", TYPE_PLAYERLEVEL);
            AddToTypDictionary("Sector", TYPE_SECTOR);
            AddToTypDictionary("Specialist", TYPE_SPECIALIST);
            AddToTypDictionary("MilitaryUnit", TYPE_MILITARYUNIT);
            AddToTypDictionary("Buff", TYPE_BUFF);
            AddToTypDictionary("BuildingsWithUnits", TYPE_BUILDINGS_WITH_UNITS);
            AddToTypDictionary("Adventure", TYPE_ADVENTURE);
            AddToTypDictionary("Loot", TYPE_LOOT);
            AddToTypDictionary("DailyTime", TYPE_DAILYTIME);
            AddToTypDictionary("DailyLogin", TYPE_DAILYLOGIN);
            AddToTypDictionary("StartQuest", TYPE_STARTQUEST);
            AddToTypDictionary("RandomQuestList", TYPE_RANDOM_QUEST_LIST);
            AddToTypDictionary("BuffOnFriend", TYPE_BUFF_ON_FRIEND);
            AddToTypDictionary("BuffByFriend", TYPE_BUFF_BY_FRIEND);
            AddToTypDictionary("PayForQuestFinish", TYPE_PAY_FOR_QUEST_FINISH);
            AddToTypDictionary("Friends", TYPE_FRIENDS);
            AddToTypDictionary("DailyTimeGuild", TYPE_GUILD_DAILYTIME);
            AddToTypDictionary("GuildSize", TYPE_GUILDSIZE);
            AddToTypDictionary("FinishPercentage", TYPE_FINISHPERCENTAGE);
            AddToTypDictionary("WindowOpen", TYPE_OPEN_WINDOW);
            AddToTypDictionary("Presskey", TYPE_KEY_PRESS);
            AddToTypDictionary("QuestComplete", TYPE_QUEST_COMPLETE);
            AddToTypDictionary("WinBattlewithUnits", TYPE_WIN_BATTLE_WITH_UNITS);
            AddToTypDictionary("CheckStorage", TYPE_CHECK_STORAGE);
            AddToTypDictionary("CheckPopulation", TYPE_CHECK_POPULATION);
            AddToTypDictionary("CheckArmy", TYPE_CHECK_ARMY);
            AddToTypDictionary("CheckAdventureType", TYPE_PLAY_SPECIFIC_ADVENTURE);
            AddToTypDictionary("Movebuilding", TYPE_MOVE_BUILDING);
            AddToTypDictionary("Deposit", TYPE_REFILL_DEPOSIT);
            AddToTypDictionary("Shopitem", TYPE_SHOP_ITEM);
            AddToTypDictionary("SpecialistTask", TYPE_SPECIALIST_TASK);
            AddToTypDictionary("ProdTime", TYPE_PRODUCTION_TIME);
            AddToTypDictionary("Bandits", TYPE_BANDITS);
            AddToTypDictionary("FriendVisit", TYPE_FRIEND_VISIT);
            AddToTypDictionary("ProductionValue", TYPE_PRODUCTION_VALUE);
            AddToTypDictionary("RefillBuff", TYPE_REFILL_BUFF);
            AddToTypDictionary("Collections", TYPE_COLLECTIONS);
            AddToTypDictionary("SkillLevel", TYPE_SKILL_LEVEL);
            AddToTypDictionary("BronzeSkillTreePoints", TYPE_BRONZE_SKILLTREE_POINTS);
            AddToTypDictionary("SilverSkillTreePoints", TYPE_SILVER_SKILLTREE_POINTS);
            AddToTypDictionary("GoldSkillTreePoints", TYPE_GOLD_SKILLTREE_POINTS);
            AddToTypDictionary("NewQuestTrigger", TYPE_NEW_QUEST_TRIGGER);
            AddToTypDictionary("EventCollections", TYPE_EVENT_COLLECTIONS);
            mConditionDictionary.Reset();
            mCondition_vector.length = 0;
            AddToConditionDictionary("unset");
            AddToConditionDictionary("onMap");
            AddToConditionDictionary("created");
            AddToConditionDictionary("ge");
            AddToConditionDictionary("destroyed");
            AddToConditionDictionary("explored");
            AddToConditionDictionary("claimed");
            AddToConditionDictionary("assignedUnits");
            AddToConditionDictionary("upgraded");
            AddToConditionDictionary("selected");
            AddToConditionDictionary("foundDeposit");
            AddToConditionDictionary("used");
            AddToConditionDictionary("l");
            AddToConditionDictionary("onMapVisitor");
            AddToConditionDictionary("geDelta");
            AddToConditionDictionary("produce");
            AddToConditionDictionary("consume");
            AddToConditionDictionary("buy");
            AddToConditionDictionary("sell");
            AddToConditionDictionary("claimedGe");
            AddToConditionDictionary("claimedLess");
            AddToConditionDictionary("questcompleted");
            AddToConditionDictionary("winbattlewithunits");
            AddToConditionDictionary("addfriends");
            AddToConditionDictionary("ChkStorage");
            AddToConditionDictionary("ChkResources");
            AddToConditionDictionary("ChkArmy");
            AddToConditionDictionary("moved");
            AddToConditionDictionary("bought");
            AddToConditionDictionary("found");
            AddToConditionDictionary("le");
            AddToConditionDictionary("levelupgrade");
            AddToConditionDictionary("visited");
            AddToConditionDictionary("exploredGe");
            AddToConditionDictionary("exploredGeDelta");
            AddToConditionDictionary("keypress");
            AddToConditionDictionary("ActivePlayer");
        }

        public static function ConvertStringToType(_arg_1:String):int
        {
            return (mTypeDictionary.Get(_arg_1));
        }

        public static function Init():void
        {
            InitDictionaries();
        }

        public static function GetGuildQuestOfPartialQuest(_arg_1:dQuestDefinitionVO):dQuestDefinitionVO
        {
            var _local_2:dQuestDefinitionVO;
            if (((!(_arg_1 == null)) && (!(_arg_1.previousQuestDefinition == null))))
            {
                _local_2 = _arg_1.previousQuestDefinition;
                if (_local_2.specialType_string == QuestManagerStatic.SPECIAL_TYPE_GUILD_QUEST)
                {
                    return (_local_2);
                };
                return (GetGuildQuestOfPartialQuest(_local_2));
            };
            return (null);
        }

        public static function ConvertConditionToString(_arg_1:int):String
        {
            if (((_arg_1 >= 0) && (_arg_1 < mCondition_vector.length)))
            {
                return (mCondition_vector[_arg_1]);
            };
            return ("<unknown condition>");
        }

        public static function GetQuestRewardString(_arg_1:int):String
        {
            return (mType_vector[_arg_1]);
        }

        private static function AddToConditionDictionary(_arg_1:String):void
        {
            mConditionDictionary.Put(_arg_1, mCondition_vector.length);
            mCondition_vector.push(_arg_1);
        }

        public static function GetQuestStatusPosition(_arg_1:int):int
        {
            var _local_2:int = QUEST_MODE_DEACTIVATED;
            switch (_arg_1)
            {
                case QUEST_MODE_PENDING_NEXT_RANDOM_DAILY_QUEST:
                    _local_2--;
                case QUEST_MODE_START_DELAY:
                    _local_2--;
                case QUEST_MODE_SHOW_WINDOW_DESCRIPTION:
                    _local_2--;
                case QUEST_MODE_START_WINDOW_DESCRIPTION_WAIT_FOR_BUTTON_PRESSED:
                    _local_2--;
                case QUEST_MODE_RUNNING:
                    _local_2--;
                case QUEST_MODE_INIT_REWARD_WINDOW:
                    _local_2--;
                case QUEST_MODE_WAIT_FOR_FINISH:
                    _local_2--;
                case QUEST_MODE_REWARD_WINDOW_WAIT_FOR_BUTTON_ACTIVE:
                    _local_2--;
                case QUEST_MODE_PRESS_REWARD_BUTTON:
                    _local_2--;
                case QUEST_MODE_LOOP_UNTIL_QUEST_REWARD_COULD_BE_ASSIGNED:
                    _local_2--;
                case QUEST_MODE_QUEST_FAILED:
                    _local_2--;
                case QUEST_MODE_REWARD_COLLECTED_IDLE:
                    _local_2--;
                case QUEST_MODE_DEACTIVATED:
                    break;
            };
            return (_local_2);
        }

        public static function IsQuestReadyForSubmit(_arg_1:dQuestElementVO, _arg_2:Boolean):Boolean
        {
            var _local_6:dQuestDefinitionTriggerVO;
            var _local_7:dQuestTriggerVO;
            var _local_8:cSquad;
            var _local_3:int;
            var _local_4:int = (_arg_1.mQuestDefinition.questTriggers_vector.length - _arg_1.mQuestDefinition.failConditions_vector.length);
            var _local_5:int;
            while (_local_5 < _local_4)
            {
                _local_6 = _arg_1.mQuestDefinition.questTriggers_vector[_local_5];
                _local_7 = _arg_1.mQuestTriggersFinished_vector[_local_5];
                switch (_local_6.type)
                {
                    case QuestManagerStatic.TYPE_PAY_FOR_QUEST_FINISH:
                        if (_arg_2)
                        {
                            if (global.resourceDefinitions_vector.indexOf(_local_6.name_string) != -1)
                            {
                                if (_local_6.name_string == defines.POPULATION_RESOURCE_NAME_string)
                                {
                                    if (global.ui.mCurrentPlayerZone.GetResources(global.ui.mCurrentPlayer).GetFree() >= _local_6.amount)
                                    {
                                        _local_3++;
                                        break;
                                    };
                                }
                                else
                                {
                                    if (global.ui.mCurrentPlayerZone.GetResources(global.ui.mCurrentPlayer).HasPlayerResource(_local_6.name_string, _local_6.amount))
                                    {
                                        _local_3++;
                                        break;
                                    };
                                };
                            }
                            else
                            {
                                _local_8 = global.ui.mCurrentPlayerZone.GetArmy(global.ui.mCurrentPlayer.GetPlayerId()).GetSquad(_local_6.name_string);
                                if (((!(_local_8 == null)) && (_local_8.amount >= _local_6.amount)))
                                {
                                    _local_3++;
                                    break;
                                };
                            };
                        };
                    default:
                        if (_local_7.status > 0)
                        {
                            _local_3++;
                        };
                };
                _local_5++;
            };
            return (_local_3 == _local_4);
        }

        public static function GetAmountOfSpecialistsForTriggerName(_arg_1:cGeneralInterface, _arg_2:int, _arg_3:String):int
        {
            gMisc.Assert((!(_arg_3 == null)), "GetAmountOfSpecialistsForTriggerName(): _triggerName must not be null!");
            if (_arg_3 == TRIGGER_NAME_ALL_GENERALS)
            {
                return (_arg_1.mCurrentPlayerZone.GetAmountOfBaseSpecialists(_arg_2, SPECIALIST_TYPE.GENERAL));
            };
            if (_arg_3 == TRIGGER_NAME_ALL_EXPLORERS)
            {
                return (_arg_1.mCurrentPlayerZone.GetAmountOfBaseSpecialists(_arg_2, SPECIALIST_TYPE.EXPLORER));
            };
            if (_arg_3 == TRIGGER_NAME_ALL_GEOLOGISTS)
            {
                return (_arg_1.mCurrentPlayerZone.GetAmountOfBaseSpecialists(_arg_2, SPECIALIST_TYPE.GEOLOGIST));
            };
            return (_arg_1.mCurrentPlayerZone.GetAmountOfSpecialists(_arg_2, SPECIALIST_TYPE.parse(_arg_3)));
        }

        public static function PreApplyRewardEffects(_arg_1:cGeneralInterface, _arg_2:dQuestElementVO, _arg_3:cPlayerData):void
        {
        }


    }
}
