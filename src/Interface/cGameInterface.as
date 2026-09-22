package Interface
{
    import Tracks.IdleDetection;
    import Tracks.UITimeAndClickDetection;
    import ServerState.cPlayerData;
    import Communication.VO.IntegerListVO;
    import Effects.EffectFactory;
    import flash.net.FileReferenceList;
    import flash.net.FileReference;
    import Utils.HashSetWrapper;
    import Communication.VO.dRequirementListsVO;
    import flash.utils.Dictionary;
    import flash.utils.Timer;
    import Specialists.cSpecialist;
    import __AS3__.vec.Vector;
    import ServerState.dResource;
    import ServerState.cResources;
    import GUI.Components.CustomAlert;
    import Enums.ModifyReason;
    import com.bluebyte.tso.util.TimeUtil;
    import Tracks.TrackManager;
    import Enums.SPECIALIST_GAIN_SOURCE;
    import Enums.AVATAR_MESSAGE_TYPE;
    import Enums.SPECIALIST_TYPE;
    import nLib.cLog;
    import Communication.VO.dUniqueID;
    import TimedProduction.cTimedProductionQueue;
    import nLib.gMisc;
    import TimedProduction.cTimedProduction;
    import Enums.DIRTY_INDICATOR;
    import Communication.VO.dTimedProductionQueueChangeVO;
    import Communication.VO.EffectVO;
    import BuffSystem.cBuff;
    import Communication.VO.Guild.dGuildBankWithdrawVO;
    import Communication.VO.dBuffVO;
    import Enums.ERROR_CODES;
    import Communication.VO.Guild.dGuildBankTransactionVO;
    import Enums.GUILD_BANK_TRANSACTION_TYPE;
    import Enums.GUILD_BANK_GROUP;
    import Communication.VO.dGameTickCommandVO;
    import flash.events.MouseEvent;
    import Communication.VO.collectibles.CollectionResourceVO;
    import BuffSystem.cBuffDefinition;
    import Communication.VO.collectibles.CreateCollectionResultVO;
    import Collections.CollectionsManager;
    import Communication.VO.collectibles.CollectionVO;
    import Utils.TriggerUtils;
    import Communication.VO.dServerAction;
    import Communication.VO.dBuffApplianceVO;
    import GO.epicWorkyard.EpicWorkyardMasterBuilding;
    import GO.epicWorkyard.EpicWorkyardSubBuilding;
    import Communication.VO.dMoveBuildingVO;
    import GO.cBuilding;
    import Communication.VO.dBuyOneClickShopItemVO;
    import Communication.VO.dTradeOfferVO;
    import Enums.TRADE_SLOT_TYPE;
    import Enums.TRADE_TYPE;
    import Enums.COMMAND;
    import Enums.ONE_CLICK_SHOPITEM;
    import flash.events.FocusEvent;
    import Communication.VO.dServerResponse;
    import Communication.VO.dAcceptTradeVO;
    import Communication.VO.dSpecialistVO;
    import Communication.VO.dResourceVO;
    import Communication.VO.UpdateVO.dLootItemsVO;
    import Communication.VO.AddResourceResponseVO;
    import Collections.BuffUtils;
    import Collections.CollectionsConsts;
    import Communication.VO.CombatPreviewPathVO;
    import flash.utils.getTimer;
    import Communication.VO.dBankDonationVO;
    import nLib.cBackbuffer;
    import flash.system.Capabilities;
    import Communication.VO.dTradeCompleteVO;
    import TimedProduction.EffectTimedProductionDefinition;
    import Utils.StringUtils;
    import Communication.VO.dTradeCompleteUpdateVO;
    import GUI.GUIObserver;
    import ServerState.gEconomics;
    import flash.events.TimerEvent;
    import MilitarySystem.cSquad;
    import Communication.VO.dRaiseArmyVO;
    import MilitarySystem.iMilitaryUnitHolder;
    import MilitarySystem.cMilitaryUnitData;
    import MilitarySystem.cMilitaryUtil;
    import Enums.COOLDOWN_TYPE;
    import Enums.OBJECTTYPE;
    import Map.GridPosition;
    import Communication.VO.UpdateVO.dCasualty;
    import Communication.VO.dPurchasedShopItemVO;
    import ShopSystem.cShopItem;
    import Communication.VO.dAdventCalendarDoorVO;
    import Communication.VO.dLeaveAdventureVO;
    import AdventureSystem.cAdventure;
    import Specialists.cSpecialistTask_TravelToZone;
    import Enums.TASK_PHASES_TRAVEL_TO_ZONE;
    import Specialists.cSpecialistTask;
    import Enums.TASK_PHASES_ATTACK_BUILDING;
    import Enums.SPECIALIST_TASK_TYPES;
    import Specialists.cSpecialistTask_AttackBuilding;
    import Specialists.cSpecialistTask_AttackBuildingNewCombat;
    import Communication.VO.dDepositVO;
    import Communication.VO.dQuestElementVO;
    import Communication.VO.dTempBuildSlotVO;
    import Communication.VO.dBuffListVO;
    import Fulfilments.Trigger.FulfilmentTrigger;
    import Communication.VO.TriggerVO;
    import Tasks.Task;
    import ShopSystem.cItemContent;
    import Communication.VO.dBuyShopItemVO;
    import ShopSystem.cShopItemGroup;
    import mx.collections.ArrayCollection;
    import Skill.cSkillList;
    import Communication.VO.dPersistedItemRegistryVO;
    import Communication.VO.CombatCommandVO;
    import GO.buildings.cCollectibleBuilding;
    import nLib.cPosInt;
    import GO.cLandscape;
    import Enums.DEPOSIT_ACCESSIBLE_TYPES;
    import GO.cDeposit;
    import GUI.Effects.gHintManager;
    import Communication.VO.ColonyCommandVO;
    import Colony.cColony;
    import Communication.VO.dPlayerVotePoolVO;
    import Communication.VO.Votes.dPlayerVoteVO;
    import Votes.cVoteDefinition;
    import Communication.VO.Guild.dGuildBankBuyTabVO;
    import GUI.GAME.cBasicPanel;
    import converted.bluebyte.tso.quests.logic.QuestManagerStatic;
    import Communication.VO.dIntegerVO;
    import Communication.VO.UpdateVO.dAdventurePlayerVO;
    import ServerState.cResourceCreation;
    import Utils.ModifiableCost;
    import GUI.Components.ResourceAlert;
    import ServerState.cComputeResourceCreation;
    import Specialists.cSpecialistTask_FindExpedition;
    import Specialists.cSpecialistTask_FindEventZone;
    import Communication.VO.dStartSpecialistTaskVO;
    import Specialists.cSpecialistTaskDefinition;
    import Specialists.cSpecialistSubTaskDefinition;
    import Communication.VO.dRequirementsVO;
    import Specialists.cSpecialistTask_FindDeposit;
    import Enums.TASK_PHASES_FIND_DEPOSIT;
    import Specialists.cSpecialistTask_ExploreSector;
    import Enums.TASK_PHASES_EXPLORE_SECTOR;
    import Specialists.cSpecialistTask_FindTreasure;
    import Enums.TASK_PHASES_FIND_TREASURE;
    import Enums.KILL_SWITCH;
    import Enums.TASK_PHASES_FIND_EXPEDITION;
    import Enums.TASK_PHASES_FIND_EVENT_ZONE;
    import Map.AdditionalDataTSO;
    import GO.cBlockingData;
    import Specialists.cSpecialistTask_Move;
    import Enums.TASK_PHASES_MOVE;
    import Specialists.cSpecialistTask_TravelToStarMenu;
    import Enums.TASK_PHASES_TRAVEL_TO_STAR_MENU;
    import Enums.SECTOR_DISCOVERY_TYPE;
    import Communication.VO.DestructBuildingResultVO;
    import Communication.VO.epicWorkyard.EpicWorkyardChangeProductionVO;
    import EpicWorkyard.EpicWorkyardsManager;
    import Communication.VO.epicWorkyard.EpicWorkyardStopProductionChainVO;
    import Communication.VO.Guild.dGuildBankEnlargeVO;
    import Communication.VO.dUpdateVO;
    import GUI.Effects.gGlowManager;
    import Enums.CAMP_TYPE;
    import Communication.VO.UpdateVO.dMailsDismissedVO;
    import MilitarySystem.cMilitaryUnitBase;
    import Fulfilments.Identity;
    import Communication.VO.dSpecialistResultVO;
    import Communication.VO.dResourcesVO;
    import Communication.VO.dArmyVO;
    import GUI.GAME.Chat.TSOChatMediator;
    import Communication.VO.Tasks.TaskClaimVO;
    import Communication.VO.UpdateVO.dFoundDepositVO;
    import Enums.EXPLORED_DEPOSIT_RESULT;
    import Communication.VO.SetBuildingVO;
    import Skill.cSkillTree;
    import Enums.SKILL_OWNER;
    import Enums.ADVENT_CALENDAR_DOOR_STATUS;
    import Enums.ADVENT_CALENDAR_DOOR_SPECIAL_TYPE;
    import Model.Notifiers.CalendarChannel;
    import Communication.VO.epicWorkyard.EpicWorkyardCreateProductionChainVO;
    import EpicWorkyard.EpicWorkyardConsts;
    import Enums.BUFF_TYPE;
    import GO.cGO;
    import Model.Notifiers.BuffAppliedNotification;
    import Enums.TRIGGER_ACTION;
    import GO.cIsoGO;
    import Sound.cSoundManager;
    import Communication.VO.Guild.dGuildBankTransferVO;
    import Communication.VO.dSquadVO;
    import MilitarySystem.cMilitaryUnitDescription;
    import Communication.VO.Skill.ResetSkillsVO;
    import Communication.VO.UpdateVO.dAdventureClientInfoVO;
    import AdventureSystem.cAdventureDefinition;
    import GUI.GAME.cBasicInfoPanel;
    import com.bluebyte.tso.adventure.logic.AdventureManager;
    import Communication.VO.dQuestDefinitionTriggerVO;
    import Communication.VO.dQuestTriggerVO;
    import Communication.VO.UpdateVO.dHardCurrencyPurchased;
    import Communication.VO.dTimedProductionVO;
    import TimedProduction.iTimedProductionDefinition;
    import TimedProduction.cTimedProductionUtl;
    import Enums.TIMED_PRODUCTION_TYPE;
    import Communication.VO.collectibles.PickupsDataVO;
    import Communication.VO.Skill.ChangeSkillsVO;
    import Communication.VO.Achievements.UserAchievementDataVO;
    import __AS3__.vec.*;

    public class cGameInterface extends cGeneralInterface 
    {

        public static const LOAD_MAP_DIRECT:Boolean = (!(global.useExternalServer));
    public static const MAX_SPOOL_TIME:Number = 60000;
    private var mInitInitalizedStartGame:Boolean = false;
        private var idleDetection:IdleDetection;
        private var uiTimeAndClickDetection:UITimeAndClickDetection;
        public var mChatWindowActive:Boolean = false;
        public var mIsBuffOnFriendQuestActive:Boolean = false;
        private var mGameTickCommandPlayer:cPlayerData;
        public var debugCompareDiff:IntegerListVO = null;
        public var effectFactory:EffectFactory = null;
        private var mInitInitalized:Boolean = false;
        public var mSpecificShopItems:Boolean = false;
        private var fileReferenceList:FileReferenceList;
        private var mLastXPUpdate:Number;
        public var mGfxDeltaTicks:Number;
        private var fr:FileReference;
        public var mIsVisitFriendsQuestActive:Boolean = false;
        public var mLastGfxDeltaTicksUpdate:Number = -1;

        public var mEnabledShopItems_vector:HashSetWrapper = new HashSetWrapper();
        public var mRequirements:dRequirementListsVO = new dRequirementListsVO();
        private var pendingEventChecks:Dictionary = new Dictionary();
        private var checkPendingEventTimer:Timer = new Timer(10000, 1);


        private static function WaitTaskCompare(_arg_1:cSpecialist, _arg_2:cSpecialist):Number
        {
            return (_arg_1.GetSortValue() - _arg_2.GetSortValue());
        }


        public function BuySpecialistDirect(_arg_1:cPlayerData, _arg_2:int, _arg_3:dUniqueID, _arg_4:Boolean):void
        {
            var _local_8:Vector.<dResource>;
            var _local_5:cResources = mCurrentPlayerZone.GetResources(_arg_1);
            if (_arg_4)
            {
                _local_8 = cSpecialist.GetCostsToBuy_vector(_arg_2, _arg_1.GetSpecialistAmount(_arg_2));
                if (!_local_5.HasPlayerResourcesInListOne(_local_8))
                {
                    CustomAlert.show("CantBuySpecialist", "CantBuySpecialist");
                    return;
                };
                _local_5.RemovePlayerResourcesFromResourcesInList(_local_8, 1, ModifyReason.BUY_SPECIALIST);
            };
            var _local_6:cSpecialist = new cSpecialist(true).InitSpecialistFromType(_arg_2, _arg_3, _arg_1.GetPlayerId(), mCurrentViewedZoneID, this);
            _local_6.insertedAt = TimeUtil.getServerTime();
            mCurrentPlayerZone.addSpecialist(_local_6);
            _arg_1.IncSpecialistAmount(_local_6.GetType());
            var _local_7:int = _local_5.GetResourceAmount(defines.HARD_CURRENCY_RESOURCE_NAME_string);
            TrackManager.getInstance().trackGainSpecialist(_local_6, 0, _local_7, false, ((_arg_4) ? SPECIALIST_GAIN_SOURCE.TAVERN : SPECIALIST_GAIN_SOURCE.OTHERS));
            switch (_local_6.GetType())
            {
                case SPECIALIST_TYPE.GEOLOGIST:
                    globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.NEW_GEOLOGIST, _local_6);
                    break;
                case SPECIALIST_TYPE.GENERAL:
                    globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.NEW_GENERAL, _local_6);
                    break;
                case SPECIALIST_TYPE.ADMIRAL:
                    globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.NEW_ADMIRAL, _local_6);
                    break;
                case SPECIALIST_TYPE.EXPLORER:
                    globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.NEW_EXPLORER, _local_6);
                    break;
                default:
                    if (cLog.isInfoEnabled())
                    {
                        cLog.info(("Could not interpret specialist type " + _local_6.GetType()));
                    };
            };
            if (globalFlash.gui.mTavernInfoPanel.IsVisible())
            {
                globalFlash.gui.mTavernInfoPanel.Refresh();
            };
        }

        private function MoveInProductionQueue(_arg_1:dTimedProductionQueueChangeVO, _arg_2:int):void
        {
            var _local_3:cTimedProductionQueue = mCurrentPlayerZone.GetProductionQueue(_arg_1.productionType);
            if (_local_3 == null)
            {
                cLog.error((((("Tried to move item (" + _arg_1.itemID.toKeyString()) + ") in TimedProductionQueue ") + _arg_1.productionType) + " but the queue is missing!"));
                return;
            };
            var _local_4:int = -1;
            var _local_5:int;
            while (_local_5 < _local_3.mTimedProductions_vector.length)
            {
                if (_local_3.mTimedProductions_vector[_local_5].GetUniqueID().eq(_arg_1.itemID))
                {
                    _local_4 = _local_5;
                    break;
                };
                _local_5++;
            };
            if (_local_4 == -1)
            {
                cLog.error((("Queue index out of bounds in MoveInProductionQueue. " + _local_4) + " item not in vector"));
                return;
            };
            if ((((_arg_2 < gMisc.GetMaxIntValue()) && (_arg_2 > -(gMisc.GetMaxIntValue()))) && (((_local_4 + _arg_2) < 0) || ((_local_4 + _arg_2) >= _local_3.mTimedProductions_vector.length))))
            {
                cLog.error((("Queue index out of bounds in MoveInProductionQueue. " + (_local_4 + _arg_2)) + " item not in vector"));
                return;
            };
            if (_local_4 >= _local_3.mTimedProductions_vector.length)
            {
                return;
            };
            var _local_6:cTimedProduction = _local_3.mTimedProductions_vector[_local_4];
            if (_arg_2 == -(gMisc.GetMaxIntValue()))
            {
                _local_3.mTimedProductions_vector.splice(_local_4, 1);
                _local_3.mTimedProductions_vector.splice(1, 0, _local_6);
            }
            else
            {
                if (_arg_2 == gMisc.GetMaxIntValue())
                {
                    _local_3.mTimedProductions_vector.splice(_local_4, 1);
                    _local_3.mTimedProductions_vector.push(_local_6);
                }
                else
                {
                    _local_3.mTimedProductions_vector[_local_4] = _local_3.mTimedProductions_vector[(_local_4 + _arg_2)];
                    _local_3.mTimedProductions_vector[(_local_4 + _arg_2)] = _local_6;
                };
            };
            var _local_7:int;
            while (_local_7 < _local_3.mTimedProductions_vector.length)
            {
                if (_local_3.mTimedProductions_vector[_local_7].CreateTimedProductionVO().index != _local_7)
                {
                    _local_3.mTimedProductions_vector[_local_7].mDirtyIndicator = (_local_3.mTimedProductions_vector[_local_7].mDirtyIndicator | DIRTY_INDICATOR.MODIFIED_BIT);
                    _local_3.mTimedProductions_vector[_local_7].CreateTimedProductionVO().index = _local_7;
                };
                _local_7++;
            };
            _local_3.SetAllProductionWaitingForServer(false);
            if (globalFlash.gui.mTimedProductionInfoPanel.IsVisible())
            {
                globalFlash.gui.mTimedProductionInfoPanel.Refresh();
            }
            else
            {
                if (globalFlash.gui.mBarracksInfoPanel.IsVisible())
                {
                    globalFlash.gui.mBarracksInfoPanel.Refresh();
                }
                else
                {
                    if (globalFlash.gui.mBarracks3InfoPanel.IsVisible())
                    {
                        globalFlash.gui.mBarracks3InfoPanel.Refresh();
                    }
                    else
                    {
                        if (globalFlash.gui.mExpeditionWeaponSmithInfoPanel.IsVisible())
                        {
                            globalFlash.gui.mExpeditionWeaponSmithInfoPanel.Refresh();
                        };
                    };
                };
            };
        }

        private function handleGuildWithdrawResource(_arg_1:cPlayerData, _arg_2:dGameTickCommandVO):void
        {
            var _local_8:String;
            var _local_11:EffectVO;
            var _local_12:int;
            var _local_13:cBuff;
            var _local_14:int;
            var _local_15:cBuff;
            var _local_3:dGuildBankWithdrawVO = (_arg_2.data as dGuildBankWithdrawVO);
            var _local_4:dBuffVO = _local_3.buff;
            var _local_5:int = _local_3.tabId;
            var _local_6:int;
            var _local_7:Boolean = true;
            var _local_9:int = ERROR_CODES.NO_ERROR;
            var _local_10:dGuildBankTransactionVO = new dGuildBankTransactionVO();
            _local_10.transactionType = GUILD_BANK_TRANSACTION_TYPE.WITHDRAW;
            _local_10.time = new Date().getTime();
            _local_10.tabID = _local_5;
            _local_10.player = _arg_1.GetPlayerName_string();
            _local_10.tabName = GetCurrentPlayerGuildBank().GetGuildBankTab(_local_5).name;
            if (_local_4 == null)
            {
                _local_9 = ERROR_CODES.ILLEGAL_VALUE;
            };
            if (_local_9 != ERROR_CODES.NO_ERROR)
            {
                _local_7 = false;
            };
            if (_local_7)
            {
                if (_local_4.buffName_string == defines.WITHDRAW_TEMP_BUFF)
                {
                    _local_6 = _local_4.getAmount();
                    _local_8 = _local_4.resourceName_string;
                    if (_local_7)
                    {
                        _local_11 = new EffectVO();
                        _local_11.effect_string = "reward";
                        _local_11.type_string = "resource";
                        _local_11.name_string = _local_4.resourceName_string;
                        _local_11.amount = _local_4.amount;
                        _local_11.uniqueID = _local_3.newUniqueID;
                        this.effectFactory.createEffect(_local_11).gameTickApply();
                        _local_10.amount = _local_6;
                        _local_10.groupType = GUILD_BANK_GROUP.RESOURCE;
                        _local_10.description = _local_8;
                        GetCurrentPlayerGuildBank().AddTransactionHistory(_local_10);
                        GetCurrentPlayerGuildBank().GetGuildBankTab(_local_5).GetResource(_local_4.resourceName_string).amount = (GetCurrentPlayerGuildBank().GetGuildBankTab(_local_5).GetResource(_local_4.resourceName_string).amount - _local_6);
                        globalFlash.gui.mGuildBankWindow.SetBusy(false);
                        globalFlash.gui.mGuildBankWindow.RefreshResourcesList();
                        globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.RESOURCE_WITHDRAW_SUCCESSFUL, [_local_4.resourceName_string, _local_6]);
                    };
                }
                else
                {
                    if (_local_7)
                    {
                        _local_12 = _local_4.uniqueId1;
                        _local_13 = cBuff.CreateBuffFromVO(_local_4);
                        _local_13.GetUniqueId().uniqueID1 = _local_3.newUniqueID.uniqueID1;
                        _local_13.GetUniqueId().uniqueID2 = _local_3.newUniqueID.uniqueID2;
                        _arg_1.addBuff(_local_13);
                        _local_6 = _local_13.GetAmount();
                        if (((!(_local_13.GetResourceName_string() == null)) && (_local_13.GetResourceName_string().length > 0)))
                        {
                            _local_8 = ((_local_13.GetType() + ",") + _local_13.GetResourceName_string());
                        }
                        else
                        {
                            _local_8 = _local_13.GetType();
                        };
                        _local_8 = ((_local_13.GetType() + ",") + _local_13.GetResourceName_string());
                        _local_10.amount = _local_6;
                        _local_10.groupType = GUILD_BANK_GROUP.BUFF;
                        _local_10.description = _local_8;
                        GetCurrentPlayerGuildBank().AddTransactionHistory(_local_10);
                        for each (_local_15 in GetCurrentPlayerGuildBank().GetGuildBankTab(_local_5).GetSortedBuffs())
                        {
                            if (_local_15.GetUniqueId().uniqueID1 == _local_12) break;
                            _local_14++;
                        };
                        GetCurrentPlayerGuildBank().GetGuildBankTab(_local_5).GetSortedBuffs().splice(_local_14, 1);
                        globalFlash.gui.mGuildBankWindow.SetBusy(false);
                        globalFlash.gui.mGuildBankWindow.RefreshResourcesList();
                        globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.BUFF_WITHDRAW_SUCCESSFUL, [_local_13]);
                    };
                };
            };
            if (_local_7)
            {
            };
        }

        override public function MouseUp(_arg_1:MouseEvent):void
        {
            if (!IsActiveAndInputActive())
            {
                return;
            };
            mMousePressed = false;
            mCurrentPlayerZone.MouseUp(_arg_1);
        }

        private function handleCreateCollection(_arg_1:cPlayerData, _arg_2:dGameTickCommandVO):Boolean
        {
            var _local_7:CollectionResourceVO;
            var _local_9:dBuffVO;
            var _local_10:dUniqueID;
            var _local_11:cBuffDefinition;
            var _local_12:cBuff;
            var _local_13:int;
            if (_arg_2.data == null)
            {
                return (false);
            };
            var _local_3:CreateCollectionResultVO = CreateCollectionResultVO(_arg_2.data);
            var _local_4:String = _local_3.collectionId;
            var _local_5:CollectionVO = CollectionsManager.getInstance().getCollection(_local_4);
            if (((_local_5 == null) || (!(_local_5.getIsActive(this)))))
            {
                return (false);
            };
            var _local_6:Vector.<CollectionResourceVO> = _local_5.getCollectionResources();
            var _local_8:cResources = mCurrentPlayerZone.GetResources(_arg_1);
            _local_5.updateHardCurrencyPrice(_local_8, this);
            if (this.mSpecificShopItems)
            {
                CustomAlert.show("ShopItemDeactivated", "ShopItemDeactivated");
                return (false);
            };
            if (_local_8.GetPlayerResource(defines.HARD_CURRENCY_RESOURCE_NAME_string).amount < _local_5.getHardCurrency())
            {
                return (false);
            };
            _local_8.AddResource(defines.HARD_CURRENCY_RESOURCE_NAME_string, -(_local_5.getHardCurrency()), ModifyReason.CREATE_COLLECTION_BUYOUT, _local_5.getName());
            for each (_local_7 in _local_6)
            {
                _local_13 = _local_8.GetPlayerResource(_local_7.getName()).amount;
                if (_local_7.getAmount() < _local_13)
                {
                    _local_13 = _local_7.getAmount();
                };
                _local_8.AddResource(_local_7.getName(), -(_local_13), ModifyReason.CREATE_COLLECTION_BUYOUT, null);
            };
            _local_9 = new dBuffVO();
            _local_10 = _local_3.uniqueId;
            _local_11 = cBuff.getBuffDefinitionByName(_local_5.getOutputBuffName());
            _local_9.buffName_string = _local_5.getOutputBuffName();
            _local_9.amount = _local_11.GetAmount();
            _local_9.resourceName_string = _local_11.GetResourceName_string();
            _local_9.recurringChance = 0;
            _local_9.uniqueId1 = _local_10.uniqueID1;
            _local_9.uniqueId2 = _local_10.uniqueID2;
            _local_12 = cBuff.CreateBuffFromVO(_local_9);
            if (_local_12.GetAmount() == 0)
            {
                _local_12.SetAmount(1);
            };
            mCurrentPlayer.addBuff(_local_12);
            globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.COLLECTION_BUFF_RECEIVED, _local_12);
            globalFlash.gui.mMayorhouseInfoPanel.activateCollection(_local_4);
            channels.TIMED_PRODUCTION.send(TriggerUtils.COLLECTION_BOUGHT_PROPERTY_NAME, _local_5);
            return (true);
        }

        public function handleRemoveZoneBuff(_arg_1:cPlayerData, _arg_2:dGameTickCommandVO):int
        {
            var _local_5:cBuffDefinition;
            var _local_3:dServerAction = (_arg_2.data as dServerAction);
            var _local_4:dBuffApplianceVO = (_local_3.data as dBuffApplianceVO);
            if (_local_4 != null)
            {
                _local_5 = cBuffDefinition.GetById(_local_4.buffID);
                if (_local_5.isZoneCancelable())
                {
                    mZoneBuffManager.removeBuff(_local_4.buffID, _local_4.sourceZoneId);
                };
                globalFlash.gui.mZoneBuffPanel.setBusyState(false);
                return (1);
            };
            return (0);
        }

        private function HandleMoveBuilding(_arg_1:cPlayerData, _arg_2:dGameTickCommandVO):void
        {
            var _local_10:EpicWorkyardMasterBuilding;
            var _local_12:EpicWorkyardSubBuilding;
            var _local_13:int;
            var _local_3:dServerAction = (_arg_2.data as dServerAction);
            var _local_4:dMoveBuildingVO = (_local_3.data as dMoveBuildingVO);
            var _local_5:int = _local_4.gridPosition;
            var _local_6:int = _local_4.paymentType;
            var _local_7:int = _local_3.grid;
            var _local_8:int = _local_3.type;
            var _local_9:cBuilding = mCurrentPlayerZone.mStreetDataMap.mBuildingContainer.get(_local_5);
            var _local_11:Vector.<EpicWorkyardSubBuilding> = new Vector.<EpicWorkyardSubBuilding>();
            if ((_local_9 is EpicWorkyardMasterBuilding))
            {
                _local_10 = (_local_9 as EpicWorkyardMasterBuilding);
                _local_11 = _local_10.getSubBuildings();
            };
            this.moveBuilding(_local_8, _local_5, _local_7, _local_6, _arg_1);
            if ((_local_9 is EpicWorkyardMasterBuilding))
            {
                _local_9 = mCurrentPlayerZone.mStreetDataMap.mBuildingContainer.get(_local_7);
                _local_10 = (_local_9 as EpicWorkyardMasterBuilding);
                _local_10.invalidateSubBuildingGridPositions();
                for each (_local_12 in _local_11)
                {
                    _local_13 = _local_10.getAvailableSubBuildingGridPosition();
                    this.moveBuilding(_local_8, _local_12.GetGrid(), _local_13, _local_6, _arg_1);
                };
            };
        }

        override public function MouseMove(_arg_1:MouseEvent):void
        {
            if (!IsActiveAndInputActive())
            {
                return;
            };
            mCurrentPlayerZone.MouseMove(_arg_1);
        }

        public function GameSettingsXMLSanityCheck():void
        {
        }

        private function handleInitiateTrade(_arg_1:cPlayerData, _arg_2:dGameTickCommandVO):Boolean
        {
            var _local_11:dBuyOneClickShopItemVO;
            var _local_12:String;
            var _local_13:int;
            var _local_14:int;
            if (_arg_2.data == null)
            {
                cLog.error((("E:" + _arg_2.playerID) + " COMMAND.INITIATE_TRADE: data is null!"));
                this.cancelTrade(null, null, _arg_1);
                return (false);
            };
            var _local_3:dTradeOfferVO = (_arg_2.data as dTradeOfferVO);
            var _local_4:cResources = mCurrentPlayerZone.GetResources(_arg_1);
            var _local_5:int;
            var _local_6:cBuff;
            var _local_7:int = cBuff.BUFF_APPLY_ERROR;
            var _local_8:String;
            var _local_9:int = -1;
            if (_local_3.slotType == TRADE_SLOT_TYPE.FRIEND_TO_FRIEND)
            {
                _local_5 = 1;
                _local_3.lots = 0;
            }
            else
            {
                _local_5 = _local_3.lots;
            };
            if (_local_3.offerRes != null)
            {
                if (!_local_4.HasPlayerResource(_local_3.offerRes.name_string, (_local_3.offerRes.amount * _local_5)))
                {
                    if (cLog.isInfoEnabled())
                    {
                        cLog.info(("Offered resources not found for trade " + _local_3));
                    };
                    this.cancelTrade("CannotAffordSendTrade", null, _arg_1);
                    return (false);
                };
                _local_8 = (((_local_3.offerRes.name_string + ",") + _local_3.offerRes.amount) + "|");
                _local_9 = TRADE_TYPE.TRADE_RES_FOR_RES;
            }
            else
            {
                if (_local_3.offerBuff != null)
                {
                    if (_local_3.lots > 1)
                    {
                        _local_3.lots = 1;
                    };
                    _local_6 = _arg_1.getBuffByUniqueID(dUniqueID.Create(_local_3.offerBuff.uniqueId1, _local_3.offerBuff.uniqueId2));
                    if (_local_6 == null)
                    {
                        if (cLog.isInfoEnabled())
                        {
                            cLog.info(("Offered buff not found for trade " + _local_3));
                        };
                        this.cancelTrade("CannotAffordSendTrade", null, _arg_1);
                        return (false);
                    };
                    if (_local_3.offerBuff.amount > _local_6.GetAmount())
                    {
                        if (cLog.isInfoEnabled())
                        {
                            cLog.info(("Offered buff amount is too high for trade " + _local_3));
                        };
                        this.cancelTrade("CannotAffordSendTrade", null, _arg_1);
                        return (false);
                    };
                    _local_7 = cBuff.CreateBuffFromVO(_local_3.offerBuff).GetAmount();
                    _local_8 = ((((_local_6.GetType() + ",") + _local_6.GetResourceName_string()) + ",") + _local_7);
                    if (_local_6.GetRecurrentChance() > 0)
                    {
                        _local_8 = (_local_8 + ("," + _local_6.GetRecurrentChance()));
                    };
                    _local_8 = (_local_8 + "|");
                    _local_9 = TRADE_TYPE.TRADE_BUFF_FOR_RES;
                }
                else
                {
                    cLog.warning(((("E:" + _arg_2.playerID) + " Invalid trade offer ") + _local_3));
                    this.cancelTrade(null, null, _arg_1);
                    return (false);
                };
            };
            if ((((_local_3.slotType == TRADE_SLOT_TYPE.PAID_SLOT_WITH_GEMS) || (_local_3.lots > 4)) && (this.mSpecificShopItems)))
            {
                this.cancelTrade(null, null, _arg_1);
                return (false);
            };
            var _local_10:int = this.ValidateBuyTradeOneClickShopItems(_arg_1, _local_3);
            if (_local_10 == -1)
            {
                _arg_1.resetLastFetchedBuff();
                this.cancelTrade(null, null, _arg_1);
                return (false);
            };
            _local_8 = (_local_8 + ("|" + _local_3.lots));
            if (_local_3.slotType != TRADE_SLOT_TYPE.FRIEND_TO_FRIEND)
            {
                mClientMessages.SendMessagetoServer(COMMAND.TRADE_GET_USER_TRADES, mCurrentViewedZoneID, null);
                if (_local_3.slotType != TRADE_SLOT_TYPE.FREE_SLOT)
                {
                    if (_local_3.slotType == TRADE_SLOT_TYPE.PAID_SLOT_WITH_GEMS)
                    {
                        _local_13 = ONE_CLICK_SHOPITEM.BUY_TRADE_SLOT_FOR_GEMS;
                        _local_12 = defines.HARD_CURRENCY_RESOURCE_NAME_string;
                        _local_14 = global.activateSlotsWithGems_vector[_local_10];
                        _local_11 = new dBuyOneClickShopItemVO().Init(_local_13);
                        this.logOneClickShopPurchase(_arg_1, _local_11, _local_14);
                    }
                    else
                    {
                        _local_13 = ONE_CLICK_SHOPITEM.BUY_TRADE_SLOT_FOR_COINS;
                        _local_12 = defines.COIN_RESOURCE_NAME_string;
                        _local_14 = global.activateSlotsWithCoins_vector[_local_10];
                    };
                    _local_4.AddResource(_local_12, -(_local_14), ModifyReason.TRADE_SLOTS, null);
                };
                if (_local_3.lots > 4)
                {
                    _local_11 = new dBuyOneClickShopItemVO().Init(ONE_CLICK_SHOPITEM.BUY_TRADE_UNLIMITED_LOTS);
                    _local_4.AddResource(defines.HARD_CURRENCY_RESOURCE_NAME_string, -(global.costOfUnlimitingLots), ModifyReason.TRADE_SLOTS, null);
                    this.logOneClickShopPurchase(_arg_1, _local_11, global.costOfUnlimitingLots);
                };
            };
            if (_local_3.offerRes != null)
            {
                _local_4.AddResource(_local_3.offerRes.name_string, (-(_local_3.offerRes.amount) * _local_5), ModifyReason.TRADE, null);
            }
            else
            {
                if (_local_3.offerBuff != null)
                {
                    _local_6.applyBuffResultToBuff(_arg_1, this, _local_7);
                    if (((_local_6.isDeleted()) || (_local_6.GetAmount() <= 0)))
                    {
                        _arg_1.removeLastFetchedBuff();
                    }
                    else
                    {
                        _local_6.DecWaitingForServerCount(this);
                    };
                };
            };
            return (true);
        }

        public function SpoolTimeDeltaValue(_arg_1:Number):Number
        {
            var _local_2:Number = gMisc.GetTimeSinceStartup();
            var _local_3:Number = mCalculateTicks.mDeltaTicksMs;
            var _local_4:Number = mGlobalTimeScale;
            mSpoolingIsActive = true;
            mGlobalTimeScale = 5;
            var _local_5:Number = (_arg_1 * (_local_4 / mGlobalTimeScale));
            var _local_6:Number = 0;
            while (_local_5 > 0)
            {
                if (_local_5 > 2500)
                {
                    mCalculateTicks.mDeltaTicksMs = 2500;
                    _local_5 = (_local_5 - 2500);
                }
                else
                {
                    mCalculateTicks.mDeltaTicksMs = _local_5;
                    _local_5 = 0;
                };
                this.CalculateGameTickLogic();
                _local_6 = (gMisc.GetTimeSinceStartup() - _local_2);
                if (_local_6 > MAX_SPOOL_TIME)
                {
                    LocalLogMessageDetail("Spooling takes to long!");
                    break;
                };
            };
            mSpoolingIsActive = false;
            mGlobalTimeScale = _local_4;
            mCalculateTicks.mDeltaTicksMs = _local_3;
            return (_local_6);
        }

        override public function FocusOutHandler(_arg_1:FocusEvent):void
        {
            if (((!(mActiveG)) || (globalFlash.gui.mCameraControlPanel.PositionIsOverGuiElement())))
            {
                return;
            };
            this.ResetScrolling();
        }

        override public function Compute():void
        {
            var _local_3:dServerResponse;
            var _local_4:dServerResponse;
            mLastServerResponseRead = true;
            if (mLastServerResponse.length != 0)
            {
                for each (_local_3 in mLastServerResponse)
                {
                    mClientMessages.ReceivedMessageFromServer(_local_3);
                };
                mLastServerResponse.length = 0;
            };
            mLastServerResponseRead = false;
            mLastServerResponseIIRead = true;
            if (mLastServerResponseII.length != 0)
            {
                for each (_local_4 in mLastServerResponseII)
                {
                    mClientMessages.ReceivedMessageFromServer(_local_4);
                };
                mLastServerResponseII.length = 0;
            };
            mLastServerResponseIIRead = false;
            TrackManager.getInstance().flush();
            if (!mActiveG)
            {
                return;
            };
            mCalculateTicks.CalculateDeltaTicks();
            if (defines.ACTIVATE_STREAMING)
            {
                ComputeStreaming();
            };
            mWobbling = (GetUnscaledClientTime() / 50);
            mWobbling = (mWobbling % 20);
            if (mWobbling > 10)
            {
                mWobbling = (20 - mWobbling);
            };
            mWobblingInt = int(mWobbling);
            mOscillating = (Math.sin((GetUnscaledClientTime() / 1000)) * 10);
            mOscillatingInt = int(mOscillating);
            this.CalculateGameTickLogic();
            var _local_1:Number = gMisc.GetTimeSinceStartup();
            var _local_2:Number = (_local_1 - this.mLastXPUpdate);
            if (_local_2 > 1000)
            {
                if (((mCurrentPlayer.CheckXPChanged()) && (mCurrentPlayer.GetPlayerId() == mHomePlayer.GetPlayerId())))
                {
                    globalFlash.gui.mAvatar.SetData(mCurrentPlayer, GetPlayerList_vector());
                };
                this.mLastXPUpdate = _local_1;
                globalFlash.gui.mAvatar.EnablePvPRanksButton(((mCurrentPlayer.mIsPlayerZone) && (!(mCurrentPlayer.mIsAdventureZone))));
            };
            mQuestClientCallbacks.RefreshLastQuestListDeferred();
            mCurrentPlayerZone.CalculateDeltaScrolls();
        }

        private function cancelTrade(_arg_1:String, _arg_2:dAcceptTradeVO, _arg_3:cPlayerData):void
        {
            globalFlash.gui.mTradeWindow.setWaitingForServer(false);
            globalFlash.gui.mTradeWindow.setTradeStatus("TradeFailed");
            if (_arg_1 != null)
            {
                CustomAlert.show(_arg_1, _arg_1);
            };
        }

        private function handleApplyLoottableBuff(_arg_1:cPlayerData, _arg_2:dGameTickCommandVO):void
        {
            var _local_6:int;
            var _local_7:Object;
            var _local_8:dUniqueID;
            var _local_9:dBuffVO;
            var _local_10:cBuff;
            var _local_11:dSpecialistVO;
            var _local_12:cSpecialist;
            var _local_13:cResources;
            var _local_14:int;
            var _local_15:dResourceVO;
            var _local_3:dLootItemsVO = (_arg_2.data as dLootItemsVO);
            var _local_4:Boolean = _local_3.uniqueID.eq(dUniqueID.Create(-1, -1));
            var _local_5:cBuff = ((_local_4) ? null : _arg_1.getBuffByUniqueID(_local_3.uniqueID));
            if (((_local_4) || (!(_local_5 == null))))
            {
                if (!_local_4)
                {
                    if (((!(_local_4)) && (!(this.isBuffUpdated(_arg_1.GetPlayerId(), _local_5, 1)))))
                    {
                        _arg_1.resetLastFetchedBuff();
                        return;
                    };
                    _local_5.DecWaitingForServerCount(this);
                    _arg_1.removeLastFetchedBuff();
                };
                globalFlash.gui.mMysteryBoxPanel.SetResult(_local_3);
                _local_6 = 0;
                while (_local_6 < _local_3.items.length)
                {
                    _local_7 = _local_3.items[_local_6];
                    _local_8 = (_local_3.uniqueIDs[_local_6] as dUniqueID);
                    if ((_local_7 is dBuffVO))
                    {
                        _local_9 = (_local_7 as dBuffVO);
                        _local_9.uniqueId1 = _local_8.uniqueID1;
                        _local_9.uniqueId2 = _local_8.uniqueID2;
                        if (mCurrentPlayerZone.GetResources(_arg_1).AddHardCurrencyResource(_local_9))
                        {
                            this.requestZonePersistence(COMMAND.ADD_HARD_CURRENCY);
                        }
                        else
                        {
                            _local_10 = cBuff.CreateBuffFromVO(_local_9);
                            _arg_1.addBuff(_local_10);
                        };
                    }
                    else
                    {
                        if ((_local_7 is dSpecialistVO))
                        {
                            _local_11 = (_local_7 as dSpecialistVO);
                            _local_11.uniqueID = _local_8;
                            _local_12 = cSpecialist.CreateSpecialistFromVO(this, _local_11, true);
                            _local_12.insertedAt = TimeUtil.getServerTime();
                            mCurrentPlayerZone.addSpecialist(_local_12);
                            _arg_1.IncSpecialistAmount(_local_11.specialistType);
                            _local_13 = mCurrentPlayerZone.GetResources(_arg_1);
                            _local_14 = _local_13.GetResourceAmount(defines.HARD_CURRENCY_RESOURCE_NAME_string);
                            TrackManager.getInstance().trackGainSpecialist(_local_12, 0, _local_14, true, SPECIALIST_GAIN_SOURCE.OTHERS);
                        }
                        else
                        {
                            if ((_local_7 is dResourceVO))
                            {
                                _local_15 = (_local_7 as dResourceVO);
                                if (_local_15.name_string == "XP")
                                {
                                    _arg_1.AddXP(_local_15.amount);
                                }
                                else
                                {
                                    if (_local_15.name_string == defines.PVP_XP_string)
                                    {
                                        _arg_1.AddPvPXp(_local_15.amount);
                                    }
                                    else
                                    {
                                        gMisc.Assert(false, (("Could not interpret resource " + _local_15) + " for loot item!"));
                                    };
                                };
                            }
                            else
                            {
                                gMisc.Assert(false, (("Could not interpret item " + _local_7) + " for a loot item!"));
                            };
                        };
                    };
                    _local_6++;
                };
                TrackManager.getInstance().trackMysteryBox(_arg_1.GetPlayerId(), ((_local_4) ? "EffectLoottable" : _local_5.GetBuffDefinition().GetName_string()), _local_3);
            }
            else
            {
                cLog.error(((("P:" + _arg_1.GetPlayerId()) + " Could not find buff ") + _local_3.uniqueID));
            };
        }

        public function addPlayerResource(_arg_1:dResource, _arg_2:cResources, _arg_3:cPlayerData, _arg_4:dUniqueID, _arg_5:int):AddResourceResponseVO
        {
            var _local_8:int;
            var _local_9:cBuff;
            var _local_6:dResource = _arg_2.GetPlayerResource(_arg_1.name_string);
            var _local_7:int = (_local_6.maxLimit - _local_6.amount);
            if (_arg_1.amount <= _local_7)
            {
                _arg_2.AddResource(_arg_1.name_string, _arg_1.amount, _arg_5, null);
                return (new AddResourceResponseVO(true, true));
            };
            _local_8 = (_arg_1.amount - _local_7);
            _arg_1.amount = (_arg_1.amount - _local_8);
            globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.QUEST_REWARD_LIMIT_REACHED, new dResource().Init(_arg_1.name_string, _local_8));
            if (_arg_1.name_string != defines.HARD_CURRENCY_RESOURCE_NAME_string)
            {
                _local_9 = BuffUtils.createBuff(CollectionsConsts.ADD_RESOURCE_BUFF_NAME, _local_8, 0, _arg_1.name_string, _arg_4);
                this.mCurrentPlayer.addBuff(_local_9);
            };
            if (_arg_1.amount > 0)
            {
                _arg_2.AddResource(_arg_1.name_string, _arg_1.amount, _arg_5, null);
            };
            return (new AddResourceResponseVO(true, false));
        }

        private function handleAddCombatPreviewPath(_arg_1:dGameTickCommandVO):void
        {
            var _local_2:CombatPreviewPathVO = (_arg_1.data as CombatPreviewPathVO);
            var _local_3:int = _local_2.gridStart;
            var _local_4:cBuilding = mCurrentPlayerZone.mStreetDataMap.mBuildingContainer.get(_local_3);
            mCombatPersitedPreview.removePathsWaitingForServer();
            if (_local_4 != null)
            {
                return;
            };
            mCombatPersitedPreview.AddPreviewPath(_local_2);
            globalFlash.gui.mToolboxPanel.Refresh();
        }

        public function ResetResourceViewUpdate():void
        {
            this.mLastXPUpdate = (gMisc.GetTimeSinceStartup() - 100000);
        }

        public function GameTickRefresh(_arg_1:cPlayerData):void
        {
            var _local_3:int;
            var _local_4:int;
            mLastGameTickRefreshClientTime = GetClientTime();
            var _local_2:int = (mGameTickRefreshCounter % 10);
            if (mCalculateEconomy)
            {
                _local_3 = mClientDeltaTime;
                mClientDeltaTime = int(GameTickPeriodicRefreshTime);
                if (mGlobalTimeScale > 5)
                {
                    _local_4 = 0;
                    while (_local_4 < mGlobalTimeScale)
                    {
                        this.CalculateLogicOncePerSecond();
                        _local_4++;
                    };
                }
                else
                {
                    mClientDeltaTime = int((GameTickPeriodicRefreshTime * mGlobalTimeScale));
                    this.CalculateLogicOncePerSecond();
                };
                mClientDeltaTime = _local_3;
            };
            if (_local_2 == 6)
            {
                if (!mSpoolingIsActive)
                {
                    if ((getTimer() - mLastActivity) > 9000)
                    {
                    };
                };
            };
            if ((((_local_2 == 3) || (_local_2 == 6)) || (_local_2 == 9)))
            {
                this.GetUpdates(_arg_1);
            };
            mGameTickRefreshCounter++;
            _arg_1.mBuildQueue.ComputeBuildQueue();
            mHomePlayer.mTradeData.computeTradeWindow();
            mCurrentPlayerGuildBank.ComputeGuildBank();
        }

        override public function MouseClick(_arg_1:MouseEvent):void
        {
            if (!IsActiveAndInputActive())
            {
                return;
            };
            mCurrentPlayerZone.MouseClick(_arg_1);
        }

        public function client_getPlayerLevel():int
        {
            return ((globalFlash.gui.mAvatar.GetDisplayedPlayerVO()) ? globalFlash.gui.mAvatar.GetDisplayedPlayerVO().playerLevel : 0);
        }

        private function handleGuildDonateResource(_arg_1:cPlayerData, _arg_2:dGameTickCommandVO):void
        {
            var _local_3:dBankDonationVO = (_arg_2.data as dBankDonationVO);
            this.donateResourceToGuild(_arg_1, _local_3.buff, _local_3.tabId, _local_3.newGuildUniqueID, _arg_2);
        }

        private function handleCompleteAchievementTriggerCheat(_arg_1:cPlayerData, _arg_2:dGameTickCommandVO):void
        {
        }

        private function ShowPlayerInfo():void
        {
            var _local_1:int = 10;
            globalFlash.gui.WriteDebugText(cBackbuffer.mBackBuffer, "-- Player Info --", mDebugTextXPos, (mDebugTextYPos = (mDebugTextYPos + _local_1)));
            globalFlash.gui.WriteDebugText(cBackbuffer.mBackBuffer, ((((("Player ID: " + mCurrentPlayer.GetPlayerId()) + " Client session: ") + mClientMessages.getClientSession()) + " BuildingCount: ") + mCurrentPlayer.GetBuildingCountAll()), mDebugTextXPos, (mDebugTextYPos = (mDebugTextYPos + _local_1)));
            globalFlash.gui.WriteDebugText(cBackbuffer.mBackBuffer, ((((((("GridPos: " + mCurrentCursor.GetGridPosition()) + " x: ") + (mCurrentCursor.GetGridPosition() % global.ui.mCurrentPlayerZone.mMapWidth)) + " y: ") + int((mCurrentCursor.GetGridPosition() / global.ui.mCurrentPlayerZone.mMapWidth))) + " db-gridPos: ") + (mCurrentCursor.GetGridPosition() + (global.ui.mCurrentPlayerZone.mMapWidth << 22))), mDebugTextXPos, (mDebugTextYPos = (mDebugTextYPos + _local_1)));
            globalFlash.gui.WriteDebugText(cBackbuffer.mBackBuffer, ((((("LastGameTickRefreshTime: " + mLastGameTickRefreshClientTime) + " GameTickCounter: ") + mGameTickRefreshCounter) + " ClientTime: ") + GetClientTime()), mDebugTextXPos, (mDebugTextYPos = (mDebugTextYPos + _local_1)));
            globalFlash.gui.WriteDebugText(cBackbuffer.mBackBuffer, ((((((("Time scale: " + mGlobalTimeScale) + " mLastSynchronizetime: ") + mLastSynchronizetime) + " PostProcessTime:") + GameTickSystemPostProcessTime) + " GameTickPeriodicRefreshTime:") + GameTickPeriodicRefreshTime), mDebugTextXPos, (mDebugTextYPos = (mDebugTextYPos + _local_1)));
            var _local_2:* = "";
            if (Capabilities.isDebugger)
            {
                _local_2 = "Debug Player";
            };
            globalFlash.gui.WriteDebugText(cBackbuffer.mBackBuffer, (("- Version " + _local_2) + " -"), mDebugTextXPos, (mDebugTextYPos = (mDebugTextYPos + _local_1)));
        }

        private function handleCompleteTradeCommon(_arg_1:cPlayerData, _arg_2:dTradeCompleteVO, _arg_3:Boolean, _arg_4:Boolean):Boolean
        {
            var _local_10:dResource;
            var _local_11:int;
            var _local_12:int;
            var _local_13:dBuffVO;
            var _local_14:dBuffVO;
            var _local_5:int = _arg_1.GetPlayerId();
            var _local_6:cResources = mCurrentPlayerZone.GetResources(_arg_1);
            var _local_7:dResourceVO;
            var _local_8:int;
            var _local_9:cBuff;
            if (_local_5 != mHomePlayer.GetPlayerId())
            {
                return (false);
            };
            if ((_arg_2.returnedItem is dResourceVO))
            {
                _local_7 = (_arg_2.returnedItem as dResourceVO);
                _local_10 = _local_6.GetPlayerResource(_local_7.name_string);
                if (_local_10 == null)
                {
                    return (false);
                };
                _local_11 = (_local_10.maxLimit - _local_10.amount);
                _local_12 = ((_arg_2.tradeDeleted) ? _arg_2.lotsRemaining : 1);
                _local_7.amount = (_local_7.amount * _local_12);
                if (_local_7.amount <= _local_11)
                {
                    _local_8 = _local_7.amount;
                }
                else
                {
                    _local_8 = _local_11;
                    _local_13 = new dBuffVO();
                    _local_13.buffName_string = "AddResource";
                    _local_13.resourceName_string = _local_7.name_string;
                    _local_13.amount = (_local_7.amount - _local_8);
                    _local_13.uniqueId1 = _arg_2.uniqueID.uniqueID1;
                    _local_13.uniqueId2 = _arg_2.uniqueID.uniqueID2;
                    _local_9 = cBuff.CreateBuffFromVO(_local_13);
                };
            }
            else
            {
                if ((_arg_2.returnedItem is dBuffVO))
                {
                    _local_14 = (_arg_2.returnedItem as dBuffVO);
                    _local_14.uniqueId1 = _arg_2.uniqueID.uniqueID1;
                    _local_14.uniqueId2 = _arg_2.uniqueID.uniqueID2;
                    _local_9 = cBuff.CreateBuffFromVO(_local_14);
                };
            };
            if (_arg_3)
            {
                if ((_arg_2.returnedItem is dResourceVO))
                {
                    globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.TRADE_ACCEPTED_WAREHOUSE);
                    if (_local_8 < _local_7.amount)
                    {
                        globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.TRADED_RESOURCE_LIMIT_REACHED, _local_7);
                    };
                }
                else
                {
                    globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.TRADE_ACCEPTED_BUFF);
                };
            }
            else
            {
                if (!_arg_2.tradeDeleted)
                {
                    _arg_1.mTradeData.updateHistoryWithAcceptedTrade(_arg_2, _local_5);
                }
                else
                {
                    _arg_1.mTradeData.rearrangeOffers(_arg_2);
                };
            };
            if (_local_8 != 0)
            {
                _local_6.AddResource(_local_7.name_string, _local_8, ((_arg_4) ? ModifyReason.TRADE_DELETED : ModifyReason.TRADE), null);
            };
            if (_local_9 != null)
            {
                mCurrentPlayer.addBuff(_local_9);
                globalFlash.gui.mStarMenu.Refresh();
            };
            return (true);
        }

        private function handleBuffAdventureCleanup(_arg_1:String):void
        {
            var _local_3:cTimedProductionQueue;
            var _local_4:cTimedProduction;
            var _local_5:cBuff;
            var _local_6:int;
            var _local_7:cTimedProduction;
            var _local_8:String;
            var _local_2:Vector.<cTimedProduction> = new Vector.<cTimedProduction>();
            for each (_local_3 in mCurrentPlayerZone.GetProductionQueue_vector())
            {
                for each (_local_7 in _local_3.mTimedProductions_vector)
                {
                    _local_8 = null;
                    if ((_local_7.GetProductionOrder().GetDefinition() is cBuffDefinition))
                    {
                        _local_8 = (_local_7.GetProductionOrder().GetDefinition() as cBuffDefinition).GetGroup_string();
                    }
                    else
                    {
                        if ((_local_7.GetProductionOrder().GetDefinition() is EffectTimedProductionDefinition))
                        {
                            _local_8 = ("" + (_local_7.GetProductionOrder().GetDefinition() as EffectTimedProductionDefinition).GetGroup());
                        };
                    };
                    if ((((!(_local_8 == null)) && (!(StringUtils.isEmpty(_local_8)))) && (_local_8 == _arg_1)))
                    {
                        _local_2.push(_local_7);
                    };
                };
            };
            for each (_local_4 in _local_2)
            {
                mCurrentPlayerZone.GetProductionQueue(_local_4.GetProductionType()).cancelProduction(_local_4.GetUniqueID(), true, mCurrentPlayer);
            };
            _local_6 = 0;
            while (_local_6 < mCurrentPlayer.mAvailableBuffs_vector.length)
            {
                _local_5 = mCurrentPlayer.mAvailableBuffs_vector[_local_6];
                if (_local_5.GetBuffDefinition().GetGroup_string() == _arg_1)
                {
                    mCurrentPlayer.removeBuffFromVector(_local_5.GetUniqueId());
                    _local_6--;
                };
                _local_6++;
            };
        }

        private function handleDeleteTrade(_arg_1:cPlayerData, _arg_2:dGameTickCommandVO):Boolean
        {
            var _local_4:dTradeCompleteVO;
            if (cLog.isInfoEnabled())
            {
                cLog.info(((("Delete trades from market place " + _arg_2.data) + " at ") + _arg_2.time));
            };
            if (!(_arg_2.data is dTradeCompleteUpdateVO))
            {
                return (false);
            };
            var _local_3:dTradeCompleteUpdateVO = (_arg_2.data as dTradeCompleteUpdateVO);
            for each (_local_4 in _local_3.tradeOffers)
            {
                this.handleCompleteTradeCommon(_arg_1, _local_4, false, true);
            };
            return (true);
        }

        private function HandleAcceptLoot(_arg_1:cPlayerData, _arg_2:dGameTickCommandVO, _arg_3:Boolean):void
        {
            var _local_4:dLootItemsVO = (_arg_2.data as dLootItemsVO);
            this.acceptLoot(_arg_1, _local_4, _arg_3);
        }

        override public function Exit():void
        {
            globalFlash.gui.ExitGuiElements();
            mCurrentPlayerZone.Exit();
            mActiveG = false;
            mComputeAndInputActive = false;
        }

        override public function Init(_arg_1:int):void
        {
            this.effectFactory = new EffectFactory(this);
            gMisc.Assert((!(this.mInitInitalized)), "Init already initialized!");
            this.mInitInitalized = true;
            new GUIObserver(this);
            super.Init(_arg_1);
            this.ApplicationResized();
            gMisc.Assert((!(this.mInitInitalizedStartGame)), "Game already initialized!");
            this.mInitInitalizedStartGame = true;
            mSynchronisationErrorBitField = 0;
            mZoneCheckUpdateVO = null;
            GameTickSystemPostProcessTime = defines.GAMETICK_SYSTEM_POSTPROCESS_TIME_MIN;
            GameTickPeriodicRefreshTime = defines.GAMETICK_PERIODIC_REFRESH_TIME;
            this.idleDetection = new IdleDetection();
            this.uiTimeAndClickDetection = new UITimeAndClickDetection();
            cBackbuffer.InitSegmentBuffer(false);
            cBackbuffer.SetRedirectToSegmentBuffer(true);
            cBackbuffer.Clear(mCurrentPlayerZone.CLEAR_COLOR);
            cBackbuffer.SetRedirectToSegmentBuffer(false);
            globalFlash.gui.InitGuiElements(this);
            mMouseCursor.Init();
            mMouseCursor.SetCursorEditMode(COMMAND.SELECT_BUILDING);
            mCurrentCursor = mMouseCursor;
            mMouseCursorSecondary.Init();
            mMouseCursorSecondary.SetCursorEditMode(COMMAND.SELECT_BUILDING);
            mCurrentSecondaryCursor = mMouseCursorSecondary;
            InitPreCreatedGOs();
            mZoom.SetScrollPosPlayerZone(mCurrentPlayerZone, 0, 2);
            this.ResetResourceViewUpdate();
            this.ClearLevel();
            mCurrentPlayer.mIsPlayerZone = true;
            mCalculateEconomy = true;
            gEconomics.init();
            mCurrentPlayer.Init(0);
            mComputeResourceCreation.Init();
            mDateFormatter.formatString = "JJ:NN:SS";
            gMisc.Assert(gEconomics.IsEconomicsInitialized(), "gServer.Init: Economics is not initialized!");
            this.GameSettingsXMLSanityCheck();
            if (defines.ACTIVATE_STREAMING)
            {
                InitStreaming();
            }
            else
            {
                mRenderScreen = true;
                mFadeInCntr = defines.FADEIN_TIME;
            };
            mLastZoneRefreshTime = 0;
            mSynchronizetime = 0;
            mLastSynchronizetime = 0;
            mLastGameTickRefreshClientTime = 0;
            SetClientTime(0);
            var _local_2:Date = new Date();
            mBirthTime = _local_2.time;
            if (!LOAD_MAP_DIRECT)
            {
                this.ServerLoadedFinished();
            };
            this.checkPendingEventTimer.addEventListener(TimerEvent.TIMER_COMPLETE, this.checkPendingEventTimerHandler);
        }

        private function HandleAcceptAdventureInvitation(_arg_1:cPlayerData, _arg_2:dGameTickCommandVO):Boolean
        {
            return (true);
        }

        private function HandleRaiseArmy(_arg_1:cPlayerData, _arg_2:dGameTickCommandVO, _arg_3:int):void
        {
            var _local_8:dResourceVO;
            var _local_9:cSpecialist;
            var _local_10:int;
            var _local_11:int;
            var _local_12:dResourceVO;
            var _local_13:cSquad;
            var _local_14:cResources;
            var _local_15:dResource;
            var _local_16:dResource;
            var _local_4:dRaiseArmyVO = (_arg_2.data as dRaiseArmyVO);
            var _local_5:iMilitaryUnitHolder;
            if (_local_4.armyHolderBuildingVO != null)
            {
                _local_5 = mCurrentPlayerZone.GetBuildingFromGridPosition(_local_4.armyHolderBuildingVO.buildingGrid);
            }
            else
            {
                if (_local_4.armyHolderSpecialistVO != null)
                {
                    _local_9 = mCurrentPlayerZone.getSpecialist(_arg_1.GetPlayerId(), _local_4.armyHolderSpecialistVO.uniqueID);
                    if (_local_9 == null)
                    {
                        if (cLog.isInfoEnabled())
                        {
                            cLog.info(("Could not find specialist on zone for " + _local_4));
                        };
                        return;
                    };
                    if (_local_9.GetTask() != null)
                    {
                        if (cLog.isInfoEnabled())
                        {
                            cLog.info(("Specialist must not have task if raising army " + _local_9));
                        };
                        _local_9.SetWaitingForServer(false);
                        return;
                    };
                    _local_5 = _local_9;
                }
                else
                {
                    gMisc.Assert(false, (("Could not retrieve army holder from " + _local_4) + "!"));
                    return;
                };
            };
            if (_local_5 == null)
            {
                if (cLog.isInfoEnabled())
                {
                    cLog.info(("Could not find unit holder " + _local_4));
                };
                return;
            };
            if (((!(mIsDefenseMode)) && (!(_arg_1.GetPlayerId() == _local_5.getPlayerID()))))
            {
                if (cLog.isInfoEnabled())
                {
                    cLog.info("Not the player owner.");
                };
                return;
            };
            var _local_6:int;
            _local_6 = _local_4.unitSquads.length;
            if ((((_local_5 is cSpecialist) && ((_local_5 as cSpecialist).GetBaseType() == SPECIALIST_TYPE.ADMIRAL)) && (_local_6 > 6)))
            {
                gMisc.Assert(false, ("Too many unit types assigned to admiral " + _local_4));
                return;
            };
            if (mIsDefenseMode)
            {
                _local_10 = 0;
                _local_11 = 0;
                for each (_local_12 in _local_4.unitSquads)
                {
                    for each (_local_15 in cMilitaryUnitData.GetUnitDataForType(_local_12.name_string).GetCosts_vector())
                    {
                        if (_local_15.name_string == defines.DEFENSE_POINT_NAME_string)
                        {
                            _local_10 = (_local_10 + (_local_15.amount * _local_12.amount));
                        };
                    };
                };
                for each (_local_13 in _local_5.GetArmy().GetSquads_vector())
                {
                    for each (_local_16 in cMilitaryUnitData.GetUnitDataForType(_local_13.name_string).GetCosts_vector())
                    {
                        if (_local_16.name_string == defines.DEFENSE_POINT_NAME_string)
                        {
                            _local_11 = (_local_11 + (_local_16.amount * _local_13.amount));
                        };
                    };
                };
                _local_14 = mCurrentPlayerZone.getResourcesFromCurrentZone();
                if (_local_14.GetResourceAmount(defines.DEFENSE_POINT_NAME_string) < (_local_10 - _local_11))
                {
                    if (cLog.isInfoEnabled())
                    {
                        cLog.info("Not enough defense points to assign army.");
                    };
                    return;
                };
                _local_14.SetResource(defines.DEFENSE_POINT_NAME_string, (_local_14.GetResourceAmount(defines.DEFENSE_POINT_NAME_string) - (_local_10 - _local_11)));
            };
            var _local_7:Vector.<dResourceVO> = new Vector.<dResourceVO>();
            for each (_local_8 in _local_4.unitSquads)
            {
                _local_7.push(_local_8);
            };
            cMilitaryUtil.RaiseArmy(mCurrentPlayerZone.GetArmy(_local_5.getPlayerID()), _local_5, _local_7);
            if ((_local_5 is cSpecialist))
            {
                (_local_5 as cSpecialist).SetWaitingForServer(false);
            }
            else
            {
                if ((_local_5 is cBuilding))
                {
                    globalFlash.gui.mDefenseBuildingPanel.SetBusyModeOff();
                };
            };
            this.requestZonePersistence(COMMAND.RAISE_ARMY);
        }

        override public function ZoomHasChanged():void
        {
            mCurrentPlayerZone.SetBackgroundHasChanged(true);
        }

        public function CalculateGameTickLogic():void
        {
            var _local_3:dGameTickCommandVO;
            var _local_4:Boolean;
            var _local_5:int;
            var _local_6:Number;
            var _local_7:int;
            var _local_8:Number;
            var _local_9:Number;
            var _local_10:Number;
            var _local_11:dGameTickCommandVO;
            var _local_12:int;
            var _local_13:dGameTickCommandVO;
            var _local_14:int;
            var _local_15:Number;
            var _local_1:int = int((mCalculateTicks.mDeltaTicksMs * mGlobalTimeScale));
            while (true)
            {
                _local_4 = true;
                if (Math.abs(mSynchronizetime) > 100)
                {
                    _local_5 = 50;
                    if (Math.abs(mSynchronizetime) > 500)
                    {
                        _local_5 = 250;
                    };
                    _local_6 = mSynchronizetime;
                    if (_local_6 > _local_5)
                    {
                        _local_6 = _local_5;
                    };
                    if (_local_6 < -(_local_5))
                    {
                        _local_6 = -(_local_5);
                    };
                    _local_1 = (_local_1 + _local_6);
                    if (_local_1 < 1)
                    {
                        _local_6 = (_local_6 + (1 - _local_1));
                        _local_1 = 1;
                    };
                    mSynchronizetime = (mSynchronizetime - _local_6);
                };
                mLastSynchronizetime = mSynchronizetime;
                mClientDeltaTime = _local_1;
                if (mClientDeltaTime > 2500)
                {
                    mClientDeltaTime = 2500;
                    _local_1 = (_local_1 - 2500);
                    _local_4 = false;
                };
                AddClientTime(mClientDeltaTime);
                if (mGameTickCommand_vector.length > 0)
                {
                    _local_7 = mClientDeltaTime;
                    _local_8 = (GetClientTime() - _local_7);
                    _local_9 = GetClientTime();
                    while (true)
                    {
                        _local_10 = defines.MAX_DOUBLE_VALUE;
                        _local_11 = null;
                        _local_12 = 0;
                        _local_14 = 0;
                        for each (_local_13 in mGameTickCommand_vector)
                        {
                            if (_local_9 >= _local_13.time)
                            {
                                _local_15 = (_local_13.time - _local_8);
                                if (_local_15 < _local_10)
                                {
                                    _local_10 = _local_15;
                                    _local_11 = _local_13;
                                    _local_12 = _local_14;
                                };
                            };
                            _local_14++;
                        };
                        if (_local_11 != null)
                        {
                            SetClientTime(_local_11.time);
                            mClientDeltaTime = int((_local_11.time - _local_8));
                            if (mClientDeltaTime >= 0)
                            {
                                if (mClientDeltaTime > 0)
                                {
                                    this.ComputeLogic();
                                };
                                this.ProcessGameTickCommands(_local_11);
                                mGameTickCommand_vector.splice(_local_12, 1);
                                _local_8 = _local_11.time;
                            }
                            else
                            {
                                cLog.warning((((("Missed gametick command " + COMMAND.GetString(_local_11.mode)) + " with clientDeltaTime of ") + mClientDeltaTime) + " ms"));
                                mSynchronisationErrorBitField = (mSynchronisationErrorBitField | cGeneralInterface.SYNCHRONISATION_ERROR_MISSED_GAMETICK);
                                mSynchronisationErrorGameTick = _local_11;
                                mSynchronisationErrorClientDeltaTime = mClientDeltaTime;
                                mGameTickCommand_vector.splice(_local_12, 1);
                                if (_local_11.mode == COMMAND.GAMETICK_REFRESH_COMMAND)
                                {
                                    cLog.warning("Missed gametick command GAMETICK_REFRESH_COMMAND recreating it!");
                                    SetGameTickRefreshCommand(mHomePlayer);
                                };
                            };
                        }
                        else
                        {
                            SetClientTime(_local_9);
                            mClientDeltaTime = int((_local_9 - _local_8));
                            break;
                        };
                    };
                };
                this.ComputeLogic();
                if (_local_4) break;
            };
            var _local_2:Boolean;
            for each (_local_3 in mGameTickCommand_vector)
            {
                if (_local_3.mode == COMMAND.GAMETICK_REFRESH_COMMAND)
                {
                    _local_2 = true;
                    break;
                };
            };
            if (!_local_2)
            {
                cLog.warning("SHOULD NOT HAPPEN!!! Gametick Command killed: recreating it!");
                mSynchronisationErrorBitField = (mSynchronisationErrorBitField | cGeneralInterface.SYNCHRONISATION_ERROR_GAMETICK_COMMAND_KILLED_ERROR);
                SetGameTickRefreshCommand(mHomePlayer);
            };
        }

        public function IsZoneSavable():Boolean
        {
            return (true);
        }

        private function checkPendingEventTimerHandler(_arg_1:TimerEvent):void
        {
            var _local_3:String;
            var _local_2:Boolean;
            for (_local_3 in this.pendingEventChecks)
            {
                mEventManager.isEventStarted(_local_3);
                _local_2 = ((_local_2) || (_local_3 in this.pendingEventChecks));
            };
            if (_local_2)
            {
                this.checkPendingEventTimer.reset();
                this.checkPendingEventTimer.start();
            };
        }

        private function HandleResetCultureBuildingCooldownWithGems(_arg_1:cPlayerData, _arg_2:dGameTickCommandVO):void
        {
            var _local_3:dUniqueID = (_arg_2.data as dUniqueID);
            var _local_4:cBuilding = mCurrentPlayerZone.mStreetDataMap.GetBuildingByUniqueId(_local_3);
            var _local_5:cResources = mCurrentPlayerZone.GetResources(_arg_1);
            if (_local_3 != null)
            {
                _local_4 = mCurrentPlayerZone.mStreetDataMap.GetBuildingByUniqueId(_local_3);
            };
            if (!_local_5.HasPlayerResource(defines.HARD_CURRENCY_RESOURCE_NAME_string, _local_4.GetSkipCooldownGemCost()))
            {
                cLog.error((("E:" + _arg_1.GetPlayerId()) + " Cannot open advent calendar door with gems. Insufficient funds!"));
                return;
            };
            _local_5.AddResource(defines.HARD_CURRENCY_RESOURCE_NAME_string, -(_local_4.GetSkipCooldownGemCost()), ModifyReason.RESET_WITH_GEMS, null);
            cooldownManager.resetCooldown(COOLDOWN_TYPE.fromTimedProduction(_local_4.productionType));
            globalFlash.gui.mCultureBuildingPanel.SetIsWaitingForServer(false);
        }

        public function removeBuffFromPlayerData(_arg_1:cPlayerData, _arg_2:cBuff):void
        {
            if (((_arg_2.isDeleted()) || (_arg_2.GetAmount() <= 0)))
            {
                _arg_1.removeLastFetchedBuff();
            };
        }

        private function ValidateBuyTradeOneClickShopItems(_arg_1:cPlayerData, _arg_2:dTradeOfferVO):int
        {
            if (((_arg_2.slotType == TRADE_SLOT_TYPE.FREE_SLOT) && (mHomePlayer.mTradeData.getNextFreeSlotForType(TRADE_SLOT_TYPE.FREE_SLOT) > 0)))
            {
                cLog.error((("E:" + _arg_1.GetPlayerId()) + " User already placed an offer but requested a free slot!"));
                return (-1);
            };
            var _local_3:cResources = mCurrentPlayerZone.GetResources(_arg_1);
            var _local_4:int;
            var _local_5:int;
            var _local_6:* = "";
            if (_arg_2.slotType == TRADE_SLOT_TYPE.PAID_SLOT_WITH_COINS)
            {
                _local_4 = mHomePlayer.mTradeData.getNextFreeSlotForType(TRADE_SLOT_TYPE.PAID_SLOT_WITH_COINS);
                if (_local_4 >= global.activateSlotsWithCoins_vector.length)
                {
                    cLog.error((("E:" + _arg_1.GetPlayerId()) + " Coin slot requested, but queue is full!"));
                    return (-1);
                };
                _local_5 = global.activateSlotsWithCoins_vector[_local_4];
                _local_6 = defines.COIN_RESOURCE_NAME_string;
            }
            else
            {
                if (_arg_2.slotType == TRADE_SLOT_TYPE.PAID_SLOT_WITH_GEMS)
                {
                    _local_4 = mHomePlayer.mTradeData.getNextFreeSlotForType(TRADE_SLOT_TYPE.PAID_SLOT_WITH_GEMS);
                    if (_local_4 >= global.activateSlotsWithGems_vector.length)
                    {
                        cLog.error((("E:" + _arg_1.GetPlayerId()) + " Gem slot requested, but queue is full!"));
                        return (-1);
                    };
                    _local_5 = global.activateSlotsWithGems_vector[_local_4];
                    _local_6 = defines.HARD_CURRENCY_RESOURCE_NAME_string;
                };
            };
            if (_local_6 != "")
            {
                if (_local_3.HasPlayerResource(_local_6, _local_5))
                {
                    if (_arg_2.lots > 4)
                    {
                        if (_local_6 == defines.HARD_CURRENCY_RESOURCE_NAME_string)
                        {
                            if (!_local_3.HasPlayerResource(_local_6, (_local_5 + global.costOfUnlimitingLots)))
                            {
                                cLog.error((("E:" + _arg_1.GetPlayerId()) + " Cannot buy OneClickShopItem: BUY_TRADE_SLOT_FOR_GEMS + BUY_TRADE_UNLIMITED_LOTS. Insufficient funds!"));
                                return (-1);
                            };
                        }
                        else
                        {
                            if (!_local_3.HasPlayerResource(defines.HARD_CURRENCY_RESOURCE_NAME_string, global.costOfUnlimitingLots))
                            {
                                cLog.error((("E:" + _arg_1.GetPlayerId()) + " Cannot buy OneClickShopItem: BUY_TRADE_UNLIMITED_LOTS. Insufficient funds!"));
                                return (-1);
                            };
                        };
                    };
                    if ((((!(_arg_2.offerRes == null)) && (_arg_2.offerRes.name_string == _local_6)) && (!(_local_3.HasPlayerResource(_local_6, (_local_5 + (_arg_2.offerRes.amount * _arg_2.lots)))))))
                    {
                        cLog.error((("E:" + _arg_1.GetPlayerId()) + " Cannot afford the trade. Insufficient funds!"));
                        return (-1);
                    };
                }
                else
                {
                    cLog.error((((("E:" + _arg_1.GetPlayerId()) + " Cannot buy OneClickShopItem: Insufficient ") + _local_6) + "!"));
                    return (-1);
                };
            };
            if (_arg_2.lots > 4)
            {
                if (!_local_3.HasPlayerResource(defines.HARD_CURRENCY_RESOURCE_NAME_string, global.costOfUnlimitingLots))
                {
                    cLog.error((("E:" + _arg_1.GetPlayerId()) + " Cannot buy OneClickShopItem: BUY_TRADE_UNLIMITED_LOTS. Insufficient funds!"));
                    return (-1);
                };
            };
            return (_local_4);
        }

        private function HandleSetBuildingDefenseMode(_arg_1:cPlayerData, _arg_2:dGameTickCommandVO, _arg_3:Boolean, _arg_4:int):void
        {
            var _local_11:dUniqueID;
            var _local_12:cBuff;
            var _local_5:dServerAction = (_arg_2.data as dServerAction);
            var _local_6:String = global.buildingGroup.GetNameFromNr_string(global.buildingGroup.mGOList_vector, _local_5.type);
            var _local_7:cBuilding = cBuilding.CreateFromString(this.mGameTickCommandPlayer, global.buildingGroup, _local_6, this);
            if (_local_7 == null)
            {
                if (cLog.isInfoEnabled())
                {
                    cLog.info((((("Could not set " + _local_6) + " at ") + _local_5.grid) + " because building could not be created!"));
                };
                return;
            };
            if (!this.mRequirements.buildingRequirements_vector[_local_7.GetBuildingName_string()].isFulfilled())
            {
                if (cLog.isInfoEnabled())
                {
                    cLog.info((((("Could not set " + _local_6) + " at ") + _local_5.grid) + " because requirements are not fulfilled!"));
                };
                return;
            };
            var _local_8:int = mCurrentPlayerZone.IsBuildingPlacableGridPosition(_local_7, this.mGameTickCommandPlayer, _local_5.grid);
            if (_local_8 != 0)
            {
                if (cLog.isInfoEnabled())
                {
                    cLog.info(((((("Could not set building " + _local_6) + " at ") + _local_5.grid) + " because IsBuildingPlacableGridPosition() returned ") + ERROR_CODES.toString(_local_8)));
                };
                return;
            };
            var _local_9:cResources = mCurrentPlayerZone.GetResources(mCurrentPlayer);
            if (((!(_arg_3)) && (!(_local_9.CanPlayerAffordBuilding(_local_6)))))
            {
                if (cLog.isInfoEnabled())
                {
                    cLog.info((((("Could not set building " + _local_6) + " at ") + _local_5.grid) + " because player can't afford it."));
                };
                return;
            };
            if (!mCurrentPlayerZone.mStreetDataMap.RemoveDepletedDepositBuildingIfOneIsThere(_local_5.grid))
            {
                if (cLog.isInfoEnabled())
                {
                    cLog.info((((("Could not set building " + _local_6) + " at ") + _local_5.grid) + " because it's not possible to remove ghost garrison."));
                };
                return;
            };
            if (_arg_3)
            {
                _local_11 = (_local_5.data as dUniqueID);
                _local_12 = null;
                _local_12 = this.mGameTickCommandPlayer.getBuffByUniqueID(_local_11);
                if (_local_12 == null)
                {
                    if (cLog.isInfoEnabled())
                    {
                        cLog.info((("Could not find buff " + _local_11) + "!"));
                    };
                    this.mGameTickCommandPlayer.resetLastFetchedBuff();
                    return;
                };
                if (_local_12.GetResourceName_string() != _local_6)
                {
                    this.mGameTickCommandPlayer.resetLastFetchedBuff();
                    return;
                };
                if (((_arg_3) && (!(this.isBuffUpdated(this.mGameTickCommandPlayer.GetPlayerId(), _local_12, 1)))))
                {
                    this.mGameTickCommandPlayer.resetLastFetchedBuff();
                    return;
                };
                _local_12.DecWaitingForServerCount(this);
                _local_12.SetAmount((_local_12.GetAmount() - 1));
                this.removeBuffFromPlayerData(this.mGameTickCommandPlayer, _local_12);
                _local_12.DecWaitingForServerCount(this);
                if (gMisc.GetRandomMinMaxInt(1, 100) <= _local_12.GetRecurrentChance())
                {
                    _local_7.SetRecurringChance(_local_12.GetRecurrentChance());
                };
                globalFlash.gui.mStarMenu.Refresh();
            }
            else
            {
                _local_9.RemoveBuildingResourcesFromPlayerResources(_local_6);
            };
            if (!_arg_3)
            {
                _local_7.mOrigin = cBuilding.BUILDING_ORIGIN_FROM_GAME;
            }
            else
            {
                _local_7.mOrigin = cBuilding.BUILDING_ORIGIN_FROM_BUFF;
            };
            _local_7 = (mCurrentPlayerZone.SetGoAtGridPosition(this.mGameTickCommandPlayer, _local_7, OBJECTTYPE.BUILDING, _local_5.grid) as cBuilding);
            if (_local_7 == null)
            {
                if (cLog.isInfoEnabled())
                {
                    cLog.info((((("Could not set " + _local_6) + " at ") + _local_5.grid) + " because SetGoAtGridPosition() returned null!"));
                };
                return;
            };
            var _local_10:GridPosition = new GridPosition(_local_5.grid, mCurrentPlayerZone.mMapWidth);
            _local_7.SetUniqueId(new dUniqueID().Init(_local_10.X(), _local_10.Y()));
            _local_7.SetBuildingMode(cBuilding.BUILDING_MODE_PRODUCES_NO_RESOURCES);
            _local_7.mDirtyIndicator.created();
            mCurrentPlayerZone.mStreetDataMap.CalculateWatchAreas();
            if (cLog.isInfoEnabled())
            {
                cLog.info(((("Building " + _local_6) + " successfully created at ") + _local_5.grid));
            };
        }

        private function HandleApplyCasualty(_arg_1:cPlayerData, _arg_2:dGameTickCommandVO):Boolean
        {
            var _local_3:dCasualty = (_arg_2.data as dCasualty);
            mCurrentPlayerZone.GetResources(_arg_1).ModifyMilitaryPopulationResource(-(_local_3.mAmount));
            return (true);
        }

        override public function ClearLevel():void
        {
            mCurrentPlayerZone.Clear();
            this.ClearLevelOnTheFly();
        }

        private function HandleDeclineAdventureInvitation(_arg_1:cPlayerData, _arg_2:dGameTickCommandVO, _arg_3:Boolean):Boolean
        {
            return (true);
        }

        public function SpoolTime(_arg_1:Number, _arg_2:Boolean):String
        {
            var _local_6:int;
            var _local_7:int;
            var _local_8:int;
            var _local_3:* = "";
            var _local_4:Number = (_arg_1 - GetClientTime());
            var _local_5:Number = this.SpoolTimeDeltaValue(_local_4);
            if (_local_5 == -1)
            {
                if (_arg_2)
                {
                    _local_3 = (_local_3 + "spooling takes longer than 60 seconds, stopping\n");
                };
            };
            if (_arg_2)
            {
                _local_6 = int(int((_local_4 / 1000)));
                _local_7 = int((_local_6 / 60));
                _local_8 = int((_local_7 / 60));
                _local_3 = (_local_3 + "**************************************************\n");
                _local_3 = (_local_3 + (((((((("spooling " + _local_6) + "sec = ") + _local_7) + "min = ") + _local_8) + " h into the future takes ") + (_local_5 / 1000)) + " sec \n"));
                _local_3 = (_local_3 + "**************************************************\n");
            };
            return (_local_3);
        }

        private function logOneClickShopPurchase(_arg_1:cPlayerData, _arg_2:dBuyOneClickShopItemVO, _arg_3:int):void
        {
            var _local_4:dPurchasedShopItemVO = new dPurchasedShopItemVO();
            _local_4.shopItemID = _arg_2.itemId;
            _local_4.playerLevelAtPurchase = _arg_1.GetPlayerLevel();
            _local_4.hardCurrencySpend = _arg_3;
            _local_4.dirtyIndicator = (_local_4.dirtyIndicator | DIRTY_INDICATOR.CREATED_BIT);
            mCurrentPlayer.mPurchasedShopItems_vector.push(_local_4);
            var _local_5:cResources = mCurrentPlayerZone.GetResources(_arg_1);
            var _local_6:int = _local_5.GetResourceAmount(defines.HARD_CURRENCY_RESOURCE_NAME_string);
            TrackManager.getInstance().trackBuyItemForGems(_arg_1, cShopItem.GetShopItem(_arg_2.itemId).GetName_string(), _arg_3, _local_6);
        }

        private function HandleSelectAdventCalendarDoorReward(_arg_1:dGameTickCommandVO):void
        {
            var _local_2:dAdventCalendarDoorVO = (_arg_1.data as dAdventCalendarDoorVO);
            var _local_3:dAdventCalendarDoorVO = mAdventCalendarManager.GetDoorById(_local_2.id);
            _local_3.chosenRewardId = _local_2.chosenRewardId;
        }

        private function HandleRemoveBuff(_arg_1:cPlayerData, _arg_2:dGameTickCommandVO):Boolean
        {
            var _local_3:dServerAction = (_arg_2.data as dServerAction);
            var _local_4:dUniqueID = (_local_3.data as dUniqueID);
            var _local_5:int = _local_3.endGrid;
            var _local_6:cBuff = _arg_1.getBuffByUniqueID(_local_4);
            if (_local_6 != null)
            {
                if (!this.isBuffUpdated(_arg_1.GetPlayerId(), _local_6, _local_5))
                {
                    _arg_1.resetLastFetchedBuff();
                    cLog.warning((((("E:" + _arg_1.GetPlayerId()) + " Could not delete buff ") + _local_4) + " in database!"));
                    return (false);
                };
                TrackManager.getInstance().trackDeleteBuff(_arg_1.getPlayerID(), _local_6.GetBuffDefinition().GetName_string(), _local_6.GetResourceName_string(), _local_5, _local_6.GetAmount(), (_local_6.GetAmount() - _local_5));
                _local_6.applyBuffResultToBuff(_arg_1, this, _local_5);
                if (((_local_6.isDeleted()) || (_local_6.GetAmount() <= 0)))
                {
                    _arg_1.removeLastFetchedBuff();
                }
                else
                {
                    _local_6.SetWaitingForServerCount((_local_6.GetWaitingForServerCount() - _local_5), this);
                };
                if (_arg_1.GetPlayerId() == mHomePlayer.GetPlayerId())
                {
                    globalFlash.gui.mStarMenu.Refresh();
                };
            }
            else
            {
                cLog.warning(((("E:" + _arg_1.GetPlayerId()) + " Could not find buff ") + _local_4));
            };
            return (true);
        }

        private function handleMoveCombatPreviewPath(_arg_1:dGameTickCommandVO):void
        {
            var _local_2:CombatPreviewPathVO = (_arg_1.data as CombatPreviewPathVO);
            var _local_3:int = _local_2.gridStart;
            var _local_4:cBuilding = mCurrentPlayerZone.mStreetDataMap.mBuildingContainer.get(_local_3);
            if (_local_4 != null)
            {
                mCombatPersitedPreview.DeleteCombatPreviewPath(_local_2.uniqueId);
                return;
            };
            mCombatPersitedPreview.MovePreviewPath(_local_2);
        }

        private function handleLeaveAdventure(_arg_1:dGameTickCommandVO):void
        {
            var _local_4:cSpecialist;
            var _local_2:dLeaveAdventureVO = (_arg_1.data as dLeaveAdventureVO);
            var _local_3:cAdventure = mCurrentPlayerZone.GetAdventure();
            if (!IsAdventureZone())
            {
                cLog.error("handleLeaveAdventure() cannot be applied on a non-adventure zone");
                return;
            };
            for each (_local_4 in mCurrentPlayerZone.GetSpecialists_vector())
            {
                if (_local_4.getPlayerID() == _local_2.playerID)
                {
                    _local_4.SetTask(new cSpecialistTask_TravelToZone(this, _local_4, _local_4.getPlayerID(), 0, 0, TASK_PHASES_TRAVEL_TO_ZONE.STRIKE_GARRISON));
                    if (_local_4.GetTask() != null)
                    {
                        (_local_4.GetTask() as cSpecialistTask_TravelToZone).BeginTravel();
                        if (((!(_local_4.GetGarrison() == null)) && (_local_4.GetGarrison().GetBuildingMode() == cBuilding.BUILDING_MODE_PRODUCES_NO_RESOURCES)))
                        {
                            mCurrentPlayerZone.mStreetDataMap.DeconstructBuildingGridPos(_local_4.GetGarrison().GetGrid());
                        };
                    };
                };
            };
        }

        private function handleRemoveAllWaitingProductions(_arg_1:cPlayerData, _arg_2:dGameTickCommandVO):void
        {
            var _local_3:int = (_arg_2.data as int);
            var _local_4:cTimedProductionQueue = mCurrentPlayerZone.GetProductionQueue(_local_3);
            if (_local_4 != null)
            {
                _local_4.cancelAllWaiting(_arg_1);
                _local_4.SetAllProductionWaitingForServer(false);
            }
            else
            {
                cLog.error(((("P:" + _arg_1.GetPlayerId()) + " - Remove production: Could not interpret production type ") + _local_3));
                return;
            };
        }

        public function ReDisableShopItem(_arg_1:int):void
        {
            if (_arg_1 > 0)
            {
                this.mEnabledShopItems_vector.remove(_arg_1);
                if (this.mEnabledShopItems_vector.isEmpty())
                {
                    this.mSpecificShopItems = false;
                };
            }
            else
            {
                this.mSpecificShopItems = false;
            };
        }

        private function HandleRetreat(_arg_1:cPlayerData, _arg_2:dGameTickCommandVO):Boolean
        {
            var _local_4:cSpecialistTask;
            if (!(_arg_2.data is dUniqueID))
            {
                return (false);
            };
            var _local_3:cSpecialist = mCurrentPlayerZone.getSpecialist(_arg_1.GetPlayerId(), dUniqueID(_arg_2.data));
            if (_local_3 != null)
            {
                _local_4 = _local_3.GetTask();
                if ((((!(_local_4 == null)) && ((_local_4.GetType() == SPECIALIST_TASK_TYPES.ATTACK_BUILDING) || (_local_4.GetType() == SPECIALIST_TASK_TYPES.ATTACK_BUILDING_NEW_COMBAT))) && (((_local_4.GetTaskPhase() == TASK_PHASES_ATTACK_BUILDING.GO_TO_TARGET) || (_local_4.GetTaskPhase() == TASK_PHASES_ATTACK_BUILDING.WAIT_AT_TARGET)) || (_local_4.GetTaskPhase() == TASK_PHASES_ATTACK_BUILDING.ATTACK_TARGET))))
                {
                    if (_local_4.GetType() == SPECIALIST_TASK_TYPES.ATTACK_BUILDING)
                    {
                        (_local_4 as cSpecialistTask_AttackBuilding).HandleRetreat(false);
                    }
                    else
                    {
                        (_local_4 as cSpecialistTask_AttackBuildingNewCombat).HandleRetreat();
                    };
                };
            };
            return (true);
        }

        private function handleRecreateEmptyDeposit(_arg_1:dGameTickCommandVO):void
        {
            mServer.CreateDepositFromDepositVO((_arg_1.data as dDepositVO), false, true);
        }

        public function handleBuyOneClickShopItem(_arg_1:cPlayerData, _arg_2:dGameTickCommandVO):Boolean
        {
            var _local_3:dBuyOneClickShopItemVO;
            var _local_4:cBuilding;
            var _local_9:int;
            var _local_10:cTimedProductionQueue;
            var _local_11:cTimedProduction;
            var _local_12:int;
            var _local_13:int;
            var _local_14:dUniqueID;
            var _local_15:cSpecialist;
            var _local_16:cSpecialistTask;
            var _local_17:int;
            var _local_18:int;
            var _local_19:int;
            var _local_20:int;
            var _local_21:dUniqueID;
            var _local_22:dQuestElementVO;
            var _local_23:int;
            var _local_24:dTempBuildSlotVO;
            _local_3 = (_arg_2.data as dBuyOneClickShopItemVO);
            if (((this.mSpecificShopItems) && (!(this.mEnabledShopItems_vector.contains(_local_3.itemId)))))
            {
                if (_local_3.itemId == ONE_CLICK_SHOPITEM.INSTANT_BUILDING_UPGRADE)
                {
                    _local_4 = mCurrentPlayerZone.GetBuildingFromGridPosition(_local_3.buildingGridIdx);
                    if (_local_4 != null)
                    {
                        _local_4.SetIsUpgradeInitiatedWithGem(false);
                    };
                };
                CustomAlert.show("ShopItemDeactivated", "ShopItemDeactivated");
                return (false);
            };
            var _local_5:cResources = mCurrentPlayerZone.GetResources(_arg_1);
            var _local_6:int;
            var _local_7:dResource;
            var _local_8:cShopItem;
            switch (_local_3.itemId)
            {
                case ONE_CLICK_SHOPITEM.INSTANT_BUILDING_CONSTRUCTION:
                    _local_4 = mCurrentPlayerZone.GetBuildingFromGridPosition(_local_3.buildingGridIdx);
                    if (_local_4 == null)
                    {
                        cLog.error(((("E:" + _arg_1.GetPlayerId()) + " Cannot instant build building. It's null: ") + _local_3.buildingGridIdx));
                        return (false);
                    };
                    if (((!(_local_4.GetBuildingMode() == cBuilding.BUILDING_MODE_SETTLER_WALKS_TO_BUILDING_GROUND_PLACE)) && (!(_local_4.GetBuildingMode() == cBuilding.BUILDING_MODE_CONSTRUCTION))))
                    {
                        cLog.error(((("E:" + _arg_1.GetPlayerId()) + " Cannot instant build building. It's building mode id ") + _local_4.GetBuildingMode()));
                        return (false);
                    };
                    _local_9 = _local_4.GetBuildInstantCosts();
                    if (((_local_5 == null) || (!(_local_5.HasPlayerResource(defines.HARD_CURRENCY_RESOURCE_NAME_string, _local_9)))))
                    {
                        cLog.error((("E:" + _arg_1.GetPlayerId()) + " Cannot instant build building. Insufficient funds!"));
                        return (false);
                    };
                    _local_5.AddResource(defines.HARD_CURRENCY_RESOURCE_NAME_string, -(_local_9), ModifyReason.INSTANT_BUILD_BUILDING, _local_4.GetBuildingName_string());
                    _local_4.SetBuildingMode(cBuilding.BUILDING_MODE_CONSTRUCTION);
                    _local_4.mBuildingProgress = (100 * defines.BUILDING_PROGRESS_SCALE_FACTOR);
                    this.logOneClickShopPurchase(_arg_1, _local_3, _local_9);
                    break;
                case ONE_CLICK_SHOPITEM.INSTANT_PROVISIONHOUSE_PRODUCTION:
                case ONE_CLICK_SHOPITEM.INSTANT_BARRACKS_PRODUCTION:
                case ONE_CLICK_SHOPITEM.INSTANT_SKILL_TIMED_PRODUCTION:
                case ONE_CLICK_SHOPITEM.INSTANT_COLLECTION_TIMED_PRODUCTION:
                case ONE_CLICK_SHOPITEM.INSTANT_EXPEDITION_PRODUCTION:
                case ONE_CLICK_SHOPITEM.INSTANT_EXPEDITION_UNIT_PRODUCTION:
                case ONE_CLICK_SHOPITEM.INSTANT_ELITE_UNIT_PRODUCTION:
                case ONE_CLICK_SHOPITEM.INSTANT_SIMPLE_TIMED_PRODUCTION:
                    _local_4 = mCurrentPlayerZone.GetBuildingFromGridPosition(_local_3.buildingGridIdx);
                    if (_local_4 == null)
                    {
                        cLog.error(((("E:" + _arg_1.GetPlayerId()) + " Cannot instant produce. Production building is null: ") + _local_3.buildingGridIdx));
                        return (false);
                    };
                    _local_10 = _local_4.productionQueue;
                    if (((_local_10 == null) || (_local_10.mTimedProductions_vector.length == 0)))
                    {
                        cLog.error((("E:" + _arg_1.GetPlayerId()) + " Cannot instant produce. Couldn't find current production in queue!"));
                        return (false);
                    };
                    _local_11 = _local_10.mTimedProductions_vector[0];
                    _local_12 = _local_11.GetInstantBuildCosts();
                    if (_local_12 <= 0)
                    {
                        cLog.error((("E:" + _arg_1.GetPlayerId()) + " Cannot instant produce. Costs are 0!"));
                        _local_10.SetAllProductionWaitingForServer(false);
                        return (false);
                    };
                    if (!_local_5.HasPlayerResource(defines.HARD_CURRENCY_RESOURCE_NAME_string, _local_12))
                    {
                        cLog.error((("E:" + _arg_1.GetPlayerId()) + " Cannot instant produce. Insufficient funds!"));
                        _local_10.SetAllProductionWaitingForServer(false);
                        return (false);
                    };
                    _local_5.AddResource(defines.HARD_CURRENCY_RESOURCE_NAME_string, -(_local_12), ModifyReason.INSTANT_PRODUCTION, _local_4.GetBuildingName_string());
                    if (_local_3.itemId == ONE_CLICK_SHOPITEM.INSTANT_SKILL_TIMED_PRODUCTION)
                    {
                        _local_10.SetProductionToRedyForPickUp(_arg_1);
                        _local_10.SetAllProductionWaitingForServer(false);
                        globalFlash.gui.mSkillProductionPanel.refresh();
                    }
                    else
                    {
                        _local_10.finishProduction(_arg_1, false);
                        _local_10.SetAllProductionWaitingForServer(false);
                    };
                    this.logOneClickShopPurchase(_arg_1, _local_3, _local_12);
                    break;
                case ONE_CLICK_SHOPITEM.INSTANT_BUILDING_UPGRADE:
                    _local_4 = mCurrentPlayerZone.GetBuildingFromGridPosition(_local_3.buildingGridIdx);
                    if (_local_4 == null)
                    {
                        cLog.error(((("E:" + _arg_1.GetPlayerId()) + " Cannot instant upgrade building. It's null: ") + _local_3.buildingGridIdx));
                        return (false);
                    };
                    _local_13 = _local_4.GetUpgradeInstantCosts();
                    if (_local_13 == 0)
                    {
                        _local_4.SetIsUpgradeInitiatedWithGem(false);
                        cLog.error((("E:" + _arg_1.GetPlayerId()) + " Cannot instant upgrade building. Building not upgradable!"));
                        return (false);
                    };
                    if (!_local_5.HasPlayerResource(defines.HARD_CURRENCY_RESOURCE_NAME_string, _local_13))
                    {
                        _local_4.SetIsUpgradeInitiatedWithGem(false);
                        cLog.error((("E:" + _arg_1.GetPlayerId()) + " Cannot instant upgrade building. Insufficient funds!"));
                        return (false);
                    };
                    _local_5.AddResource(defines.HARD_CURRENCY_RESOURCE_NAME_string, -(_local_13), ModifyReason.INSTANT_BUILDING_UPGRADE, _local_4.GetBuildingName_string());
                    if (_local_4.IsUpgradeInProgress())
                    {
                        _local_4.refundUpgrade();
                    };
                    mComputeResourceCreation.UpgradeBuilding(_local_4);
                    TrackManager.getInstance().trackBuildingUpdgrade(_arg_1, _local_4, true);
                    this.logOneClickShopPurchase(_arg_1, _local_3, _local_13);
                    break;
                case ONE_CLICK_SHOPITEM.HALF_SPECIALIST_TIME:
                    _local_14 = _local_3.uniqueID;
                    if (dUniqueID.isEmpty(_local_14))
                    {
                        cLog.error(((("E:" + _arg_1.GetPlayerId()) + " Specialist ID is not valid:") + _local_14));
                        return (false);
                    };
                    _local_15 = mCurrentPlayerZone.getSpecialist(_arg_1.GetPlayerId(), _local_14);
                    if (_local_15 == null)
                    {
                        cLog.error(((("E:" + _arg_1.GetPlayerId()) + " Could not find specialist with ID ") + _local_14));
                        return (false);
                    };
                    _local_16 = _local_15.GetTask();
                    if (_local_15.GetTask() == null)
                    {
                        cLog.error((((("E:" + _arg_1.GetPlayerId()) + " Specialist ") + _local_14) + " has no task!"));
                        return (false);
                    };
                    _local_17 = _local_15.GetTask().getSpeedUpCosts();
                    _local_18 = _local_15.GetTask().getSpeedUpFactor();
                    if (_local_18 <= 0)
                    {
                        cLog.error((("E:" + _arg_1.GetPlayerId()) + " Cannot speed up task!"));
                        return (false);
                    };
                    if (_local_5.HasPlayerResource(defines.HARD_CURRENCY_RESOURCE_NAME_string, _local_17))
                    {
                        _local_5.AddResource(defines.HARD_CURRENCY_RESOURCE_NAME_string, -(_local_17), ModifyReason.HALF_SPECIALIST_TIME, (((SPECIALIST_TYPE.toString(_local_15.GetType()) + " (") + SPECIALIST_TASK_TYPES.toString(_local_16.GetType())) + ")"));
                        this.logOneClickShopPurchase(_arg_1, _local_3, _local_17);
                    }
                    else
                    {
                        cLog.error((("E:" + _arg_1.GetPlayerId()) + " Cannot speed up specialist. Insufficient funds!"));
                        return (false);
                    };
                    _local_19 = (_local_16.GetNeededTime() - _local_16.GetCollectedTime());
                    _local_20 = int((_local_19 - (_local_19 / _local_18)));
                    _local_16.SetCollectedTime((_local_16.GetCollectedTime() + _local_20));
                    _local_16.IncBonusTime(_local_20);
                    _local_16.mDirtyIndicator = (_local_16.mDirtyIndicator | DIRTY_INDICATOR.MODIFIED_BIT);
                    globalFlash.gui.mSpecialistCooldownPanel.Refresh();
                    break;
                case ONE_CLICK_SHOPITEM.PAY_FOR_QUEST_FINISH:
                    _local_21 = _local_3.uniqueID;
                    if (dUniqueID.isEmpty(_local_21))
                    {
                        cLog.error((("E:" + _arg_1.GetPlayerId()) + " Quest unique ID is null"));
                        return (false);
                    };
                    _local_22 = mQuestClientCallbacks.GetClientQuestPool().GetQuestFromUniqueID(_local_21);
                    if (_local_22 == null)
                    {
                        cLog.error(((("E:" + _arg_1.GetPlayerId()) + " Could not find quest with unique ID ") + _local_21));
                        return (false);
                    };
                    _local_23 = _local_22.GetQuestDefinition().questWinGemCosts;
                    if (_local_23 == 0)
                    {
                        cLog.error(((("E:" + _arg_1.GetPlayerId()) + " quest could not be won with gems ") + _local_22));
                        _local_22.instantFinishInProgress = false;
                        return (false);
                    };
                    if (!_local_22.IsRunning())
                    {
                        cLog.error(((("E:" + _arg_1.GetPlayerId()) + " quest isn't running ") + _local_22));
                        _local_22.instantFinishInProgress = false;
                        return (false);
                    };
                    if (_local_5.HasPlayerResource(defines.HARD_CURRENCY_RESOURCE_NAME_string, _local_23))
                    {
                        _local_5.AddResource(defines.HARD_CURRENCY_RESOURCE_NAME_string, -(_local_23), ModifyReason.PAY_FOR_QUEST_FINISH, _local_22.getQuestName_string());
                        this.logOneClickShopPurchase(_arg_1, _local_3, _local_23);
                    }
                    else
                    {
                        cLog.error((("E:" + _arg_1.GetPlayerId()) + " Cannot win quest. Insufficient funds!"));
                        _local_22.instantFinishInProgress = false;
                        return (false);
                    };
                    _local_22.FinishQuest(this);
                    break;
                case ONE_CLICK_SHOPITEM.BUY_TEMP_BUILD_QUEUE_SLOT:
                    _local_8 = cShopItem.GetShopItem(ONE_CLICK_SHOPITEM.BUY_TEMP_BUILD_QUEUE_SLOT);
                    if (_local_5.HasPlayerResourcesInList(_local_8.GetIncCosts_vector(mCurrentPlayer.GetPurchasedShopItemAmount(_local_8.GetId())), 1))
                    {
                        _local_5.RemovePlayerResourcesFromResourcesInList(_local_8.GetIncCosts_vector(mCurrentPlayer.GetPurchasedShopItemAmount(_local_8.GetId())), 1, ModifyReason.BUY_TEMP_BUILD_QUEUE_SLOT);
                        _local_6 = 0;
                        for each (_local_7 in _local_8.GetIncCosts_vector(mCurrentPlayer.GetPurchasedShopItemAmount(_local_8.GetId())))
                        {
                            if (_local_7.name_string == defines.HARD_CURRENCY_RESOURCE_NAME_string)
                            {
                                _local_6 = _local_7.amount;
                                break;
                            };
                        };
                        _local_24 = new dTempBuildSlotVO();
                        _local_24.timeOfPurchase = GetClientTime();
                        _local_24.dirtyIndicator = (_local_24.dirtyIndicator | DIRTY_INDICATOR.CREATED_BIT);
                        mCurrentPlayer.mAvailableTempSlots_vector.push(_local_24);
                        mCurrentPlayer.mBuildQueue.updateTempSlots();
                        this.logOneClickShopPurchase(_arg_1, _local_3, _local_6);
                        channels.TRADE.send(TriggerUtils.TRADE_QUEUE_SLOT_PROPERTY_NAME, TriggerUtils.TRADE_QUEUE_SLOT_TEMPORARY_TYPE_NAME);
                    }
                    else
                    {
                        cLog.error((("E:" + _arg_1.GetPlayerId()) + " Can't buy temp build slot. Insufficient funds!"));
                        return (false);
                    };
                    break;
                case ONE_CLICK_SHOPITEM.BUY_PERMANENT_COLONY_SLOT:
                case ONE_CLICK_SHOPITEM.BUY_TEMP_COLONY_SLOT:
                    _local_8 = cShopItem.GetShopItem(_local_3.itemId);
                    if ((mCurrentPlayer.GetColonySlotCountTemp() + mCurrentPlayer.GetColonySlotCountPermanent()) < mCurrentPlayer.GetColonySlotCountTempMax())
                    {
                        if (_local_5.HasPlayerResourcesInList(_local_8.GetIncCosts_vector(mCurrentPlayer.GetPurchasedShopItemAmount(_local_8.GetId())), 1))
                        {
                            _local_5.RemovePlayerResourcesFromResourcesInList(_local_8.GetIncCosts_vector(mCurrentPlayer.GetPurchasedShopItemAmount(_local_8.GetId())), 1, ModifyReason.BUY_COLONY_SLOT);
                            _local_6 = 0;
                            for each (_local_7 in _local_8.GetIncCosts_vector(mCurrentPlayer.GetPurchasedShopItemAmount(_local_8.GetId())))
                            {
                                if (_local_7.name_string == defines.HARD_CURRENCY_RESOURCE_NAME_string)
                                {
                                    _local_6 = _local_7.amount;
                                    break;
                                };
                            };
                            this.logOneClickShopPurchase(_arg_1, _local_3, _local_6);
                            if (_local_3.itemId == ONE_CLICK_SHOPITEM.BUY_TEMP_COLONY_SLOT)
                            {
                                mCurrentPlayer.SetColonySlotCountTemp((mCurrentPlayer.GetColonySlotCountTemp() + 1));
                            }
                            else
                            {
                                mCurrentPlayer.SetColonySlotCountPermanent((mCurrentPlayer.GetColonySlotCountPermanent() + 1));
                            };
                            globalFlash.gui.mColonyWindow.Clear();
                            globalFlash.gui.mColonyWindow.Refresh();
                            globalFlash.gui.mColonyWindow.mPanel.busyOverlay.visible = false;
                        }
                        else
                        {
                            globalFlash.gui.mColonyWindow.mPanel.busyOverlay.visible = false;
                            cLog.error((("E:" + _arg_1.GetPlayerId()) + " Can't buy temp build slot. Insufficient funds!"));
                            return (false);
                        };
                    }
                    else
                    {
                        globalFlash.gui.mColonyWindow.mPanel.busyOverlay.visible = false;
                        cLog.error((("E:" + _arg_1.GetPlayerId()) + " Can't buy temp build slot. not enough free temp slots to buy left!"));
                        return (false);
                    };
                    break;
                case ONE_CLICK_SHOPITEM.BUY_TRADE_SLOT_FOR_COINS:
                case ONE_CLICK_SHOPITEM.BUY_TRADE_SLOT_FOR_GEMS:
                case ONE_CLICK_SHOPITEM.BUY_TRADE_UNLIMITED_LOTS:
                    break;
                default:
                    return (false);
            };
            return (true);
        }

        private function ShowIngameErrorMessagesDetail():void
        {
        }

        public function handleApplyBuffStack(_arg_1:cPlayerData, _arg_2:dGameTickCommandVO):int
        {
            var _local_8:dBuffVO;
            var _local_9:cSquad;
            var _local_10:cSquad;
            var _local_11:Object;
            var _local_3:dServerAction = (_arg_2.data as dServerAction);
            var _local_4:dBuffListVO = (_local_3.data as dBuffListVO);
            var _local_5:int;
            var _local_6:int;
            var _local_7:cBuilding = mCurrentPlayerZone.GetBuildingFromGridPosition(_local_3.grid);
            if (((!(_local_7 == null)) && (_local_7.mIsEventMonster)))
            {
                for each (_local_9 in _local_7.GetArmy().GetSquads_vector())
                {
                    _local_5 = (_local_5 + _local_9.amount);
                };
            };
            for each (_local_8 in _local_4.buffList)
            {
                this.applyBuffWithRetry(_arg_1, new dUniqueID().Init(_local_8.uniqueId1, _local_8.uniqueId2), _local_8.amount, _local_3.type, _local_3.grid, _local_4.target_string);
            };
            if (((!(_local_7 == null)) && (_local_7.mIsEventMonster)))
            {
                for each (_local_10 in _local_7.GetArmy().GetSquads_vector())
                {
                    _local_6 = (_local_6 + _local_10.amount);
                };
                _local_11 = new Object();
                _local_11.removedUnits = (_local_5 - _local_6);
                _local_11.monsterName = _local_7.GetBuildingName_string();
                globalFlash.gui.mAvatarMessageList.AddMessage(((_arg_1.GetPlayerId() == mCurrentPlayer.GetPlayerId()) ? AVATAR_MESSAGE_TYPE.MONSTER_HIT : AVATAR_MESSAGE_TYPE.MONSTER_HIT_BY_FRIEND), _local_11);
            };
            return (0);
        }

        private function handlePayToFinish(_arg_1:cPlayerData, _arg_2:int):void
        {
            var _local_7:FulfilmentTrigger;
            var _local_8:TriggerVO;
            var _local_9:dResource;
            var _local_3:Task = (getCurrentTaskManager().getIdentityByID(_arg_2) as Task);
            var _local_4:Boolean = true;
            var _local_5:cResources = mCurrentPlayerZone.GetResources(_arg_1);
            var _local_6:Vector.<dResource> = new Vector.<dResource>();
            if (!_local_3.getFinished())
            {
                for each (_local_7 in _local_3.getTriggers())
                {
                    _local_8 = _local_7.getDefinition();
                    if (((!(_local_7.getFinished())) && (_local_8.action_string == TriggerUtils.PAY_TO_FINISH_string)))
                    {
                        if (global.resourceDefinitions_vector.indexOf(_local_8.item_string) != -1)
                        {
                            if (_local_5.HasPlayerResource(_local_8.item_string, _local_8.amount))
                            {
                                _local_9 = new dResource();
                                _local_9.name_string = _local_8.item_string;
                                _local_9.amount = _local_8.amount;
                                _local_6.push(_local_9);
                            }
                            else
                            {
                                _local_4 = false;
                                break;
                            };
                        };
                    }
                    else
                    {
                        if (((!(_local_7.getFinished())) && (!(_local_8.action_string == TriggerUtils.PAY_TO_FINISH_string))))
                        {
                            _local_4 = false;
                            break;
                        };
                    };
                };
                if (((_local_4) && (_local_6.length > 0)))
                {
                    _local_5._RemovePlayerResourcesFromResourcesInList(_local_6, 1, ModifyReason.PAY_FOR_TASK_FINISH, true);
                    _local_3.setAllTriggerFinished();
                };
            };
            globalFlash.gui.mTaskBuildingPanel.mPanel.busy = false;
            globalFlash.gui.mTaskBuildingPanel.Refresh();
        }

        public function HandleBuyShopItem(_arg_1:dGameTickCommandVO):Boolean
        {
            var _local_8:int;
            var _local_9:dPurchasedShopItemVO;
            var _local_10:dResource;
            var _local_11:Boolean;
            var _local_12:int;
            var _local_13:Object;
            var _local_14:dBuffVO;
            var _local_15:cBuff;
            var _local_16:int;
            var _local_17:dSpecialistVO;
            var _local_18:cSpecialist;
            var _local_19:int;
            var _local_20:cItemContent;
            if (!(_arg_1.data is dBuyShopItemVO))
            {
                return (false);
            };
            var _local_2:dBuyShopItemVO = (_arg_1.data as dBuyShopItemVO);
            var _local_3:cShopItem = cShopItem.GetShopItem(_local_2.itemID);
            if (_local_3 == null)
            {
                return (false);
            };
            if ((((!(_arg_1.mode == COMMAND.BUY_SHOP_ITEM_MOBILE)) && (_local_3.hideInShop(this))) || ((this.mSpecificShopItems) && (!(this.mEnabledShopItems_vector.contains(_local_2.itemID))))))
            {
                return (false);
            };
            var _local_4:cPlayerData = FindPlayerFromId(_arg_1.playerID);
            gMisc.Assert((!(_local_4 == null)), ("Could not find player with id " + _arg_1.playerID));
            if (((_local_2.giftedPlayerID == 0) && (_local_3.GetPerPlayer() > 0)))
            {
                if (_local_4.GetPurchasedShopItemAmount(_local_3.GetId()) >= _local_3.GetPerPlayer())
                {
                    return (false);
                };
            };
            var _local_5:int = shopManager.GetRemainingShopItemCount(_local_3);
            if (((!(_local_5 == defines.NO_LIMIT)) && (_local_5 < 1)))
            {
                return (false);
            };
            var _local_6:Vector.<dResource> = _local_3.GetIncCosts_vector(mCurrentPlayer.GetPurchasedShopItemAmount(_local_3.GetId()));
            var _local_7:cResources = mCurrentPlayerZone.GetResources(_local_4);
            if (_local_7 == null)
            {
                return (false);
            };
            if (_local_7.HasPlayerResourcesInList(_local_6, 1))
            {
                _local_7.RemovePlayerResourcesFromResourcesInList(_local_6, 1, ModifyReason.BUY_SHOP_ITEM);
                _local_8 = _local_7.GetResourceAmount(defines.HARD_CURRENCY_RESOURCE_NAME_string);
                cLog.info(("SHOP BUY ORIGIN " + _local_2.transactionFrom));
                if (_local_2.transactionFrom == defines.TRANSACTION_FROM_PROMOTION)
                {
                    TrackManager.getInstance().trackBuyItemPromotion(_local_4, _local_3.GetName_string(), _local_6, _local_8);
                }
                else
                {
                    if (_local_2.transactionFrom == defines.TRANSACTION_FROM_WIDGET)
                    {
                        TrackManager.getInstance().trackBuyItemWidget(_local_4, _local_3.GetName_string(), _local_6, _local_8, cShopItemGroup.GetShopItemGroup(_local_3.GetGroupId()).GetName_string());
                    }
                    else
                    {
                        TrackManager.getInstance().trackBuyItem(_local_4, _local_3.GetName_string(), _local_6, _local_8, cShopItemGroup.GetShopItemGroup(_local_3.GetGroupId()).GetName_string());
                    };
                };
                _local_9 = new dPurchasedShopItemVO();
                _local_9.shopItemID = _local_3.GetId();
                _local_9.timeOfPurchase = new Date().getTime();
                _local_9.playerLevelAtPurchase = _local_4.GetPlayerLevel();
                _local_9.giftedToPlayerId = _local_2.giftedPlayerID;
                for each (_local_10 in _local_6)
                {
                    if (_local_10.name_string == defines.HARD_CURRENCY_RESOURCE_NAME_string)
                    {
                        _local_9.hardCurrencySpend = (_local_9.hardCurrencySpend + _local_10.amount);
                    }
                    else
                    {
                        _local_9.resourcesSpend = (_local_9.resourcesSpend + (((((_local_9.resourcesSpend.length > 0) ? "," : "") + _local_10.amount) + " ") + _local_10.name_string));
                    };
                };
                _local_9.dirtyIndicator = (_local_9.dirtyIndicator | DIRTY_INDICATOR.CREATED_BIT);
                _local_4.mPurchasedShopItems_vector.push(_local_9);
                shopManager.transactionCounter[_local_3]--;
                _local_11 = false;
                _local_12 = 0;
                if (_local_2.giftedPlayerID == 0)
                {
                    for each (_local_13 in _local_2.shopItemContent_vector)
                    {
                        if ((_local_13 is dBuffVO))
                        {
                            _local_14 = (_local_13 as dBuffVO);
                            if (_local_7.AddHardCurrencyResource(_local_14))
                            {
                                this.requestZonePersistence(COMMAND.ADD_HARD_CURRENCY);
                                _local_11 = true;
                                _local_12 = (_local_12 + _local_14.amount);
                            }
                            else
                            {
                                _local_15 = cBuff.CreateBuffFromVO(_local_14);
                                _local_16 = _local_15.GetAmount();
                                _local_15.SetAmount(((_local_16 > 0) ? _local_16 : 1));
                                _local_15.SetInsertedAt(TimeUtil.getServerTime());
                                _local_4.addBuff(_local_15);
                            };
                        }
                        else
                        {
                            if ((_local_13 is dSpecialistVO))
                            {
                                _local_17 = (_local_13 as dSpecialistVO);
                                _local_18 = cSpecialist.CreateSpecialistFromVO(this, _local_17, true);
                                _local_18.insertedAt = TimeUtil.getServerTime();
                                mCurrentPlayerZone.addSpecialist(_local_18);
                                _local_4.IncSpecialistAmount(_local_17.specialistType);
                                _local_19 = _local_7.GetResourceAmount(defines.HARD_CURRENCY_RESOURCE_NAME_string);
                                TrackManager.getInstance().trackGainSpecialist(_local_18, _local_9.hardCurrencySpend, _local_19, false, SPECIALIST_GAIN_SOURCE.SHOP);
                            }
                            else
                            {
                                return (false);
                            };
                        };
                    };
                    if (_local_11)
                    {
                        globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.PURCHASE_HARD_CURRENCY_SUCCESSFUL);
                        TrackManager.getInstance().trackGemAdded(_local_4, defines.CURRENCY_GEMS, _local_12, mCurrentPlayerZone.GetResources(_local_4).GetPlayerResource(defines.HARD_CURRENCY_RESOURCE_NAME_string).amount, "In Game Shop");
                    }
                    else
                    {
                        for each (_local_20 in _local_3.GetShopItemContent_vector())
                        {
                            if (mItemRegistry.IsLimitedItem(_local_20.GetType(), _local_20.GetName_string(), _local_20.GetResourceName_string()))
                            {
                                mItemRegistry.RegisterItem(_local_20.GetType(), _local_20.GetName_string(), _local_20.GetResourceName_string(), ((_local_20.GetCount() > 0) ? _local_20.GetCount() : 1));
                            };
                        };
                        globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.PURCHASE_SUCCESSFUL);
                    };
                }
                else
                {
                    globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.PURCHASE_GIFT_SUCCESSFUL);
                };
            }
            else
            {
                return (false);
            };
            if (globalFlash.gui.mShopWindow.IsVisible())
            {
                globalFlash.gui.mShopWindow.Refresh();
            };
            return (true);
        }

        private function AddLootItems(_arg_1:cPlayerData, _arg_2:ArrayCollection, _arg_3:ArrayCollection, _arg_4:Boolean):void
        {
            var _local_6:Object;
            var _local_7:dUniqueID;
            var _local_8:dBuffVO;
            var _local_9:dResource;
            var _local_10:int;
            var _local_11:int;
            var _local_12:cBuff;
            var _local_13:cBuff;
            var _local_14:dSpecialistVO;
            var _local_15:cSpecialist;
            var _local_16:cResources;
            var _local_17:int;
            var _local_18:dResourceVO;
            var _local_5:int;
            while (_local_5 < _arg_2.length)
            {
                _local_6 = _arg_2[_local_5];
                _local_7 = (_arg_3[_local_5] as dUniqueID);
                if ((_local_6 is dBuffVO))
                {
                    _local_8 = (_local_6 as dBuffVO);
                    if (mCurrentPlayerZone.GetResources(_arg_1).AddHardCurrencyResource(_local_8))
                    {
                        this.requestZonePersistence(COMMAND.ADD_HARD_CURRENCY);
                    }
                    else
                    {
                        if (((_arg_4) && (_local_8.buffName_string == defines.ADD_RESOURCE_BUFF)))
                        {
                            _local_9 = mCurrentPlayerZone.GetResources(_arg_1).GetPlayerResource(_local_8.resourceName_string);
                            _local_10 = Math.min(_local_8.amount, (_local_9.maxLimit - _local_9.amount));
                            _local_11 = Math.min(_local_8.amount, (_local_8.amount - _local_10));
                            if (_local_10 > 0)
                            {
                                mCurrentPlayerZone.GetResources(_arg_1).AddResource(_local_8.resourceName_string, _local_10, ModifyReason.ADD_RESOURCE_BUFF, null);
                            };
                            if (_local_11 > 0)
                            {
                                _local_8.amount = _local_11;
                                globalFlash.gui.mAvatarMessageList.AddResourceMessage(_local_8.resourceName_string, AVATAR_MESSAGE_TYPE.USED_RESOURCE_BUFF_LIMIT_REACHED, cBuff.CreateBuffFromVO(_local_8));
                                _local_8.uniqueId1 = _local_7.uniqueID1;
                                _local_8.uniqueId2 = _local_7.uniqueID2;
                                _local_12 = cBuff.CreateBuffFromVO(_local_8);
                                _arg_1.addBuff(_local_12);
                            };
                        }
                        else
                        {
                            _local_8.uniqueId1 = _local_7.uniqueID1;
                            _local_8.uniqueId2 = _local_7.uniqueID2;
                            _local_13 = cBuff.CreateBuffFromVO(_local_8);
                            _local_13.SetAmount(Math.max(1, _local_13.GetAmount()));
                            _arg_1.addBuff(_local_13);
                        };
                    };
                }
                else
                {
                    if ((_local_6 is dSpecialistVO))
                    {
                        _local_14 = (_local_6 as dSpecialistVO);
                        _local_14.uniqueID = _local_7;
                        _local_15 = cSpecialist.CreateSpecialistFromVO(this, _local_14, true);
                        _local_15.insertedAt = TimeUtil.getServerTime();
                        mCurrentPlayerZone.addSpecialist(_local_15);
                        _arg_1.IncSpecialistAmount(_local_14.specialistType);
                        _local_16 = mCurrentPlayerZone.GetResources(_arg_1);
                        _local_17 = _local_16.GetResourceAmount(defines.HARD_CURRENCY_RESOURCE_NAME_string);
                        TrackManager.getInstance().trackGainSpecialist(_local_15, 0, _local_17, false, SPECIALIST_GAIN_SOURCE.OTHERS);
                    }
                    else
                    {
                        if ((_local_6 is dResourceVO))
                        {
                            _local_18 = (_local_6 as dResourceVO);
                            if (_local_18.name_string == "XP")
                            {
                                _arg_1.AddXP(_local_18.amount);
                            }
                            else
                            {
                                if (_local_18.name_string == defines.PVP_XP_string)
                                {
                                    _arg_1.AddPvPXp(_local_18.amount);
                                }
                                else
                                {
                                    gMisc.Assert(false, (("Could not interpret resource " + _local_18) + " for loot item!"));
                                };
                            };
                        }
                        else
                        {
                            gMisc.Assert(false, (("Could not interpret item " + _local_6) + " for a loot item!"));
                        };
                    };
                };
                _local_5++;
            };
        }

        override public function ClearLevelOnTheFly():void
        {
            mCurrentPlayerZone.ClearOnTheFly();
            mComputeResourceCreation.ResetResourceCreation();
            global.getApplication().particlePlane.stop();
            skillLists_vector.length = 0;
            skillLists_vector = new Vector.<cSkillList>();
        }

        public function handleItemRegistryRegister(_arg_1:cPlayerData, _arg_2:dGameTickCommandVO):void
        {
            var _local_3:dServerAction = (_arg_2.data as dServerAction);
            var _local_4:dPersistedItemRegistryVO = (_local_3.data as dPersistedItemRegistryVO);
            if (_local_4 != null)
            {
                mItemRegistry.RegisterItem(_local_4.itemType, _local_4.itemName_string, _local_4.resource_name_string, _local_4.amount);
            };
        }

        private function handleDeliverProduction(_arg_1:cPlayerData, _arg_2:dGameTickCommandVO):void
        {
            var _local_3:int = (_arg_2.data as int);
            var _local_4:cTimedProductionQueue = mCurrentPlayerZone.GetProductionQueue(_local_3);
            if (_local_4 != null)
            {
                _local_4.deliver(_arg_1, false);
            }
            else
            {
                cLog.error(((("P:" + _arg_1.GetPlayerId()) + " - Deliver production: Could not interpret production type ") + _local_3));
                return;
            };
        }

        private function handleCompleteTradeMarket(_arg_1:cPlayerData, _arg_2:dGameTickCommandVO):Boolean
        {
            var _local_4:dTradeCompleteVO;
            if (cLog.isInfoEnabled())
            {
                cLog.info(((("Complete trade via market place " + _arg_2.data) + " at ") + _arg_2.time));
            };
            if (!(_arg_2.data is dTradeCompleteUpdateVO))
            {
                return (false);
            };
            var _local_3:dTradeCompleteUpdateVO = (_arg_2.data as dTradeCompleteUpdateVO);
            for each (_local_4 in _local_3.tradeOffers)
            {
                this.handleCompleteTradeCommon(_arg_1, _local_4, false, false);
                globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.TRADE_LOT_SOLD);
            };
            return (true);
        }

        private function isBuffUpdated(_arg_1:int, _arg_2:cBuff, _arg_3:int):Boolean
        {
            var _local_4:Boolean;
            _arg_3 = Math.abs(_arg_3);
            if (_arg_2.GetAmount() > _arg_3)
            {
                _local_4 = true;
                if (_local_4)
                {
                    TrackManager.getInstance().trackApplyBuff(_arg_1, mCurrentViewedZoneID, _arg_2.GetBuffDefinition().GetName_string(), _arg_2.GetResourceName_string(), _arg_3, _arg_2.GetAmount(), (_arg_2.GetAmount() - _arg_3));
                };
            }
            else
            {
                _local_4 = true;
                _arg_2.setDeleted();
                if (_local_4)
                {
                    TrackManager.getInstance().trackApplyBuff(_arg_1, mCurrentViewedZoneID, _arg_2.GetBuffDefinition().GetName_string(), _arg_2.GetResourceName_string(), _arg_2.GetAmount(), _arg_2.GetAmount(), 0);
                };
            };
            return (_local_4);
        }

        public function executeCombatUnitSwitch(_arg_1:uint, _arg_2:CombatCommandVO):Boolean
        {
            var _local_3:cSpecialist;
            var _local_4:cSpecialistTask_AttackBuildingNewCombat;
            if (cLog.isInfoEnabled())
            {
                cLog.info(("cGameInterface.HandleCombatCommand: command " + _arg_2.commandId));
            };
            if (_arg_2.IsValid())
            {
                _local_3 = mCurrentPlayerZone.getSpecialist(_arg_1, _arg_2.generalUniqueId);
                if (((!(_local_3 == null)) && (_local_3.GetTask() is cSpecialistTask_AttackBuildingNewCombat)))
                {
                    _local_4 = (_local_3.GetTask() as cSpecialistTask_AttackBuildingNewCombat);
                    if (((((!(_arg_2 == null)) && (_arg_2.IsValid())) && ((!(_local_4 == null)) && (!(_local_4.GetCombat() == null)))) && (!(_local_4.GetCombat().IsDone()))))
                    {
                        _local_4.SetStartingUnitType(null);
                        return (_local_4.GetCombat().HandleSwitchPlayerUnit(_arg_2.value));
                    };
                    return (false);
                };
                cLog.error((("cGameInterface.HandleCombatCommand: could not find specialist " + _arg_2.generalUniqueId) + "!"));
            }
            else
            {
                cLog.error((("cGameInterface.HandleCombatCommand: command not valid " + _arg_2.toString()) + "!"));
            };
            return (false);
        }

        private function donateResourceToEvent(_arg_1:cPlayerData, _arg_2:dBuffVO, _arg_3:int, _arg_4:int, _arg_5:dGameTickCommandVO):int
        {
            var _local_6:int;
            var _local_7:Boolean = true;
            var _local_8:cResources = mCurrentPlayerZone.GetResourcesForPlayerID(mHomePlayer.GetPlayerId());
            var _local_9:dResource = _local_8.GetPlayerResource(_arg_2.resourceName_string);
            _local_6 = Math.min(_local_9.getAmount(), _arg_2.getAmount());
            _local_8.AddResource(_arg_2.resourceName_string, -(_local_6), ModifyReason.DONATION, null);
            globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.RESOURCE_DONATION_SUCCESSFUL, [_arg_2.resourceName_string, _local_6]);
            globalFlash.gui.mWarehouseInfoPanel.donateResourcePanelController.serverResponseReceived();
            channels.RESOURCE.eventDonated(_arg_2.resourceName_string, _local_6);
            return (_local_6);
        }

        private function HandleMoveCollectible(_arg_1:cPlayerData, _arg_2:dGameTickCommandVO):void
        {
            var _local_10:String;
            var _local_3:dServerAction = (_arg_2.data as dServerAction);
            var _local_4:dMoveBuildingVO = (_local_3.data as dMoveBuildingVO);
            var _local_5:int = _local_4.gridPosition;
            var _local_6:int = _local_3.grid;
            if (mCurrentPlayerZone.mStreetDataMap.mBuildingContainer.get(_local_6) != null)
            {
                cLog.error((((("Could not move building from " + _local_5) + " to ") + _local_6) + " because grid position is not empty!"));
                return;
            };
            var _local_7:cBuilding = mCurrentPlayerZone.mStreetDataMap.mBuildingContainer.get(_local_5);
            if (_local_7 == null)
            {
                cLog.error((((("Could not move building from " + _local_5) + " to ") + _local_6) + " because building is null!"));
                return;
            };
            if (!(_local_7 is cCollectibleBuilding))
            {
                cLog.error((((("Could not move building from " + _local_5) + " to ") + _local_6) + " because at least one position is illegal!"));
                return;
            };
            if (_local_7.IsDestructionInitiated())
            {
                cLog.error((((("Could not move building from " + _local_5) + " to ") + _local_6) + " because the building is already in destruction mode"));
                return;
            };
            mCurrentPlayerZone.mStreetDataMap.RemoveBuildingGridPos(_local_7.GetGrid(), false);
            if (CollectionsManager.getInstance().getBuildingIsNormalCollectible(_local_7.GetBuildingName_string()))
            {
                mCurrentPlayerZone.mStreetDataMap.removePickupFromList(CollectionsConsts.COLLECTIBLE_BUILDING_NORMAL, _local_4.gridPosition);
            }
            else
            {
                mCurrentPlayerZone.mStreetDataMap.removePickupFromList(CollectionsConsts.COLLECTIBLE_BUILDING_EVENT, _local_4.gridPosition);
            };
            _local_7.setMovedBuildingGrid(_local_6);
            _local_7.mIsSelectable = true;
            _local_7.SetIsMoveInitiated(false);
            var _local_8:cPosInt = new cPosInt();
            gCalculations.ConvertStreetGridToPixelPos(this.mCurrentPlayerZone, _local_6, _local_8);
            _local_7.SetPosition(_local_8.x, (_local_8.y + global.streetGridYHalf));
            var _local_9:cLandscape = mCurrentPlayerZone.mStreetDataMap.mLandscapeContainer.get(_local_6);
            if (_local_9 != null)
            {
                _local_10 = _local_9.GetContainerName_string();
                if (mCurrentPlayerZone.IsDepositFoundType(_local_10))
                {
                    mCurrentPlayerZone.RemoveDepositIcon(_local_6);
                };
            };
            mCurrentPlayerZone.mStreetDataMap.mBuildingContainer.put(_local_6, _local_7);
            mCurrentPlayerZone.mStreetDataMap.AddBuildingToList(_local_7);
            mCurrentPlayerZone.mStreetDataMap.RecalculateBlockingGridAndPathFinding(_local_7.getPlayerID());
            mCurrentPlayerZone.mStreetDataMap.UpdateObjectPositions();
            _local_7.mDirtyIndicator.strongModified();
        }

        private function handleCompleteAchievementCheat(_arg_1:cPlayerData, _arg_2:dGameTickCommandVO):void
        {
        }

        private function PlaceDepositOnMap(_arg_1:cDeposit, _arg_2:cSpecialist):void
        {
            mCurrentPlayerZone.AddLandscape(mCurrentPlayer, (defines.DEPOSITFOUND_NAME_string + _arg_1.GetContainerName_string()), _arg_1.GetGrid());
            mCurrentPlayerZone.mStreetDataMap.RemoveDepletedDepositBuildingIfOneIsThere(_arg_1.GetGrid());
            mCurrentPlayerZone.mStreetDataMap.SetDepositGridPos(mCurrentPlayer, _arg_1, _arg_1.GetGrid());
            mCurrentPlayerZone.AddDepositIcon(_arg_1.GetContainerName_string(), _arg_1.GetGrid());
            _arg_1.SetAccessibleType(DEPOSIT_ACCESSIBLE_TYPES.ACCESSIBLE);
            globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.GEOLOGIST_FINISHED_POSITIVE, [_arg_1, _arg_2]);
        }

        private function ComputeLogic():void
        {
            mCurrentPlayerZone.LogicCompute();
            channels.TICK.tick(GetClientTime());
            mCurrentPlayerZone.RenderCompute();
            mZoneBuffManager.Compute();
            var _local_1:cResources = mCurrentPlayerZone.GetResources(mCurrentPlayer);
            globalFlash.gui.mInfoBar.SetPopulation(_local_1);
            globalFlash.gui.mInfoBar.SetResource(_local_1);
            if (globalFlash.gui.mWarehouseInfoPanel.IsVisible())
            {
                globalFlash.gui.mWarehouseInfoPanel.UpdateResources();
            };
            if (globalFlash.gui.mMayorhouseInfoPanel.IsVisible())
            {
                globalFlash.gui.mMayorhouseInfoPanel.UpdateResources();
            };
            if (globalFlash.gui.mExpeditionInfoBar.IsVisible())
            {
                globalFlash.gui.mExpeditionInfoBar.UpdateAll();
            };
            if ((((isOnHomzone()) && (mCurrentPlayer.GetClaimedPvPLevel() < mCurrentPlayer.GetPlayerPvPLevel())) && (!(globalFlash.gui.mPvPLevelUpHintPointer.IsVisible()))))
            {
                gHintManager.ShowPvPLevelUpNotification();
            }
            else
            {
                if ((((isOnHomzone()) && (mCurrentPlayer.GetClaimedPvPLevel() >= mCurrentPlayer.GetPlayerPvPLevel())) && (globalFlash.gui.mPvPLevelUpHintPointer.IsVisible())))
                {
                    gHintManager.HidePvPLevelUpNotification();
                };
            };
        }

        private function removeBuildingFromGrid(_arg_1:int):Boolean
        {
            var _local_2:cBuilding = mCurrentPlayerZone.GetBuildingFromGridPosition(_arg_1);
            if (_local_2 == null)
            {
                return (false);
            };
            _local_2.handleBuildingDeconstructed();
            mCurrentPlayerZone.mStreetDataMap.DeconstructBuildingGridPos(_arg_1);
            return (true);
        }

        private function HandleColonyCommand(_arg_1:cPlayerData, _arg_2:dGameTickCommandVO):Boolean
        {
            var _local_3:ColonyCommandVO = (_arg_2.data as ColonyCommandVO);
            if (cLog.isInfoEnabled())
            {
                cLog.info(("cGameInterface.HandleColonyCommand: command " + _local_3.toString()));
            };
            var _local_4:Boolean;
            if (_local_3.IsValid())
            {
                _local_4 = cColony.HandleColonyCommand(this, _local_3);
            }
            else
            {
                cLog.error(("cGameInterface.HandleColonyCommand: command not valid! " + _local_3.toString()));
            };
            if (((_local_4) && (_local_3.commandId == COMMAND.COLONY_ASSIGN)))
            {
                channels.ZONE.notifyPropertyObserver(TriggerUtils.COLONY_SLOTS_TOTAL, 0);
            };
            return (_local_4);
        }

        public function ResetScrolling():void
        {
            scroll = defines.SCROLL_NOT;
        }

        private function handleEventDonateResource(_arg_1:cPlayerData, _arg_2:dGameTickCommandVO):void
        {
            var _local_5:int;
            var _local_3:int = mHomePlayer.GetPlayerLevel();
            var _local_4:dBuffVO = (_arg_2.data as dBankDonationVO).buff;
            if (global.eventDonations.enabledEventDonations[_local_4.resourceName_string] === true)
            {
                if (_local_4.amount > 0)
                {
                    _local_5 = this.donateResourceToEvent(_arg_1, _local_4, _local_3, (_arg_2.data as dBankDonationVO).newGuildUniqueID, _arg_2);
                    TrackManager.getInstance().trackDonateEventResource(_local_4.resourceName_string, _local_5, mHomePlayer);
                };
            };
        }

        private function HandleDeleteGuildMarketPlayerVoteWithGems(_arg_1:dGameTickCommandVO):void
        {
            var _local_5:dPlayerVotePoolVO;
            var _local_2:dPlayerVoteVO = (_arg_1.data as dPlayerVoteVO);
            var _local_3:cResources = mCurrentPlayerZone.GetResources(this.mGameTickCommandPlayer);
            var _local_4:cVoteDefinition = (global.vote_definitions.getItem(global.vote_shop_group.name_string) as cVoteDefinition);
            if (!_local_3.HasPlayerResource(defines.HARD_CURRENCY_RESOURCE_NAME_string, _local_4.costGems))
            {
                cLog.error((("E:" + this.mGameTickCommandPlayer.GetPlayerId()) + " Cannot delete the Guild Market Vote with gems. Insufficient funds!"));
                return;
            };
            _local_3.AddResource(defines.HARD_CURRENCY_RESOURCE_NAME_string, -(_local_4.costGems), ModifyReason.RESET_WITH_GEMS, _local_4.name);
            for each (_local_5 in mVotesManager.GetPlayerVote().pools)
            {
                _local_5.votes.removeAll();
            };
            globalFlash.gui.mGuildWindow.RefreshGuildMarket();
        }

        private function handleGuildBankBuyTab(_arg_1:cPlayerData, _arg_2:dGameTickCommandVO):void
        {
            var _local_3:dGuildBankBuyTabVO = (_arg_2.data as dGuildBankBuyTabVO);
            var _local_4:dGuildBankTransactionVO = new dGuildBankTransactionVO();
            _local_4.transactionType = GUILD_BANK_TRANSACTION_TYPE.BUY_TAB;
            _local_4.time = new Date().getTime();
            _local_4.player = _arg_1.GetPlayerName_string();
            if (_local_3.costCoins > 0)
            {
                _local_4.description = defines.GUILDCOIN_RESOURCE_NAME_string;
                _local_4.amount = _local_3.costCoins;
            };
            if (_local_3.costGems > 0)
            {
                _local_4.description = defines.HARD_CURRENCY_RESOURCE_NAME_string;
                _local_4.amount = _local_3.costGems;
            };
            var _local_5:cResources = mCurrentPlayerZone.GetResources(_arg_1);
            if (_local_3.costCoins > 0)
            {
                global.ui.mCurrentPlayerGuildBank.RemoveResourceFromPaytab(defines.GUILDCOIN_RESOURCE_NAME_string, -(_local_3.costCoins));
                GetCurrentPlayerGuildBank().currUpdateCoin++;
            };
            if (_local_3.costGems > 0)
            {
                _local_5.AddResource(defines.HARD_CURRENCY_RESOURCE_NAME_string, -(_local_3.costGems), ModifyReason.GUILD_BANK_BUY_TAB, null);
                GetCurrentPlayerGuildBank().currUpdateGem++;
            };
            GetCurrentPlayerGuildBank().AddTransactionHistory(_local_4);
            GetCurrentPlayerGuildBank().AddGuildBankTab(_local_3.newTabID);
            globalFlash.gui.mGuildBankWindow.SetBusy(false);
            globalFlash.gui.mGuildBankWindow.ReconfigureTabs();
        }

        public function visitZone(_arg_1:int):void
        {
            cBasicPanel.HideCurrentActivePanel();
            globalFlash.gui.mLoadingZonePanel.Show();
            globalFlash.gui.mStarMenu.ResetScrollPosition();
            mCurrentPlayerZone.SaveZoneStartZoom();
            if (mCurrentPlayer.mIsPlayerZone)
            {
                this.mIsBuffOnFriendQuestActive = ((mQuestClientCallbacks.IsQuestActive(QuestManagerStatic.TYPE_BUFF_ON_FRIEND)) || (getCurrentUserAchievementManager().isTriggerActive(TriggerUtils.BUFF_APPLIED_ON_FRIEND_PROPERTY_NAME)));
                this.mIsVisitFriendsQuestActive = mQuestClientCallbacks.IsQuestActive(QuestManagerStatic.TYPE_FRIEND_VISIT);
            };
            if ((((this.mIsVisitFriendsQuestActive) && (_arg_1 > 0)) && (!(mCurrentPlayer.GetPlayerId() == _arg_1))))
            {
                mClientMessages.SendMessagetoServer(COMMAND.VISIT_FRIEND_ZONE, mCurrentViewedZoneID, new dIntegerVO(_arg_1));
            };
            mClientMessages.SendGetZoneMessageToServer(COMMAND.GET_ZONE, _arg_1, this.mIsBuffOnFriendQuestActive);
        }

        public function handleApplyBuff(_arg_1:cPlayerData, _arg_2:dGameTickCommandVO):int
        {
            var _local_3:dServerAction = (_arg_2.data as dServerAction);
            return (this.applyBuffWithRetry(_arg_1, (_local_3.data as dUniqueID), _local_3.endGrid, _local_3.type, _local_3.grid, null));
        }

        private function CalculateLogicOncePerSecond():void
        {
            var _local_4:cSpecialist;
            var _local_1:Vector.<cSpecialist> = mCurrentPlayerZone.GetSpecialists_vector();
            var _local_2:int = _local_1.length;
            _local_1.sort(WaitTaskCompare);
            var _local_3:int;
            while (_local_3 < _local_2)
            {
                _local_4 = _local_1[_local_3];
                _local_4.PerformTask(_local_3);
                if (_local_1.indexOf(_local_4) == -1)
                {
                    _local_3--;
                    _local_2--;
                };
                _local_3++;
            };
            mComputeResourceCreation.Compute();
        }

        private function applyBuffWithRetry(_arg_1:cPlayerData, _arg_2:dUniqueID, _arg_3:int, _arg_4:int, _arg_5:int, _arg_6:Object):int
        {
            var _local_7:int = this.applyBuff(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6);
            return (_local_7);
        }

        private function HandleInviteToAdventure(_arg_1:cPlayerData, _arg_2:dGameTickCommandVO):Boolean
        {
            var _local_3:cAdventure = mCurrentPlayerZone.GetAdventure();
            if (_local_3 == null)
            {
                return (false);
            };
            if (_local_3.GetCurrentPlayersCount() >= _local_3.GetMaxPlayersCount())
            {
                globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.ADVENTURE_IS_FULL);
                return (false);
            };
            var _local_4:int = (_arg_2.data as dIntegerVO).value;
            if (_local_3.HasPlayerInAdventure(_local_4))
            {
                globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.ADVENTURE_HAS_PLAYER_ALREADY);
                return (false);
            };
            _local_3.InviteAdventurePlayer(new dAdventurePlayerVO().Init(_local_3.GetAdventureID(), _local_4));
            globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.ADVENTURE_INVITATION_SENT);
            TrackManager.getInstance().trackAdventureInvitationSent(_local_3.GetOwnerPlayerID(), _local_4, _local_3.GetZoneId(), _local_3.GetName_string());
            return (true);
        }

        private function moveBuilding(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:int, _arg_5:cPlayerData):void
        {
            var _local_16:cResourceCreation;
            var _local_17:String;
            var _local_18:dResource;
            var _local_19:dResource;
            var _local_20:cBuffDefinition;
            var _local_21:String;
            var _local_22:int;
            var _local_23:dResource;
            var _local_24:cBuilding;
            var _local_6:String = global.buildingGroup.GetNameFromNr_string(global.buildingGroup.mGOList_vector, _arg_1);
            cLog.info(((((("Moving building: " + _local_6) + " from ") + _arg_2) + " to ") + _arg_3));
            if (((!(gCalculations.IsGridInsideMap(this.mCurrentPlayerZone, _arg_2))) || (!(gCalculations.IsGridInsideMap(this.mCurrentPlayerZone, _arg_3)))))
            {
                cLog.error((((("Could not move building from " + _arg_2) + " to ") + _arg_3) + " because at least one position is illegal!"));
                return;
            };
            var _local_7:cBuilding = mCurrentPlayerZone.GetBuildingFromGridPosition(_arg_3);
            if (_local_7 != null)
            {
                if (_local_7.GetBuildingMode() == cBuilding.BUILDING_MODE_PLACED)
                {
                    cLog.info(("Removed pre-placed object from " + _arg_3));
                    mCurrentPlayerZone.mStreetDataMap.RemovePrePlaceBuildingGridPos(this.mGameTickCommandPlayer, _arg_3);
                }
                else
                {
                    cLog.error((("Could not move building to " + _arg_3) + " because there is already a building at this position!"));
                    return;
                };
            };
            var _local_8:cBuilding = mCurrentPlayerZone.mStreetDataMap.mBuildingContainer.get(_arg_2);
            if (_local_8 == null)
            {
                _local_17 = (("Player tries to move building from " + _arg_2) + " which is not there (any more)!");
                cLog.error(_local_17);
                return;
            };
            if (!_local_8.IsMovable())
            {
                cLog.error((("Not possible to move the building at " + _arg_2) + ", which is a non movable building!"));
                return;
            };
            var _local_9:ModifiableCost = new ModifiableCost();
            if (_arg_4 == cBuilding.BUILDING_MOVE_WITH_GEM)
            {
                if (((this.mSpecificShopItems) && (_local_8.GetGemMovementCosts() > 0)))
                {
                    return;
                };
                _local_18 = new dResource();
                _local_18.name_string = defines.HARD_CURRENCY_RESOURCE_NAME_string;
                _local_18.amount = _local_8.GetGemMovementCosts();
                _local_9.cost.push(_local_18);
            }
            else
            {
                _local_9 = _local_8.GetMovementCosts();
            };
            if (!(_local_8 is EpicWorkyardSubBuilding))
            {
                if ((((_local_9 == null) && (!(_local_8.IsRecurringBuilding()))) && (_local_8.GetUpgradeLevel() > 1)))
                {
                    cLog.error((((("trying to move the building at " + _arg_2) + ", level ") + _local_8.GetUpgradeLevel()) + ", is not bought from the shop but still trying to move for free"));
                    return;
                };
            };
            var _local_10:cResources = mCurrentPlayerZone.GetResources(this.mGameTickCommandPlayer);
            if (_local_9 != null)
            {
                for each (_local_19 in _local_9.cost)
                {
                    if (!_local_10.HasPlayerResource(_local_19.name_string, _local_19.amount))
                    {
                        ResourceAlert.show("MoveBuildingErrorMissingResources", null, "MoveBuildingError", null, _local_9.cost);
                        cLog.error((("Player has not enough resources to move building at " + _arg_2) + "!"));
                        this.ResetMovedBuilding(_local_8);
                        return;
                    };
                };
            };
            var _local_11:Number = 0;
            if (_local_8.IsUpgradeInProgress())
            {
                _local_20 = _local_8.GetUpgradeLevelBonusesForLevel((_local_8.GetUpgradeLevel() + 1));
                if (_local_20 != null)
                {
                    _local_11 = (_local_20.GetProductionTime() - (GetClientTime() - _local_8.GetUpgradeStartTime()));
                    if (_local_11 < defines.MIN_UPGRADE_TIME_TO_MOVE_UPGRADING_BUILDING_FOR_GAMETICK)
                    {
                        CustomAlert.show("MoveBuildingErrorUpgradeTooClose", "MoveBuildingError");
                        cLog.error((((("Building upgrade is completed too soon (" + (_local_11 / 1000)) + " sec) to move building at ") + _arg_2) + "!"));
                        this.ResetMovedBuilding(_local_8);
                        return;
                    };
                };
            };
            if (_local_8.IsEngagedInCombat())
            {
                cLog.error((("Player tries to move a building at " + _arg_2) + " which is engaged in combat!"));
                this.ResetMovedBuilding(_local_8);
                return;
            };
            if (_local_8.mPlayerData.GetPlayerId() != this.mGameTickCommandPlayer.GetPlayerId())
            {
                cLog.error((("Player tries to move a building at " + _arg_2) + " whose owner he isn't!"));
                this.ResetMovedBuilding(_local_8);
                return;
            };
            if (((_local_8.mOrigin == cBuilding.BUILDING_ORIGIN_FROM_GAME) && (!(this.mRequirements.buildingRequirements_vector[_local_8.GetBuildingName_string()].isFulfilled()))))
            {
                cLog.error((("Player tries to move a building at " + _arg_2) + " with too high playerLevel!"));
                this.ResetMovedBuilding(_local_8);
                return;
            };
            var _local_12:int = mCurrentPlayerZone.IsBuildingPlacableGridPosition(_local_8, this.mGameTickCommandPlayer, _arg_3);
            if (_local_12 != 0)
            {
                cLog.error((((("Building could not be moved from " + _arg_2) + " to ") + _arg_3) + " because IsBuildingPlacableGridPosition() reports an invalid position!"));
                this.ResetMovedBuilding(_local_8);
                return;
            };
            mCurrentPlayerZone.mStreetDataMap.RemoveBuildingGridPos(_local_8.GetGrid(), false);
            _local_8.setMovedBuildingGrid(_arg_3);
            var _local_13:int = _local_8.GetBuildingModeBeforeMoving();
            _local_8.SetBuildingMode(_local_13);
            _local_8.mIsSelectable = true;
            _local_8.SetIsMoveInitiated(false);
            var _local_14:cPosInt = new cPosInt();
            gCalculations.ConvertStreetGridToPixelPos(this.mCurrentPlayerZone, _arg_3, _local_14);
            _local_8.SetPosition(_local_14.x, (_local_14.y + global.streetGridYHalf));
            var _local_15:cLandscape = mCurrentPlayerZone.mStreetDataMap.mLandscapeContainer.get(_arg_3);
            if (_local_15 != null)
            {
                _local_21 = _local_15.GetContainerName_string();
                if (mCurrentPlayerZone.IsDepositFoundType(_local_21))
                {
                    mCurrentPlayerZone.RemoveDepositIcon(_arg_3);
                };
            };
            mCurrentPlayerZone.mStreetDataMap.mBuildingContainer.put(_arg_3, _local_8);
            mCurrentPlayerZone.mStreetDataMap.AddBuildingToList(_local_8);
            mCurrentPlayerZone.mStreetDataMap.RecalculateBlockingGridAndPathFinding(_local_8.getPlayerID());
            mCurrentPlayerZone.mStreetDataMap.UpdateObjectPositions();
            _local_16 = _local_8.GetResourceCreation();
            if (_local_16 != null)
            {
                mComputeResourceCreation.CalculateProductionPaths(_local_8, true);
                _local_16.SetInvalidatePaths(false);
                if (_local_16.GetResourceCreationDefinition() != null)
                {
                    if (_local_16.GetDepositBuildingGridPos() > -1)
                    {
                        _local_16.SetDepositPath(mPathFinder.CalculatePath(_local_8.GetStreetGridEntry(), _local_16.GetDepositBuildingGridPos(), null, false));
                    };
                    switch (_local_13)
                    {
                        case cBuilding.BUILDING_MODE_SETTLER_WALKS_FROM_STOREHOUSE_TO_RESOURCECREATIONHOUSE:
                            _local_16.pathPos = 0;
                            break;
                        case cBuilding.BUILDING_MODE_SETTLER_WALKS_FROM_RESOURCECREATIONHOUSE_TO_EXTERNAL_RESOURCE:
                            _local_16.pathPos = 0;
                            break;
                        case cBuilding.BUILDING_MODE_WORKANIM_IS_WORKING_AT_WORKYARD_LOCAL_WORKYARD_SYSTEM:
                            _local_22 = int((((_local_16.GetWorkTime() * 1000) + ((_local_16.GetPath().pathLenX10000 / cComputeResourceCreation.SETTLER_WALK_SPEED_INT) / mGlobalTimeScale)) as int));
                            _local_8.mStartWorkCounter = ((_local_8.mStartWorkCounter > _local_22) ? _local_22 : _local_8.mStartWorkCounter);
                            break;
                        case cBuilding.BUILDING_MODE_SETTLER_WALKS_FROM_EXTERNAL_RESOURCE_TO_RESOURCECREATIONHOUSE:
                            _local_16.pathPos = _local_16.GetDepositPath().pathLenX10000;
                            break;
                        case cBuilding.BUILDING_MODE_SETTLER_WALKS_FROM_RESOURCECREATIONHOUSE_TO_STOREHOUSE:
                            _local_16.pathPos = _local_16.GetPath().pathLenX10000;
                            break;
                    };
                };
                _local_16.mDirtyIndicator = DIRTY_INDICATOR.MODIFIED_BIT;
            };
            _local_8.mDirtyIndicator.strongModified();
            TrackManager.getInstance().trackBuildingMove(_arg_5, _local_8, (_arg_4 == cBuilding.BUILDING_MOVE_WITH_GEM));
            if (_local_9 != null)
            {
                for each (_local_23 in _local_9.cost)
                {
                    _local_10.AddResource(_local_23.name_string, -(_local_23.amount), ModifyReason.MOVE_BUILDING, null);
                };
                TrackManager.getInstance().trackBuyItem(_arg_5, "Move Building", _local_9.cost, _local_10.GetResourceAmount(defines.HARD_CURRENCY_RESOURCE_NAME_string), null);
            };
            if (_local_8.productionQueue != null)
            {
                mCurrentPlayerZone.setProductionQueue(_local_8.productionQueue);
                _local_8.productionQueue.productionBuilding = _local_8;
            };
            if (_local_8 != null)
            {
            };
            if (cLog.isInfoEnabled())
            {
                _local_24 = mCurrentPlayerZone.mStreetDataMap.mBuildingContainer.get(_arg_3);
                cLog.info(("newBuilding:" + _local_24));
                cLog.info(("newBuilding.GetBuildingMode():" + _local_24.GetBuildingMode()));
                cLog.info(("newBuilding.GetGrid():" + _local_24.GetGrid()));
                cLog.info(("newBuilding.GetUpgradeLevel():" + _local_24.GetUpgradeLevel()));
                cLog.info(("newBuilding.mBuffs_vector:" + _local_8.mBuffs_vector));
                if (_local_16 != null)
                {
                    cLog.info(("newResourceCreation.GetSettlerKIState():" + _local_16.GetSettlerKIState()));
                    cLog.info(("newResourceCreation.GetGatheredResource():" + _local_16.GetGatheredResource()));
                    cLog.info(("newResourceCreation.GetResourceCreationHouse():" + _local_16.GetResourceCreationHouse().GetGrid()));
                    cLog.info(("newResourceCreation.GetResourceCreationHouse().GetStreetGridEntry():" + _local_16.GetResourceCreationHouse().GetStreetGridEntry()));
                    if (_local_16.GetStoreHouse() != null)
                    {
                        cLog.info(("newResourceCreation.GetStoreHouse():" + _local_16.GetStoreHouse().GetGrid()));
                        cLog.info(("newResourceCreation.GetStoreHouse().GetStreetGridEntry():" + _local_16.GetStoreHouse().GetStreetGridEntry()));
                    };
                    cLog.info(("newResourceCreation.GetPath():" + _local_16.GetPath()));
                    cLog.info(("newResourceCreation.GetDepositBuildingGridPos():" + _local_16.GetDepositBuildingGridPos()));
                    cLog.info(("newResourceCreation.GetDepositPath():" + _local_16.GetDepositPath()));
                };
                cLog.info((((((("Building '" + _local_6) + "' moved from ") + _arg_2) + " to ") + _arg_3) + "!"));
            };
        }

        public function HandleSetTask(_arg_1:cPlayerData, _arg_2:dGameTickCommandVO):Boolean
        {
            var _local_3:dServerAction;
            var _local_7:cSpecialist;
            var _local_10:cSpecialistTask;
            var _local_11:int;
            var _local_12:cSpecialistTask_FindExpedition;
            var _local_13:Vector.<dResource>;
            var _local_14:cResources;
            var _local_15:cSpecialistTask_FindEventZone;
            var _local_16:Vector.<dResource>;
            var _local_17:cResources;
            var _local_18:int;
            var _local_19:int;
            var _local_20:cBuilding;
            var _local_21:int;
            var _local_22:int;
            var _local_23:int;
            var _local_24:String;
            var _local_25:cBuilding;
            var _local_26:Boolean;
            var _local_27:cSpecialistTask_TravelToZone;
            var _local_28:String;
            var _local_29:cSpecialistTask_AttackBuildingNewCombat;
            var _local_30:cSpecialistTask_AttackBuilding;
            _local_3 = (_arg_2.data as dServerAction);
            if (!(_local_3.data is dStartSpecialistTaskVO))
            {
                return (false);
            };
            var _local_4:dStartSpecialistTaskVO = (_local_3.data as dStartSpecialistTaskVO);
            if (((_local_3.type < 0) || (_local_3.type >= global.specialistTaskDefinitions_vector.length)))
            {
                return (false);
            };
            var _local_5:cSpecialistTaskDefinition = global.specialistTaskDefinitions_vector[_local_3.type];
            if (((_local_4.subTaskID < 0) || (_local_4.subTaskID >= _local_5.subtasks_vector.length)))
            {
                return (false);
            };
            var _local_6:cSpecialistSubTaskDefinition = _local_5.subtasks_vector[_local_4.subTaskID];
            _local_7 = mCurrentPlayerZone.getSpecialist(_arg_1.GetPlayerId(), _local_4.uniqueID);
            if (_local_7 == null)
            {
                cLog.error((("Could not find specialist " + _local_4.uniqueID) + "!"));
                return (false);
            };
            var _local_8:dRequirementsVO = this.mRequirements.specialistTaskRequirements_vector[(_local_5.taskName_string + _local_6.taskType_string)];
            if (((!(_local_8 == null)) && (!(_local_8.isFulfilledForSkillList(_local_7.getSkillTree())))))
            {
                return (false);
            };
            var _local_9:String = SPECIALIST_TYPE.toString(_local_7.GetBaseType());
            if (_local_5.specialistType_string.indexOf(_local_9) == -1)
            {
                return (false);
            };
            if (_local_7.GetTask() != null)
            {
                if (_local_7.GetTask().GetType() == SPECIALIST_TASK_TYPES.WAIT_FOR_CONFIRMATION)
                {
                    _local_7.SetTask(null);
                }
                else
                {
                    cLog.error((("Specialist " + _local_4.uniqueID) + " has a task already!"));
                    return (false);
                };
            };
            switch (_local_3.type)
            {
                case SPECIALIST_TASK_TYPES.DEPOSIT_SEARCH:
                    cLog.info(((("Ordered Specialist " + _local_4.uniqueID) + " to search deposit with type") + _local_6.taskType_string));
                    _local_10 = new cSpecialistTask_FindDeposit(this, _local_7, 0, TASK_PHASES_FIND_DEPOSIT.SEARCH_DEPOSIT, _local_4.subTaskID);
                    break;
                case SPECIALIST_TASK_TYPES.EXPLORE:
                    cLog.info((("Ordered Specialist " + _local_4.uniqueID) + " to explore sector"));
                    _local_10 = new cSpecialistTask_ExploreSector(this, _local_7, 0, TASK_PHASES_EXPLORE_SECTOR.EXPLORE_SECTOR, _local_4.subTaskID);
                    break;
                case SPECIALIST_TASK_TYPES.FIND_TREASURE:
                    cLog.info(((("Ordered specialist " + _local_4.uniqueID) + " to find treasure with search type ") + _local_6.taskType_string));
                    _local_10 = new cSpecialistTask_FindTreasure(this, _local_7, 0, TASK_PHASES_FIND_TREASURE.FIND_TREASURE, _local_4.subTaskID, mEventManager.GetActiveTwoStepEventName());
                    break;
                case SPECIALIST_TASK_TYPES.FIND_EXPEDITION:
                    cLog.info(((("Ordered specialist " + _local_4.uniqueID) + " to find event zone with search type ") + _local_6.taskType_string));
                    if (killswitch.isLocked(KILL_SWITCH.PVP_COLONY_SEARCH))
                    {
                        cLog.error(("Task locked by killswitch: " + _local_6.taskType_string));
                        return (false);
                    };
                    _local_10 = new cSpecialistTask_FindExpedition(this, _local_7, 0, TASK_PHASES_FIND_EXPEDITION.FIND_EXPEDITION, _local_4.subTaskID);
                    _local_12 = (_local_10 as cSpecialistTask_FindExpedition);
                    _local_13 = _local_12.getCosts_vector();
                    _local_14 = mCurrentPlayerZone.GetResourcesForPlayerID(_local_7.getPlayerID());
                    if (_local_14.HasPlayerResourcesInListOne(_local_13))
                    {
                        _local_14.RemovePlayerResourcesFromResourcesInList(_local_13, 1, ModifyReason.FIND_EXPEDITION);
                    }
                    else
                    {
                        cLog.error(("Player cannot afford task " + _local_3.type));
                        return (false);
                    };
                    break;
                case SPECIALIST_TASK_TYPES.FIND_ADVENTURE_ZONE:
                    cLog.info(((("Ordered specialist " + _local_4.uniqueID) + " to find event zone with search type ") + _local_6.taskType_string));
                    if (killswitch.isLocked(KILL_SWITCH.ADVENTURE_SEARCH))
                    {
                        cLog.error(("Task locked by killswitch: " + _local_6.taskType_string));
                        return (false);
                    };
                    _local_10 = new cSpecialistTask_FindEventZone(this, _local_7, 0, TASK_PHASES_FIND_EVENT_ZONE.FIND_EVENT_ZONE, _local_4.subTaskID);
                    _local_15 = (_local_10 as cSpecialistTask_FindEventZone);
                    _local_16 = _local_15.getCosts_vector();
                    _local_17 = mCurrentPlayerZone.GetResourcesForPlayerID(_local_7.getPlayerID());
                    if (_local_17.HasPlayerResourcesInListOne(_local_16))
                    {
                        _local_17.RemovePlayerResourcesFromResourcesInList(_local_16, 1, ModifyReason.FIND_ADVENTURE_ZONE);
                    }
                    else
                    {
                        cLog.error(("Player cannot afford task " + _local_3.type));
                        return (false);
                    };
                    break;
                case SPECIALIST_TASK_TYPES.TRAVEL_TO_ZONE:
                    if (_local_3.grid == mCurrentViewedZoneID)
                    {
                        cLog.error((("Invalid destination zone for travelling (equal to current zone): " + _local_3.grid) + "!"));
                        return (false);
                    };
                    if (cLog.isInfoEnabled())
                    {
                        cLog.info(((("Ordered specialist " + _local_4.uniqueID) + " to travel to zone ") + _local_3.grid));
                    };
                    _local_10 = new cSpecialistTask_TravelToZone(this, _local_7, _local_3.grid, _local_3.endGrid, 0, TASK_PHASES_TRAVEL_TO_ZONE.STRIKE_GARRISON);
                    if (IsAdventureZoneID(_local_3.grid))
                    {
                        _local_27 = (_local_10 as cSpecialistTask_TravelToZone);
                        _local_27.sendTravelNotification();
                    };
                    break;
                case SPECIALIST_TASK_TYPES.MOVE:
                    cLog.info(((("Ordered Specialist " + _local_4.uniqueID) + " to move to ") + _local_3.grid));
                    _local_18 = _local_3.grid;
                    if (_local_18 < 0)
                    {
                        cLog.error((("SPECIALIST_TASK_TYPES.MOVE: Invalid destination grid: " + _local_18) + "!"));
                        return (false);
                    };
                    _local_11 = mCurrentPlayerZone.mStreetDataMap.mAdditionalData.get(_local_18, AdditionalDataTSO.Sector);
                    _local_19 = mCurrentPlayerZone.mSectorList_vector[_local_11].GetOwnerPlayerID();
                    if (((!(_local_19 == 0)) && (!(_local_19 == _local_7.getPlayerID()))))
                    {
                        _local_28 = "Wants to set garrison in a sector which does not belong to him!";
                        cLog.error(_local_28);
                        return (false);
                    };
                    _local_20 = mCurrentPlayerZone.GetBuildingFromGridPosition(_local_18);
                    if (_local_20 != null)
                    {
                        if (((_local_20.GetBuildingMode() == cBuilding.BUILDING_MODE_PLACED) || (mCurrentPlayerZone.isFreePlacableDepletedDeposit(_local_20.GetBuildingName_string()))))
                        {
                            if (!mCurrentPlayerZone.mStreetDataMap.RemoveDepletedDepositBuildingIfOneIsThere(_local_18))
                            {
                                mCurrentPlayerZone.mStreetDataMap.RemovePrePlaceBuildingGridPos(_arg_1, _local_18);
                            };
                        }
                        else
                        {
                            cLog.error((("Error building already set at position 'Garrison' at " + _local_18) + "!"));
                            return (false);
                        };
                    };
                    _local_21 = mCurrentPlayerZone.mStreetDataMap.GetBlockType(_local_18);
                    if (_local_21 != cBlockingData.BLOCK_TYPE_ALLOW_ALL)
                    {
                        cLog.error((("Error grid position is blocked at " + _local_18) + "!"));
                        return (false);
                    };
                    _local_10 = new cSpecialistTask_Move(this, _local_7, _local_18, 0, TASK_PHASES_MOVE.STRIKE_GARRISON);
                    break;
                case SPECIALIST_TASK_TYPES.TRAVEL_TO_STAR_MENU:
                    _local_10 = new cSpecialistTask_TravelToStarMenu(this, _local_7, 0, TASK_PHASES_TRAVEL_TO_STAR_MENU.DECONSTRUCT_GARRISON);
                    break;
                case SPECIALIST_TASK_TYPES.ATTACK_BUILDING:
                case SPECIALIST_TASK_TYPES.ATTACK_BUILDING_NEW_COMBAT:
                    if (cLog.isInfoEnabled())
                    {
                        cLog.info(("Ordered Specialist General to attack building at " + _local_3.grid));
                    };
                    _local_22 = _local_3.grid;
                    _local_23 = _local_3.endGrid;
                    _local_24 = (_local_3.data as dStartSpecialistTaskVO).paramString;
                    if (!_local_7.GetSpecialistDescription().isCanAttack())
                    {
                        return (false);
                    };
                    if (_local_7.GetGarrisonGridIdx() == -1)
                    {
                        return (false);
                    };
                    if (((_local_7.GetArmy() == null) || (!(_local_7.GetArmy().HasUnits()))))
                    {
                        return (false);
                    };
                    _local_25 = mCurrentPlayerZone.GetBuildingFromGridPosition(_local_22);
                    if (_local_25 == null)
                    {
                        return (false);
                    };
                    if (_local_25.getPlayerID() == _arg_2.playerID)
                    {
                        return (false);
                    };
                    _local_11 = mCurrentPlayerZone.mStreetDataMap.mAdditionalData.get(_local_22, AdditionalDataTSO.Sector);
                    if (!SECTOR_DISCOVERY_TYPE.isExplored(FindPlayerFromId(_local_7.getPlayerID()).GetSectorDiscovery(_local_11)))
                    {
                        return (false);
                    };
                    if (!_local_25.getBuildingIsAttackable())
                    {
                        return (false);
                    };
                    if (((UsesCombatThree()) && ((_local_24 == null) || (!(_local_7.GetArmy().HasUnit(_local_24))))))
                    {
                        return (false);
                    };
                    _local_26 = false;
                    if (UsesCombatThree())
                    {
                        _local_29 = new cSpecialistTask_AttackBuildingNewCombat(this, _local_7, _local_7.GetGarrison().GetStreetGridEntry(), _local_22, _local_23, 0, TASK_PHASES_ATTACK_BUILDING.GO_TO_TARGET, _local_24);
                        _local_26 = (_local_29.GetDestinationPath().dest_vector.length == 0);
                        _local_10 = _local_29;
                    }
                    else
                    {
                        _local_30 = new cSpecialistTask_AttackBuilding(this, _local_7, _local_7.GetGarrison().GetStreetGridEntry(), _local_22, _local_23, 0, TASK_PHASES_ATTACK_BUILDING.GO_TO_TARGET);
                        _local_26 = (_local_30.GetDestinationPath().dest_vector.length == 0);
                        _local_10 = _local_30;
                    };
                    if (_local_26)
                    {
                        globalFlash.gui.mAvatarMessageList.AddMessage(((UsesCombatThree()) ? AVATAR_MESSAGE_TYPE.ADMIRAL_CANNOT_REACH_TARGET : AVATAR_MESSAGE_TYPE.GENERAL_CANNOT_REACH_TARGET), _local_7);
                        return (false);
                    };
                    _local_10.PrepareTask();
                    _local_7.DisableWaitForCommandAnimation();
                    break;
                default:
                    return (false);
            };
            _local_7.SetTask(_local_10);
            globalFlash.gui.mSpecialistPanel.Refresh(_local_7);
            globalFlash.gui.mStarMenu.Refresh();
            return (true);
        }

        private function ResetMovedBuilding(_arg_1:cBuilding):void
        {
            _arg_1.SetBuildingMode(_arg_1.GetBuildingModeBeforeMoving());
            _arg_1.SetIsMoveInitiated(false);
            var _local_2:cResourceCreation = _arg_1.GetResourceCreation();
            if (_local_2 != null)
            {
                _local_2.RestoreKIStateBeforeMoving();
            };
        }

        private function refundCollectibleResources(_arg_1:DestructBuildingResultVO, _arg_2:cPlayerData):void
        {
            var _local_6:dResource;
            var _local_7:AddResourceResponseVO;
            var _local_3:cResources = mCurrentPlayerZone.GetResources(_arg_2);
            var _local_4:int;
            var _local_5:int = _arg_1.collectibleRefundResources.length;
            _local_4 = 0;
            while (_local_4 < _local_5)
            {
                _local_6 = _arg_1.collectibleRefundResources[_local_4];
                _local_7 = this.addPlayerResource(_local_6, _local_3, _arg_2, _arg_1.collectibleRefundResourceUniqueIDs[_local_4], ModifyReason.REFUND_COLLECTIBLE_RESOURCES);
                if (_local_7.getAddedDirectly())
                {
                    globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.COLLECTION_RESOURCE_RECEIVED, _local_6);
                };
                _local_4++;
            };
            if (IsAdventureZoneID(mCurrentViewedZoneID))
            {
                globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.COLLECTED_PICKUP_IN_ADVENTURE);
            };
        }

        private function handleChangeEpicProductionChain(_arg_1:cPlayerData, _arg_2:dGameTickCommandVO):Boolean
        {
            var _local_3:int;
            if (_arg_2.data == null)
            {
                return (false);
            };
            var _local_4:EpicWorkyardChangeProductionVO = (_arg_2.data as EpicWorkyardChangeProductionVO);
            var _local_5:cBuilding = this.mCurrentPlayerZone.mStreetDataMap.mBuildingContainer.get(_local_4.masterBuildingGridPosition);
            if (_local_5 == null)
            {
                return (false);
            };
            var _local_6:cBuilding = this.mCurrentPlayerZone.mStreetDataMap.mBuildingContainer.get(_local_4.subBuildingGridPosition);
            if (_local_6 == null)
            {
                return (false);
            };
            var _local_7:EpicWorkyardMasterBuilding = (_local_5 as EpicWorkyardMasterBuilding);
            if (_local_7 == null)
            {
                return (false);
            };
            var _local_8:EpicWorkyardSubBuilding = (_local_6 as EpicWorkyardSubBuilding);
            if (_local_8 == null)
            {
                return (false);
            };
            if (_local_8.getMasterBuilding() != _local_7)
            {
                return (false);
            };
            if (!EpicWorkyardsManager.getInstance().getChainAvailable(this, _local_7.GetBuildingName_string(), _local_4.productionChainSubBuildingName, _local_4.productionChainSubBuildingRank))
            {
                LocalLogMessageDetail("Chain is not yet available!");
                return (false);
            };
            var _local_9:int = _local_4.subBuildingGridPosition;
            if (_local_9 == defines.ILLEGAL_INT_POS)
            {
                return (false);
            };
            var _local_10:Boolean = this.removeBuildingFromGrid(_local_9);
            if (_local_10)
            {
                _local_3 = _local_7.removeSubBuilding(_local_8);
                _local_6.removeBuilding(true);
                mCurrentPlayer.DecAnyBuildingCount(_local_8);
                return (this.addEpicWorkyardSubBuildingAtIndex(_local_4.subBuildingGridPosition, _local_4.productionChainSubBuildingName, _local_4.productionChainSubBuildingRank, _local_7, _local_3));
            };
            return (false);
        }

        private function handleRemoveProduction(_arg_1:cPlayerData, _arg_2:dGameTickCommandVO):void
        {
            var _local_3:dTimedProductionQueueChangeVO = (_arg_2.data as dTimedProductionQueueChangeVO);
            var _local_4:cTimedProductionQueue = mCurrentPlayerZone.GetProductionQueue(_local_3.productionType);
            if (_local_4 != null)
            {
                _local_4.cancelProduction(_local_3.itemID, _local_3.doAlways, _arg_1);
                _local_4.SetAllProductionWaitingForServer(false);
            }
            else
            {
                cLog.error(((("P:" + _arg_1.GetPlayerId()) + " - Remove production: Could not interpret production type ") + _local_3.productionType));
                return;
            };
        }

        private function handleDestroyEpicProductionChain(_arg_1:cPlayerData, _arg_2:dGameTickCommandVO):Boolean
        {
            if (_arg_2.data == null)
            {
                return (false);
            };
            var _local_3:EpicWorkyardStopProductionChainVO = (_arg_2.data as EpicWorkyardStopProductionChainVO);
            var _local_4:cBuilding = this.mCurrentPlayerZone.mStreetDataMap.mBuildingContainer.get(_local_3.masterBuildingGridPosition);
            if (_local_4 == null)
            {
                return (false);
            };
            var _local_5:cBuilding = this.mCurrentPlayerZone.mStreetDataMap.mBuildingContainer.get(_local_3.subBuildingGridPosition);
            if (_local_5 == null)
            {
                return (false);
            };
            var _local_6:EpicWorkyardMasterBuilding = (_local_4 as EpicWorkyardMasterBuilding);
            if (_local_6 == null)
            {
                return (false);
            };
            var _local_7:EpicWorkyardSubBuilding = (_local_5 as EpicWorkyardSubBuilding);
            if (_local_7 == null)
            {
                return (false);
            };
            if (_local_7.getMasterBuilding() != _local_6)
            {
                return (false);
            };
            var _local_8:int = _local_3.subBuildingGridPosition;
            if (_local_8 == defines.ILLEGAL_INT_POS)
            {
                return (false);
            };
            var _local_9:Boolean = this.removeBuildingFromGrid(_local_8);
            if (_local_9)
            {
                _local_6.removeSubBuilding(_local_7);
                _local_5.removeBuilding(true);
            };
            _local_6.setWaitingForServerResponse(false);
            mCurrentPlayer.DecAnyBuildingCount(_local_7);
            globalFlash.gui.mEpicWorkyardInfoPanel.refreshChains();
            return (_local_9);
        }

        private function handleGuildBankEnlarge(_arg_1:cPlayerData, _arg_2:dGameTickCommandVO):void
        {
            var _local_3:dGuildBankEnlargeVO = (_arg_2.data as dGuildBankEnlargeVO);
            var _local_4:dGuildBankTransactionVO = new dGuildBankTransactionVO();
            _local_4.transactionType = GUILD_BANK_TRANSACTION_TYPE.ENLARGE;
            _local_4.time = new Date().getTime();
            _local_4.player = _arg_1.GetPlayerName_string();
            if (_local_3.costCoins > 0)
            {
                _local_4.description = defines.GUILDCOIN_RESOURCE_NAME_string;
                _local_4.amount = _local_3.costCoins;
            };
            if (_local_3.costGems > 0)
            {
                _local_4.description = defines.HARD_CURRENCY_RESOURCE_NAME_string;
                _local_4.amount = _local_3.costGems;
            };
            _local_4.tabID = _local_3.tabID;
            _local_4.tabName = GetCurrentPlayerGuildBank().GetGuildBankTab(_local_3.tabID).name;
            var _local_5:cResources = mCurrentPlayerZone.GetResources(_arg_1);
            if (_local_3.costCoins > 0)
            {
                global.ui.mCurrentPlayerGuildBank.RemoveResourceFromPaytab(defines.GUILDCOIN_RESOURCE_NAME_string, -(_local_3.costCoins));
                _local_5.AddResource(defines.GUILDCOIN_RESOURCE_NAME_string, -(_local_3.costCoins), ModifyReason.GUILD_BANK_ENLARGE, null);
            };
            if (_local_3.costGems > 0)
            {
                _local_5.AddResource(defines.HARD_CURRENCY_RESOURCE_NAME_string, -(_local_3.costGems), ModifyReason.GUILD_BANK_ENLARGE, null);
            };
            GetCurrentPlayerGuildBank().AddTransactionHistory(_local_4);
            GetCurrentPlayerGuildBank().EnlargeTabs(_local_3.tabID);
            globalFlash.gui.mGuildBankWindow.SetBusy(false);
            globalFlash.gui.mGuildBankWindow.RefreshResourcesList();
        }

        public function handleApplyBuffErrorForceZoneRefresh(_arg_1:cPlayerData, _arg_2:dUniqueID, _arg_3:cBuff):void
        {
            cLog.info((((("E:" + _arg_1.GetPlayerId()) + " Could not update buff ") + _arg_2) + " in database, so it will not be applied to the zone!"));
            if (((!(_arg_3 == null)) && (_arg_3.isDeleted())))
            {
                _arg_1.removeLastFetchedBuff();
            }
            else
            {
                _arg_1.replaceBuff(_arg_2);
            };
        }

        private function GetUpdates(_arg_1:cPlayerData):void
        {
            var _local_2:dUpdateVO = new dUpdateVO();
            _local_2.synchronisationClientTime = GetClientTime();
            if (_arg_1.mIsPlayerZone)
            {
                _local_2.synchronisationErrorBitField = mSynchronisationErrorBitField;
                _local_2.zoneCheckVO = mZoneCheckUpdateVO;
                if (mSynchronisationErrorGameTick != null)
                {
                    _local_2.gametickCommandMode = mSynchronisationErrorGameTick.mode;
                    _local_2.gametickDeltaTime = mSynchronisationErrorClientDeltaTime;
                }
                else
                {
                    _local_2.gametickCommandMode = COMMAND.UNDEFINED;
                    _local_2.gametickDeltaTime = 0;
                };
            }
            else
            {
                _local_2.synchronisationErrorBitField = cGeneralInterface.SYNCHRONISATION_JUST_REFRESH;
                _local_2.zoneCheckVO = null;
                _local_2.gametickCommandMode = COMMAND.UNDEFINED;
                _local_2.synchronisationClientTime = 0;
            };
            mSynchronisationErrorBitField = 0;
            mSynchronisationErrorGameTick = null;
            mSynchronisationErrorClientDeltaTime = 0;
            mZoneCheckUpdateVO = null;
            if (!mGetUpdatesSend)
            {
                mClientMessages.SendMessagetoServer(COMMAND.GET_UPDATES, mCurrentViewedZoneID, _local_2);
                mGetUpdatesSend = true;
            };
        }

        override public function Render():void
        {
            global.mSwitchToAntialiasingCntr = 0;
            var _local_1:Number = gMisc.GetTimeSinceStartup();
            if (this.mLastGfxDeltaTicksUpdate != -1)
            {
                this.mGfxDeltaTicks = (_local_1 - this.mLastGfxDeltaTicksUpdate);
            }
            else
            {
                this.mGfxDeltaTicks = 0;
            };
            this.mLastGfxDeltaTicksUpdate = _local_1;
            if (!mActiveG)
            {
                return;
            };
            cBackbuffer.Lock();
            if (mCurrentPlayerZone.mClearBackGround)
            {
                cBackbuffer.Clear(mCurrentPlayerZone.CLEAR_COLOR);
            };
            mCurrentPlayerZone.Render();
            mDebugTextXPos = 160;
            mDebugTextYPos = -5;
            var _local_2:int = 10;
            if (!mRenderScreen)
            {
                if (mCurrentPlayerZone.mClearBackGround)
                {
                    cBackbuffer.Clear(mCurrentPlayerZone.CLEAR_COLOR);
                };
            };
            cBackbuffer.Unlock();
            RenderBackBufferToCanvas();
            gGlowManager.glowStep();
            mCurrentPlayerZone.RenderOverlayGraphics(global.getApplication().isoengine.graphics);
        }

        private function addGhostGarrison(_arg_1:int):void
        {
            var _local_2:cBuilding = cBuilding.CreateFromString(null, global.buildingGroup, defines.DEFENSE_MODE_GHOST_GARRISON_string, this);
            _local_2 = (mCurrentPlayerZone.SetGoAtGridPosition(this.mGameTickCommandPlayer, _local_2, OBJECTTYPE.BUILDING, _arg_1) as cBuilding);
            if (_local_2 == null)
            {
                cLog.error(((((("Z:" + mCurrentViewedZoneID) + " P:") + this.mGameTickCommandPlayer.getPlayerID()) + " could not place ghost garrison on grid position ") + _arg_1));
                return;
            };
            _local_2.SetBuildingMode(cBuilding.BUILDING_MODE_PRODUCES_NO_RESOURCES);
            _local_2.SetIsDefenseBuilding(true);
            var _local_3:GridPosition = new GridPosition(_arg_1, mCurrentPlayerZone.mMapWidth);
            _local_2.SetUniqueId(new dUniqueID().Init(_local_3.X(), _local_3.Y()));
            _local_2.SetCampType(CAMP_TYPE.DEFENSE_SLOT);
            _local_2.mDirtyIndicator.created();
        }

        private function handleCompleteTradeMail(_arg_1:cPlayerData, _arg_2:dGameTickCommandVO):Boolean
        {
            if (cLog.isInfoEnabled())
            {
                cLog.info(((("Complete trade via mail " + _arg_2.data) + " at ") + _arg_2.time));
            };
            if (!(_arg_2.data is dTradeCompleteVO))
            {
                return (false);
            };
            return (this.handleCompleteTradeCommon(_arg_1, (_arg_2.data as dTradeCompleteVO), true, false));
        }

        private function isBuffDeleted(_arg_1:int, _arg_2:cBuff):Boolean
        {
            return (true);
        }

        private function handleExpireMail(_arg_1:cPlayerData, _arg_2:dGameTickCommandVO):void
        {
        }

        public function DisableAllShopItems():void
        {
            this.mSpecificShopItems = true;
            this.mEnabledShopItems_vector = new HashSetWrapper();
        }

        private function ShowGameTickInfo():void
        {
            var _local_2:dGameTickCommandVO;
            var _local_1:int = 10;
            globalFlash.gui.WriteDebugText(cBackbuffer.mBackBuffer, "-- GameTick Info --", mDebugTextXPos, (mDebugTextYPos = (mDebugTextYPos + _local_1)));
            for each (_local_2 in mGameTickCommand_vector)
            {
                globalFlash.gui.WriteDebugText(cBackbuffer.mBackBuffer, _local_2.toString().replace("<dGameTickCommandVO ", "<").replace("</dGameTickCommandVO>\n", ""), mDebugTextXPos, (mDebugTextYPos = (mDebugTextYPos + _local_1)));
            };
        }

        override public function MouseOut(_arg_1:MouseEvent):void
        {
            mMousePressed = false;
        }

        private function HandleDestructMountain(_arg_1:dGameTickCommandVO):Boolean
        {
            if (_arg_1.data == null)
            {
                return (false);
            };
            var _local_2:int = gMisc.ObjectToInt(_arg_1.data);
            if (_local_2 == defines.ILLEGAL_INT_POS)
            {
                return (false);
            };
            var _local_3:cBuilding = mCurrentPlayerZone.GetBuildingFromGridPosition(_local_2);
            if (_local_3 == null)
            {
                return (false);
            };
            mCurrentPlayerZone.mStreetDataMap.DeconstructMountainGridPos(_local_2);
            return (true);
        }

        public function requestZonePersistence(_arg_1:int):void
        {
        }

        public function ProcessGameTickCommands(_arg_1:dGameTickCommandVO):void
        {
            var _local_2:dMailsDismissedVO;
            var _local_3:dUniqueID;
            var _local_4:cBuffDefinition;
            var _local_5:cBuff;
            var _local_6:dQuestElementVO;
            var _local_7:Boolean;
            var _local_8:EffectVO;
            var _local_9:dGameTickCommandVO;
            var _local_10:cResources;
            var _local_11:int;
            var _local_12:int;
            var _local_13:int;
            var _local_14:int;
            var _local_15:cMilitaryUnitBase;
            var _local_16:int;
            var _local_17:Identity;
            var _local_18:String;
            var _local_19:dSpecialistResultVO;
            var _local_20:dServerAction;
            var _local_21:cBuilding;
            var _local_22:dUniqueID;
            var _local_23:Array;
            var _local_24:int;
            var _local_25:int;
            var _local_26:int;
            var _local_27:int;
            var _local_28:dIntegerVO;
            this.mGameTickCommandPlayer = FindPlayerFromId(_arg_1.playerID);
            if (this.mGameTickCommandPlayer == null)
            {
                return;
            };
            switch (_arg_1.mode)
            {
                case COMMAND.GAMETICK_REFRESH_COMMAND:
                case COMMAND.TRADE_GET_USER_TRADES:
                case COMMAND.APPLY_EFFECT:
                case COMMAND.SET_TASK:
                case COMMAND.RAISE_ARMY:
                case COMMAND.START_TIMED_PRODUCTION:
                    break;
                default:
                    this.requestZonePersistence(_arg_1.mode);
                    LocalLogMessageDetail(((((("PGTC: playerID=" + _arg_1.playerID) + " mode=") + _arg_1.mode) + " data=") + _arg_1.data));
            };
            switch (_arg_1.mode)
            {
                case COMMAND.SET_BUILDING_BY_BUFF:
                case COMMAND.SET_BUILDING_IN_GAME:
                case COMMAND.SET_BUILDING_PICKUP:
                    this.HandleSetBuilding(this.mGameTickCommandPlayer, _arg_1);
                    return;
                case COMMAND.SET_BUILDING_IN_DEFENSE_MODE:
                    this.HandleSetBuildingDefenseMode(this.mGameTickCommandPlayer, _arg_1, false, mCurrentPlayerZone.mMapWidth);
                    return;
                case COMMAND.SET_BUILDING_IN_DEFENSE_MODE_BY_BUFF:
                    this.HandleSetBuildingDefenseMode(this.mGameTickCommandPlayer, _arg_1, true, mCurrentPlayerZone.mMapWidth);
                    return;
                case COMMAND.MOVE_BUILDING:
                    this.HandleMoveBuilding(this.mGameTickCommandPlayer, _arg_1);
                    return;
                case COMMAND.MOVE_COLLECTIBLE_BUILDING:
                    this.HandleMoveCollectible(this.mGameTickCommandPlayer, _arg_1);
                    return;
                case COMMAND.BUILDQUEUE_MOVE_UP:
                    if (_arg_1.data == null) break;
                    this.mGameTickCommandPlayer.mBuildQueue.MoveUp(gMisc.ObjectToInt(_arg_1.data));
                    return;
                case COMMAND.BUILDQUEUE_MOVE_DOWN:
                    if (_arg_1.data == null) break;
                    this.mGameTickCommandPlayer.mBuildQueue.MoveDown(gMisc.ObjectToInt(_arg_1.data));
                    return;
                case COMMAND.BUILDQUEUE_REMOVE:
                    if (_arg_1.data == null) break;
                    this.mGameTickCommandPlayer.mBuildQueue.Remove(gMisc.ObjectToInt(_arg_1.data));
                    return;
                case COMMAND.SET_TASK:
                    this.HandleSetTask(this.mGameTickCommandPlayer, _arg_1);
                    return;
                case COMMAND.QUEST_APPLY_REWARD_EFFECTS:
                    if (IsCurrentPlayerQuestPlayer())
                    {
                        _local_6 = (_arg_1.data as dQuestElementVO);
                        QuestManagerStatic.ApplyRewardEffects(this, _local_6, this.mGameTickCommandPlayer);
                        mQuestClientCallbacks.RefreshLastQuestList(_local_6);
                        _local_7 = _local_6.isReset;
                    };
                    return;
                case COMMAND.QUEST_PAY_FOR_QUEST_FINISH:
                    this.HandlePayForQuestFinish(this.mGameTickCommandPlayer, _arg_1);
                    return;
                case COMMAND.APPLY_EFFECT:
                case COMMAND.MODIFIER_EFFECT:
                    _local_8 = (_arg_1.data as EffectVO);
                    this.effectFactory.createEffect(_local_8).gameTickApply();
                    return;
                case COMMAND.SPEEDMODE:
                    mGlobalTimeScale = (_arg_1.data as dIntegerVO).value;
                    for each (_local_9 in mGameTickCommand_vector)
                    {
                        _local_9.time = (_arg_1.time + (GameTickSystemPostProcessTime * mGlobalTimeScale));
                    };
                    return;
                case COMMAND.RESOURCES_CHEAT:
                    _local_10 = mCurrentPlayerZone.GetResources(this.mGameTickCommandPlayer);
                    _local_10.ApplyResourceListForCheat((_arg_1.data as dResourcesVO));
                    return;
                case COMMAND.ARMY_CHEAT:
                    mCurrentPlayerZone.GetArmy(_arg_1.playerID).ApplyArmyForCheat((_arg_1.data as dArmyVO));
                    return;
                case COMMAND.SET_CITY_LEVEL:
                    _local_11 = this.mGameTickCommandPlayer.GetPlayerLevel();
                    _local_12 = (_arg_1.data as dIntegerVO).value;
                    if (_local_12 > _local_11)
                    {
                        _local_13 = _local_11;
                        while (_local_13 < _local_12)
                        {
                            if (_local_13 >= global.playerLevels_vector.length) break;
                            _local_14 = global.playerLevels_vector[_local_13];
                            this.mGameTickCommandPlayer.AddXP((_local_14 - this.mGameTickCommandPlayer.GetXP()));
                            _local_13++;
                        };
                    };
                    globalFlash.gui.mAvatar.SetData(this.mGameTickCommandPlayer, GetPlayerList_vector());
                    mCurrentPlayerZone.SetBackgroundHasChanged(true);
                    return;
                case COMMAND.MAX_UNITS_CHEAT:
                    for each (_local_15 in cMilitaryUnitBase.GetAllUnit(false))
                    {
                        if (_local_15.IsProducible())
                        {
                            mCurrentPlayerZone.GetArmy(mCurrentPlayer.GetPlayerId()).AddUnits(_local_15.GetType(), 10000, 0, true);
                        };
                    };
                    return;
                case COMMAND.CHEAT_FINISH_TASK:
                    _local_16 = (_arg_1.data as int);
                    if (_local_16 > 0)
                    {
                        _local_17 = getCurrentTaskManager().getIdentityByID(_local_16);
                        _local_17.setAllTriggerFinished();
                    };
                    return;
                case COMMAND.CHEAT_RESET_TASKS:
                    _local_18 = (_arg_1.data as String);
                    if (_local_18 != null)
                    {
                    };
                    return;
                case COMMAND.ADD_HARD_CURRENCY:
                    this.HandleAddHardCurrency(this.mGameTickCommandPlayer, _arg_1, ModifyReason.UNDEFINED);
                    return;
                case COMMAND.RETREAT:
                    this.HandleRetreat(this.mGameTickCommandPlayer, _arg_1);
                    return;
                case COMMAND.APPLY_CASUALTIES:
                    this.HandleApplyCasualty(this.mGameTickCommandPlayer, _arg_1);
                    return;
                case COMMAND.DISMISS_MAILS:
                    _local_2 = (_arg_1.data as dMailsDismissedVO);
                    this.HandleMailsDismissed(this.mGameTickCommandPlayer, _local_2);
                    return;
                case COMMAND.ACCEPT_LOOT:
                    this.HandleAcceptLoot(this.mGameTickCommandPlayer, _arg_1, false);
                    return;
                case COMMAND.CLAIM_LOOT:
                    this.HandleAcceptLoot(this.mGameTickCommandPlayer, _arg_1, true);
                    return;
                case COMMAND.INVITE_TO_ADVENTURE:
                    if (this.HandleInviteToAdventure(this.mGameTickCommandPlayer, _arg_1))
                    {
                    };
                    return;
                case COMMAND.ACCEPT_ADVENTURE_INVITATION:
                    if (this.HandleAcceptAdventureInvitation(this.mGameTickCommandPlayer, _arg_1))
                    {
                    };
                    return;
                case COMMAND.DECLINE_ADVENTURE_INVITATION:
                    this.HandleDeclineAdventureInvitation(this.mGameTickCommandPlayer, _arg_1, false);
                    return;
                case COMMAND.ADVENTURE_INVITATION_EXPIRED:
                    this.HandleDeclineAdventureInvitation(this.mGameTickCommandPlayer, _arg_1, true);
                    return;
                case COMMAND.BUY_ONE_CLICK_SHOP_ITEM:
                    if (this.handleBuyOneClickShopItem(this.mGameTickCommandPlayer, _arg_1))
                    {
                    };
                    return;
                case COMMAND.RAISE_ARMY:
                    this.HandleRaiseArmy(this.mGameTickCommandPlayer, _arg_1, mCurrentPlayerZone.mMapWidth);
                    return;
                case COMMAND.BUY_SPECIALIST:
                    _local_19 = (_arg_1.data as dSpecialistResultVO);
                    this.BuySpecialistDirect(this.mGameTickCommandPlayer, _local_19.type, _local_19.uniqueID, _local_19.withCosts);
                    return;
                case COMMAND.REVEAL_FRIEND_COLLECTIBLE_BUILDING_BUFF:
                    _local_3 = ((_arg_1.data as dServerAction).data as dUniqueID);
                    _local_4 = cBuff.getBuffDefinitionByName(CollectionsConsts.REVEAL_FRIENDS_COLLECTIBLES_BUFF);
                    _local_5 = BuffUtils.createBuff(CollectionsConsts.REVEAL_FRIENDS_COLLECTIBLES_BUFF, 1, 0, _local_4.GetResourceName_string(), _local_3);
                    this.mGameTickCommandPlayer.addBuff(_local_5);
                    this.handleApplyBuff(this.mGameTickCommandPlayer, _arg_1);
                    return;
                case COMMAND.APPLY_BUFF:
                    this.handleApplyBuff(this.mGameTickCommandPlayer, _arg_1);
                    return;
                case COMMAND.ZONE_BUFF_REMOVE:
                    this.handleRemoveZoneBuff(this.mGameTickCommandPlayer, _arg_1);
                    return;
                case COMMAND.ITEM_REGISTRY_REGISTER:
                    this.handleItemRegistryRegister(this.mGameTickCommandPlayer, _arg_1);
                    return;
                case COMMAND.APPLY_BUFF_LIST:
                    this.handleApplyBuffStack(this.mGameTickCommandPlayer, _arg_1);
                    return;
                case COMMAND.APPLY_LOOTTABLE_BUFF:
                    this.handleApplyLoottableBuff(this.mGameTickCommandPlayer, _arg_1);
                    return;
                case COMMAND.REMOVE_BUFF:
                    this.HandleRemoveBuff(this.mGameTickCommandPlayer, _arg_1);
                    return;
                case COMMAND.START_TIMED_PRODUCTION:
                    this.HandleStartTimedProduction(this.mGameTickCommandPlayer, _arg_1);
                    return;
                case COMMAND.DELIVER_PRODUCTION:
                    this.handleDeliverProduction(this.mGameTickCommandPlayer, _arg_1);
                    return;
                case COMMAND.PRODUCTION_REMOVE:
                    this.handleRemoveProduction(this.mGameTickCommandPlayer, _arg_1);
                    return;
                case COMMAND.BUY_SHOP_ITEM:
                case COMMAND.BUY_SHOP_ITEM_MOBILE:
                    if (this.HandleBuyShopItem(_arg_1))
                    {
                    };
                    return;
                case COMMAND.DESTRUCT_BUILDING:
                    this.HandleDestructBuilding(this.mGameTickCommandPlayer, _arg_1, mCurrentPlayerZone.mMapWidth);
                    return;
                case COMMAND.DESTRUCT_MOUNTAIN:
                    this.HandleDestructMountain(_arg_1);
                    return;
                case COMMAND.INITIATE_TRADE:
                    this.handleInitiateTrade(this.mGameTickCommandPlayer, _arg_1);
                    return;
                case COMMAND.ACCEPT_TRADE_GTC:
                    this.handleAcceptTrade(this.mGameTickCommandPlayer, _arg_1);
                    return;
                case COMMAND.COMPLETE_TRADE_MAIL:
                    this.handleCompleteTradeMail(this.mGameTickCommandPlayer, _arg_1);
                    return;
                case COMMAND.COMPLETE_TRADE_MARKET:
                    if (this.handleCompleteTradeMarket(this.mGameTickCommandPlayer, _arg_1))
                    {
                    };
                    return;
                case COMMAND.DELETE_TRADE_GTC:
                    this.handleDeleteTrade(this.mGameTickCommandPlayer, _arg_1);
                    return;
                case COMMAND.TRADE_GET_USER_TRADES:
                    mHomePlayer.mTradeData.setUserPlacedOffers((_arg_1.data as ArrayCollection));
                    return;
                case COMMAND.SET_SKILLPOINTS:
                    this.handleSetSkillpoints(_arg_1);
                    return;
                case COMMAND.RESET_SKILLPOINTS:
                    this.handleResetSkillpoints(_arg_1);
                    return;
                case COMMAND.UPGRADE_BUILDING:
                    if (_arg_1.data == null) break;
                    if (mCurrentPlayerZone.mStreetDataMap.UpgradeBuildingGridPos(this.mGameTickCommandPlayer, gMisc.ObjectToInt(_arg_1.data)))
                    {
                    };
                    return;
                case COMMAND.STOP_PRODUCTION:
                    _local_20 = (_arg_1.data as dServerAction);
                    _local_21 = mCurrentPlayerZone.GetBuildingFromGridPosition(_local_20.grid);
                    if (_local_21 != null)
                    {
                        _local_21.SetProductionActive(((_local_20.type == 1) ? true : false));
                    };
                    return;
                case COMMAND.GAMETICK_REFRESH_COMMAND:
                    this.GameTickRefresh(this.mGameTickCommandPlayer);
                    SetGameTickRefreshCommand(this.mGameTickCommandPlayer);
                    return;
                case COMMAND.REMOVE_TEMP_BUILD_SLOT:
                    this.RemoveTemporaryBuildSlot(this.mGameTickCommandPlayer, _arg_1);
                    return;
                case COMMAND.GUILD_DONATE_RESOURCE:
                    this.handleGuildDonateResource(this.mGameTickCommandPlayer, _arg_1);
                    return;
                case COMMAND.GUILD_BANK_WITHDRAW:
                    this.handleGuildWithdrawResource(this.mGameTickCommandPlayer, _arg_1);
                    return;
                case COMMAND.GUILD_BANK_TRANSFER:
                    this.handleGuildTransferResource(this.mGameTickCommandPlayer, _arg_1);
                    return;
                case COMMAND.EVENT_DONATE_RESOURCE:
                    this.handleEventDonateResource(this.mGameTickCommandPlayer, _arg_1);
                    return;
                case COMMAND.EPIC_WORKYARD_CREATE_PRODUCTION_CHAIN:
                    this.handleCreateEpicProductionChain(this.mGameTickCommandPlayer, _arg_1);
                    return;
                case COMMAND.EPIC_WORKYARD_DESTROY_PRODUCTION_CHAIN:
                    this.handleDestroyEpicProductionChain(this.mGameTickCommandPlayer, _arg_1);
                    return;
                case COMMAND.EPIC_WORKYARD_CHANGE_PRODUCTION_CHAIN:
                    this.handleChangeEpicProductionChain(this.mGameTickCommandPlayer, _arg_1);
                    return;
                case COMMAND.GUILD_BANK_BUY_TAB:
                    this.handleGuildBankBuyTab(this.mGameTickCommandPlayer, _arg_1);
                    return;
                case COMMAND.GUILD_BANK_ENLARGE:
                    this.handleGuildBankEnlarge(this.mGameTickCommandPlayer, _arg_1);
                    return;
                case COMMAND.ATTACK_BUILDING:
                    return;
                case COMMAND.COLONY_ASSIGN:
                case COMMAND.COLONY_REMOVE:
                    this.HandleColonyCommand(this.mGameTickCommandPlayer, _arg_1);
                    return;
                case COMMAND.CREATE_COLLECTION:
                    this.handleCreateCollection(this.mGameTickCommandPlayer, _arg_1);
                    return;
                case COMMAND.OPEN_ADVENT_CALENDAR_DOOR:
                    this.HandleOpenAdventCalendarDoor(this.mGameTickCommandPlayer, _arg_1, false);
                    return;
                case COMMAND.OPEN_ADVENT_CALENDAR_DOOR_WITH_GEMS:
                    this.HandleOpenAdventCalendarDoor(this.mGameTickCommandPlayer, _arg_1, true);
                    return;
                case COMMAND.RESET_CULTURE_BUILDING_COOLDOWN_WITH_GEMS:
                    this.HandleResetCultureBuildingCooldownWithGems(this.mGameTickCommandPlayer, _arg_1);
                    return;
                case COMMAND.SELECT_ADVENT_CALENDAR_DOOR_REWARD:
                    this.HandleSelectAdventCalendarDoorReward(_arg_1);
                    return;
                case COMMAND.VOTES_SEND_PLAYER_VOTE:
                    this.HandleSendGuildMarketPlayerVote(_arg_1);
                    return;
                case COMMAND.VOTES_DELETE_PLAYER_VOTE_WITH_GEMS:
                    this.HandleDeleteGuildMarketPlayerVoteWithGems(_arg_1);
                    return;
                case COMMAND.FORCE_COMPLETE_ACHIEVEMENT:
                    this.handleCompleteAchievementCheat(this.mGameTickCommandPlayer, _arg_1);
                    return;
                case COMMAND.FORCE_COMPLETE_ACHIEVEMENT_TRIGGER:
                    this.handleCompleteAchievementTriggerCheat(this.mGameTickCommandPlayer, _arg_1);
                    return;
                case COMMAND.GET_COMPARED_USER_ACHIEVEMENTS:
                    this.handleGetComparedUserAchievements(_arg_1);
                    return;
                case COMMAND.UPDATE_PICKUP_DATA:
                    this.handlePickupDataUpdate(_arg_1);
                    return;
                case COMMAND.EXPIRE_MAIL_CHEAT:
                    this.handleExpireMail(this.mGameTickCommandPlayer, _arg_1);
                    return;
                case COMMAND.EXECUTE_PICKUP:
                    _local_22 = (_arg_1.data as dUniqueID);
                    if (!pickupManager.pickup(_local_22))
                    {
                        cLog.error((("uid:" + _local_22) + " unable to find resource pickup to execute!"));
                    };
                    return;
                case COMMAND.NOTIFY_GENERAL_SKILL_STAR_COINS_PICKED_UP:
                    globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.GENERAL_SKILL_STAR_COINS_PICKED_UP_FROM_ADVENTURE, (_arg_1.data as int));
                    return;
                case COMMAND.ADD_BLOCKING_PATH_PREVIEW:
                    this.handleAddCombatPreviewPath(_arg_1);
                    return;
                case COMMAND.DELETE_BLOCKING_PATH_PREVIEW:
                    this.handleDeleteCombatPreviewPath(_arg_1);
                    return;
                case COMMAND.MOVE_BLOCKING_PATH_PREVIEW_START:
                case COMMAND.MOVE_BLOCKING_PATH_PREVIEW_TARGET:
                    this.handleMoveCombatPreviewPath(_arg_1);
                    return;
                case COMMAND.INIT_CHAT:
                    TSOChatMediator.InitChat(true);
                    return;
                case COMMAND.START_EVENT:
                    _local_23 = (_arg_1.data as String).split(",");
                    if (((!(_local_23 == null)) && (_local_23.length >= 3)))
                    {
                        mEventManager.StartEvent(this, _local_23[0], new Number(_local_23[1]), new Number(_local_23[2]), new Number(_local_23[3]), new Number(_local_23[4]), new Number(_local_23[5]));
                    }
                    else
                    {
                        cLog.error(("Error while trying to start event " + (_arg_1.data as String)));
                    };
                    return;
                case COMMAND.STOP_EVENT:
                    mEventManager.StopEvent(this, (_arg_1.data as String));
                    return;
                case COMMAND.CLEANUP_EVENT:
                    mEventManager.CleanUp(this, (_arg_1.data as String));
                    return;
                case COMMAND.PRODUCTION_MOVE_TOP:
                    this.MoveInProductionQueue((_arg_1.data as dTimedProductionQueueChangeVO), -(gMisc.GetMaxIntValue()));
                    return;
                case COMMAND.PRODUCTION_MOVE_BOTTOM:
                    this.MoveInProductionQueue((_arg_1.data as dTimedProductionQueueChangeVO), gMisc.GetMaxIntValue());
                    return;
                case COMMAND.PRODUCTION_MOVE_UP:
                    this.MoveInProductionQueue((_arg_1.data as dTimedProductionQueueChangeVO), -1);
                    return;
                case COMMAND.PRODUCTION_MOVE_DOWN:
                    this.MoveInProductionQueue((_arg_1.data as dTimedProductionQueueChangeVO), 1);
                    return;
                case COMMAND.PRODUCTION_CANCEL_ALL_WAITING:
                    this.handleRemoveAllWaitingProductions(this.mGameTickCommandPlayer, _arg_1);
                    return;
                case COMMAND.RECREATE_EMPTY_DEPOSIT:
                    this.handleRecreateEmptyDeposit(_arg_1);
                    return;
                case COMMAND.CLAM_TASK_REWARD:
                    getCurrentTaskManager().rewardTask(this, (_arg_1.data as TaskClaimVO));
                    globalFlash.gui.mTaskBuildingPanel.claimTaskRewardsCompletedHandler();
                    return;
                case COMMAND.SET_PVP_LEVEL:
                    _local_24 = this.mGameTickCommandPlayer.GetPlayerPvPLevel();
                    _local_25 = (_arg_1.data as dIntegerVO).value;
                    if (_local_25 > _local_24)
                    {
                        _local_26 = _local_24;
                        while (_local_26 < _local_25)
                        {
                            if (_local_26 >= global.playerPvPLevels_vector.length) break;
                            _local_27 = global.playerPvPLevels_vector[_local_26].pvpXp;
                            this.mGameTickCommandPlayer.AddPvPXp((_local_27 - this.mGameTickCommandPlayer.GetPlayerPvPXp()));
                            _local_26++;
                        };
                    };
                    return;
                case COMMAND.ADD_PVP_XP:
                    this.mGameTickCommandPlayer.AddPvPXp((_arg_1.data as dIntegerVO).value);
                    return;
                case COMMAND.UPDATE_PVP_MODIFIER:
                    _local_28 = (_arg_1.data as dIntegerVO);
                    mCurrentPlayer.SetPvpModifier(_local_28.value);
                    return;
                case COMMAND.DEPOSIT_FOUND:
                    this.handleDepositFound((_arg_1.data as dFoundDepositVO));
                    return;
                case COMMAND.PAY_TO_FINISH:
                    this.handlePayToFinish(this.mGameTickCommandPlayer, (_arg_1.data as int));
                    return;
                case COMMAND.CONTENT_GENERATOR_ROLL:
                    mContentGeneratorManager.ApplyRollResult(_arg_1.data);
                    return;
                case COMMAND.CONTENT_GENERATOR_COMPLETE_COLLECTION:
                    mContentGeneratorManager.ApplyCompleteCollection(_arg_1.data);
                    return;
                case COMMAND.KILL_EVENT_MONSTER:
                    globalFlash.gui.mEventMonster.handleKillEventMonster();
                    return;
                case COMMAND.BUFF_ADVENTURE_CLEANUP:
                    this.handleBuffAdventureCleanup((_arg_1.data as String));
                    return;
                case COMMAND.LEAVE_ADVENTURE:
                    this.handleLeaveAdventure(_arg_1);
                    return;
            };
        }

        override public function MouseDown(_arg_1:MouseEvent):void
        {
            if (!IsActiveAndInputActive())
            {
                return;
            };
            mMousePressed = true;
            mCurrentPlayerZone.MouseDown(_arg_1);
        }

        private function HandleSendGuildMarketPlayerVote(_arg_1:dGameTickCommandVO):void
        {
            var _local_2:dPlayerVoteVO = (_arg_1.data as dPlayerVoteVO);
            mVotesManager.SetPlayerVote(_local_2);
            globalFlash.gui.mGuildWindow.RefreshGuildMarket();
        }

        private function addEpicWorkyardSubBuildingAtIndex(_arg_1:int, _arg_2:String, _arg_3:int, _arg_4:EpicWorkyardMasterBuilding, _arg_5:int):Boolean
        {
            var _local_9:cResourceCreation;
            var _local_6:EpicWorkyardSubBuilding = (cBuilding.CreateFromString(this.mGameTickCommandPlayer, global.buildingGroup, _arg_2, this) as EpicWorkyardSubBuilding);
            if (_local_6 == null)
            {
                LocalLogMessageDetail((("Could not create epic sub building out of '" + _arg_2) + "'!"));
                return (false);
            };
            gMisc.Assert((!(_local_6.IsMovable())), "Epic workyard sub buildigns can't be movable");
            if (_arg_1 < 0)
            {
                return (false);
            };
            while (_arg_3 > 1)
            {
                _local_6.Upgrade();
                _arg_3--;
            };
            _local_6 = (mCurrentPlayerZone.SetGoAtGridPosition(this.mGameTickCommandPlayer, _local_6, OBJECTTYPE.BUILDING, _arg_1) as EpicWorkyardSubBuilding);
            if (_local_6 == null)
            {
                LocalLogMessageDetail((("Error could not set sub building at grid '" + _arg_1) + "' invalid build pos!"));
                return (false);
            };
            var _local_7:int = _arg_4.addSubBuilding(_local_6, _arg_5);
            _local_6.SetBuildingMode(cBuilding.BUILDING_MODE_BUILDER_WALKS_FROM_RESOURCECREATIONHOUSE_TO_STOREHOUSE);
            var _local_8:GridPosition = new GridPosition(_arg_1, mCurrentPlayerZone.mMapWidth);
            _local_6.SetUniqueId(new dUniqueID().Init(_local_8.X(), _local_8.Y()));
            if (_local_6.GetResourceCreation() != null)
            {
                _local_9 = _local_6.GetResourceCreation();
                _local_9.mDirtyIndicator = (_local_9.mDirtyIndicator | DIRTY_INDICATOR.CREATED_BIT);
                _local_9.pathPos = ((_local_9.GetPath() != null) ? _local_9.GetPath().pathLenX20000 : 0);
            };
            _local_6.mDirtyIndicator.created();
            _arg_4.setWaitingForServerResponse(false);
            mCurrentPlayer.IncAnyBuildingCount(_local_6);
            globalFlash.gui.mEpicWorkyardInfoPanel.refreshChains();
            TrackManager.getInstance().trackEpicWorkyardChainEnabled(mCurrentPlayer, _arg_2, _local_7);
            return (true);
        }

        private function handleDeleteCombatPreviewPath(_arg_1:dGameTickCommandVO):void
        {
            globalFlash.gui.mToolboxPanel.Refresh();
        }

        private function ShowAddtionalDebugGameInfo_string():void
        {
            var _local_1:* = "";
            this.ShowDebugString("-- Debug Info --");
            this.ShowDebugString(("Zoom: " + Math.round(mZoom.GetScaleFactor())));
            this.ShowDebugString(((("ScrollPos: " + Math.round(mZoom.GetScrollPosX())) + ",") + Math.round(mZoom.GetScrollPosY())));
            this.ShowDebugString(("SmoothZoom: " + mZoom.mSmoothing));
            this.ShowDebugString(("tempString: " + temp_string));
            this.ShowDebugString(((("MouseOverCanvas: " + global.getApplication().isoengine.mMouseOverCanvas) + " MouseMove: ") + global.getApplication().isoengine.mMouseMove));
            this.ShowDebugString(("mActive: " + mActiveG));
            this.ShowDebugString(("mComputeAndInputActive: " + mComputeAndInputActive));
            this.ShowDebugString(("mCanvasFocused: " + global.getApplication().isoengine.mCanvasFocused));
            this.ShowDebugString(("mApplicationActive: " + global.getApplication().isoengine.mApplicationActive));
            this.ShowDebugString(("mIgnoreNextClick: " + global.getApplication().isoengine.mIgnoreNextClick));
            this.ShowDebugString(("Player XP: " + mCurrentPlayer.GetXP()));
            this.ShowDebugString(("Player PlayerLevel: " + mCurrentPlayer.GetPlayerLevel()));
            this.ShowDebugString(("Player CityLevel: " + mCurrentPlayer.GetCityLevel()));
            this.ShowDebugString(("Player Name: " + mCurrentPlayer.GetPlayerName_string()));
        }

        private function acceptLoot(_arg_1:cPlayerData, _arg_2:dLootItemsVO, _arg_3:Boolean):void
        {
            this.AddLootItems(_arg_1, _arg_2.items, _arg_2.uniqueIDs, _arg_3);
            this.AddLootItems(_arg_1, _arg_2.premiumItems, _arg_2.premiumUniqueIDs, _arg_3);
            channels.ZONE.notifyPropertyObserver(TriggerUtils.LOOT_RESOURCE_NAME, _arg_2);
        }

        private function HandleDestructBuilding(_arg_1:cPlayerData, _arg_2:dGameTickCommandVO, _arg_3:int):Boolean
        {
            var _local_8:cResources;
            var _local_9:dResource;
            if (_arg_2.data == null)
            {
                return (false);
            };
            var _local_4:DestructBuildingResultVO = DestructBuildingResultVO(_arg_2.data);
            var _local_5:int = _local_4.gridIndex;
            if (_local_5 == defines.ILLEGAL_INT_POS)
            {
                return (false);
            };
            var _local_6:cBuilding = mCurrentPlayerZone.GetBuildingFromGridPosition(_local_5);
            if (_local_6 == null)
            {
                return (false);
            };
            if ((((CollectionsManager.getInstance().getBuildingIsNormalCollectible(_local_6.GetBuildingName_string())) && (mCurrentPlayerZone.GetResources(_arg_1) == null)) && (_local_4.collectibleRefundResources.length > 0)))
            {
                _local_6.SetIsDestructionInitiated(false);
                return (false);
            };
            _local_6.setDestroyedByPlayerID(_arg_1.getPlayerID());
            if (CollectionsManager.getInstance().getBuildingIsNormalCollectible(_local_6.GetBuildingName_string()))
            {
                this.refundCollectibleResources(_local_4, _arg_1);
                pickupManager.notifyPropertyObserver(TriggerUtils.COLLECTED_PICKUP_NAME, _local_6);
                mCurrentPlayerZone.mStreetDataMap.removePickupFromList(CollectionsConsts.COLLECTIBLE_BUILDING_NORMAL, _local_4.gridIndex);
            }
            else
            {
                if (CollectionsManager.getInstance().getBuildingIsEventCollectible(_local_6.GetBuildingName_string()))
                {
                    mCurrentPlayerZone.mStreetDataMap.removePickupFromList(CollectionsConsts.COLLECTIBLE_BUILDING_EVENT, _local_4.gridIndex);
                    if (IsAdventureZoneID(mCurrentViewedZoneID))
                    {
                        globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.COLLECTED_EVENT_PICKUP_IN_ADVENTURE, [_local_6.GetBuildingName_string(), CollectionsManager.getInstance().getLocaExtension_string(_local_6.GetBuildingName_string())]);
                    };
                };
            };
            if (!(_local_6 is cCollectibleBuilding))
            {
                TrackManager.getInstance().trackBuildingDestroy(_arg_1, _local_6, _local_4.origin);
            };
            var _local_7:Boolean = true;
            if (mIsDefenseMode)
            {
                _local_8 = mCurrentPlayerZone.GetResources(mCurrentPlayer);
                if (_local_6.mOrigin == cBuilding.BUILDING_ORIGIN_FROM_GAME)
                {
                    _local_8.RefundAllBuildingResourcesToPlayerResources(_local_6);
                }
                else
                {
                    if ((((_local_6.mOrigin == cBuilding.BUILDING_ORIGIN_FROM_BUFF) && (_local_6.IsDefenseModeGarrison())) && (!(_local_6.GetArmy() == null))))
                    {
                        for each (_local_9 in _local_6.GetArmy().GetTotalUnitResourceCosts())
                        {
                            _local_8.AddResource(_local_9.name_string, _local_9.amount, ModifyReason.DESTRUCT_BUILDING_ARMY, null);
                        };
                    };
                };
                _local_6.GetArmy().DisbandArmy(null);
                _local_6.removeBuilding(true);
                this.addGhostGarrison(_local_5);
            }
            else
            {
                _local_7 = this.removeBuildingFromGrid(_local_5);
            };
            return (_local_7);
        }

        private function handleDepositFound(_arg_1:dFoundDepositVO):void
        {
            var _local_3:Vector.<cDeposit>;
            var _local_4:cDeposit;
            var _local_5:int;
            var _local_6:dFoundDepositVO;
            var _local_7:cDeposit;
            if (cLog.isInfoEnabled())
            {
                cLog.info(((("Geologist " + _arg_1.specialistID) + " finished search for ") + _arg_1.depositSearchedFor));
            };
            var _local_2:cSpecialist = mCurrentPlayerZone.getSpecialist(mCurrentViewedZoneID, _arg_1.specialistID);
            if (_arg_1.depositVO != null)
            {
                _local_3 = new Vector.<cDeposit>();
                _local_4 = cDeposit.CreateDepositFromVO(_arg_1.depositVO, this);
                _local_5 = 1;
                for each (_local_6 in _arg_1.extraDeposits_vector)
                {
                    _local_3.push(cDeposit.CreateDepositFromVO(_local_6.depositVO, this));
                    if (_local_6.depositVO.name_string == _arg_1.depositSearchedFor)
                    {
                        _local_5++;
                    };
                };
                this.PlaceDepositOnMap(_local_4, _local_2);
                for each (_local_7 in _local_3)
                {
                    this.PlaceDepositOnMap(_local_7, _local_2);
                };
            }
            else
            {
                switch (_arg_1.exploredDepositResult)
                {
                    case EXPLORED_DEPOSIT_RESULT.ALL_DEPOSITS_ACCESSIBLE:
                        globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.GEOLOGIST_FINISHED_NEGATIVE_ALL_ACCESSIBLE, [_arg_1.depositSearchedFor, _local_2]);
                        return;
                    default:
                        globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.GEOLOGIST_FINISHED_NEGATIVE, [_arg_1.depositSearchedFor, _local_2]);
                        if (cLog.isInfoEnabled())
                        {
                            cLog.warning(((("Could not interpret explored deposit result code " + _arg_1.exploredDepositResult) + " [Z:") + mCurrentViewedZoneID));
                        };
                };
            };
        }

        private function HandleSetBuilding(_arg_1:cPlayerData, _arg_2:dGameTickCommandVO):void
        {
            var _local_12:int;
            var _local_3:dServerAction = (_arg_2.data as dServerAction);
            if (!(_local_3.data is SetBuildingVO))
            {
                if (cLog.isInfoEnabled())
                {
                    cLog.info((((("Could not set building #" + _local_3.type) + " at ") + _local_3.grid) + " because Data is not SetBuildingVO"));
                };
                return;
            };
            var _local_4:dUniqueID = (_local_3.data as SetBuildingVO).buffUniqueId;
            var _local_5:dUniqueID = (_local_3.data as SetBuildingVO).buildingUniqueId;
            var _local_6:* = (_arg_2.mode == COMMAND.SET_BUILDING_BY_BUFF);
            var _local_7:* = (_arg_2.mode == COMMAND.SET_BUILDING_PICKUP);
            if (!gCalculations.IsGridInsideMap(this.mCurrentPlayerZone, _local_3.grid))
            {
                if (cLog.isInfoEnabled())
                {
                    cLog.info((((("Could not set building #" + _local_3.type) + " at ") + _local_3.grid) + " because position is not inside map!"));
                };
                return;
            };
            if (!_local_6)
            {
                if (this.mGameTickCommandPlayer.mBuildQueue.IsBuildingAtGridPositionInQueue(_local_3.grid))
                {
                    if (cLog.isInfoEnabled())
                    {
                        cLog.info((((("Could not set building #" + _local_3.type) + " at ") + _local_3.grid) + " because grid entry in buildqueue is duplicated!"));
                    };
                    return;
                };
            };
            var _local_8:cBuilding = mCurrentPlayerZone.GetBuildingFromGridPosition(_local_3.grid);
            if (_local_8 != null)
            {
                if (_local_8.GetBuildingMode() == cBuilding.BUILDING_MODE_PLACED)
                {
                    mCurrentPlayerZone.mStreetDataMap.RemovePrePlaceBuildingGridPos(this.mGameTickCommandPlayer, _local_3.grid);
                }
                else
                {
                    if (cLog.isInfoEnabled())
                    {
                        cLog.info((((("Could not set building #" + _local_3.type) + " at ") + _local_3.grid) + " because there is already a building at this position!"));
                    };
                    return;
                };
            };
            var _local_9:String = global.buildingGroup.GetNameFromNr_string(global.buildingGroup.mGOList_vector, _local_3.type);
            if (((!(_local_6)) && (!(_local_7))))
            {
                if (this.mGameTickCommandPlayer.mBuildQueue.IsFull())
                {
                    if (cLog.isInfoEnabled())
                    {
                        cLog.info((((("Could not set " + _local_9) + " at ") + _local_3.grid) + " because buildqueue is full!"));
                    };
                    return;
                };
                if (this.mGameTickCommandPlayer.IsMaximumBuildingCountReached(_local_9))
                {
                    cLog.info((((("Could not set " + _local_9) + " at ") + _local_3.grid) + " because maximum building limit is reached!"));
                    return;
                };
            };
            var _local_10:cBuff;
            if (_local_6)
            {
                _local_10 = this.mGameTickCommandPlayer.getBuffByUniqueID(_local_4);
                if (_local_10 == null)
                {
                    if (cLog.isInfoEnabled())
                    {
                        cLog.info((("Could not find buff " + _local_4) + "!"));
                    };
                    this.mGameTickCommandPlayer.resetLastFetchedBuff();
                    return;
                };
                if (_local_10.GetResourceName_string() != _local_9)
                {
                    this.mGameTickCommandPlayer.resetLastFetchedBuff();
                    return;
                };
            };
            var _local_11:cBuilding = cBuilding.CreateFromString(this.mGameTickCommandPlayer, global.buildingGroup, _local_9, this);
            if (_local_11 == null)
            {
                if (cLog.isInfoEnabled())
                {
                    cLog.info((((("Could not set " + _local_9) + " at ") + _local_3.grid) + " because building could not be created!"));
                };
                this.mGameTickCommandPlayer.resetLastFetchedBuff();
                return;
            };
            if (((!(_local_6)) && (!(this.mRequirements.buildingRequirements_vector[_local_11.GetBuildingName_string()].isFulfilled()))))
            {
                if (cLog.isInfoEnabled())
                {
                    cLog.info((((("Could not set " + _local_9) + " at ") + _local_3.grid) + " because requirements are not fulfilled!"));
                };
                this.mGameTickCommandPlayer.resetLastFetchedBuff();
                return;
            };
            if (!_local_7)
            {
                _local_12 = mCurrentPlayerZone.IsBuildingPlacableGridPosition(_local_11, this.mGameTickCommandPlayer, _local_3.grid);
                if (_local_12 != 0)
                {
                    if (cLog.isInfoEnabled())
                    {
                        cLog.info(((((("Could not set building " + _local_9) + " at ") + _local_3.grid) + " because IsBuildingPlacableGridPosition() returned ") + ERROR_CODES.toString(_local_12)));
                    };
                    this.mGameTickCommandPlayer.resetLastFetchedBuff();
                    return;
                };
            };
            if (((_local_6) && (!(this.isBuffUpdated(this.mGameTickCommandPlayer.GetPlayerId(), _local_10, 1)))))
            {
                this.mGameTickCommandPlayer.resetLastFetchedBuff();
                return;
            };
            _local_11 = (mCurrentPlayerZone.SetGoAtGridPosition(this.mGameTickCommandPlayer, _local_11, OBJECTTYPE.BUILDING, _local_3.grid) as cBuilding);
            if (_local_11 == null)
            {
                if (cLog.isInfoEnabled())
                {
                    cLog.info((((("Could not set " + _local_9) + " at ") + _local_3.grid) + " because SetGoAtGridPosition() returned null!"));
                };
                this.mGameTickCommandPlayer.resetLastFetchedBuff();
                return;
            };
            _local_11.SetUniqueId(_local_5);
            _local_11.mDirtyIndicator.created();
            if (_local_11.GetResourceCreation() != null)
            {
                _local_11.GetResourceCreation().mDirtyIndicator = (_local_11.GetResourceCreation().mDirtyIndicator | DIRTY_INDICATOR.CREATED_BIT);
            };
            if (_local_6)
            {
                _local_11.SetBuildingMode(cBuilding.BUILDING_MODE_SET_BUILDING_GROUND_PLACE);
            }
            else
            {
                if (!_local_7)
                {
                    this.mGameTickCommandPlayer.mBuildQueue.Add(_local_11);
                    this.mGameTickCommandPlayer.IncBuildingCountAll(_local_11, true);
                };
            };
            if (!_local_6)
            {
                _local_11.mOrigin = cBuilding.BUILDING_ORIGIN_FROM_GAME;
            }
            else
            {
                _local_11.mOrigin = cBuilding.BUILDING_ORIGIN_FROM_BUFF;
                if (gMisc.GetRandomMinMaxInt(1, 100) <= _local_10.GetRecurrentChance())
                {
                    _local_11.SetRecurringChance(_local_10.GetRecurrentChance());
                };
                this.mGameTickCommandPlayer.removeLastFetchedBuff();
                _local_10.DecWaitingForServerCount(this);
                if (this.mGameTickCommandPlayer.GetPlayerId() == mHomePlayer.GetPlayerId())
                {
                    globalFlash.gui.mStarMenu.Refresh();
                };
            };
            cLog.info(((("Building " + _local_9) + " successfully created at ") + _local_3.grid));
            TrackManager.getInstance().trackBuildingPlace(_arg_1, _local_11);
        }

        public function getSkillTree(_arg_1:int, _arg_2:Object):cSkillTree
        {
            var _local_4:dUniqueID;
            var _local_5:cSpecialist;
            var _local_6:int;
            var _local_7:cDeposit;
            var _local_3:cSkillTree;
            switch (_arg_1)
            {
                case SKILL_OWNER.SPECIALIST:
                    _local_4 = (_arg_2 as dUniqueID);
                    _local_5 = mCurrentPlayerZone.getSpecialist(mCurrentViewedZoneID, _local_4);
                    if (_local_5 != null)
                    {
                        _local_3 = _local_5.getSkillTree();
                    };
                    break;
                case SKILL_OWNER.DEPOSIT:
                    _local_6 = (_arg_2 as int);
                    _local_7 = mCurrentPlayerZone.mStreetDataMap.mDepositContainer.get(_local_6);
                    if (_local_7 != null)
                    {
                        _local_3 = _local_7.getSkillTree();
                    };
                    break;
                default:
                    cLog.error("Couldn't interpret ownertype of skilltree!");
            };
            return (_local_3);
        }

        private function donateResourceToGuild(_arg_1:cPlayerData, _arg_2:dBuffVO, _arg_3:int, _arg_4:int, _arg_5:dGameTickCommandVO):int
        {
            var _local_8:String;
            var _local_11:cResources;
            var _local_12:dResource;
            var _local_13:dUniqueID;
            var _local_14:cBuff;
            var _local_6:int;
            var _local_7:Boolean = true;
            var _local_9:int = ERROR_CODES.NO_ERROR;
            var _local_10:dGuildBankTransactionVO = new dGuildBankTransactionVO();
            _local_10.transactionType = GUILD_BANK_TRANSACTION_TYPE.DONATE;
            _local_10.time = new Date().getTime();
            _local_10.tabID = _arg_3;
            _local_10.player = _arg_1.GetPlayerName_string();
            _local_10.tabName = GetCurrentPlayerGuildBank().GetGuildBankTab(_arg_3).name;
            if (_local_9 == ERROR_CODES.NO_ERROR)
            {
                if (_arg_2.buffName_string == defines.DONATE_TEMP_BUFF)
                {
                    _local_11 = mCurrentPlayerZone.GetResourcesForPlayerID(mHomePlayer.GetPlayerId());
                    _local_12 = _local_11.GetPlayerResource(_arg_2.resourceName_string);
                    _local_6 = Math.min(_local_12.getAmount(), _arg_2.getAmount());
                    _local_8 = _arg_2.resourceName_string;
                    if (_local_7)
                    {
                        _local_11.AddResource(_arg_2.resourceName_string, -(_local_6), ModifyReason.DONATION, null);
                        _local_10.amount = _local_6;
                        _local_10.groupType = GUILD_BANK_GROUP.RESOURCE;
                        _local_10.description = _local_8;
                        GetCurrentPlayerGuildBank().AddTransactionHistory(_local_10);
                        GetCurrentPlayerGuildBank().GetGuildBankTab(_arg_3).GetResource(_arg_2.resourceName_string).amount = (GetCurrentPlayerGuildBank().GetGuildBankTab(_arg_3).GetResource(_arg_2.resourceName_string).amount + _local_6);
                        globalFlash.gui.mGuildBankWindow.SetBusy(false);
                        globalFlash.gui.mGuildBankWindow.RefreshResourcesList();
                        globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.RESOURCE_DONATION_SUCCESSFUL, [_arg_2.resourceName_string, _local_6]);
                        globalFlash.gui.mWarehouseInfoPanel.donateResourcePanelController.serverResponseReceived();
                    };
                }
                else
                {
                    _local_13 = dUniqueID.Create(_arg_2.uniqueId1, _arg_2.uniqueId2);
                    _local_14 = _arg_1.getBuffByUniqueID(_local_13);
                    if (_local_14 == null)
                    {
                        cLog.warning(((("Could not find buff " + _local_13) + " from playerID ") + _arg_1.GetPlayerId()));
                        _arg_1.resetLastFetchedBuff();
                        return (cBuff.BUFF_APPLY_ERROR);
                    };
                    _local_6 = _local_14.GetAmount();
                    if (((!(_local_14.GetResourceName_string() == null)) && (_local_14.GetResourceName_string().length > 0)))
                    {
                        _local_8 = ((_local_14.GetType() + ",") + _local_14.GetResourceName_string());
                    }
                    else
                    {
                        _local_8 = _local_14.GetType();
                    };
                    if (_local_7)
                    {
                        _local_10.amount = _local_6;
                        _local_10.groupType = GUILD_BANK_GROUP.BUFF;
                        _local_10.description = _local_8;
                        if (_arg_2.buffName_string == defines.ADD_RESOURCE_BUFF)
                        {
                            GetCurrentPlayerGuildBank().GetGuildBankTab(_arg_3).GetResource(_local_14.GetResourceName_string()).amount = (GetCurrentPlayerGuildBank().GetGuildBankTab(_arg_3).GetResource(_local_14.GetResourceName_string()).amount + _local_6);
                            globalFlash.gui.mGuildBankWindow.SetBusy(false);
                            globalFlash.gui.mGuildBankWindow.RefreshResourcesList();
                            globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.RESOURCE_DONATION_SUCCESSFUL, [_arg_2.resourceName_string, _local_6]);
                        }
                        else
                        {
                            if (_local_7)
                            {
                                _arg_2 = _local_14.CreateBuffVOFromBuff();
                                _arg_2.uniqueId1 = _arg_4;
                                GetCurrentPlayerGuildBank().GetGuildBankTab(_arg_3).AddBuffVOToBankTab(_arg_2);
                                globalFlash.gui.mGuildBankWindow.SetBusy(false);
                                globalFlash.gui.mGuildBankWindow.RefreshResourcesList();
                                _local_14.DecWaitingForServerCount(this);
                                _arg_1.removeLastFetchedBuff();
                                globalFlash.gui.mStarMenu.Refresh();
                                globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.BUFF_DONATION_SUCCESSFUL, [_local_14]);
                            }
                            else
                            {
                                globalFlash.gui.mGuildBankWindow.SetBusy(false);
                                globalFlash.gui.mGuildBankWindow.RefreshResourcesList();
                            };
                        };
                        if (_local_7)
                        {
                        };
                        GetCurrentPlayerGuildBank().AddTransactionHistory(_local_10);
                    }
                    else
                    {
                        _local_7 = false;
                        _arg_1.resetLastFetchedBuff();
                    };
                };
            }
            else
            {
                _local_7 = false;
            };
            if (_local_7)
            {
                channels.RESOURCE.guildbankDonated(_arg_2.resourceName_string, _local_6);
            };
            return (_local_6);
        }

        private function HandleMailsDismissed(_arg_1:cPlayerData, _arg_2:dMailsDismissedVO):void
        {
            var _local_3:dLootItemsVO;
            for each (_local_3 in _arg_2.items)
            {
                this.acceptLoot(_arg_1, _local_3, _arg_2.claim);
            };
            globalFlash.gui.mMailWindow.onMailsDismissed(_arg_2);
        }

        private function HandleOpenAdventCalendarDoor(_arg_1:cPlayerData, _arg_2:dGameTickCommandVO, _arg_3:Boolean):void
        {
            var _local_8:int;
            var _local_9:int;
            var _local_4:dAdventCalendarDoorVO = (_arg_2.data as dAdventCalendarDoorVO);
            var _local_5:dAdventCalendarDoorVO = mAdventCalendarManager.GetDoorById(_local_4.id);
            var _local_6:cResources = mCurrentPlayerZone.GetResources(_arg_1);
            if ((((_arg_3) || (!(_local_5.status == ADVENT_CALENDAR_DOOR_STATUS.CAN_OPEN))) && (!(_local_5.status == ADVENT_CALENDAR_DOOR_STATUS.CAN_OPEN_WITH_GEMS))))
            {
                return;
            };
            if (_arg_3)
            {
                if (!_local_6.HasPlayerResource(defines.HARD_CURRENCY_RESOURCE_NAME_string, _local_5.openGemCost))
                {
                    cLog.error((("E:" + _arg_1.GetPlayerId()) + " Cannot open advent calendar door with gems. Insufficient funds!"));
                    globalFlash.gui.mAdventWindow.ResetDoorWaiting(_local_5);
                    return;
                };
                _local_6.AddResource(defines.HARD_CURRENCY_RESOURCE_NAME_string, -(_local_5.openGemCost), ModifyReason.ADVENT_CALENDAR_DOOR, _local_5.id);
            };
            _local_5.chosenRewardId = _local_4.chosenRewardId;
            _local_5.status = ((_arg_3) ? ADVENT_CALENDAR_DOOR_STATUS.OPENED_WITH_GEMS : ADVENT_CALENDAR_DOOR_STATUS.OPENED);
            if (_local_5.specialType == ADVENT_CALENDAR_DOOR_SPECIAL_TYPE.FINAL_REWARD)
            {
                mAdventCalendarManager.finalReward = _local_5;
            }
            else
            {
                _local_8 = mAdventCalendarManager.calendarDoors.getItemIndex(_local_5);
                mAdventCalendarManager.calendarDoors[_local_8] = _local_5;
            };
            globalFlash.gui.mAdventWindow.ResetDoorWaiting(_local_5);
            globalFlash.gui.mAdventWindow.UpdateGUI();
            mAdventCalendarManager.UpdateHintPointer();
            channels.CALENDAR.send(CalendarChannel.DOOR_OPENED, _local_5);
            var _local_7:EffectVO = (_local_5.rewards.getItemAt(_local_5.chosenRewardId) as EffectVO);
            _local_7.uniqueID = (_local_4.rewards.getItemAt(_local_5.chosenRewardId) as EffectVO).uniqueID;
            _local_7.additionalUniqueIds_vector = (_local_4.rewards.getItemAt(_local_5.chosenRewardId) as EffectVO).additionalUniqueIds_vector;
            _local_7.source = "CalendarDoor";
            this.effectFactory.createEffect(_local_7).apply();
            if (_arg_3)
            {
                _local_9 = _local_6.GetResourceAmount(defines.HARD_CURRENCY_RESOURCE_NAME_string);
                TrackManager.getInstance().trackAdventCalendarDoorOpenedWithGems(_local_5, _arg_1, _local_9);
            }
            else
            {
                TrackManager.getInstance().trackAdventCalendarDoorOpened(_local_5, _arg_1);
            };
        }

        private function handleCreateEpicProductionChain(_arg_1:cPlayerData, _arg_2:dGameTickCommandVO):Boolean
        {
            if (_arg_2.data == null)
            {
                return (false);
            };
            var _local_3:EpicWorkyardCreateProductionChainVO = (_arg_2.data as EpicWorkyardCreateProductionChainVO);
            var _local_4:EpicWorkyardMasterBuilding = (mCurrentPlayerZone.mStreetDataMap.mBuildingContainer.get(_local_3.masterBuildingGridPosition) as EpicWorkyardMasterBuilding);
            if (_local_4 == null)
            {
                LocalLogMessageDetail((("Error at grid '" + _local_3.masterBuildingGridPosition) + "' there is no master epic building!"));
                return (false);
            };
            if (_local_4.getSubBuildings().length >= EpicWorkyardConsts.MAX_SUB_BUILDINGS)
            {
                LocalLogMessageDetail("Error epic building max production chains reached!");
                return (false);
            };
            if (!EpicWorkyardsManager.getInstance().getChainAvailable(this, _local_4.GetBuildingName_string(), _local_3.productionChainSubBuildingName, _local_3.productionChainSubBuildingRank))
            {
                LocalLogMessageDetail("Chain is not yet available!");
                return (false);
            };
            return (this.addEpicWorkyardSubBuildingAtIndex(_local_4.getAvailableSubBuildingGridPosition(), _local_3.productionChainSubBuildingName, _local_3.productionChainSubBuildingRank, _local_4, -1));
        }

        override public function ApplicationResized():void
        {
            cBackbuffer.Init(global.screenWidth, global.screenHeight, false);
            this.ZoomHasChanged();
        }

        private function applyBuff(_arg_1:cPlayerData, _arg_2:dUniqueID, _arg_3:int, _arg_4:int, _arg_5:int, _arg_6:Object):int
        {
            var _local_12:Boolean;
            var _local_7:int = _arg_1.GetPlayerId();
            if (cLog.isInfoEnabled())
            {
                cLog.info(("handleApplyBuff() Buff: " + _arg_2));
            };
            if (_arg_3 < 0)
            {
                _arg_1.resetLastFetchedBuff();
                return (cBuff.BUFF_APPLY_ERROR);
            };
            var _local_8:cBuff = _arg_1.getBuffByUniqueID(_arg_2);
            if (_local_8 == null)
            {
                cLog.warning(((("Could not find buff " + _arg_2) + " from playerID ") + _local_7));
                _arg_1.resetLastFetchedBuff();
                return (cBuff.BUFF_APPLY_ERROR);
            };
            var _local_9:Object = _local_8.IsApplyable(_arg_1, this, _arg_5);
            if (!((_local_9 is cGO) || ((_local_9 is String) && ((_local_9 as String) == BUFF_TYPE.toString(BUFF_TYPE.ZONE_TIMED)))))
            {
                if (_arg_3 > 0)
                {
                    _local_8.SetWaitingForServerCount((_local_8.GetWaitingForServerCount() - _arg_3), this);
                }
                else
                {
                    _local_8.DecWaitingForServerCount(this);
                };
                cLog.info((((((("E:" + _local_7) + " Could not apply buff ") + _arg_2) + " at ") + _arg_5) + " because buff needs target but game object was null!"));
                _arg_1.resetLastFetchedBuff();
                return (cBuff.BUFF_APPLY_ERROR);
            };
            if (((_local_9 is String) && ((_local_9 as String) == BUFF_TYPE.toString(BUFF_TYPE.ZONE_TIMED))))
            {
                _local_9 = new cGO(this);
            };
            var _local_10:cGO = (_local_9 as cGO);
            var _local_11:int = _local_8.calculateBuffResult(_arg_1, this, _local_10, _arg_3, _arg_6);
            if (cLog.isInfoEnabled())
            {
                cLog.info(((("calculateBuffResult(" + _local_10) + ") returned ") + _local_11));
            };
            if (_local_11 == cBuff.BUFF_APPLY_ERROR)
            {
                if (_arg_3 > 0)
                {
                    _local_8.SetWaitingForServerCount((_local_8.GetWaitingForServerCount() - _arg_3), this);
                }
                else
                {
                    _local_8.DecWaitingForServerCount(this);
                };
                if (cLog.isInfoEnabled())
                {
                    cLog.info((((("Could not apply buff " + _arg_2) + " at ") + _arg_5) + " because buffResult was BUFF_APPLY_ERROR!"));
                };
                _arg_1.resetLastFetchedBuff();
                return (cBuff.BUFF_APPLY_ERROR);
            };
            if (_arg_3 > 0)
            {
                _local_8.SetWaitingForServerCount((_local_8.GetWaitingForServerCount() - _arg_3), this);
            }
            else
            {
                _local_8.DecWaitingForServerCount(this);
            };
            if (((_local_8.GetBuffDefinition().getIsNotUpdatable()) || (this.isBuffUpdated(_local_7, _local_8, _local_11))))
            {
                _local_12 = false;
                if (!_local_8.applyBuffResultToZone(_arg_1, this, _local_10, _local_11, _arg_4))
                {
                    cLog.warning((("Could not apply buff " + _arg_2) + " on zone!"));
                    _local_12 = true;
                };
                channels.BUFF.send(cBuff.BUFF_APPLIED_string, new BuffAppliedNotification(_local_8, _local_10, _local_11, _arg_1.GetPlayerId()));
                this.removeBuffFromPlayerData(_arg_1, _local_8);
                if ((_arg_6 is dIntegerVO))
                {
                    (_arg_6 as dIntegerVO).value = ((_arg_6 as dIntegerVO).value + _local_8.getRemoveUnitsAmount());
                };
                if (_arg_1.getPlayerID() != mCurrentViewedZoneID)
                {
                    if (IsAdventureZone())
                    {
                        channels.BUFF.send(TRIGGER_ACTION.ACTION_BUFF_APPLIED_ON_ADVENTURE_string, new BuffAppliedNotification(_local_8, _local_10, _local_11, _local_10.getPlayerID()));
                    }
                    else
                    {
                        channels.BUFF.send(TriggerUtils.BUFF_RECEIVED_FROM_FRIEND_PROPERTY_NAME, new BuffAppliedNotification(_local_8, _local_10, _local_11, _local_10.getPlayerID()));
                    };
                };
                if (_local_12)
                {
                    return (cBuff.BUFF_APPLY_ERROR);
                };
            }
            else
            {
                return (cBuff.BUFF_APPLY_ERROR);
            };
            this.handleApplyBuffGUI(_local_7, _local_8);
            if ((_local_10 is cIsoGO))
            {
                delete global.buffingBlockedUntil[(_local_10 as cIsoGO).GetGrid()];
                mCurrentCursor.invalidateBuffTarget((_local_10 as cIsoGO).GetGrid());
            };
            return (cBuff.BUFF_APPLY_SUCCESS);
        }

        public function handleApplyBuffGUI(_arg_1:int, _arg_2:cBuff):void
        {
            cSoundManager.getInstance().playEffect("BuffPlace", _arg_2.GetBuffDefinition().GetName_string());
            if (_arg_1 == mHomePlayer.GetPlayerId())
            {
                globalFlash.gui.mStarMenu.RefreshBuff(_arg_2);
            };
            if (((mCurrentCursor.mCurrentBuff == _arg_2) && (_arg_2.GetAmount() == 0)))
            {
                mCurrentCursor.SetCursorEditMode(COMMAND.SELECT_BUILDING);
            };
        }

        public function UpdateGuiOnZoneLoad():void
        {
            mCurrentCursor.SetCursorEditMode(COMMAND.SELECT_BUILDING);
            globalFlash.gui.UpdateGuiOnZoneLoad();
        }

        private function handleGuildTransferResource(_playerData:cPlayerData, event:dGameTickCommandVO):void
        {
            var transfer:dGuildBankTransferVO;
            var buff:dBuffVO;
            var tabID:int;
            var targetTabID:int;
            var description:String;
            var spentAmount:int;
            var accepted:Boolean;
            var transaction:dGuildBankTransactionVO;
            var cbuff:cBuff;
            var oldUniqueId1:int;
            var i:int;
            var gbuff:cBuff;
            var guildBuff:cBuff;
            try
            {
                transfer = (event.data as dGuildBankTransferVO);
                buff = transfer.buff;
                tabID = transfer.tabId;
                targetTabID = transfer.targetTabId;
                spentAmount = 0;
                accepted = true;
                transaction = new dGuildBankTransactionVO();
                transaction.transactionType = GUILD_BANK_TRANSACTION_TYPE.TRANSFER;
                transaction.time = new Date().getTime();
                transaction.tabID = tabID;
                transaction.targetTabID = targetTabID;
                transaction.player = _playerData.GetPlayerName_string();
                transaction.tabName = GetCurrentPlayerGuildBank().GetGuildBankTab(tabID).name;
                transaction.targetTabName = GetCurrentPlayerGuildBank().GetGuildBankTab(targetTabID).name;
                if (buff.buffName_string == defines.TRANSFER_TEMP_BUFF)
                {
                    spentAmount = buff.getAmount();
                    description = buff.resourceName_string;
                    transaction.amount = spentAmount;
                    transaction.groupType = GUILD_BANK_GROUP.RESOURCE;
                    transaction.description = description;
                    if (accepted)
                    {
                        GetCurrentPlayerGuildBank().AddTransactionHistory(transaction);
                        GetCurrentPlayerGuildBank().GetGuildBankTab(tabID).GetResource(buff.resourceName_string).amount = (GetCurrentPlayerGuildBank().GetGuildBankTab(tabID).GetResource(buff.resourceName_string).amount - spentAmount);
                        GetCurrentPlayerGuildBank().GetGuildBankTab(targetTabID).GetResource(buff.resourceName_string).amount = (GetCurrentPlayerGuildBank().GetGuildBankTab(targetTabID).GetResource(buff.resourceName_string).amount + spentAmount);
                        globalFlash.gui.mGuildBankWindow.SetBusy(false);
                        globalFlash.gui.mGuildBankWindow.RefreshResourcesList();
                        globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.RESOURCE_TRANSFER_SUCCESSFUL, [buff.resourceName_string, spentAmount]);
                    }
                    else
                    {
                        globalFlash.gui.mGuildBankWindow.SetBusy(false);
                        globalFlash.gui.mGuildBankWindow.RefreshResourcesList();
                    };
                }
                else
                {
                    cbuff = cBuff.CreateBuffFromVO(buff);
                    description = ((cbuff.GetType() + ",") + cbuff.GetResourceName_string());
                    transaction.amount = spentAmount;
                    transaction.groupType = GUILD_BANK_GROUP.BUFF;
                    transaction.description = description;
                    if (accepted)
                    {
                        GetCurrentPlayerGuildBank().AddTransactionHistory(transaction);
                        oldUniqueId1 = buff.uniqueId1;
                        for each (gbuff in GetCurrentPlayerGuildBank().GetGuildBankTab(tabID).GetSortedBuffs())
                        {
                            if (gbuff.GetUniqueId().uniqueID1 == oldUniqueId1) break;
                            i = (i + 1);
                        };
                        guildBuff = (GetCurrentPlayerGuildBank().GetGuildBankTab(tabID).GetSortedBuffs().splice(i, 1)[0] as cBuff);
                        guildBuff.GetUniqueId().uniqueID1 = transfer.newGuildUniqueID;
                        GetCurrentPlayerGuildBank().GetGuildBankTab(targetTabID).AddBuffToBankTab(guildBuff);
                        globalFlash.gui.mGuildBankWindow.SetBusy(false);
                        globalFlash.gui.mGuildBankWindow.RefreshResourcesList();
                        globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.BUFF_TRANSFER_SUCCESSFUL, [cbuff]);
                    };
                };
            }
            finally
            {
            };
        }

        override public function MouseWheel(_arg_1:MouseEvent):void
        {
            if (!IsActiveAndInputActive())
            {
                return;
            };
            mCurrentPlayerZone.MouseWheel(_arg_1);
        }

        public function hireMilitaryUnits(_arg_1:int, _arg_2:cSpecialist, _arg_3:String, _arg_4:int):void
        {
            var _local_5:dSquadVO = new dSquadVO().init(_arg_3, _arg_4, cMilitaryUnitDescription.GetUnitDescriptionForType(_arg_3).GetHitPoints());
            _arg_2.GetArmy().AddSquadVO(_local_5, true);
            var _local_6:* = (!(mCurrentPlayer.GetPlayerId() == _arg_1));
            var _local_7:int = _arg_4;
            var _local_8:* = (!(_arg_3 in mCurrentPlayerZone.mHiredTroopsPool));
            if (_local_8)
            {
                if (!_local_6)
                {
                    mCurrentPlayerZone.mHiredTroopsPool[_arg_3] = _local_7;
                };
            }
            else
            {
                if (!_local_6)
                {
                    mCurrentPlayerZone.mHiredTroopsPool[_arg_3] = (mCurrentPlayerZone.mHiredTroopsPool[_arg_3] + _local_7);
                };
            };
            if (!_local_6)
            {
                globalFlash.gui.mHiredTroopsPoolPanel.SetData(mCurrentPlayerZone.mHiredTroopsPool);
            };
        }

        public function forceZonePersistence(_arg_1:int):void
        {
        }

        public function ServerLoadedFinished():void
        {
            globalFlash.gui.mEventInfoPanel.StartLoadingInfoState();
            if (isOnHomzone())
            {
                globalFlash.gui.mEventInfoPanel.Show();
            };
        }

        public function ActivateChatWindow(_arg_1:Boolean):void
        {
            this.mChatWindowActive = _arg_1;
        }

        private function handleResetSkillpoints(_arg_1:dGameTickCommandVO):void
        {
            var _local_4:cResources;
            var _local_5:int;
            var _local_2:ResetSkillsVO = (_arg_1.data as ResetSkillsVO);
            var _local_3:cSkillTree = this.getSkillTree(_local_2.owner, _local_2.ownerID);
            if (_local_3 != null)
            {
                _local_4 = mCurrentPlayerZone.GetResources(mCurrentPlayer);
                if (((!(_local_2.premium)) || (_local_4.HasPlayerResource(defines.HARD_CURRENCY_RESOURCE_NAME_string, _local_3.getResetCosts()))))
                {
                    _local_3.resetSkillpoints(_local_2);
                    channels.SPECIALIST.notifyPropertyObserver(TriggerUtils.SKILL_CHANGED_PROPERTY_NAME, _local_3);
                    _local_5 = _local_4.GetResourceAmount(defines.HARD_CURRENCY_RESOURCE_NAME_string);
                    TrackManager.getInstance().trackResetSkillTree(mCurrentPlayer, _local_3, _local_2, _local_5);
                }
                else
                {
                    cLog.error(("Reset Skill without enough HardCurrency. Cheater or Bug! Player:" + _arg_1.playerID));
                };
            };
        }

        private function ShowDebugString(_arg_1:String):void
        {
            globalFlash.gui.WriteDebugText(cBackbuffer.mBackBuffer, _arg_1, mDebugTextXPos, (mDebugTextYPos = (mDebugTextYPos + 10)));
        }

        override public function SelectBuilding(_arg_1:cBuilding):void
        {
            var _local_3:cSpecialistTask_AttackBuildingNewCombat;
            var _local_4:dAdventureClientInfoVO;
            var _local_5:cAdventureDefinition;
            var _local_6:cSpecialist;
            var _local_7:cBasicInfoPanel;
            if (_arg_1 == null)
            {
                return;
            };
            mCurrentlySelectededBuilding = _arg_1;
            cSoundManager.getInstance().playEffect("SelectBuilding", _arg_1.GetBuildingName_string());
            if (mCurrentlySelectededBuilding.handleSelectBuilding())
            {
                return;
            };
            var _local_2:cSpecialist;
            if (((mIsDefenseMode) && (_arg_1.IsDefenseModeGhostGarrison())))
            {
                globalFlash.gui.mToolboxPanel.Show();
            }
            else
            {
                if (_arg_1.IsDefenseModeGarrison())
                {
                    globalFlash.gui.mDefenseBuildingPanel.SetData(_arg_1, defines.DEFENSE_POINT_NAME_string);
                    globalFlash.gui.mDefenseBuildingPanel.Show();
                }
                else
                {
                    if (_arg_1.getPlayerID() != mCurrentPlayer.GetPlayerId())
                    {
                        if (((!(_arg_1.mIsEventMonster)) || (IsAdventureZone())))
                        {
                            if (UsesCombatThree())
                            {
                                for each (_local_2 in mCurrentPlayerZone.GetSpecialists_vector())
                                {
                                    if (((!(_local_2.GetTask() == null)) && (_local_2.GetTask().GetType() == SPECIALIST_TASK_TYPES.ATTACK_BUILDING_NEW_COMBAT)))
                                    {
                                        _local_3 = cSpecialistTask_AttackBuildingNewCombat(_local_2.GetTask());
                                    };
                                };
                            }
                            else
                            {
                                if (_arg_1.GetArmy())
                                {
                                    _local_4 = AdventureManager.getInstance().getAdventure(global.getApplication().mGameInterface.mCurrentViewedZoneID);
                                    if (_local_4)
                                    {
                                        _local_5 = cAdventureDefinition.FindAdventureDefinition(_local_4.adventureName);
                                        if (((_local_5) && ((_local_5.IsBuffAdventure()) || ((_local_5.IsMixedAdventure()) && (_arg_1.GetArmy().HasInvincibleUnits())))))
                                        {
                                            globalFlash.gui.mCombatScenarioToolTip.SetDataByClick(_arg_1);
                                            globalFlash.gui.mCombatScenarioToolTip.Show();
                                        };
                                    };
                                }
                                else
                                {
                                    globalFlash.gui.mEnemyBuildingInfoPanel.SetData(_arg_1);
                                    globalFlash.gui.mEnemyBuildingInfoPanel.Show();
                                };
                            };
                        }
                        else
                        {
                            if (_arg_1.GetBuildingMode() != cBuilding.BUILDING_MODE_EPIC_MONSTER_DYING_EFFECT)
                            {
                                globalFlash.gui.mEventMonster.SetData(_arg_1);
                                globalFlash.gui.mEventMonster.Show();
                            };
                        };
                    }
                    else
                    {
                        if (_arg_1.isGarrison())
                        {
                            if (_arg_1.IsBuildingActive())
                            {
                                _local_6 = null;
                                for each (_local_2 in mCurrentPlayerZone.GetSpecialists_vector())
                                {
                                    if (_local_2.GetGarrisonGridIdx() == _arg_1.GetGrid())
                                    {
                                        _local_6 = _local_2;
                                        break;
                                    };
                                };
                                if (_local_6 != null)
                                {
                                    globalFlash.gui.mSpecialistPanel.SetData(_local_6);
                                    globalFlash.gui.mSpecialistPanel.Show();
                                }
                                else
                                {
                                    gMisc.Assert(false, ("There is a garrison without general: " + _arg_1));
                                };
                            }
                            else
                            {
                                cLog.warning("Cannot manage army whose garrison is not ready. TODO: Create a special window.");
                            };
                        }
                        else
                        {
                            if (StringUtils.startsWith(_arg_1.GetBuildingName_string(), defines.DESTROYABLE_MOUNTAIN_string))
                            {
                                globalFlash.gui.mMountainInfoPanel.SetData(_arg_1);
                                globalFlash.gui.mMountainInfoPanel.Show();
                            }
                            else
                            {
                                if (_arg_1.GetBuildingMode() != cBuilding.BUILDING_MODE_MOVING)
                                {
                                    if (!_arg_1.IsBuildingActive())
                                    {
                                        globalFlash.gui.mConstructionInfoPanel.SetData(_arg_1);
                                        globalFlash.gui.mConstructionInfoPanel.Show();
                                    }
                                    else
                                    {
                                        _local_7 = globalFlash.gui.GetInfoPanel(_arg_1.GetBuildingName_string());
                                        _local_7.SetData(_arg_1);
                                        this.channels.BUILDING.send("buildingSelected", _arg_1);
                                        _local_7.Show();
                                        mCurrentlySelectededBuilding = _arg_1;
                                    };
                                };
                            };
                        };
                    };
                };
            };
            mQuestClientCallbacks.BuildingSelectedGui(_arg_1);
        }

        private function HandlePayForQuestFinish(_arg_1:cPlayerData, _arg_2:dGameTickCommandVO):void
        {
            var _local_4:Boolean;
            var _local_5:cResources;
            var _local_6:Vector.<dResource>;
            var _local_7:Vector.<cSquad>;
            var _local_8:int;
            var _local_9:dQuestDefinitionTriggerVO;
            var _local_10:dResource;
            var _local_11:cSquad;
            var _local_12:cSquad;
            var _local_13:Boolean;
            var _local_14:int;
            var _local_15:int;
            var _local_16:dQuestTriggerVO;
            var _local_3:dQuestElementVO = (_arg_2.data as dQuestElementVO);
            if (IsCurrentPlayerQuestPlayer())
            {
                _local_4 = true;
                _local_5 = mCurrentPlayerZone.GetResources(_arg_1);
                _local_6 = new Vector.<dResource>();
                _local_7 = new Vector.<cSquad>();
                _local_8 = 0;
                while (_local_8 < _local_3.mQuestDefinition.questTriggers_vector.length)
                {
                    _local_9 = _local_3.mQuestDefinition.questTriggers_vector[_local_8];
                    if (((_local_3.GetTriggerStatus(_local_9.triggerIdx) == 0) && (_local_9.type == QuestManagerStatic.TYPE_PAY_FOR_QUEST_FINISH)))
                    {
                        if (global.resourceDefinitions_vector.indexOf(_local_9.name_string) != -1)
                        {
                            if (_local_5.HasPlayerResource(_local_9.name_string, _local_9.amount))
                            {
                                _local_10 = new dResource();
                                _local_10.name_string = _local_9.name_string;
                                _local_10.amount = _local_9.amount;
                                _local_6.push(_local_10);
                            }
                            else
                            {
                                _local_4 = false;
                                break;
                            };
                        }
                        else
                        {
                            _local_11 = mCurrentPlayerZone.GetArmy(mCurrentPlayer.GetPlayerId()).GetSquad(_local_9.name_string);
                            if (((!(_local_11 == null)) && (_local_11.amount >= _local_9.amount)))
                            {
                                _local_7.push(new cSquad(_local_9.name_string, _local_9.amount, 0, false));
                            }
                            else
                            {
                                _local_4 = false;
                                break;
                            };
                        };
                    };
                    _local_8++;
                };
                if (((_local_4) && ((_local_6.length > 0) || (_local_7.length > 0))))
                {
                    _local_5._RemovePlayerResourcesFromResourcesInList(_local_6, 1, ModifyReason.PAY_FOR_QUEST_FINISH, true);
                    for each (_local_12 in _local_7)
                    {
                        _local_15 = mCurrentPlayerZone.GetArmy(mCurrentPlayer.GetPlayerId()).RemoveUnits(_local_12.name_string, _local_12.amount);
                        _local_5.ModifyMilitaryPopulationResource(-(_local_15));
                    };
                    _local_3.SetAllTriggersToWon(QuestManagerStatic.TYPE_PAY_FOR_QUEST_FINISH);
                    _local_13 = true;
                    _local_14 = 0;
                    while (_local_14 < _local_3.GetQuestTriggersFinished_vector().length)
                    {
                        _local_16 = _local_3.mQuestTriggersFinished_vector[_local_14];
                        if (_local_16.status == 0)
                        {
                            _local_13 = false;
                            break;
                        };
                        _local_14++;
                    };
                    if (_local_13)
                    {
                        _local_3.FinishQuest(this);
                        return;
                    };
                };
            };
            _local_3.SetQuestMode(QuestManagerStatic.QUEST_MODE_RUNNING);
        }

        private function handleAcceptTrade(_playerData:cPlayerData, _gameTickCommand:dGameTickCommandVO):Boolean
        {
            var resource:dResource;
            var freeAmount:int;
            if (cLog.isInfoEnabled())
            {
                cLog.info(((("Accepting trade " + _gameTickCommand.data) + " at ") + _gameTickCommand.time));
            };
            if (!(_gameTickCommand.data is dAcceptTradeVO))
            {
                this.cancelTrade(null, null, _playerData);
                return (false);
            };
            var acceptTradeVO:dAcceptTradeVO = (_gameTickCommand.data as dAcceptTradeVO);
            var playerID:int = _playerData.GetPlayerId();
            var resources:cResources = mCurrentPlayerZone.GetResources(_playerData);
            var tradeOfferRes:dResourceVO;
            var tradeCostsRes:dResourceVO;
            var tradeCostsBuff:dBuffVO;
            var tradeOfferResAmountToAdd:int;
            var buffToPayWith:cBuff;
            var buffToPayWithResult:int = cBuff.BUFF_APPLY_ERROR;
            var newBuffVO:dBuffVO;
            var newBuff:cBuff;
            var tradeAccept_string:String;
            var tradeAcceptType:int = -1;
            var lotsRemaining:int;
            if (playerID != mHomePlayer.GetPlayerId())
            {
                this.cancelTrade(null, acceptTradeVO, _playerData);
                return (false);
            };
            if ((acceptTradeVO.offer is dResourceVO))
            {
                tradeOfferRes = (acceptTradeVO.offer as dResourceVO);
                resource = resources.GetPlayerResource(tradeOfferRes.name_string);
                freeAmount = (resource.maxLimit - resource.amount);
                if (tradeOfferRes.amount <= freeAmount)
                {
                    tradeOfferResAmountToAdd = tradeOfferRes.amount;
                }
                else
                {
                    tradeOfferResAmountToAdd = freeAmount;
                    newBuffVO = new dBuffVO();
                    newBuffVO.buffName_string = "AddResource";
                    newBuffVO.resourceName_string = tradeOfferRes.name_string;
                    newBuffVO.amount = (tradeOfferRes.amount - tradeOfferResAmountToAdd);
                    newBuffVO.uniqueId1 = acceptTradeVO.uniqueID.uniqueID1;
                    newBuffVO.uniqueId2 = acceptTradeVO.uniqueID.uniqueID2;
                    newBuff = cBuff.CreateBuffFromVO(newBuffVO);
                };
            }
            else
            {
                if ((acceptTradeVO.offer is dBuffVO))
                {
                    newBuffVO = (acceptTradeVO.offer as dBuffVO);
                    newBuffVO.uniqueId1 = acceptTradeVO.uniqueID.uniqueID1;
                    newBuffVO.uniqueId2 = acceptTradeVO.uniqueID.uniqueID2;
                    newBuff = cBuff.CreateBuffFromVO(newBuffVO);
                };
            };
            if ((acceptTradeVO.costs is dResourceVO))
            {
                tradeCostsRes = (acceptTradeVO.costs as dResourceVO);
                if (!resources.HasPlayerResource(tradeCostsRes.name_string, tradeCostsRes.amount))
                {
                    this.cancelTrade(null, acceptTradeVO, _playerData);
                    return (false);
                };
                tradeAccept_string = (((tradeCostsRes.name_string + ",") + tradeCostsRes.amount) + "|@|0");
                tradeAcceptType = TRADE_TYPE.TRADE_RES_FOR_RES;
            }
            else
            {
                if ((acceptTradeVO.costs is dBuffVO))
                {
                    tradeCostsBuff = (acceptTradeVO.costs as dBuffVO);
                    buffToPayWith = _playerData.getBuffByBuffVO(tradeCostsBuff);
                    if (buffToPayWith == null)
                    {
                        this.cancelTrade(null, acceptTradeVO, _playerData);
                        return (false);
                    };
                    buffToPayWithResult = tradeCostsBuff.amount;
                    tradeAccept_string = (((buffToPayWith.GetType() + ",") + buffToPayWith.GetResourceName_string()) + ",");
                    tradeAccept_string = (tradeAccept_string + buffToPayWithResult);
                    if (buffToPayWith.GetRecurrentChance() > 0)
                    {
                        tradeAccept_string = (tradeAccept_string + ("," + buffToPayWith.GetRecurrentChance()));
                    };
                    tradeAccept_string = (tradeAccept_string + "|@|0");
                    tradeAcceptType = TRADE_TYPE.TRADE_BUFF_FOR_RES;
                };
            };
            try
            {
                if (acceptTradeVO.slotType != TRADE_SLOT_TYPE.FRIEND_TO_FRIEND)
                {
                    globalFlash.gui.mTradeWindow.setTradeStatus("TradeSucess");
                    globalFlash.gui.mTradeWindow.setWaitingForServer(false);
                };
            }
            catch(error:Error)
            {
                cLog.error(("A database error ocurred while accepting trade: " + error));
            };
            if (tradeCostsRes != null)
            {
                if (!resources.AddResource(tradeCostsRes.name_string, -(tradeCostsRes.amount), ModifyReason.TRADE, null))
                {
                    this.cancelTrade(null, acceptTradeVO, _playerData);
                    return (false);
                };
            }
            else
            {
                if (tradeCostsBuff != null)
                {
                    if (!buffToPayWith.applyBuffResultToBuff(_playerData, this, buffToPayWithResult))
                    {
                        this.cancelTrade(null, acceptTradeVO, _playerData);
                        return (false);
                    };
                    if (((buffToPayWith.isDeleted()) || (buffToPayWith.GetAmount() <= 0)))
                    {
                        _playerData.removeLastFetchedBuff();
                    };
                };
            };
            if (tradeOfferResAmountToAdd != 0)
            {
                resources.AddResource(tradeOfferRes.name_string, tradeOfferResAmountToAdd, ModifyReason.TRADE, null);
                globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.TRADE_ACCEPTED_WAREHOUSE);
                if (tradeOfferResAmountToAdd < tradeOfferRes.amount)
                {
                    globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.TRADED_RESOURCE_LIMIT_REACHED, tradeOfferRes);
                };
            };
            if (newBuff != null)
            {
                _playerData.addBuff(newBuff);
                if ((acceptTradeVO.offer is dBuffVO))
                {
                    globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.TRADE_ACCEPTED_BUFF);
                };
            };
            _playerData.mTradeData.updateHistoryWithBoughtTrade(acceptTradeVO);
            if (((!(newBuff == null)) || (!(tradeCostsBuff == null))))
            {
                globalFlash.gui.mStarMenu.Refresh();
            };
            TrackManager.getInstance().trackTradeAccepted(_playerData, acceptTradeVO, tradeCostsRes, tradeCostsBuff, tradeOfferRes, newBuffVO, lotsRemaining);
            return (true);
        }

        private function HandleAddHardCurrency(_arg_1:cPlayerData, _arg_2:dGameTickCommandVO, _arg_3:int):Boolean
        {
            var _local_4:dHardCurrencyPurchased = (_arg_2.data as dHardCurrencyPurchased);
            mCurrentPlayerZone.GetResources(_arg_1).AddResource(defines.HARD_CURRENCY_RESOURCE_NAME_string, _local_4.mAmount, _arg_3, null);
            if (_local_4.mResetUser)
            {
                TrackManager.getInstance().trackGemReset(_arg_1, defines.CURRENCY_GEMS, _local_4.mAmount, mCurrentPlayerZone.GetResources(_arg_1).GetPlayerResource(defines.HARD_CURRENCY_RESOURCE_NAME_string).amount);
            }
            else
            {
                TrackManager.getInstance().trackGemPurchased(_arg_1, defines.CURRENCY_GEMS, _local_4.mAmount, mCurrentPlayerZone.GetResources(_arg_1).GetPlayerResource(defines.HARD_CURRENCY_RESOURCE_NAME_string).amount, ((_local_4.mTransactionId != null) ? "Webshop" : "Support"));
            };
            return (true);
        }

        private function HandleStartTimedProduction(_arg_1:cPlayerData, _arg_2:dGameTickCommandVO):void
        {
            var _local_5:dTimedProductionVO;
            var _local_6:Vector.<cBuilding>;
            var _local_7:cBuffDefinition;
            var _local_8:iTimedProductionDefinition;
            var _local_9:EffectTimedProductionDefinition;
            var _local_3:ArrayCollection = (_arg_2.data as ArrayCollection);
            var _local_4:cTimedProductionUtl = new cTimedProductionUtl(this);
            for each (_local_5 in _local_3)
            {
                _local_4.startTimedProduction(_local_5);
                mCurrentPlayerZone.GetProductionQueue(_local_5.productionType).SetWaitingForServer(false);
                if (TIMED_PRODUCTION_TYPE.isCultureBuilding(_local_5.productionType))
                {
                    _local_6 = mCurrentPlayerZone.mStreetDataMap.GetBuildingForProductionType(_local_5.productionType);
                    for each (_local_8 in global.timedProductions_vector[_local_5.productionType])
                    {
                        if (_local_8.GetType() == _local_5.type_string)
                        {
                            _local_9 = (_local_8 as EffectTimedProductionDefinition);
                            _local_7 = cBuffDefinition.GetByName(_local_9.effects_vector[0].name_string);
                        };
                    };
                    if (_local_6.length > 0)
                    {
                        cooldownManager.setCooldown(COOLDOWN_TYPE.fromTimedProduction(_local_6[0].productionType), _local_7.GetCultureBuildingCooldown());
                        globalFlash.gui.mCultureBuildingPanel.SetIsWaitingForServer(false);
                    };
                };
            };
        }

        private function handlePickupDataUpdate(_arg_1:dGameTickCommandVO):void
        {
            var _local_3:String;
            var _local_4:dQuestElementVO;
            var _local_2:PickupsDataVO = (_arg_1.data as PickupsDataVO);
            for each (_local_3 in CollectionsManager.getInstance().getQuestsToResetAtPickupGeneration(_local_2.generatedPickupsType))
            {
                _local_4 = mNewQuestManager.getQuest(_local_3);
                if (_local_4 != null)
                {
                    if (_local_2.numberOfGeneratedPickups > 0)
                    {
                        if (_local_4.GetQuestMode() != QuestManagerStatic.QUEST_MODE_RUNNING)
                        {
                            _local_4.ResetQuestFinishedTriggersRestartMode();
                            _local_4.StartQuest();
                        };
                    }
                    else
                    {
                        _local_4.SetQuestMode(QuestManagerStatic.QUEST_MODE_DEACTIVATED);
                    };
                };
            };
            mCurrentPlayerZone.mStreetDataMap.setInitialNumberOfPickups(_local_2.generatedPickupsType, _local_2.numberOfGeneratedPickups);
        }

        public function IsChatWindowActive():Boolean
        {
            return (this.mChatWindowActive);
        }

        private function ShowIngameErrorMessages():void
        {
        }

        private function handleSetSkillpoints(_arg_1:dGameTickCommandVO):void
        {
            var _local_4:ChangeSkillsVO;
            var _local_2:ChangeSkillsVO = (_arg_1.data as ChangeSkillsVO);
            var _local_3:cSkillTree = this.getSkillTree(_local_2.owner, _local_2.ownerID);
            if (_local_3 != null)
            {
                _local_4 = _local_3.applyVO(_local_2);
                channels.SPECIALIST.notifyPropertyObserver(TriggerUtils.SKILL_CHANGED_PROPERTY_NAME, _local_3);
                TrackManager.getInstance().trackUseSkillPoint(mCurrentPlayer, _local_3, _local_4);
            };
        }

        public function EnableShopItem(_arg_1:int):void
        {
            this.mEnabledShopItems_vector.add(_arg_1);
        }

        private function handleGetComparedUserAchievements(_arg_1:dGameTickCommandVO):void
        {
            var _local_2:UserAchievementDataVO = (_arg_1.data as UserAchievementDataVO);
            if (_local_2 != null)
            {
                addComparedUserAchievementManager(_local_2);
            };
        }

        private function RemoveTemporaryBuildSlot(_arg_1:cPlayerData, _arg_2:dGameTickCommandVO):Boolean
        {
            var _local_3:Number = (_arg_2.data as dTempBuildSlotVO).timeOfPurchase;
            var _local_4:dTempBuildSlotVO;
            var _local_5:Vector.<dTempBuildSlotVO> = _arg_1.mAvailableTempSlots_vector;
            var _local_6:int;
            while (((_local_6 < _local_5.length) && (_local_4 == null)))
            {
                if (_local_5[_local_6].timeOfPurchase == _local_3)
                {
                    _local_4 = _local_5[_local_6];
                    break;
                };
                _local_6++;
            };
            if (_local_4 == null)
            {
                cLog.error(((("E:" + _arg_1.GetPlayerId()) + " Could not find tempbuild slot  ") + _local_3));
                return (false);
            };
            _arg_1.mAvailableTempSlots_vector.splice(_local_6, 1);
            globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.TEMP_BUILD_SLOT_REMOVED);
            return (true);
        }


    }
}
