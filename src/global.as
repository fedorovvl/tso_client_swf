package 
{
    import flash.events.IEventDispatcher;
    import __AS3__.vec.Vector;
    import ItemRegistry.IRItem;
    import GUI.Assets.gLoadingScreenInterface;
    import flash.utils.Dictionary;
    import GO.cGOGroup;
    import GOSets.cGOSet;
    import GOSets.cGOSetList;
    import GUI.vo.UIComponentHeaderVO;
    import Communication.VO.dPvpLevelDataVO;
    import mx.collections.ArrayCollection;
    import nLib.cXML;
    import flash.xml.XMLNode;
    import GO.cWatchData;
    import BuffSystem.cBuffDefinition;
    import TimedProduction.iTimedProductionDefinition;
    import Specialists.cSpecialistTaskDefinition;
    import nLib.cPosInt;
    import nLib.cStringIntDictionary;
    import Communication.VO.ExpeditionMapLevelGroupVO;
    import Communication.VO.ExpeditionDifficultyVO;
    import Communication.VO.ExpeditionMapSizeVO;
    import Communication.VO.GameEventVO;
    import GameEvent.EventWindowDefinition;
    import com.bluebyte.tso.donations.EventDonationController;
    import ShopSystem.PromotionVO;
    import Skill.SkillpointDefinition;
    import Skill.SkillDefinition;
    import Skill.SkillTreeDefinition;
    import Interface.cGameInterface;
    import BuffSystem.PremiumAccount;
    import Utils.HashMapWrapper;
    import ShopSystem.cShopItemGroup;
    import com.bluebyte.tso.ui.battle.battlecloud.definition.BattlegroundDefinition;
    import com.bluebyte.tso.rendering.buildinglayers.BuildingLayerManager;
    import com.bluebyte.tso.service.ServiceManager;
    import Communication.VO.dFilterVO;
    import Communication.VO.ReactionListVO;
    import flash.events.EventDispatcher;
    import mx.core.Application;
    import mx.events.PropertyChangeEvent;
    import flash.events.Event;
    import __AS3__.vec.*;

    public class global implements IEventDispatcher 
    {

        public static var commandLineArguments:Object = null;
        public static const enableClientLogTransfer:Boolean = false;
        public static var emptyString:String = "";
        public static var itemLimits:Vector.<IRItem> = new Vector.<IRItem>();
        public static var loadingScreen:gLoadingScreenInterface = null;
        public static var gameState:String;
        public static var CHEAT_KEYS:Boolean = true;
        public static var screenWidth:int;
        public static var screenHeight:int;
        public static var screenWidthHalf:int;
        public static var screenHeightHalf:int;
        public static var mSwitchToAntialiasingCntr:int = 0;
        public static var defaultGosetBuffTwinkleName:String;
        public static var defaultGosetFriendBuffTwinkleName:String;
        public static var customGosetBuffTwinkleName:String;
        public static var customGosetFriendBuffTwinkleName:String;
        public static var buffingBlockedUntil:Dictionary = new Dictionary();
        public static const guiIconGroup:cGOGroup = new cGOGroup();
        public static const backgroundGroup:cGOGroup = new cGOGroup();
        public static const streetGroup:cGOGroup = new cGOGroup();
        public static const buildingGroup:cGOGroup = new cGOGroup();
        public static const landscapeGroup:cGOGroup = new cGOGroup();
        public static const settlerGroup:cGOGroup = new cGOGroup();
        public static const animalGroup:cGOGroup = new cGOGroup();
        public static const effectGroup:cGOGroup = new cGOGroup();
        public static const goSet_vector:Vector.<cGOSet> = new Vector.<cGOSet>();
        public static const goSetList_vector:Vector.<cGOSetList> = new Vector.<cGOSetList>();
        public static var activateDebugQuestGui:Boolean = false;
        public static const uiComponentHeaders:Vector.<UIComponentHeaderVO> = new Vector.<UIComponentHeaderVO>();
        public static var showAllSettlerNames:Boolean = false;
        public static const playerPvPLevels_vector:Vector.<dPvpLevelDataVO> = new Vector.<dPvpLevelDataVO>();
        public static const playerPvPLevelEffects_vector:Vector.<ArrayCollection> = new Vector.<ArrayCollection>();
        public static const playerLevels_vector:Vector.<int> = new Vector.<int>();
        public static const playerLevelRewardXPs_vector:Vector.<int> = new Vector.<int>();
        public static const playerLevelEffects_vector:Vector.<ArrayCollection> = new Vector.<ArrayCollection>();
        public static const cityLevels_vector:Vector.<int> = new Vector.<int>();
        public static var gameSettingsFilename:String = defines.FILENAME_GAME_SETTINGS;//"game_settings.xml"
        public static var unitsFilename:String = defines.FILENAME_UNITS;//"game_units.xml"
        public static var gfxSettingsFilename:String = defines.FILENAME_GFX_SETTINGS;//"gfx_settings.xml"
        public static var soundSettingsFilename:String = defines.FILENAME_SOUND_SETTINGS;//"sound_settings.xml"
        public static var expeditionMapRules:String = defines.FILENAME_EXPEDITION_MAP_RULES;//"game_expedition_map_rules.xml"
        public static var expeditionMapFiles:String = defines.FILENAME_EXPEDITION_MAPS;//"game_expedition_maps.xml"
        public static var shopConfigFilename:String = defines.FILENAME_SHOP_CONFIG;//"shopconfig.xml"
        public static var skillSettingsFilenames_vector:Vector.<String> = new Vector.<String>();
        public static var helpDefinitionsFilename:String = defines.FILENAME_HELP_DEFINITIONS;//"help_definitions.xml"
        public static var gameEventsFilename:String = defines.FILENAME_GAME_EVENTS;//"game_events.xml"
        public static var collectionsFilename:String = defines.FILENAME_COLLECTIONS_DEFINITIONS;//"collections_definitions.xml"
        public static var adventCalendarFilename:String = defines.FILENAME_ADVENT_CALENDAR_CONFIG;//"advent_calendar_config_default.xml"
        public static var votesFilename:String = defines.FILENAME_VOTES_DEFINITIONS;//"votes_config_default.xml"
        public static var votesGroupFilename:String = defines.FILENAME_VOTES_SHOP_GROUP;//"votes_shop_group.xml"
        public static var epicWorkyardFilename:String = defines.FILENAME_EPIC_WORKYARD;//"epic_workyard_definitions.xml"
        public static var triggersFilename:String = defines.FILENAME_TRIGGER_DEFINITIONS;//"trigger_loca_definitions.xml"
        public static var achievementsFilename:String = defines.FILENAME_ACHIEVEMENTS_DEFINITIONS;//"achievements_definitions.xml"
        public static var collectionGeneratorFilename:String = defines.FILENAME_COLLECTION_GENERATOR_DEFINITIONS;//"content_generator.xml"
        public static var eventsFilename:String = defines.FILENAME_EVENTS_CONFIG;//"events_config.xml"
        public static var taskFilename:String = defines.FILENAME_TASK_DEFINITIONS;//"task_building_definitions.xml"
        public static var genericValuesFilename:String = defines.GENERIC_VALUES_CONFIG;//"generic_values.xml"
        public static var itemLimitsFilename:String = defines.FILENAME_ITEM_LIMITS;//"item_limits.xml"
        public static var reactionsFilename:String = defines.REACTIONS_CONFIG;//"reactions.xml"
        public static var playerInitialLevel:int;
        public static var returnRate:int;
        public static var defaultChatChannels:Dictionary = new Dictionary();
        public static var gfxSettingsGameObjectsXML:cXML = new cXML();
        public static var textureAtlas:XMLNode;
        public static var GOListScale:int = 0;
        public static var changeLogUrl:String;
        public static var promoCodeUrl:String;
        public static var tipOfTheDayCount:int;
        public static var loadingBannerImage:String;
        public static var loadingMessageCount:int;
        private static var _792929080partner:String;
        public static var partnerSettings:Dictionary;
        public static var guildHighscorePageSize:int;
        public static var guildBankRefreshInterval:int = defines.GUILD_BANK_REFRESH_INTERVAL;//30
        public static var guildBannerCount:int;
        public static var guildJoinCooldown:int;
        public static var guildMaxSizeLimit:int;
        public static var guildAppointedLeaderMaxWait:Number;
        public static var guildInactiveStepDown:Number;
        public static var guildMaxSuccessionLimit:int;
        public static var guildUpgradeLevels:Object = new Object();
        public static var guildBankPayTabAllowedResources:Vector.<String> = new Vector.<String>();
        public static var guildBankInitialGoodsCapacity:int;
        public static var guildBankMinWithdrawLimits:int;
        public static var guildBankInitialBuffsCapacity:int;
        public static var guildBankMinBuffsWithdrawLimits:int;
        public static var guildBankAditionalTabCostCoin:Object = new Object();
        public static var guildBankAditionalTabCostGem:Object = new Object();
        public static var guildBankEnlargeCostCoin:Object = new Object();
        public static var guildBankEnlargeCostGem:Object = new Object();
        public static var guildBankEnlargeAmount:Object = new Object();
        public static var guildBankEnlargeBuffAmount:Object = new Object();
        public static var resourceHardcurrencyValues:Object = new Object();
        public static var questCategoryOrder:Vector.<Object> = new Vector.<Object>();
        public static var helpCategoryOrder:Vector.<String> = new Vector.<String>();
        public static var hasEventInfoPanelBeenShown:Boolean = false;
        public static var guildQuestRewardModifierPerSize:Object = new Object();
        public static var combatLoopDurationMS:int = 1000;
        public static var unitSwitchPauseDuration:int = 2000;
        public static var combatUnitSwitchChance:int = 50;
        private static var _485774909batchUnitsPerDisc:int = 1;
        public static var pvpSafeTimeInitial:int = 43200;
        public static var pvpAttackDuration:int = (6 * 3600);//21600
        public static var colonySlotTempPriceModifier:Number = 1.5;
        public static var colonyYieldTickTime:int = 21600;
        public static var defaultCancelledRankingTime:int = 21600;
        public static var minCombatTierToRank:int = 3;
        public static var chatRoomSendCooldown:int;
        public static var chatReconnectInterval:int;
        public static var buildingInfoIconDelay:int = 0;
        public static var combatRoundDuration:int = 0;
        public static var repairRoundDuration:int = 0;
        public static var repairRate:int = 10;
        public static var repairCostFactor:int = 100;
        public static var defaultBuildInstantCosts:int = 5;
        public static var defaultUpgradeInstantBonusPercentage:int = 5;
        public static var watchAreas_vector:Vector.<Vector.<cWatchData>>;
        public static var mailLifetimes_vector:Vector.<Number>;
        public static var expirableMailTypes:Vector.<int> = new Vector.<int>();
        private static var _1247857637mailboxWindowSize:int;
        public static var mailboxPageSize:int;
        public static var maxRecipients:int;
        public static const buildingUpgradeBonuses_vector:Vector.<cBuffDefinition> = new Vector.<cBuffDefinition>();
        public static const map_BuffName_BuffDefinition:Object = new Object();
        public static const map_BuffId_BuffDefinition:Object = new Object();
        public static const resourceDefinitions_vector:Vector.<String> = new Vector.<String>();
        public static const timedProductions_vector:Vector.<Vector.<iTimedProductionDefinition>> = new Vector.<Vector.<iTimedProductionDefinition>>();
        public static const specialistTaskDefinitions_vector:Vector.<cSpecialistTaskDefinition> = new Vector.<cSpecialistTaskDefinition>();
        public static const miscConditions:Vector.<String> = new Vector.<String>();
        public static var buildingDefaultParameterConstructionDuration:int = 1;
        public static var buildingDefaultParameterDestructionDuration:int = 1;
        public static var buildingDefaultParameterXP:int = 0;
        public static var buildingDefaultFogRemoveList_vector:Vector.<cPosInt> = new Vector.<cPosInt>();
        public static var buildingDefaultParameterDoNotCountList_dictionary:cStringIntDictionary = new cStringIntDictionary();
        public static var buildingDefaultParameterDoNotShowMissingResourceIcon_dictionary:cStringIntDictionary = new cStringIntDictionary();
        public static var hiddenBanditCamps_dictionary:cStringIntDictionary = new cStringIntDictionary();
        public static var hideMouseOverDepositAmount_dictionary:cStringIntDictionary = new cStringIntDictionary();
        public static var initGlobalTimeScale:Number = 100;
        public static const ONE_HOURS_SEC:Number = 3600;
        public static var maxTempSlotsAvailablePerPlayer:int = 5;
        public static var tempSlotDuration:Number = 60;
        public static var checkProductionValueTriggerInterval:int = defines.CHECK_PRODUCTION_VALUE_TRIGGER_INTERVAL;//30
        public static var expeditionMapLevelGroupVO:ExpeditionMapLevelGroupVO = null;
        public static var expeditionDifficultyVO:ExpeditionDifficultyVO = null;
        public static var expeditionMapSizeVO:ExpeditionMapSizeVO = null;
        public static var tradeRefreshInterval:int = defines.TRADE_REFRESH_INTERVAL;//30
        public static var tradeExpirationTime:int = ((10 * 1000) * 60);//600000
        public static var tradeCoolDownTime:int = (60 * 1000);//60000
        public static var expiredTradesInDisplay:int = 5;
        public static var costOfUnlimitingLots:int = 5;
        public static var tradeMaxSearchAmount:int;
        public static var tradeMaxBuffAmount:int;
        public static var tradeMaxBuildingAmount:int;
        public static var tradeMaxAdventureAmount:int;
        public static var activateSlotsWithCoins_vector:Vector.<int> = new Vector.<int>();
        public static var activateSlotsWithGems_vector:Vector.<int> = new Vector.<int>();
        public static var tradeFriendDelay:int = 86400;
        public static var tradeCacheSetTime:int = (30 * 1000);//30000
        public static var economyCalculationTime:int = 3600;
        public static const map_HelpName_HelpDefinition:Object = new Object();
        public static const gameEvent_vector:Vector.<GameEventVO> = new Vector.<GameEventVO>();
        public static const streetGridX:int = 117;
        public static const streetGridY:int = 72;
        public static const streetGridXFloat:Number = streetGridX;//117
        public static const streetGridYFloat:Number = streetGridY;//72
        public static const streetGridXHalf:int = (streetGridX / 2);//58
        public static const streetGridYHalf:int = (streetGridY / 2);//36
        public static const streetGridXHalfFloat:Number = streetGridXHalf;//58
        public static const streetGridYHalfFloat:Number = streetGridYHalf;//36
        public static var scrollSpeed:int = 25;
        public static var defaultMaximumBuildingsCountAll:int = 0;
        public static var defaultMaximumBuildingCount:int = 0;
        public static var adventureMaximumOwner:int;
        public static var adventureMaximumGuest:int;
        public static var maxAnimalsOnMap:int = 0;
        public static var alternativeWater:Boolean = false;
        public static var flashPlayerRedirectURL:String = "";
        public static var eventLoadingScreen:String;
        public static var eventLadderURL_string:String;
        public static var eventWindowDefinitions:Vector.<EventWindowDefinition> = new Vector.<EventWindowDefinition>();
        public static var eventDonations:EventDonationController = new EventDonationController();
        public static var eventBlockResource_string:String = "";
        public static var eventCounterWatchTime:uint = (30 * 1000);//30000
        public static var adventCalendarWatchTime:uint = (30 * 1000);//30000
        public static var useExternalServer:Boolean;
        public static var useBigBrother:Boolean;
        public static var bigBrotherURL:String;
        public static var staticFilesURL:String;
        public static var staticFilesURLList:Array;
        public static var userCountry:String;
        public static var realmLanguage:String;
        public static var lang:String;
        public static var gameworld:String;
        public static var baseUri:String;
        public static var domain:String;
        public static var localizedDomain:String;
        public static var settingsEnvironment:String = "default";
        public static var promotions_vector:Vector.<PromotionVO> = new Vector.<PromotionVO>();
        public static var promotionMinLvl:int;
        public static var depositDefinitions:Object = new Object();
        public static var skillPoints_vector:Vector.<SkillpointDefinition> = new Vector.<SkillpointDefinition>();
        public static var skills_vector:Vector.<SkillDefinition> = new Vector.<SkillDefinition>();
        public static var skillTrees_vector:Vector.<SkillTreeDefinition> = new Vector.<SkillTreeDefinition>();
        public static var starCoinConversionRate:Number;
        public static var generalSkillStarCoinConversionRate:Number;
        public static var ui:cGameInterface = null;
        private static var _2081397858ui_bindable:cGameInterface = null;
        public static var premiumAccount:PremiumAccount = new PremiumAccount();
        public static var advent_calendar_required_event:String = "inactive";
        public static var advent_calendar_days:ArrayCollection = new ArrayCollection();
        public static var eventSwitchSettings:ArrayCollection = new ArrayCollection();
        public static var genericValuesFromId:HashMapWrapper = new HashMapWrapper();
        public static var genericValuesFromName:HashMapWrapper = new HashMapWrapper();
        public static var pickupManagerLimitsPerType:HashMapWrapper = new HashMapWrapper();
        public static var vote_definitions:HashMapWrapper = new HashMapWrapper();
        public static var vote_shop_group:cShopItemGroup;
        public static var vote_pool_definitions:HashMapWrapper = new HashMapWrapper();
        public static var battlegroundDefinition:BattlegroundDefinition;
        public static var m_JSInitCall:String;
        public static var buildingLayerManager:BuildingLayerManager = BuildingLayerManager.getInstance();
        public static var achievementFacebookUrl:Object;
        public static var services:ServiceManager;
        public static var homeZoneToolBoxSectionData:ArrayCollection = new ArrayCollection();
        public static var defenseModeToolBoxSectionData:ArrayCollection = new ArrayCollection();
        public static var attackModeToolBoxSectionData:ArrayCollection = new ArrayCollection();
        public static var mGraphicScaleFactor:Number = 1;
        public static var omniSeedException:Vector.<String>;
        public static var adventAssetPrefix:String = "";
        public static var defaultFilter_vector:Vector.<dFilterVO>;
        public static var defaultAnimals:Object = new Object();
        public static var gameReactionListVO:ReactionListVO;
        private static var _staticBindingEventDispatcher:EventDispatcher = new EventDispatcher();

        private var _bindingEventDispatcher:EventDispatcher;

        public function global()
        {
            this._bindingEventDispatcher = new EventDispatcher(IEventDispatcher(this));
            super();
        }

        [Bindable(event="propertyChange")]
        public static function get ui_bindable():cGameInterface
        {
            return (global._2081397858ui_bindable);
        }

        public static function getApplication():SWMMO
        {
            return (Application.application as SWMMO);
        }

        public static function set batchUnitsPerDisc(_arg_1:int):void
        {
            var _local_3:IEventDispatcher;
            var _local_2:Object = global._485774909batchUnitsPerDisc;
            if (_local_2 !== _arg_1)
            {
                global._485774909batchUnitsPerDisc = _arg_1;
                _local_3 = global.staticEventDispatcher;
                if (_local_3 != null)
                {
                    _local_3.dispatchEvent(PropertyChangeEvent.createUpdateEvent(global, "batchUnitsPerDisc", _local_2, _arg_1));
                };
            };
        }

        public static function get staticEventDispatcher():IEventDispatcher
        {
            return (_staticBindingEventDispatcher);
        }

        [Bindable(event="propertyChange")]
        public static function get partner():String
        {
            return (global._792929080partner);
        }

        public static function set ui_bindable(_arg_1:cGameInterface):void
        {
            var _local_3:IEventDispatcher;
            var _local_2:Object = global._2081397858ui_bindable;
            if (_local_2 !== _arg_1)
            {
                global._2081397858ui_bindable = _arg_1;
                _local_3 = global.staticEventDispatcher;
                if (_local_3 != null)
                {
                    _local_3.dispatchEvent(PropertyChangeEvent.createUpdateEvent(global, "ui_bindable", _local_2, _arg_1));
                };
            };
        }

        public static function set partner(_arg_1:String):void
        {
            var _local_3:IEventDispatcher;
            var _local_2:Object = global._792929080partner;
            if (_local_2 !== _arg_1)
            {
                global._792929080partner = _arg_1;
                _local_3 = global.staticEventDispatcher;
                if (_local_3 != null)
                {
                    _local_3.dispatchEvent(PropertyChangeEvent.createUpdateEvent(global, "partner", _local_2, _arg_1));
                };
            };
        }

        [Bindable(event="propertyChange")]
        public static function get batchUnitsPerDisc():int
        {
            return (global._485774909batchUnitsPerDisc);
        }

        public static function set mailboxWindowSize(_arg_1:int):void
        {
            var _local_3:IEventDispatcher;
            var _local_2:Object = global._1247857637mailboxWindowSize;
            if (_local_2 !== _arg_1)
            {
                global._1247857637mailboxWindowSize = _arg_1;
                _local_3 = global.staticEventDispatcher;
                if (_local_3 != null)
                {
                    _local_3.dispatchEvent(PropertyChangeEvent.createUpdateEvent(global, "mailboxWindowSize", _local_2, _arg_1));
                };
            };
        }

        [Bindable(event="propertyChange")]
        public static function get mailboxWindowSize():int
        {
            return (global._1247857637mailboxWindowSize);
        }


        public function dispatchEvent(_arg_1:Event):Boolean
        {
            return (this._bindingEventDispatcher.dispatchEvent(_arg_1));
        }

        public function willTrigger(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.willTrigger(_arg_1));
        }

        public function addEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false, _arg_4:int=0, _arg_5:Boolean=false):void
        {
            this._bindingEventDispatcher.addEventListener(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
        }

        public function removeEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false):void
        {
            this._bindingEventDispatcher.removeEventListener(_arg_1, _arg_2, _arg_3);
        }

        public function hasEventListener(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.hasEventListener(_arg_1));
        }


    }
}
