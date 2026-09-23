package Interface
{
    import nLib.cNLibInterface;
    import flash.events.IEventDispatcher;
    import GO.cBuilding;
    import GO.cGO;
    import Achievements.UserAchievementManager;
    import Trigger.TimedTriggerManager;
    import flash.utils.Dictionary;
    import ZoneBuff.ZoneBuffManager;
    import com.bluebyte.tso.genericvalues.GenericValueManager;
    import __AS3__.vec.Vector;
    import com.bluebyte.tso.conditionsystem.logic.ConditionManager;
    import GO.epicWorkyard.EpicWorkyardAutoUpgrader;
    import GameEvent.GameEventManager;
    import converted.bluebyte.tso.contentgenerator.logic.ContentGeneratorManager;
    import AdventureSystem.AdventureLootMediator;
    import ServerState.cPlayerData;
    import Communication.VO.dZoneVO;
    import converted.bluebyte.tso.reaction.ReactionManager;
    import Communication.VO.dZoneCheckVO;
    import Communication.VO.dPersistedBuffApplianceVO;
    import mx.formatters.DateFormatter;
    import ItemRegistry.ItemRegistry;
    import Communication.VO.Guild.dGuildVO;
    import com.bluebyte.tso.cooldown.CooldownManager;
    import Communication.VO.dClientDateVO;
    import Skill.cSkillList;
    import Tasks.TaskManager;
    import flash.events.EventDispatcher;
    import Communication.VO.dGameTickCommandVO;
    import com.bluebyte.tso.logic.PickupManager;
    import Tasks.TaskBuildingMapObserver;
    import com.bluebyte.tso.server.KillSwitch;
    import Map.cPlayerZoneScreen;
    import ZoneBuff.ZoneSpecialistActivity;
    import Model.Channels;
    import Model.Notifiers.InputNotifier;
    import Trigger.TriggerActions;
    import com.bluebyte.tso.quests.logic.QuestClientCallbacks;
    import converted.bluebyte.tso.quests.logic.IQuestManager;
    import Events.EventManager;
    import AdventCalendar.AdventCalendarManager;
    import Votes.VotesManager;
    import ShopSystem.cShopUtl;
    import ServerState.cServer;
    import GuildSystem.cGuildBank;
    import ServerState.cDataTracking;
    import ServerState.cComputeResourceCreation;
    import ServerState.cCombatPersistedPreview;
    import ServerState.cClientMessagesII;
    import Communication.VO.dServerResponse;
    import nLib.cCalculateTicks;
    import PathFinding.cPathFinder;
    import ServerOnly.cServerOnly;
    import PathFinding.cCreatePath;
    import nLib.cZoom;
    import Text.cOnScreenHelpDisplay;
    import flash.geom.Point;
    import nLib.cPosInt;
    import flash.utils.getTimer;
    import consts.GameConstants;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import flash.events.MouseEvent;
    import mx.events.PropertyChangeEvent;
    import Communication.VO.dServerAction;
    import ServerState.Responding;
    import GO.cGOSpriteLibContainer;
    import GO.cGOGroup;
    import Communication.VO.DestructBuildingResultVO;
    import Communication.VO.collectibles.PickupsDataVO;
    import Enums.COMMAND;
    import Communication.VO.dClientInitDataVO;
    import BuffSystem.cBuffDefinition;
    import ServerState.dResource;
    import nLib.gMisc;
    import flash.system.Capabilities;
    import Enums.OBJECTTYPE;
    import Communication.VO.Achievements.UserAchievementDataVO;
    import mx.collections.ArrayCollection;
    import Communication.VO.Achievements.UserAchievementTriggerFinishedUpdateVO;
    import Achievements.AchievementManagerBuilder;
    import Achievements.AchievementsManager;
    import GUI.ApplicationFacade;
    import Achievements.AchievementConsts;
    import com.bluebyte.tso.util.TimeUtil;
    import GUI.GAME.Chat.TSOChatMediator;
    import nLib.cBackbuffer;
    import Enums.BUFF_TARGET_ZONE;
    import Communication.VO.Fulfilments.FulfilmentTriggerFinishedUpdateVO;
    import Communication.VO.Fulfilments.FulfilmentTriggerValueUpdateVO;
    import Tasks.TaskPool;
    import Communication.VO.Tasks.TaskDataVO;
    import Communication.VO.Achievements.UserAchievementTriggerValueUpdateVO;
    import nLib.cLog;
    import flash.events.Event;
    import Communication.VO.dQuestDefinitionHintVO;
    import Communication.VO.Guild.dGuildPlayerListItemVO;
    import Model.Notifiers.SpecialistNotifier;
    import Enums.HINT_TYPE;
    import GUI.Effects.gHintManager;
    import Specialists.cSpecialist;
    import MilitarySystem.cSquad;
    import Specialists.cSpecialistTask;
    import ServerState.cResources;
    import Enums.RESOURCE_GROUP;
    import Enums.SPECIALIST_TASK_TYPES;
    import Specialists.cSpecialistTask_AttackBuildingNewCombat;
    import Achievements.IAchievementTreeNode;
    import flash.events.FocusEvent;
    import Communication.VO.Guild.dGuildBankVO;
    import Communication.VO.dBuildingVO;
    import Enums.DIRTY_INDICATOR;
    import nLib.cEventWithData;
    import __AS3__.vec.*;

    public class cGeneralInterface implements cNLibInterface, IEventDispatcher 
    {

        public static const BUILDING_OWNERSHIP_PLAYER:int = 1;
        public static const BUILDING_OWNERSHIP_BANDITCAMP:int = -1;
        public static const BUILDING_OWNERSHIP_FREE:int = 0;
        public static const SYNCHRONISATION_JUST_REFRESH:int = (1 << 0);
        public static const SYNCHRONISATION_ERROR_DEFAULT:int = (1 << 1);
        public static const SYNCHRONISATION_ERROR_MISSED_GAMETICK:int = (1 << 2);
        public static const SYNCHRONISATION_ERROR_GAMETICK_COMMAND_KILLED_ERROR:int = (1 << 3);
        public static const SYNCHRONISATION_ERROR_SERVER_PREPLACEDBUILDINGCOULDNOTBEPLACED:int = (1 << 4);
        public static const SYNCHRONISATION_ERROR_SERVER_CLIENT_TIME_MISMATCH:int = (1 << 5);
        public static const SYNCHRONISATION_ERROR_GAMETICK_MISMATCH_ERROR:int = (1 << 6);
        public static const SYNCHRONISATION_ERROR_ADVENTUREZONE_DIFFERENT_MAP:int = (1 << 7);
        public static const SYNCHRONISATION_ERROR_RESOURCE_MISMATCH:int = (1 << 8);
        public static const SYNCHRONISATION_ERROR_BUILDING_MISMATCH:int = (1 << 9);
        public static const SYNCHRONISATION_ERROR_BUILDING_MODE_MISMATCH:int = (1 << 10);
        public static const SYNCHRONISATION_ERROR_GARRISON_MISMATCH:int = (1 << 11);
        public static const SYNCHRONISATION_ERROR_SPECIALIST_MISMATCH:int = (1 << 12);
        public static const SYNCHRONISATION_ERROR_SQUAD_MISMATCH:int = (1 << 13);
        public static const SYNCHRONISATION_ERROR_BANDIT_MISMATCH:int = (1 << 14);
        public static const SYNCHRONISATION_ERROR_APPLY_BUFF_MISMATCH:int = (1 << 15);
        public static const SYNCHRONISATION_ERROR_PACKET_LOST:int = (1 << 16);
        public static const SYNCHRONISATION_ERROR_COMBAT_MISMATCH:int = (1 << 17);
        public static const SYNCHRONISATION_ERROR_COLLECTION_PARTS_MISMATCH:int = (1 << 18);

        protected var mStreamingPhase:int = 0;
        public var mCurrentlySelectededBuilding:cBuilding = null;
        public var mGetUpdatesSend:Boolean;
        public var showIsoBackgroundGrid:Boolean = false;
        public var mStreetCursorOrange:cGO = null;
        private var mCurrentUserAchievementManager:UserAchievementManager;
        public var mLockedPreviewPathEndGrid:int = 0;
        public var onMapClickHandler:Function = null;
        private var mTimedTriggerManager:TimedTriggerManager;
        private var mComparedUsersAchievementManager:Dictionary;
        public var mStreetCursorGreen:cGO = null;
        public var mZoneBuffManager:ZoneBuffManager;
        public var showCollectibleBuildingDebugGrid:Boolean = false;
        public var mStreetCursorRed:cGO = null;
        public var mProductionPathBoth:cGO = null;
        public var genericValueManager:GenericValueManager;
        protected var mInGameErrorMessagesLogDetail_vector:Vector.<String>;
        private var mGameClientTime:Number = 0;
        public var mWobbling:Number = 0;
        public var mConditionManager:ConditionManager;
        public var mCheckProductionValueTriggerCounter:int = -1;
        private var epicWorkyardAutoUpgrader:EpicWorkyardAutoUpgrader;
        public var showBlockingGrid:Boolean = false;
        public var gameEventManager:GameEventManager;
        public var mContentGeneratorManager:ContentGeneratorManager;
        public var mMousePressed:Boolean = false;
        public var showCostMatrix:Boolean = false;
        public var showIsoDebugGrid:Boolean = false;
        public var showDepositMap:Boolean = false;
        public var mActiveG:Boolean = false;
        protected var mFadeInCntr:Number;
        public var mLastActivity:int;
        public var showWatchAreas:Boolean = false;
        public var mStreetCursorPink:cGO = null;
        public var mCheckZoneHomePlayerLevel:int = -1;
        protected var mBlackScreenTimeout:Number;
        private var adventureLootMediator:AdventureLootMediator;
        public var mSynchronisationErrorClientDeltaTime:int = 0;
        public var mHomePlayer:cPlayerData;
        public var mConnectionLost:Boolean = false;
        public var mSynchronizeZone:dZoneVO = null;
        public var mLastSynchronizetime:Number = 0;
        public var mFog:cGO = null;
        public var mReactionManager:ReactionManager;
        private var _617771443mCurrentPlayer:cPlayerData = null;
        private var mTempDate:Date;
        public var mZoneCheckUpdateVO:dZoneCheckVO = null;
        public var mProductionPathWorkyard:cGO = null;
        public var lastColonyYieldCalculationTime:Number;
        public var showBuildingAndLandscapeDebug:String = "";
        protected var mDateFormatter:DateFormatter;
        public var mWobblingInt:int = 0;
        public var showSegmentBuffer:Boolean = false;
        public var GameTickSystemPostProcessTime:Number = 2500;
        public var mShowOnScreenInfoPlayer:Boolean = true;
        public var GameTickPeriodicRefreshTime:Number = 1000;
        public var mRefreshZoneIsActive:Boolean = false;
        public var mItemRegistry:ItemRegistry;
        protected var mDebugTextXPos:int;
        public var showFogOfWar:Boolean = true;
        public var mStreetCursorWhite:cGO = null;
        public var mCurrentPlayerGuild:dGuildVO = null;
        public var showBuildings:Boolean = true;
        public var mLastServerResponseIIRead:Boolean = false;
        public var mZoneCheckVO:dZoneCheckVO;
        public var cooldownManager:CooldownManager;
        public var mProductionPathDeposit:cGO = null;
        public var mLockPreviewPath:Boolean = false;
        public var mLastZoneRefreshTime:Number = 0;
        public var mServerDate:dClientDateVO;
        private var mPlayersOnMap_vector:Vector.<cPlayerData>;
        protected var mStreamingParallelCntr:int = 0;
        public var mGlobalTimeScale:Number = 100;
        protected var mDebugTextYPos:int;
        public var showBackgroundGrid:Boolean = false;
        public var mGameTickRefreshCounter:int;
        public var CHEAT_KEYS:Boolean = false;
        public var mZoneMapName:String = null;
        public var mOscillating:Number = 0;
        public var skillLists_vector:Vector.<cSkillList>;
        public var mBackgroundCursorRed:cGO = null;
        public var mBlockingPathPreviewStart:cGO = null;
        public var mLastGameTickRefreshClientTime:Number = 0;
        public var showCursorDebugInfo:Boolean = false;
        public var mShowIngameDetailErrorLog:Boolean = false;
        public var mQuestFileNames:Vector.<String> = null;
        public var SHOW_DEBUG_TEXT:Boolean = false;
        public var mBirthTime:Number = 0;
        public var mWatchAreas:Vector.<cGO>;
        public var mStreetCursorYellow:cGO = null;
        public var mLastServerResponseRead:Boolean = false;
        public var mSynchronisationErrorBitField:int = 0;
        public var showBuildingDebugGrid:Boolean = false;
        private var mCurrentTaskManager:TaskManager;
        public var mCalculateEconomy:Boolean = true;
        public var mPacketLostTime:Number = 0;
        public var mEffectiveHomePlayerID:int = -1;
        public var showSectorGrid:Boolean = false;
        public var mStreetCursorGrid:cGO = null;
        protected var mRenderScreen:Boolean;
        public var mBlockingPathPreviewFinish:cGO = null;
        public var mOscillatingInt:int = 0;
        private var _bindingEventDispatcher:EventDispatcher;
        public var mCurrentCursor:cCursor = null;
        public var mComputeAndInputActive:Boolean = false;
        public var mStreetPathCursor:cGO = null;
        public var scroll:int = 0;
        public var temp_string:String = "";
        public var temp3:int;
        public var temp4:int;
        public var temp2:int;
        private var _625721612mIsDefenseMode:Boolean = false;
        public var mClientDeltaTime:int = 0;
        public var mSpoolingIsActive:Boolean = false;
        public var mBorder:cGO = null;
        public var mStreetCursorSelected:cGO = null;
        public var mOnScreenFps:Boolean;
        public var mShowOnScreenInfoGameTickCommands:Boolean = true;
        public var mSynchronisationErrorGameTick:dGameTickCommandVO = null;
        protected var mInGameErrorMessagesLog_vector:Vector.<String>;
        public var mRenderBuildingShadows:Boolean = true;
        private var _81847919pickupManager:PickupManager;
        private var taskBuildingMapObserver:TaskBuildingMapObserver;
        private var _445580263mPacketLost:Boolean = false;
        public var mCurrentViewedZoneID:int = 0;
        public var mPatternFog:cGO = null;
        public var mLastZoomPos:Dictionary;
        protected var mBackGroundIsStreamed:Boolean;
        private var mUsesCombatThree:Boolean = false;
        public var filter:int = 0;
        public var mShowIngameErrorLog:Boolean = true;
        public var mStreetCursorMagenta:cGO = null;
        private var _639667182killswitch:KillSwitch;
        public var mCurrentPlayerZone:cPlayerZoneScreen;
        public var showIsoGrid:Boolean = false;
        public var showLandingFields:Boolean = false;
        public var mInitStartTime:Number = 0;
        public var mCheckTimedTriggerCount:int = -1;
        public var mStreetCursorBlue:cGO = null;
        public var mActivateDebugQuestGui:Boolean = false;
        public var temp:int;
        public var mMilitaryPath:cGO = null;
        public var mShowAdditionalDebugInfo:Boolean;
        public var mSynchronizetime:Number = 0;
        public var mCurrentSecondaryCursor:cCursor = null;
        public var mZoneSpecialistActivityTracker:ZoneSpecialistActivity;

        public var channels:Channels = new Channels();
        public var inputNotifier:InputNotifier = channels.INPUT;
        public var mTriggerEffects:TriggerActions = new TriggerActions((this as cGeneralInterface));
        public var mQuestClientCallbacks:QuestClientCallbacks = new QuestClientCallbacks((this as cGeneralInterface));
        public var mNewQuestManager:IQuestManager = mQuestClientCallbacks;
        public var mEventManager:EventManager = new EventManager((this as cGeneralInterface));
        public var mAdventCalendarManager:AdventCalendarManager = new AdventCalendarManager((this as cGeneralInterface));
        public var mVotesManager:VotesManager = new VotesManager((this as cGeneralInterface));
        public var shopManager:cShopUtl = new cShopUtl((this as cGeneralInterface));
        public var mServer:cServer = new cServer((this as cGeneralInterface));
        private var _1484268286mCurrentPlayerGuildBank:cGuildBank = new cGuildBank();
        public var mDataTracking:cDataTracking = new cDataTracking((this as cGeneralInterface));
        public var mComputeResourceCreation:cComputeResourceCreation = new cComputeResourceCreation((this as cGeneralInterface));
        public var mCombatPersitedPreview:cCombatPersistedPreview = new cCombatPersistedPreview((this as cGeneralInterface));
    public var mClientMessages:cClientMessagesII = new cClientMessagesII((this as cGeneralInterface));
        public var mLastServerResponse:Vector.<dServerResponse> = new Vector.<dServerResponse>();
        public var mLastServerResponseII:Vector.<dServerResponse> = new Vector.<dServerResponse>();
        public var mCalculateTicks:cCalculateTicks = new cCalculateTicks();
        public var mPathFinder:cPathFinder = new cPathFinder((this as cGeneralInterface));
        public var mServerOnly:cServerOnly = new cServerOnly((this as cGeneralInterface));
        public var mCreatePath:cCreatePath = new cCreatePath((this as cGeneralInterface));
        public var mSetStreets:cSetStreets = new cSetStreets((this as cGeneralInterface));
        public var mSetBuildings:cSetBuildings = new cSetBuildings((this as cGeneralInterface));
        public var mSetBlockingPathPreview:cSetBlockingPathPreview = new cSetBlockingPathPreview((this as cGeneralInterface));
        public var mZoom:cZoom = new cZoom();
        public var mOnScreenHelpDisplay:cOnScreenHelpDisplay = new cOnScreenHelpDisplay((this as cGeneralInterface));
        public var mMouseCursor:cCursor = new cCursor((this as cGeneralInterface));
        public var mMouseCursorSecondary:cCursor = new cCursor((this as cGeneralInterface));
        public const mGameTickCommand_vector:Vector.<dGameTickCommandVO> = new Vector.<dGameTickCommandVO>();
        public var mP:Point = new Point();
        public var mIntP:cPosInt = new cPosInt();

        public function cGeneralInterface()
        {
            this.mHomePlayer = new cPlayerData((this as cGeneralInterface));
            this.mCurrentPlayerZone = new cPlayerZoneScreen((this as cGeneralInterface));
            this.mWatchAreas = new Vector.<cGO>();
            this.mZoneCheckVO = new dZoneCheckVO();
            this.mLastActivity = getTimer();
            this.mLastZoomPos = new Dictionary();
            this.skillLists_vector = new Vector.<cSkillList>();
            this.mInGameErrorMessagesLog_vector = new Vector.<String>();
            this.mInGameErrorMessagesLogDetail_vector = new Vector.<String>();
            this.mPlayersOnMap_vector = new Vector.<cPlayerData>();
            this.mTempDate = new Date();
            this.mDateFormatter = new DateFormatter();
            this.mComparedUsersAchievementManager = new Dictionary();
            this.mTimedTriggerManager = new TimedTriggerManager();
            this.mConditionManager = new ConditionManager();
            this.genericValueManager = new GenericValueManager((this as cGeneralInterface));
            this.mContentGeneratorManager = new ContentGeneratorManager((this as cGameInterface));
            this.cooldownManager = new CooldownManager((this as cGeneralInterface));
            this._bindingEventDispatcher = new EventDispatcher(IEventDispatcher(this));
            super();
        }

        public static function isDefaultPlayerName(_arg_1:String):Boolean
        {
            return ((!(_arg_1 == null)) && (_arg_1.indexOf(GameConstants.DEFAULT_PLAYER_NAME) == 0));
        }

        public static function GetSynchronisationErrorText(_arg_1:int):String
        {
            var _local_2:* = "";
            if ((_arg_1 & SYNCHRONISATION_JUST_REFRESH) != 0)
            {
                _local_2 = (_local_2 + "[SYNCHRONISATION_JUST_REFRESH]");
            };
            if ((_arg_1 & SYNCHRONISATION_ERROR_DEFAULT) != 0)
            {
                _local_2 = (_local_2 + "[ERROR_DEFAULT]");
            };
            if ((_arg_1 & SYNCHRONISATION_ERROR_MISSED_GAMETICK) != 0)
            {
                _local_2 = (_local_2 + "[ERROR_MISSED_GAMETICK]");
            };
            if ((_arg_1 & SYNCHRONISATION_ERROR_GAMETICK_COMMAND_KILLED_ERROR) != 0)
            {
                _local_2 = (_local_2 + "[ERROR_GAMETICK_COMMAND_KILLED_ERROR]");
            };
            if ((_arg_1 & SYNCHRONISATION_ERROR_SERVER_PREPLACEDBUILDINGCOULDNOTBEPLACED) != 0)
            {
                _local_2 = (_local_2 + "[ERROR_SERVER_PREPLACEDBUILDINGCOULDNOTBEPLACED]");
            };
            if ((_arg_1 & SYNCHRONISATION_ERROR_SERVER_CLIENT_TIME_MISMATCH) != 0)
            {
                _local_2 = (_local_2 + "[ERROR_SERVER_CLIENT_TIME_MISMATCH]");
            };
            if ((_arg_1 & SYNCHRONISATION_ERROR_GAMETICK_MISMATCH_ERROR) != 0)
            {
                _local_2 = (_local_2 + "[ERROR_GAMETICK_MISMATCH_ERROR]");
            };
            if ((_arg_1 & SYNCHRONISATION_ERROR_ADVENTUREZONE_DIFFERENT_MAP) != 0)
            {
                _local_2 = (_local_2 + "[ERROR_ADVENTUREZONE_DIFFERENT_MAP]");
            };
            if ((_arg_1 & SYNCHRONISATION_ERROR_RESOURCE_MISMATCH) != 0)
            {
                _local_2 = (_local_2 + "[ERROR_RESOURCE_MISMATCH]");
            };
            if ((_arg_1 & SYNCHRONISATION_ERROR_BUILDING_MISMATCH) != 0)
            {
                _local_2 = (_local_2 + "[ERROR_BUILDING_MISMATCH]");
            };
            if ((_arg_1 & SYNCHRONISATION_ERROR_BUILDING_MODE_MISMATCH) != 0)
            {
                _local_2 = (_local_2 + "[ERROR_BUILDING_MODE_MISMATCH]");
            };
            if ((_arg_1 & SYNCHRONISATION_ERROR_GARRISON_MISMATCH) != 0)
            {
                _local_2 = (_local_2 + "[ERROR_GARRISON_MISMATCH]");
            };
            if ((_arg_1 & SYNCHRONISATION_ERROR_SPECIALIST_MISMATCH) != 0)
            {
                _local_2 = (_local_2 + "[ERROR_SPECIALIST_MISMATCH]");
            };
            if ((_arg_1 & SYNCHRONISATION_ERROR_SQUAD_MISMATCH) != 0)
            {
                _local_2 = (_local_2 + "[ERROR_SQUAD_MISMATCH]");
            };
            if ((_arg_1 & SYNCHRONISATION_ERROR_BANDIT_MISMATCH) != 0)
            {
                _local_2 = (_local_2 + "[ERROR_BANDIT_MISMATCH]");
            };
            if ((_arg_1 & SYNCHRONISATION_ERROR_APPLY_BUFF_MISMATCH) != 0)
            {
                _local_2 = (_local_2 + "[APPLY_BUFF_MISMATCH]");
            };
            if ((_arg_1 & SYNCHRONISATION_ERROR_PACKET_LOST) != 0)
            {
                _local_2 = (_local_2 + "[PACKET_LOST]");
            };
            if ((_arg_1 & SYNCHRONISATION_ERROR_COMBAT_MISMATCH) != 0)
            {
                _local_2 = (_local_2 + "[ERROR_COMBAT_MISMATCH]");
            };
            if ((_arg_1 & SYNCHRONISATION_ERROR_COLLECTION_PARTS_MISMATCH) != 0)
            {
                _local_2 = (_local_2 + "[SYNCHRONISATION_ERROR_COLLECTION_PARTS_MISMATCH]");
            };
            return (_local_2);
        }

        public static function getComputedPlayerName(_arg_1:String):String
        {
            return ((isDefaultPlayerName(_arg_1)) ? cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, GameConstants.LABEL_AVATAR_NAME) : _arg_1);
        }


        public function MouseClick(_arg_1:MouseEvent):void
        {
        }

        public function isOnHomzone():Boolean
        {
            return (this.mCurrentPlayer.GetHomeZoneId() == this.mCurrentViewedZoneID);
        }

        public function Compute():void
        {
        }

        [Bindable(event="propertyChange")]
        public function get mPacketLost():Boolean
        {
            return (this._445580263mPacketLost);
        }

        [Bindable(event="propertyChange")]
        public function get killswitch():KillSwitch
        {
            return (this._639667182killswitch);
        }

        public function GetCurrentPlayerGuild():dGuildVO
        {
            return (this.mCurrentPlayerGuild);
        }

        public function UsesCombatThreeSet(_arg_1:Boolean):void
        {
            this.mUsesCombatThree = _arg_1;
        }

        public function set mPacketLost(_arg_1:Boolean):void
        {
            var _local_2:Object = this._445580263mPacketLost;
            if (_local_2 !== _arg_1)
            {
                this._445580263mPacketLost = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "mPacketLost", _local_2, _arg_1));
            };
        }

        public function SendServerActionSimple(_arg_1:int, _arg_2:Object, _arg_3:Responding=null):dServerAction
        {
            var _local_4:dServerAction = new dServerAction();
            _local_4.type = _arg_1;
            _local_4.data = _arg_2;
            this.mClientMessages.SendMessagetoServer(_arg_1, this.mCurrentViewedZoneID, _local_4, _arg_3);
            return (_local_4);
        }

        protected function SetUsageCntrGroup(_arg_1:cGOGroup):void
        {
            var _local_2:cGOSpriteLibContainer;
            for each (_local_2 in _arg_1.mGOList_vector)
            {
                _local_2.setSpriteAsUsed();
            };
        }

        public function set killswitch(_arg_1:KillSwitch):void
        {
            var _local_2:Object = this._639667182killswitch;
            if (_local_2 !== _arg_1)
            {
                this._639667182killswitch = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "killswitch", _local_2, _arg_1));
            };
        }

        public function removePickups(_arg_1:int):Vector.<dGameTickCommandVO>
        {
            var _local_6:int;
            var _local_7:DestructBuildingResultVO;
            var _local_8:cBuilding;
            var _local_9:dGameTickCommandVO;
            var _local_2:Vector.<dGameTickCommandVO> = new Vector.<dGameTickCommandVO>();
            var _local_3:Dictionary = this.mCurrentPlayerZone.mStreetDataMap.getPickups(_arg_1);
            var _local_4:int = this.mHomePlayer.GetPlayerId();
            var _local_5:PickupsDataVO = new PickupsDataVO().init(_arg_1, -1);
            _local_2.push(this.CreateGameTickCommand(_local_4, COMMAND.UPDATE_PICKUP_DATA, _local_5, 0));
            if (_local_3 != null)
            {
                for each (_local_6 in _local_3)
                {
                    _local_7 = new DestructBuildingResultVO();
                    _local_7.gridIndex = _local_6;
                    _local_8 = _local_3.get(_local_6);
                    if (_local_8 != null)
                    {
                        _local_7.origin = ("removePickUps: " + _local_8.GetBuildingName_string());
                    }
                    else
                    {
                        _local_7.origin = "removePickUps";
                    };
                    _local_9 = this.CreateGameTickCommand(_local_4, COMMAND.DESTRUCT_BUILDING, _local_7, 0);
                    _local_2.push(_local_9);
                };
            };
            return (_local_2);
        }

        public function RefreshGuildBank():void
        {
        }

        public function GetGameTickPostProcessTime(_arg_1:Number):Number
        {
            if (_arg_1 == 0)
            {
                _arg_1 = this.GameTickSystemPostProcessTime;
            };
            return (this.GetClientTime() + (_arg_1 * this.mGlobalTimeScale));
        }

        public function ZoneFinished():void
        {
            var _local_1:cGOSpriteLibContainer;
            var _local_2:dClientInitDataVO;
            var _local_3:cBuffDefinition;
            var _local_4:dResource;
            globalFlash.gui.ShowDefaultGuiElements();
            this.mActiveG = true;
            this.mComputeAndInputActive = true;
            this.mClientMessages.SendMessagetoServer(COMMAND.GUILD_GET_OWN, this.mCurrentPlayer.GetHomeZoneId(), null);
            for each (_local_1 in global.buildingGroup.mGOList_vector)
            {
                if (_local_1 != null)
                {
                    for each (_local_3 in _local_1.buildingUpgradeBonuses_vector)
                    {
                        for each (_local_4 in _local_3.GetCosts_vector())
                        {
                            if (!global.resourceHardcurrencyValues.hasOwnProperty(_local_4.name_string))
                            {
                                gMisc.Assert(false, (("Resource: " + _local_4.name_string) + " not listed in ResourceHardcurrencyValues"));
                            };
                        };
                    };
                };
            };
            _local_2 = new dClientInitDataVO();
            _local_2.clientInitDuration = (getTimer() - this.mInitStartTime);
            _local_2.clientCapabilities = Capabilities.serverString;
            this.mClientMessages.SendMessagetoServer(COMMAND.INIT_CLIENT_DONE, this.mCurrentViewedZoneID, _local_2);
        }

        public function InitPreCreatedGOs():void
        {
            this.mBackgroundCursorRed = cGO.CreateGoFromLevelObject(this.mHomePlayer, OBJECTTYPE.BACKGROUND, "BackgroundCursorRed", this);
            this.mMilitaryPath = cGO.CreateGoFromLevelObject(this.mHomePlayer, OBJECTTYPE.STREET, "MilitaryPath", this);
            this.mProductionPathWorkyard = cGO.CreateGoFromLevelObject(this.mHomePlayer, OBJECTTYPE.STREET, "ProductionPathWorkyard", this);
            this.mProductionPathDeposit = cGO.CreateGoFromLevelObject(this.mHomePlayer, OBJECTTYPE.STREET, "ProductionPathDeposit", this);
            this.mProductionPathBoth = cGO.CreateGoFromLevelObject(this.mHomePlayer, OBJECTTYPE.STREET, "ProductionPathBoth", this);
            this.mStreetCursorGrid = cGO.CreateGoFromLevelObject(this.mHomePlayer, OBJECTTYPE.STREET, "Street_Grid", this);
            this.mStreetCursorGreen = cGO.CreateGoFromLevelObject(this.mHomePlayer, OBJECTTYPE.STREET, "Street_Grid_Green", this);
            this.mStreetCursorBlue = cGO.CreateGoFromLevelObject(this.mHomePlayer, OBJECTTYPE.STREET, "Street_Grid_Blue", this);
            this.mStreetCursorMagenta = cGO.CreateGoFromLevelObject(this.mHomePlayer, OBJECTTYPE.STREET, "Street_Grid_Magenta", this);
            this.mStreetCursorRed = cGO.CreateGoFromLevelObject(this.mHomePlayer, OBJECTTYPE.STREET, "Street_Grid_Red", this);
            this.mStreetCursorWhite = cGO.CreateGoFromLevelObject(this.mHomePlayer, OBJECTTYPE.STREET, "Street_Grid_White", this);
            this.mStreetCursorYellow = cGO.CreateGoFromLevelObject(this.mHomePlayer, OBJECTTYPE.STREET, "Street_Grid_Yellow", this);
            this.mStreetCursorPink = cGO.CreateGoFromLevelObject(this.mHomePlayer, OBJECTTYPE.STREET, "Street_Grid_Pink", this);
            this.mStreetCursorOrange = cGO.CreateGoFromLevelObject(this.mHomePlayer, OBJECTTYPE.STREET, "Street_Grid_Orange", this);
            this.mStreetPathCursor = cGO.CreateGoFromLevelObject(this.mHomePlayer, OBJECTTYPE.STREET, "Street_PathCursor", this);
            this.mStreetCursorSelected = cGO.CreateGoFromLevelObject(this.mHomePlayer, OBJECTTYPE.STREET, "Street_Grid_Selected", this);
            this.mBorder = cGO.CreateGoFromLevelObject(this.mHomePlayer, OBJECTTYPE.STREET, "border", this);
            this.mFog = cGO.CreateGoFromLevelObject(this.mHomePlayer, OBJECTTYPE.STREET, "Fog", this);
            this.mPatternFog = cGO.CreateGoFromLevelObject(this.mHomePlayer, OBJECTTYPE.STREET, "PatternFog", this);
            var _local_1:int;
            while (_local_1 < global.watchAreas_vector.length)
            {
                this.mWatchAreas.push(cGO.CreateGoFromLevelObject(this.mHomePlayer, OBJECTTYPE.STREET, ("WatchArea" + _local_1), this));
                _local_1++;
            };
            this.mBlockingPathPreviewStart = cGO.CreateGoFromLevelObject(this.mHomePlayer, OBJECTTYPE.BUILDING, "GhostGarrison", this);
            this.mBlockingPathPreviewFinish = cGO.CreateGoFromLevelObject(this.mHomePlayer, OBJECTTYPE.STREET, "MilitaryGhostPath", this);
        }

        public function ShowDebugInfoMessage(_arg_1:String, _arg_2:Number):void
        {
        }

        public function getComparedUsersAchievementsData():ArrayCollection
        {
            var _local_2:UserAchievementManager;
            var _local_3:UserAchievementDataVO;
            var _local_1:ArrayCollection = new ArrayCollection();
            for each (_local_2 in this.mComparedUsersAchievementManager)
            {
                _local_3 = new UserAchievementDataVO();
                _local_3.userID = _local_2.getPlayerID();
                _local_2.getAchievementTriggerUpdates(_local_3.finishedAchievementTriggers, null);
                _local_1.addItem(_local_3);
            };
            return (_local_1);
        }

        public function MouseOut(_arg_1:MouseEvent):void
        {
        }

        public function IsMoreThanOnePlayerOnMap():Boolean
        {
            return (this.mPlayersOnMap_vector.length > 2);
        }

        public function AddClientTime(_arg_1:Number):void
        {
            this.mGameClientTime = (this.mGameClientTime + _arg_1);
        }

        public function set mCurrentPlayer(_arg_1:cPlayerData):void
        {
            var _local_2:Object = this._617771443mCurrentPlayer;
            if (_local_2 !== _arg_1)
            {
                this._617771443mCurrentPlayer = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "mCurrentPlayer", _local_2, _arg_1));
            };
        }

        public function addComparedUserAchievementManager(_arg_1:UserAchievementDataVO):void
        {
            var _local_4:UserAchievementTriggerFinishedUpdateVO;
            var _local_2:AchievementManagerBuilder = new AchievementManagerBuilder(AchievementsManager.getInstance(), this);
            var _local_3:UserAchievementManager = _local_2.buildUserAchievementManager(this, _arg_1.userID, null, null, null);
            for each (_local_4 in _arg_1.finishedAchievementTriggers)
            {
                _local_3.setTriggerAchievementFinished(_local_4);
            };
            this.mComparedUsersAchievementManager[_local_3.getPlayerID()] = _local_3;
            ApplicationFacade.sendNotification(AchievementConsts.COMPARED_TREE_RECEIVED, _local_3.getTree());
        }

        public function AddGameTickCommand(_arg_1:dGameTickCommandVO):void
        {
            if (_arg_1 != null)
            {
                this.mGameTickCommand_vector.push(_arg_1);
            };
        }

        public function CreateImmediateGameTickCommand(_arg_1:int, _arg_2:int, _arg_3:Object, _arg_4:int):dGameTickCommandVO
        {
            var _local_6:dGameTickCommandVO;
            var _local_7:dGameTickCommandVO;
            var _local_8:Number;
            var _local_5:Number = this.GetClientTime();
            for each (_local_6 in this.mGameTickCommand_vector)
            {
                _local_8 = ((_local_6.time > _local_5) ? (_local_6.time - _local_5) : (_local_5 - _local_6.time));
                if (_local_8 < 1E-7)
                {
                    _local_5 = (_local_5 + 100);
                    break;
                };
            };
            _local_7 = new dGameTickCommandVO();
            _local_7.playerID = _arg_1;
            _local_7.time = _local_5;
            _local_7.mode = _arg_2;
            _local_7.data = _arg_3;
            this.AddGameTickCommand(_local_7);
            return (_local_7);
        }

        public function hasEventListener(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.hasEventListener(_arg_1));
        }

        public function GetCurrentDateInMs():Number
        {
            return (TimeUtil.getServerTime());
        }

        [Bindable(event="propertyChange")]
        public function get mCurrentPlayerGuildBank():cGuildBank
        {
            return (this._1484268286mCurrentPlayerGuildBank);
        }

        public function GetClientTime():Number
        {
            return (this.mGameClientTime);
        }

        protected function InitStreaming():void
        {
            this.mStreamingParallelCntr = 0;
            this.mStreamingPhase = 0;
            this.mBlackScreenTimeout = (gMisc.GetTimeSinceStartup() + 10000);
            if (defines.STREAMING_SET_SCREEN_TO_BLACK_UNTIL_BACKGROUND_IS_STREAMED)
            {
                this.mRenderScreen = false;
                this.mFadeInCntr = 0;
            }
            else
            {
                this.mRenderScreen = true;
                this.mFadeInCntr = defines.FADEIN_TIME;
            };
            this.mBackGroundIsStreamed = false;
        }

        [Bindable(event="propertyChange")]
        public function get mIsDefenseMode():Boolean
        {
            return (this._625721612mIsDefenseMode);
        }

        public function CacheBackgroundScroll():void
        {
            if (this.mCurrentPlayerZone != null)
            {
                this.mCurrentPlayerZone.CacheBackgroundScroll();
            };
        }

        public function FindPlayerFromId(_arg_1:int):cPlayerData
        {
            var _local_2:cPlayerData;
            for each (_local_2 in this.mPlayersOnMap_vector)
            {
                if (_local_2.GetPlayerId() == _arg_1)
                {
                    return (_local_2);
                };
            };
            return (null);
        }

        public function AddNewPlayer(_arg_1:cPlayerData):void
        {
            this.mPlayersOnMap_vector.push(_arg_1);
        }

        public function SwitchOnScreenDisplay():void
        {
            this.mShowAdditionalDebugInfo = (!(this.mShowAdditionalDebugInfo));
        }

        public function getCurrentTaskManager():TaskManager
        {
            return (this.mCurrentTaskManager);
        }

        public function Init(_arg_1:int):void
        {
            this.mGlobalTimeScale = global.initGlobalTimeScale;
            this.mHomePlayer.SetPlayerId(_arg_1);
            this.AddNewPlayer(this.mHomePlayer);
            this.mCurrentPlayer = this.mHomePlayer;
            this.mCurrentViewedZoneID = _arg_1;
            this.mMousePressed = false;
            this.mShowAdditionalDebugInfo = false;
            this.mOnScreenFps = false;
            this.mGetUpdatesSend = false;
            this.SHOW_DEBUG_TEXT = false;
            this.CHEAT_KEYS = global.CHEAT_KEYS;
            this.mActivateDebugQuestGui = global.activateDebugQuestGui;
            this.mCurrentlySelectededBuilding = null;
            this.mGameTickCommand_vector.length = 0;
            if (!global.useExternalServer)
            {
                this.SetGameTickRefreshCommand(this.mCurrentPlayer);
            };
            this.mCalculateTicks.InitFpsCounter();
            this.killswitch = new KillSwitch();
            this.mZoom.Init(cZoom.STANDARD_ZOOM_FACTOR_ARRAY, this, global.ui.mCurrentPlayerZone);
            this.mZoom.setScaleIndexWithZoomFactor(cZoom.START_ZOOM_FACTOR);
            TSOChatMediator.reconnectToChatTimer(null);
            this.pickupManager = new PickupManager(this);
            this.mZoneBuffManager = new ZoneBuffManager(this);
            this.mZoneSpecialistActivityTracker = new ZoneSpecialistActivity(this);
            this.mItemRegistry = new (flash.utils.getDefinitionByName("ItemRegistry.ItemRegistry") as Class)(this);
            this.adventureLootMediator = new AdventureLootMediator(this);
            this.mReactionManager = new ReactionManager((this as cGameInterface), global.gameReactionListVO);
            this.epicWorkyardAutoUpgrader = new EpicWorkyardAutoUpgrader(this);
        }

        protected function RenderBackBufferToCanvas():void
        {
            global.getApplication().isoengine.graphics.clear();
            global.getApplication().isoengine.graphics.beginBitmapFill(cBackbuffer.mBackBuffer, null, false, false);
            global.getApplication().isoengine.graphics.drawRect(0, 0, cBackbuffer.GetWidth(), cBackbuffer.GetHeight());
            global.getApplication().isoengine.graphics.endFill();
        }

        public function Exit():void
        {
        }

        public function ClearLevel():void
        {
        }

        public function SetGameTickRefreshCommand(_arg_1:cPlayerData):void
        {
            var _local_2:dGameTickCommandVO = this.CreateGameTickCommand(_arg_1.GetPlayerId(), COMMAND.GAMETICK_REFRESH_COMMAND, null, 0);
            _local_2.time = this.GetGameTickPostProcessTime(this.GameTickPeriodicRefreshTime);
        }

        public function isPreviewPathLocked():Boolean
        {
            return (this.mLockPreviewPath);
        }

        public function getZoneTypes(_arg_1:int):int
        {
            var _local_2:int;
            if (this.mCurrentViewedZoneID == _arg_1)
            {
                _local_2 = (_local_2 | BUFF_TARGET_ZONE.HOME);
            }
            else
            {
                if (this.mCurrentViewedZoneID > 0)
                {
                    _local_2 = (_local_2 | BUFF_TARGET_ZONE.FRIEND);
                };
            };
            if (this.mCurrentViewedZoneID <= defines.ADVENTUREZONEID)
            {
                if (!this.UsesCombatThree())
                {
                    _local_2 = (_local_2 | BUFF_TARGET_ZONE.ADVENTURE);
                }
                else
                {
                    if (this.mIsDefenseMode)
                    {
                        _local_2 = (_local_2 | BUFF_TARGET_ZONE.DEFENSE_MODE);
                    }
                    else
                    {
                        _local_2 = (_local_2 | BUFF_TARGET_ZONE.EXPEDITION);
                    };
                };
            };
            return (_local_2);
        }

        public function UpdatePositions():void
        {
            if (this.mCurrentPlayerZone != null)
            {
                this.mCurrentPlayerZone.UpdatePositions();
                this.mCurrentPlayerZone.SetAllRescaleDirtyFlags();
            };
        }

        public function willTrigger(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.willTrigger(_arg_1));
        }

        [Bindable(event="propertyChange")]
        public function get pickupManager():PickupManager
        {
            return (this._81847919pickupManager);
        }

        public function innerBuildTaskManager(_arg_1:TaskDataVO, _arg_2:Vector.<String>):void
        {
            var _local_3:FulfilmentTriggerFinishedUpdateVO;
            var _local_4:FulfilmentTriggerValueUpdateVO;
            if (_arg_1.isInitialized())
            {
                this.setCurrentTaskManager(new TaskManager(this, TaskPool.getInstance(), _arg_1.userID, null, _arg_1.tasksToStart, null, _arg_2, false));
            };
            if (this.mCurrentTaskManager != null)
            {
                if (_arg_1.tasksTriggerValueUpdates.length > 0)
                {
                    for each (_local_3 in _arg_1.finishedTasksTriggers)
                    {
                        this.mCurrentTaskManager.setTriggerIdentityFinished(_local_3);
                    };
                    for each (_local_4 in _arg_1.tasksTriggerValueUpdates)
                    {
                        this.mCurrentTaskManager.updateIdentityValue(_local_4);
                    };
                };
                this.mCurrentTaskManager.setResetTaskTime(_arg_1.taskResetTime);
                this.mCurrentTaskManager.setInitialized(true);
                ApplicationFacade.getInstance().sendNotification(TaskManager.TASK_TREE_UPDATED, this.mCurrentTaskManager.getTree());
            };
            if (this.taskBuildingMapObserver != null)
            {
                this.taskBuildingMapObserver.dispose();
            };
            this.taskBuildingMapObserver = new TaskBuildingMapObserver(this, TaskPool.getInstance().getTaskBuildingNames_vector());
        }

        public function IsAdventureZone():Boolean
        {
            return (this.mCurrentViewedZoneID <= defines.ADVENTUREZONEID);
        }

        public function buildCurrentUserAchievementManager(_arg_1:UserAchievementDataVO):void
        {
            var _local_2:AchievementManagerBuilder;
            var _local_3:UserAchievementTriggerFinishedUpdateVO;
            var _local_4:UserAchievementTriggerValueUpdateVO;
            if (((!(this.IsAdventureZoneID(this.mCurrentPlayer.GetPlayerId()))) && ((_arg_1.achievementTriggerValueUpdates.length > 0) || (_arg_1.finishedAchievementTriggers.length > 0))))
            {
                _local_2 = new AchievementManagerBuilder(AchievementsManager.getInstance(), this);
                if (this.mCurrentUserAchievementManager != null)
                {
                    this.mCurrentUserAchievementManager.dispose();
                    this.mCurrentUserAchievementManager = null;
                };
                this.mCurrentUserAchievementManager = _local_2.buildUserAchievementManager(this, _arg_1.userID, null, null, null);
                for each (_local_3 in _arg_1.finishedAchievementTriggers)
                {
                    this.mCurrentUserAchievementManager.setTriggerAchievementFinished(_local_3);
                };
                for each (_local_4 in _arg_1.achievementTriggerValueUpdates)
                {
                    this.mCurrentUserAchievementManager.updateAchievementValue(_local_4);
                };
                this.mCurrentUserAchievementManager.setInitialized(true);
                this.mCurrentUserAchievementManager.allUpdatesHandled();
            };
        }

        public function ResetPlayerList():void
        {
            this.mPlayersOnMap_vector.length = 0;
        }

        public function Render():void
        {
        }

        public function GetSelectedBuilding():cBuilding
        {
            return (this.mCurrentlySelectededBuilding);
        }

        public function SwitchOnScreenFps():void
        {
            this.mOnScreenFps = (!(this.mOnScreenFps));
        }

        public function getCurrentUserAchievementManager():UserAchievementManager
        {
            return (this.mCurrentUserAchievementManager);
        }

        public function GetPlayerList_vector():Vector.<cPlayerData>
        {
            return (this.mPlayersOnMap_vector);
        }

        public function LockPreviewPath(_arg_1:int):void
        {
            this.mLockPreviewPath = true;
            this.mLockedPreviewPathEndGrid = _arg_1;
        }

        public function setComparedUsersAchievementManager(_arg_1:ArrayCollection):void
        {
            var _local_3:UserAchievementManager;
            var _local_4:UserAchievementDataVO;
            var _local_5:UserAchievementTriggerFinishedUpdateVO;
            this.mComparedUsersAchievementManager = new Dictionary();
            var _local_2:AchievementManagerBuilder = new AchievementManagerBuilder(AchievementsManager.getInstance(), this);
            for each (_local_4 in _arg_1)
            {
                _local_3 = _local_2.buildUserAchievementManager(this, _local_4.userID, null, null, null);
                for each (_local_5 in _local_4.finishedAchievementTriggers)
                {
                    _local_3.setTriggerAchievementFinished(_local_5);
                };
                this.mComparedUsersAchievementManager[_local_4.userID] = _local_3;
            };
        }

        public function LocalLogMessage(_arg_1:String):void
        {
            var _local_4:String;
            if (this.mInGameErrorMessagesLogDetail_vector.length > 1000)
            {
                this.mInGameErrorMessagesLogDetail_vector.splice(0, 100);
            };
            if (this.mInGameErrorMessagesLog_vector.length > 100)
            {
                this.mInGameErrorMessagesLog_vector.splice(0, 10);
            };
            var _local_2:Array = _arg_1.split("\n");
            if (_local_2.length == 0)
            {
                _local_2.push(_arg_1);
            };
            var _local_3:* = "";
            for each (_local_4 in _local_2)
            {
                _local_3 = (_local_3 + (_local_4 + " <cr>"));
            };
            this.mInGameErrorMessagesLogDetail_vector.push(_local_3);
            this.mInGameErrorMessagesLog_vector.push(_local_3);
            _arg_1 = _local_3;
            cLog.info(("[LocalLogMessage] " + _arg_1));
        }

        public function MouseWheel(_arg_1:MouseEvent):void
        {
        }

        public function MouseMove(_arg_1:MouseEvent):void
        {
        }

        public function set mCurrentPlayerGuildBank(_arg_1:cGuildBank):void
        {
            var _local_2:Object = this._1484268286mCurrentPlayerGuildBank;
            if (_local_2 !== _arg_1)
            {
                this._1484268286mCurrentPlayerGuildBank = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "mCurrentPlayerGuildBank", _local_2, _arg_1));
            };
        }

        public function getAdventureName():String
        {
            if (this.IsAdventureZoneID(this.mCurrentViewedZoneID))
            {
                if (this.mCurrentPlayerZone.GetAdventure() != null)
                {
                    return (this.mCurrentPlayerZone.GetAdventure().GetName_string());
                };
                return (this.mCurrentPlayerZone.mAdventureName);
            };
            return (cPlayerZoneScreen.HOME_ZONE_string);
        }

        public function MouseUp(_arg_1:MouseEvent):void
        {
        }

        public function UnlockPreviewPath():void
        {
            this.mLockPreviewPath = false;
        }

        protected function ComputeStreaming():void
        {
            if (this.mStreamingParallelCntr < 16)
            {
                if (this.mStreamingPhase == 0)
                {
                    this.StreamGroup(global.backgroundGroup);
                    if (global.backgroundGroup.mStreamIsIdle)
                    {
                        this.mBackGroundIsStreamed = true;
                    };
                }
                else
                {
                    if (this.mStreamingPhase == 1)
                    {
                        if (this.mBackGroundIsStreamed)
                        {
                            this.StreamGroup(global.streetGroup);
                        };
                    }
                    else
                    {
                        if (this.mStreamingPhase == 2)
                        {
                            if (this.mBackGroundIsStreamed)
                            {
                                this.StreamGroup(global.landscapeGroup);
                            };
                        }
                        else
                        {
                            if (this.mStreamingPhase == 3)
                            {
                                if (this.mBackGroundIsStreamed)
                                {
                                    this.StreamGroup(global.buildingGroup);
                                };
                            }
                            else
                            {
                                if (this.mStreamingPhase == 4)
                                {
                                    if (this.mBackGroundIsStreamed)
                                    {
                                        this.StreamGroup(global.settlerGroup);
                                    };
                                }
                                else
                                {
                                    if (this.mStreamingPhase == 5)
                                    {
                                        if (this.mBackGroundIsStreamed)
                                        {
                                            this.StreamGroup(global.animalGroup);
                                        };
                                    }
                                    else
                                    {
                                        if (this.mStreamingPhase == 6)
                                        {
                                            if (this.mBackGroundIsStreamed)
                                            {
                                                this.StreamGroup(global.guiIconGroup);
                                            };
                                        }
                                        else
                                        {
                                            if (this.mStreamingPhase == 7)
                                            {
                                                if (this.mBackGroundIsStreamed)
                                                {
                                                    this.StreamGroup(global.effectGroup);
                                                };
                                            };
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
                this.mStreamingPhase++;
                this.mStreamingPhase = (this.mStreamingPhase % 8);
            };
            if (global.backgroundGroup.mStreamIsIdle)
            {
                globalFlash.gui.mSplashScreen.Hide();
                if (!this.mRenderScreen)
                {
                    this.mRenderScreen = true;
                    this.mFadeInCntr = defines.FADEIN_TIME;
                };
            };
            if (gMisc.GetTimeSinceStartup() > this.mBlackScreenTimeout)
            {
                if (!this.mRenderScreen)
                {
                    this.mRenderScreen = true;
                    this.mFadeInCntr = 0;
                };
            };
        }

        public function GetPlayerName_string(_arg_1:int):String
        {
            if (_arg_1 < 0)
            {
                return (cLocaManager.GetInstance().getLabel("Bandits"));
            };
            if (_arg_1 == 0)
            {
                return ("None");
            };
            return (this.FindPlayerFromId(_arg_1).GetPlayerName_string());
        }

        public function set mIsDefenseMode(_arg_1:Boolean):void
        {
            var _local_2:Object = this._625721612mIsDefenseMode;
            if (_local_2 !== _arg_1)
            {
                this._625721612mIsDefenseMode = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "mIsDefenseMode", _local_2, _arg_1));
            };
        }

        public function IsActiveAndInputActive():Boolean
        {
            return ((this.mActiveG) && (this.mComputeAndInputActive));
        }

        public function dispatchEvent(_arg_1:Event):Boolean
        {
            return (this._bindingEventDispatcher.dispatchEvent(_arg_1));
        }

        public function SetCurrentPlayerGuild(_arg_1:dGuildVO):void
        {
            var _local_2:dGuildVO;
            var _local_3:dQuestDefinitionHintVO;
            var _local_4:dQuestDefinitionHintVO;
            var _local_5:dQuestDefinitionHintVO;
            var _local_6:dGuildPlayerListItemVO;
            var _local_7:dGuildPlayerListItemVO;
            if (this.mCurrentPlayerGuild != null)
            {
                _local_2 = this.mCurrentPlayerGuild;
            };
            if (_arg_1)
            {
                if (_arg_1.guildBank)
                {
                    this.SetCurrentPlayerGuildBank(_arg_1.guildBank);
                }
                else
                {
                    if (!this.mCurrentPlayerGuildBank.mIsInitialized)
                    {
                        this.RefreshGuildBank();
                    };
                };
            };
            this.mCurrentPlayerGuild = _arg_1;
            this.channels.SPECIALIST.notify(SpecialistNotifier.IN_GUILD, this.mCurrentPlayerGuild);
            if ((((this.isOnHomzone()) && (!(this.mVotesManager.GetPlayerVote().seen))) && (this.mVotesManager.IsVoteEnabled())))
            {
                _local_3 = new dQuestDefinitionHintVO();
                _local_3.type = HINT_TYPE.GLOW;
                _local_3.pointTo = "GAMESTATE_ID_ACTIONBAR.actionBarRight.btnActionBar05";
                _local_4 = new dQuestDefinitionHintVO();
                _local_4.type = HINT_TYPE.GLOW;
                _local_4.pointTo = "GAMESTATE_ID_GUILD_WINDOW.GuildMarket";
                _local_5 = new dQuestDefinitionHintVO();
                _local_5.type = HINT_TYPE.GLOW;
                _local_5.pointTo = "GAMESTATE_ID_GUILD_WINDOW.btnGuildMarketToggleHistory";
                gHintManager.ShowHints(new ArrayCollection([_local_3, _local_4, _local_5]));
            };
            globalFlash.gui.mFriendsList.Refresh();
            globalFlash.gui.mGuildWindow.SetGuild(_arg_1);
            if (((!(_local_2 == null)) && (!(this.mCurrentPlayerGuild == null))))
            {
                for each (_local_6 in _local_2.members)
                {
                    for each (_local_7 in this.mCurrentPlayerGuild.members)
                    {
                        if (_local_6.username == _local_7.username)
                        {
                            _local_7.onlineStatus = _local_6.onlineStatus;
                            break;
                        };
                    };
                };
            };
            if (globalFlash.gui.mChatPanel != null)
            {
                if (this.mCurrentPlayerGuild)
                {
                    globalFlash.gui.mChatPanel.setGuildTag(this.mCurrentPlayerGuild.tag);
                }
                else
                {
                    globalFlash.gui.mChatPanel.setGuildTag();
                };
            };
        }

        public function IsAdventureZoneID(_arg_1:int):Boolean
        {
            return (_arg_1 <= defines.ADVENTUREZONEID);
        }

        [Bindable(event="propertyChange")]
        public function get mCurrentPlayer():cPlayerData
        {
            return (this._617771443mCurrentPlayer);
        }

        public function CalculateZoneCheckSum():void
        {
            var _local_9:cBuilding;
            var _local_10:int;
            var _local_11:Vector.<cBuilding>;
            var _local_12:cBuilding;
            var _local_13:int;
            var _local_14:int;
            var _local_15:int;
            var _local_16:Vector.<cSpecialist>;
            var _local_17:Vector.<dResource>;
            var _local_18:dResource;
            var _local_19:int;
            var _local_20:int;
            var _local_21:int;
            var _local_22:Vector.<cSquad>;
            var _local_23:cSquad;
            var _local_24:cSpecialist;
            var _local_25:cSpecialistTask;
            this.mZoneCheckVO.clientTime = (int(this.GetClientTime()) & 0x7FFFFFFF);
            this.mZoneCheckVO.gameTickRefreshCounter = this.mGameTickRefreshCounter;
            var _local_1:cResources = this.mCurrentPlayerZone.GetResources(this.mHomePlayer);
            var _local_2:int;
            var _local_3:int;
            var _local_4:int;
            if (_local_1 != null)
            {
                _local_17 = _local_1.GetPlayerResources_vector(RESOURCE_GROUP.ALL);
                for each (_local_18 in _local_17)
                {
                    _local_3 = (_local_3 ^ (_local_18.amount + (_local_2 << 12)));
                    _local_4 = (_local_4 + _local_18.amount);
                    _local_2++;
                };
                _local_3 = (_local_3 + ((_local_4 & 0x03FF) << 20));
            };
            this.mZoneCheckVO.zoneCheckSumResources = _local_3;
            _local_2 = 0;
            var _local_5:int;
            var _local_6:int;
            var _local_7:int;
            var _local_8:Vector.<cBuilding> = this.mCurrentPlayerZone.mStreetDataMap.GetBuildings_vector();
            for each (_local_9 in _local_8)
            {
                if (_local_9 != null)
                {
                    _local_19 = (int(_local_9.mBuildingCreationTime) & 0x7FFFFFFF);
                    _local_20 = _local_9.GetBuildingMode();
                    if (((_local_20 >= cBuilding.BUILDING_MODE_BUILDER_WALKS_FROM_RESOURCECREATIONHOUSE_TO_STOREHOUSE) && (_local_20 <= cBuilding.BUILDING_MODE_WORKANIM_IS_WORKING_AT_EXTERNAL_DEPOSIT)))
                    {
                        _local_20 = cBuilding.BUILDING_MODE_WORKANIM_IS_WORKING_AT_EXTERNAL_DEPOSIT;
                    };
                    _local_21 = _local_9.GetUpgradeLevel();
                    if (_local_9.GetBuildingName_string() == defines.GUILDHOUSE_NAME_string)
                    {
                        _local_21 = 1;
                    };
                    if (_local_9.isGarrison())
                    {
                        _local_5 = (_local_5 ^ ((_local_20 + (_local_9.GetGrid() << 4)) + (_local_19 << 16)));
                        _local_5 = (_local_5 ^ ((_local_21 + (_local_9.GetGOContainer().mGfxResourceListNr << 6)) + (_local_9.getPlayerID() << 16)));
                    }
                    else
                    {
                        _local_7 = (_local_7 ^ _local_20);
                        _local_6 = (_local_6 ^ (_local_9.GetGrid() + (_local_19 << 6)));
                        _local_6 = (_local_6 ^ ((_local_21 + (_local_9.GetGOContainer().mGfxResourceListNr << 6)) + (_local_9.getPlayerID() << 16)));
                    };
                };
            };
            this.mZoneCheckVO.zoneCheckSumBuildings = _local_6;
            this.mZoneCheckVO.zoneCheckSumBuildingModes = _local_7;
            this.mZoneCheckVO.zoneCheckSumGarrisons = _local_5;
            _local_10 = 0;
            _local_11 = this.mCurrentPlayerZone.mStreetDataMap.GetBuildings_vector();
            for each (_local_12 in _local_11)
            {
                if (null != _local_12)
                {
                    _local_22 = _local_12.GetArmy().GetSquadsCollection_vector();
                    for each (_local_23 in _local_22)
                    {
                        _local_10 = (_local_10 ^ (_local_23.GetUnitBase().GetCombatPriority() + (_local_23.GetAmount() << 6)));
                    };
                };
            };
            this.mZoneCheckVO.zoneCheckSumBandits = _local_10;
            _local_13 = 0;
            _local_14 = 0;
            _local_15 = 0;
            _local_16 = this.mCurrentPlayerZone.GetSpecialists_vector();
            if (_local_16 != null)
            {
                for each (_local_24 in _local_16)
                {
                    _local_13 = (_local_13 ^ _local_24.GetType());
                    _local_25 = _local_24.GetTask();
                    if (((((!(_local_25 == null)) && (!(_local_25.GetType() == SPECIALIST_TASK_TYPES.WAIT_FOR_CONFIRMATION))) && (!(_local_25.GetType() == SPECIALIST_TASK_TYPES.FIND_EXPEDITION))) && (!(_local_25.GetType() == SPECIALIST_TASK_TYPES.FIND_ADVENTURE_ZONE))))
                    {
                        _local_13 = (_local_13 ^ ((_local_25.GetType() << 6) + (_local_25.GetTaskPhase() << 16)));
                        if (_local_25.GetType() == SPECIALIST_TASK_TYPES.ATTACK_BUILDING_NEW_COMBAT)
                        {
                            _local_15 = (_local_15 ^ (_local_25 as cSpecialistTask_AttackBuildingNewCombat).GetCombatChecksum());
                        };
                    };
                    _local_14 = (_local_14 ^ _local_24.GetArmy().GetChecksum());
                };
            };
            this.mZoneCheckVO.zoneCheckSumSpecialists = _local_13;
            this.mZoneCheckVO.zoneCheckSumSquads = _local_14;
            this.mZoneCheckVO.zoneCheckSumCombat = _local_15;
            this.mZoneCheckVO.zoneCheckSumCollectionParts = this.mContentGeneratorManager.CalculateZoneCheckSum();
            var _local_26:int;
            var _local_27:ArrayCollection = this.mZoneBuffManager.getZoneBuffsForPersistence();
            var _local_28:dPersistedBuffApplianceVO;
            var _local_29:cBuffDefinition;
            var _local_30:Number;
            if (_local_27 != null)
            {
                for each (_local_28 in _local_27)
                {
                    if (_local_28 != null)
                    {
                        _local_29 = cBuffDefinition.GetById(_local_28.buffID);
                        if (_local_29 != null)
                        {
                            _local_30 = (_local_28.startTime + _local_29.getDuration(_local_28.applianceMode));
                            _local_26 = (_local_26 ^ ((Math.abs(_local_30) < 2147483648) ? int(_local_30) : int(0x80000000)));
                        };
                    };
                };
            };
            this.mZoneCheckVO.zoneCheckSumBuffs = _local_26;
            this.mZoneCheckVO.zoneCheckSumBlackMarketAuction = -1;
            this.mZoneCheckUpdateVO = this.mZoneCheckVO;
        }

        public function addEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false, _arg_4:int=0, _arg_5:Boolean=false):void
        {
            this._bindingEventDispatcher.addEventListener(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
        }

        public function getTimedTriggerManager():TimedTriggerManager
        {
            return (this.mTimedTriggerManager);
        }

        public function getComparedUserTree(_arg_1:int):IAchievementTreeNode
        {
            var _local_2:UserAchievementManager = this.mComparedUsersAchievementManager[_arg_1];
            if (_local_2 != null)
            {
                if (getTimer() < (_local_2.getCreatedTime() + AchievementConsts.COMPARED_USER_ACHIEVEMENTS_REFRESH_TIME_MILLIS))
                {
                    return (_local_2.getTree());
                };
            };
            this.mComparedUsersAchievementManager[_arg_1] = null;
            return (null);
        }

        protected function StreamGroup(_arg_1:cGOGroup):void
        {
            var _local_2:cGOSpriteLibContainer;
            for each (_local_2 in _arg_1.mGOList_vector)
            {
                if (((((!(_local_2 == null)) && (_local_2.mStream)) && (!(_local_2.mStreamingInProgress))) && (_local_2.isSpriteUsed())))
                {
                    if (_local_2.IsStreamingEnabled())
                    {
                        _local_2.mStreamingInProgress = true;
                        _local_2.LoadAll(_local_2.mFileName_string, this.StreamingComplete, _local_2.mDeltaCompression);
                        this.mStreamingParallelCntr++;
                    };
                };
            };
            for each (_local_2 in _arg_1.mGOWorkAnimList_vector)
            {
                if (_local_2)
                {
                    if ((((_local_2.mStream) && (!(_local_2.mStreamingInProgress))) && (_local_2.isSpriteUsed())))
                    {
                        _local_2.mStreamingInProgress = true;
                        _local_2.LoadAll(_local_2.mFileName_string, this.StreamingComplete, _local_2.mDeltaCompression);
                        this.mStreamingParallelCntr++;
                    };
                };
            };
            if (_arg_1.mLastCurrentStreams == _arg_1.mCurrentStreams)
            {
                _arg_1.mStreamedDelay--;
                if (_arg_1.mStreamedDelay < 0)
                {
                    _arg_1.mStreamIsIdle = true;
                };
            }
            else
            {
                _arg_1.mStreamedDelay = cGOGroup.STREAM_IDLE_DELAY;
                _arg_1.mLastCurrentStreams = global.backgroundGroup.mCurrentStreams;
                _arg_1.mStreamIsIdle = false;
            };
        }

        public function MouseDown(_arg_1:MouseEvent):void
        {
        }

        public function UnselectBuilding():void
        {
            this.mCurrentlySelectededBuilding = null;
        }

        public function getSeed():int
        {
            return ((this.mGameClientTime % 0xFFFFFFF) as int);
        }

        public function ApplicationResized():void
        {
        }

        public function FocusOutHandler(_arg_1:FocusEvent):void
        {
        }

        public function CreateGameTickCommand(_arg_1:int, _arg_2:int, _arg_3:Object, _arg_4:int):dGameTickCommandVO
        {
            var _local_6:dGameTickCommandVO;
            var _local_7:dGameTickCommandVO;
            var _local_8:Number;
            var _local_5:Number = (this.GetGameTickPostProcessTime(0) + _arg_4);
            for each (_local_6 in this.mGameTickCommand_vector)
            {
                _local_8 = ((_local_6.time > _local_5) ? (_local_6.time - _local_5) : (_local_5 - _local_6.time));
                if (_local_8 < 1E-7)
                {
                    _local_5 = (_local_5 + 100);
                    break;
                };
            };
            _local_7 = new dGameTickCommandVO();
            _local_7.playerID = _arg_1;
            _local_7.time = _local_5;
            _local_7.mode = _arg_2;
            _local_7.data = _arg_3;
            this.AddGameTickCommand(_local_7);
            return (_local_7);
        }

        public function GetCurrentPlayerGuildBank():cGuildBank
        {
            return (this.mCurrentPlayerGuildBank);
        }

        public function ZoomHasChanged():void
        {
        }

        public function SetCurrentPlayerGuildBank(_arg_1:dGuildBankVO):void
        {
            this.mCurrentPlayerGuildBank.Init(_arg_1);
            if (globalFlash.gui.mGuildBankWindow.IsVisible())
            {
                globalFlash.gui.mGuildBankWindow.ReconfigureTabs();
                globalFlash.gui.mGuildBankWindow.RefreshResourcesList();
            };
        }

        public function SetClientTime(_arg_1:Number):void
        {
            this.mGameClientTime = _arg_1;
        }

        public function set pickupManager(_arg_1:PickupManager):void
        {
            var _local_2:Object = this._81847919pickupManager;
            if (_local_2 !== _arg_1)
            {
                this._81847919pickupManager = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "pickupManager", _local_2, _arg_1));
            };
        }

        public function buildTaskManager(_arg_1:dZoneVO):void
        {
            var _local_2:Vector.<String>;
            var _local_3:dBuildingVO;
            if (!this.IsAdventureZoneID(this.mCurrentPlayer.GetPlayerId()))
            {
                _local_2 = new Vector.<String>();
                for each (_local_3 in _arg_1.buildings)
                {
                    if (TaskPool.getInstance().isTaskBuilding(_local_3.buildingName_string))
                    {
                        _local_2.push(_local_3.buildingName_string);
                    };
                };
                this.innerBuildTaskManager(_arg_1.tasksData, _local_2);
            };
        }

        public function SendServerAction(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:int, _arg_5:Object, _arg_6:Responding=null):dServerAction
        {
            var _local_7:dServerAction = new dServerAction();
            _local_7.type = _arg_2;
            _local_7.grid = _arg_3;
            _local_7.endGrid = _arg_4;
            _local_7.data = _arg_5;
            this.mClientMessages.SendMessagetoServer(_arg_1, this.mCurrentViewedZoneID, _local_7, _arg_6);
            return (_local_7);
        }

        protected function setCurrentTaskManager(_arg_1:TaskManager):void
        {
            if (this.mCurrentTaskManager != null)
            {
                this.mCurrentTaskManager.dispose();
                this.mCurrentTaskManager = null;
            };
            this.mCurrentTaskManager = _arg_1;
            this.channels.TASK_MANAGER.updated();
        }

        public function getAdventureLootMediator():AdventureLootMediator
        {
            return (this.adventureLootMediator);
        }

        public function GetPlayerListPositionFromId(_arg_1:int):int
        {
            var _local_2:int = this.mPlayersOnMap_vector.length;
            var _local_3:int;
            while (_local_3 < _local_2)
            {
                if (this.mPlayersOnMap_vector[_local_3].GetPlayerId() == _arg_1)
                {
                    return (_local_3);
                };
                _local_3++;
            };
            return (0);
        }

        public function removeEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false):void
        {
            this._bindingEventDispatcher.removeEventListener(_arg_1, _arg_2, _arg_3);
        }

        public function UsesCombatThree():Boolean
        {
            return (this.mUsesCombatThree);
        }

        public function ClearLevelOnTheFly():void
        {
        }

        public function ZoneUpdateAfterMapRefreshed():void
        {
            var _local_2:cPlayerData;
            var _local_1:cResources = this.mCurrentPlayerZone.GetResources(this.mCurrentPlayer);
            if (_local_1 != null)
            {
                _local_1.CalculateMaxLimitsForResources(this.mCurrentPlayer.GetPlayerId());
                _local_1.mDirtyIndicator = DIRTY_INDICATOR.CLEAN;
            };
            this.mCurrentPlayer.SetXPChanged();
            for each (_local_2 in this.mPlayersOnMap_vector)
            {
                _local_2.RefreshBuildingList();
            };
            if (this.mHomePlayer.GetPlayerId() == this.mCurrentPlayer.GetPlayerId())
            {
                globalFlash.gui.mInfoBar.SetBuildingsCount(this.mCurrentPlayer.mCurrentBuildingsCountAll, this.mCurrentPlayer.GetMaxBuildingCount());
            };
            this.mCurrentPlayerZone.mStreetDataMap.RefreshMayorHouse();
            this.mCurrentPlayerZone.mStreetDataMap.RefreshLogisticsHouse();
            this.mCurrentPlayerZone.mStreetDataMap.RefreshGuildHouse();
            this.mCurrentPlayerZone.mStreetDataMap.RefreshGuildBankHouse();
            this.mCurrentPlayerZone.mStreetDataMap.CalculateSectors(((this.mHomePlayer != null) ? this.mHomePlayer : this.mCurrentPlayer));
            this.mCurrentPlayerZone.mStreetDataMap.CalculateBlockingGrid();
            this.mCurrentPlayerZone.mStreetDataMap.CalculateWatchAreas();
            this.mCurrentPlayerZone.mStreetDataMap.CalculateBorders();
            this.mCurrentPlayerZone.mStreetDataMap.RefreshExploredDeposits();
        }

        protected function StreamingComplete(_arg_1:cEventWithData):void
        {
            var _local_2:cGOSpriteLibContainer = (_arg_1.mObject as cGOSpriteLibContainer);
            _local_2.mStream = false;
            _local_2.mStreamingInProgress = false;
            this.mStreamingParallelCntr--;
            _local_2.mGoGroup.mCurrentStreams++;
            if (_local_2.mRefreshAfterStream)
            {
                this.mCurrentPlayerZone.SetBackgroundHasChanged(true);
            };
        }

        public function GetUnscaledClientTime():Number
        {
            return (gMisc.GetTimeSinceStartup());
        }

        public function LocalLogMessageDetail(_arg_1:String):void
        {
            var _local_4:String;
            if (this.mInGameErrorMessagesLogDetail_vector.length > 1000)
            {
                this.mInGameErrorMessagesLogDetail_vector.splice(0, 100);
            };
            var _local_2:Array = _arg_1.split("\n");
            if (_local_2.length == 0)
            {
                _local_2.push(_arg_1);
            };
            var _local_3:* = (("[" + int((gMisc.GetTimeSinceStartup() / 100))) + "] ");
            for each (_local_4 in _local_2)
            {
                _local_3 = (_local_3 + (_local_4 + " <cr>"));
            };
            this.mInGameErrorMessagesLogDetail_vector.push(_local_3);
            _arg_1 = _local_3;
            cLog.info(("[LocalLogMessageDetail] " + _arg_1));
        }

        public function IsCurrentPlayerQuestPlayer():Boolean
        {
            var _local_1:int = this.mHomePlayer.GetPlayerId();
            if (this.IsAdventureZoneID(_local_1))
            {
                return (true);
            };
            if (_local_1 == this.mCurrentPlayer.GetPlayerId())
            {
                return (true);
            };
            return (false);
        }

        public function IsQuestPlayerOnMap():Boolean
        {
            var _local_2:cPlayerData;
            var _local_1:int = this.mHomePlayer.GetPlayerId();
            if (this.IsAdventureZoneID(_local_1))
            {
                return (true);
            };
            for each (_local_2 in this.mPlayersOnMap_vector)
            {
                if (_local_2.GetPlayerId() == _local_1)
                {
                    return (true);
                };
            };
            return (false);
        }

        public function StartScrolling(_arg_1:int):void
        {
            this.scroll = _arg_1;
        }

        public function joinGuildChannels():void
        {
            if (((!(globalFlash.gui.mChatPanel == null)) && (!(this.mCurrentPlayerGuild == null))))
            {
                globalFlash.gui.mChatPanel.joinGuildChannel(this.mCurrentPlayerGuild);
                if (this.mCurrentPlayerGuild.playerPermissions.OfficersChannel())
                {
                    globalFlash.gui.mChatPanel.joinOfficersChannel(this.mCurrentPlayerGuild);
                }
                else
                {
                    globalFlash.gui.mChatPanel.leaveOfficesChannel();
                };
            };
        }

        public function registerOnMapClickHandler(_arg_1:Function):void
        {
            this.onMapClickHandler = _arg_1;
        }

        public function SelectBuilding(_arg_1:cBuilding):void
        {
            this.mCurrentlySelectededBuilding = _arg_1;
        }

        public function GetCurrentDateInHours():Number
        {
            return (Math.round((((this.GetCurrentDateInMs() / 1000) / 60) / 60)));
        }


    }
}
