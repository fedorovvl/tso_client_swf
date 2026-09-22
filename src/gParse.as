package 
{
    import nLib.cCustomDispatcher;
    import EpicWorkyard.EpicWorkyardsManager;
    import EpicWorkyard.EpicWorkyardsParser;
    import nLib.gMisc;
    import nLib.cXML;
    import ShopSystem.cShopItemGroup;
    import Achievements.AchievementsManager;
    import Achievements.AchievementsParser;
    import Tasks.TaskPool;
    import __AS3__.vec.Vector;
    import GO.cWatchData;
    import mx.collections.ArrayCollection;
    import BuffSystem.cBuffDefinition;
    import Specialists.cSpecialistTaskDefinition;
    import ServerState.dResource;
    import Specialists.cSpecialistSubTaskDefinition;
    import GameEvent.EventWindowDefinition;
    import Utils.StringUtils;
    import Communication.VO.EffectVO;
    import Communication.VO.dPvpLevelDataVO;
    import MilitarySystem.cMilitaryUnitDescription;
    import Enums.MAIL_TYPE;
    import AdventureSystem.cAdventureDefinition;
    import BuffSystem.BuffTargetGroups;
    import BuffSystem.BuffAdventureController;
    import com.bluebyte.tso.util.ClientLogger;
    import GOSets.cGOSetManager;
    import Specialists.cSpecialist;
    import Enums.SPECIALIST_TASK_TYPES;
    import Enums.PICKUP_PROVIDER_TYPE;
    import Model.ChannelMap;
    import nLib.cLog;
    import GUI.GAME.Chat.TSOChatMediator;
    import ServerState.gEconomics;
    import GUI.Loca.TriggerLocaManager;
    import GUI.Loca.TriggerLocaParser;
    import Communication.VO.TriggerVO;
    import Skill.SkillDefinition;
    import Skill.SkillpointDefinition;
    import Skill.SkillTreeDefinition;
    import ItemRegistry.IRItem;
    import Enums.ITEM_CONTENT_TYPE;
    import nLib.cStringIntDictionary;
    import Events.dEventVO;
    import Votes.cVoteDefinition;
    import Votes.cVotePoolDefinition;
    import Communication.VO.dHelpDefinitionVO;
    import Communication.VO.GameEventVO;
    import Collections.CollectionsManager;
    import Collections.CollectionsParser;
    import Communication.VO.GenericValueVO;
    import Communication.VO.dAdventCalendarDoorVO;
    import ShopSystem.dBanner;
    import Achievements.AchievementFacebookUrl;
    import nLib.cFilenameUtil;
    import GUI.Loca.cLocaManager;
    import Communication.VO.ReactionListVO;
    import MilitarySystem.cMilitaryUnitData;
    import Deposit.DepositDefinition;
    import GUI.vo.GraphicsHeaderVO;
    import com.bluebyte.tso.ui.battle.battlecloud.definition.BattlegroundDefinition;
    import Communication.VO.dFilterVO;
    import GUI.vo.UIComponentHeaderVO;
    import GUI.GAME.cBattleWindow;
    import TimedProduction.iTimedProductionDefinition;
    import TimedProduction.EffectTimedProductionDefinition;
    import Enums.TIMED_PRODUCTION_TYPE;
    import GO.cToolBoxSectionData;
    import ShopSystem.cShopItem;
    import __AS3__.vec.*;

    public class gParse 
    {

        private static var mDispatcherLanguageConfig:cCustomDispatcher = new cCustomDispatcher();
        private static var mDispatcherGfxSettings:cCustomDispatcher = new cCustomDispatcher();
        private static var mDispatcherUnits:cCustomDispatcher = new cCustomDispatcher();
        private static var mDispatcherGameSettings:cCustomDispatcher = new cCustomDispatcher();
        private static var mDispatcherShopConfig:cCustomDispatcher = new cCustomDispatcher();
        private static var mDispatcherHelpDefinitions:cCustomDispatcher = new cCustomDispatcher();
        private static var mDispatcherCollections:cCustomDispatcher = new cCustomDispatcher();
        private static var mDispatcherAchievements:cCustomDispatcher = new cCustomDispatcher();
        private static var mDispatcherTriggerLoca:cCustomDispatcher = new cCustomDispatcher();
        private static var mDispatcherGameEvents:cCustomDispatcher = new cCustomDispatcher();
        private static var mDispatcherSkillConfig:cCustomDispatcher = new cCustomDispatcher();
        private static var mDispatcherAdventCalendar:cCustomDispatcher = new cCustomDispatcher();
        private static var mDispatcherEpicWorkyards:cCustomDispatcher = new cCustomDispatcher();
        private static var mDispatcherEvents:cCustomDispatcher = new cCustomDispatcher();
        private static var mDispatcherGenericValues:cCustomDispatcher = new cCustomDispatcher();
        private static var mDispatcherTasks:cCustomDispatcher = new cCustomDispatcher();
        private static var mDispatcherContentGenerator:cCustomDispatcher = new cCustomDispatcher();
        private static var mDispatcherItemLimits:cCustomDispatcher = new cCustomDispatcher();
        private static var mDispatcherVote:cCustomDispatcher = new cCustomDispatcher();
        private static var mDispatcherVoteShopGroup:cCustomDispatcher = new cCustomDispatcher();


        public static function DispatcherEpicWorkyards(rootXml:cXML):void
        {
            try
            {
                EpicWorkyardsManager.setInstance(new EpicWorkyardsParser(rootXml).buildEpicWorkyardsManager());
            }
            catch(error:Error)
            {
                gMisc.MessageBox(("Error parsing epic_workyard_definitions.xml: " + error));
            };
            mDispatcherEpicWorkyards.doAction();
        }

        public static function ParseGenericValues(_arg_1:String, _arg_2:Function):void
        {
            mDispatcherGenericValues.addEventListener(cCustomDispatcher.mAction_string, _arg_2);
            var _local_3:cXML = new cXML();
            _local_3.LoadFile(_arg_1, DispatcherGenericValues, definesMaster.LOAD_ENC);
        }

        public static function DispatcherVotesShopGroup(rootXml:cXML):void
        {
            try
            {
                global.vote_shop_group = cShopItemGroup.ReadShopItemGroupFromXml(rootXml, true);
            }
            catch(error:Error)
            {
                gMisc.MessageBox(("Error parsing votes_shop_group.xml: " + error));
            };
            mDispatcherVoteShopGroup.doAction();
        }

        public static function DispatcherAchievements(rootXml:cXML):void
        {
            try
            {
                AchievementsManager.setInstance(new AchievementsParser(rootXml).buildAchievementsManager());
            }
            catch(error:Error)
            {
                gMisc.MessageBox(("Error parsing achievements_definitions.xml: " + error));
            };
            mDispatcherAchievements.doAction();
        }

        public static function DispatcherTasks(rootXml:cXML):void
        {
            try
            {
                TaskPool.setInstance(TaskPool.parseXML(rootXml));
            }
            catch(error:Error)
            {
                gMisc.MessageBox(("Error parsing task_building_definitions.xml: " + error));
            };
            mDispatcherTasks.doAction();
        }

        private static function PostProcess():void
        {
        }

        public static function DispatcherGameSettings(root:cXML):void
        {
            var globals:cXML;
            var allExceptions:String;
            var entry:String;
            var playerLevels:cXML;
            var levels:Vector.<cXML>;
            var level:cXML;
            var pvpLevels:cXML;
            var pvpLevelsChildren:Vector.<cXML>;
            var rank:cXML;
            var tradeSubNode:cXML;
            var activateSlotsWithCoins_vector:Vector.<cXML>;
            var slotCountCostsXML:cXML;
            var activateSlotsWithGems_vector:Vector.<cXML>;
            var costCountPerSlotsXml:cXML;
            var watchAreas_vector:Vector.<Vector.<cWatchData>>;
            var watchAreasXml:cXML;
            var watchAreasXml_vector:Vector.<cXML>;
            var watchAreaXml:cXML;
            var mailLifetimes_vector:Vector.<Number>;
            var mailXML:cXML;
            var mailLifetimesXml_vector:Vector.<cXML>;
            var mailLifetimeXml:cXML;
            var buildingUpgradeBonusesXml_vector:Vector.<cXML>;
            var upgradeBuffXml:cXML;
            var availableBuffsXml_vector:Vector.<cXML>;
            var buffXml:cXML;
            var xmlBuildingDefaultParameter:cXML;
            var doNotShowMissingResourceIcon_string:String;
            var hiddenBanditCamps_string:String;
            var hideMouseOverDepositAmount_string:String;
            var outerXML:cXML;
            var folder_string:String;
            var tmpSkillSettings_vector:Vector.<cXML>;
            var newsXML:cXML;
            var guildXML:cXML;
            var upgradeLevels:Vector.<cXML>;
            var guildBankXML:cXML;
            var paymentTabAllowedResources:Vector.<cXML>;
            var paytabResource:cXML;
            var aditionalTabWithCoin:Vector.<cXML>;
            var aditionalTabWithGem:Vector.<cXML>;
            var enlargeGuildBank:Vector.<cXML>;
            var guildEnlarge:cXML;
            var guildQuestRewardModifier:Vector.<cXML>;
            var guildQuestModifier:cXML;
            var gameObjectsTree:cXML;
            var specialistTasks_vector:Vector.<cXML>;
            var specialistTask:cXML;
            var miscConditionArray:Vector.<cXML>;
            var specialistTaskNode:cXML;
            var premiumAccountParamsXml:cXML;
            var pickupManagerTypes:Vector.<cXML>;
            var pickupManagerType:cXML;
            var eventWindows:cXML;
            var donations:cXML;
            var chatChannelNotificationNode:cXML;
            var effects:Vector.<cXML>;
            var parsedEffects:ArrayCollection;
            var effect:cXML;
            var pvpLevelEffects:Vector.<cXML>;
            var pvpLevelParsedEffects:ArrayCollection;
            var pvpLevelEffect:cXML;
            var coinCost:int;
            var gemsCost:int;
            var watchArea:Vector.<cWatchData>;
            var id:int;
            var gridsXml:cXML;
            var grids_vector:Vector.<cXML>;
            var gridXml:cXML;
            var watchData:cWatchData;
            var mailType:int;
            var lifeTime:Number;
            var buildingUpgradeBonuses:cBuffDefinition;
            var buff:cBuffDefinition;
            var taskName:String;
            var specialistType:String;
            var headstart:int;
            var specialistTaskDefinition:cSpecialistTaskDefinition;
            var taskID:int;
            var specialistSubTasks_vector:Vector.<cXML>;
            var specialistSubTask:cXML;
            var subTaskID:int;
            var taskType:String;
            var duration:int;
            var lootTableGroupID:int;
            var speedUpCosts:int;
            var speedUpFactor:int;
            var costs:Vector.<dResource>;
            var specialistSubTaskDefinition:cSpecialistSubTaskDefinition;
            var miscConditionName:String;
            var name_string:String;
            var value:Number;
            var innerXML:cXML;
            var eventWindow:EventWindowDefinition;
            var resourceName_string:String;
            try
            {
                globals = root.MoveToSubNode("Globals");
                global.playerInitialLevel = globals.MoveToSubNode("PlayerInitialLevel").GetAttributeInt("Level");
                global.defaultBuildInstantCosts = globals.MoveToSubNode("DefaultBuildInstantCosts").GetAttributeInt("HardCurrency");
                global.defaultUpgradeInstantBonusPercentage = globals.MoveToSubNode("DefaultInstantUpgradeBonusPercentage").GetAttributeInt("value");
                parseTimedProductions(root.MoveToSubNode("TimedProductions"));
                global.starCoinConversionRate = globals.MoveToSubNode("Lvl50XpConversion").GetAttributeFloatingPoint("starCoinConversionRate");
                global.generalSkillStarCoinConversionRate = globals.MoveToSubNode("GeneralSkillXPConversion").GetAttributeFloatingPoint("starCoinConversionRate");
                global.adventAssetPrefix = globals.MoveToSubNode("AdventCalendarSettings").GetAttributeString_string("assetPrefix", "");
                global.omniSeedException = new Vector.<String>();
                allExceptions = globals.MoveToSubNode("OmniSeedException").GetAttributeString_string("resources");
                for each (entry in StringUtils.split(allExceptions, ","))
                {
                    global.omniSeedException.push(entry);
                };
                playerLevels = root.MoveToSubNode("PlayerLevels");
                levels = playerLevels.CreateChildrenArray();
                for each (level in levels)
                {
                    global.playerLevels_vector.push(level.GetAttributeInt("xp"));
                    if (level.GetAttributeInt("cl") > 0)
                    {
                        global.cityLevels_vector.push(level.GetAttributeInt("xp"));
                    };
                    global.playerLevelRewardXPs_vector.push(level.GetAttributeInt("rewardxp"));
                    effects = level.CreateChildrenArray();
                    parsedEffects = new ArrayCollection();
                    for each (effect in effects)
                    {
                        parsedEffects.addItem(EffectVO.CreateFromXML(effect));
                    };
                    global.playerLevelEffects_vector.push(parsedEffects);
                };
                pvpLevels = root.MoveToSubNode("PvPLevels");
                pvpLevelsChildren = pvpLevels.CreateChildrenArray();
                for each (rank in pvpLevelsChildren)
                {
                    global.playerPvPLevels_vector.push(new dPvpLevelDataVO(rank.GetAttributeInt("pvpXp"), rank.GetAttributeString_string("icon")));
                    pvpLevelEffects = rank.CreateChildrenArray();
                    pvpLevelParsedEffects = new ArrayCollection();
                    for each (pvpLevelEffect in pvpLevelEffects)
                    {
                        pvpLevelParsedEffects.addItem(EffectVO.CreateFromXML(pvpLevelEffect));
                    };
                    global.playerPvPLevelEffects_vector.push(pvpLevelParsedEffects);
                };
                global.initGlobalTimeScale = globals.MoveToSubNode("GlobalTimeScale").GetAttributeFloatingPoint("factor");
                global.combatRoundDuration = (globals.MoveToSubNode("CombatRoundDuration").GetAttributeInt("seconds") * 1000);
                global.combatLoopDurationMS = globals.MoveToSubNode("Combat30").GetAttributeInt("combatLoopDurationMS");
                global.unitSwitchPauseDuration = globals.MoveToSubNode("Combat30").GetAttributeInt("unitSwitchPauseDuration");
                global.combatUnitSwitchChance = globals.MoveToSubNode("Combat30").GetAttributeInt("combatUnitSwitchChance");
                global.batchUnitsPerDisc = globals.MoveToSubNode("Combat30").GetAttributeInt("batchUnitsPerDisc");
                global.pvpSafeTimeInitial = globals.MoveToSubNode("PVPValues").GetAttributeInt("initialSafeTime");
                global.colonySlotTempPriceModifier = globals.MoveToSubNode("ColonyValues").GetAttributeFloatingPoint("tempSlotPriceModifier");
                global.colonyYieldTickTime = globals.MoveToSubNode("ColonyValues").GetAttributeInt("colonyYieldTickTime");
                global.chatRoomSendCooldown = globals.MoveToSubNode("ChatRoomSendCooldown").GetAttributeInt("value");
                global.chatReconnectInterval = globals.MoveToSubNode("ChatReconnectInterval").GetAttributeInt("value");
                global.defaultCancelledRankingTime = globals.MoveToSubNode("Rankings").GetAttributeInt("defaultCancelledRankingTime");
                global.minCombatTierToRank = globals.MoveToSubNode("Rankings").GetAttributeInt("minCombatTierToRank");
                global.buildingInfoIconDelay = (globals.MoveToSubNode("BuildingInfoIconDelay").GetAttributeInt("value") * 1000);
                global.repairRoundDuration = (globals.MoveToSubNode("RepairRoundDuration").GetAttributeInt("seconds") * 1000);
                global.repairRate = globals.MoveToSubNode("RepairRate").GetAttributeInt("hitPoints");
                global.repairCostFactor = globals.MoveToSubNode("RepairCostFactor").GetAttributeInt("percent");
                cMilitaryUnitDescription.InitData(root.MoveToSubNode("MilitaryUnits"));
                global.maxTempSlotsAvailablePerPlayer = globals.MoveToSubNode("TempBuildSlots").GetAttributeInt("perPlayer");
                global.tempSlotDuration = (globals.MoveToSubNode("TempBuildSlots").GetAttributeInt("durationInSeconds") * 1000);
                tradeSubNode = globals.MoveToSubNode("TradeConfiguration");
                global.tradeExpirationTime = (tradeSubNode.GetAttributeInt("tradeExpirationTimeInSeconds") * 1000);
                global.tradeCoolDownTime = (tradeSubNode.GetAttributeInt("tradeCoolDownTimeInSeconds") * 1000);
                global.tradeCacheSetTime = (tradeSubNode.GetAttributeInt("tradeCacheSetTimeInSeconds") * 1000);
                global.tradeFriendDelay = tradeSubNode.GetAttributeInt("friendDelayInSeconds");
                global.costOfUnlimitingLots = tradeSubNode.GetAttributeInt("unlimitedLotsCost");
                global.tradeMaxSearchAmount = tradeSubNode.GetAttributeInt("maxSearchAmount");
                global.tradeMaxBuffAmount = tradeSubNode.GetAttributeInt("maxBuffAmount");
                global.tradeMaxBuildingAmount = tradeSubNode.GetAttributeInt("maxBuildingAmount");
                global.tradeMaxAdventureAmount = tradeSubNode.GetAttributeInt("maxAdventureAmount");
                activateSlotsWithCoins_vector = globals.MoveToSubNodeAndCreateChildrenArray("TradeActivateSlotWithCoin");
                for each (slotCountCostsXML in activateSlotsWithCoins_vector)
                {
                    coinCost = slotCountCostsXML.GetAttributeInt("costCoins");
                    global.activateSlotsWithCoins_vector.push(coinCost);
                };
                activateSlotsWithGems_vector = globals.MoveToSubNodeAndCreateChildrenArray("TradeActivateSlotWithGems");
                for each (costCountPerSlotsXml in activateSlotsWithGems_vector)
                {
                    gemsCost = costCountPerSlotsXml.GetAttributeInt("costGems");
                    global.activateSlotsWithGems_vector.push(gemsCost);
                };
                global.economyCalculationTime = ((globals.MoveToSubNode("EconomyCalculationTime").GetAttributeInt("hourlyTime") * 60) * 60);
                watchAreas_vector = new Vector.<Vector.<cWatchData>>();
                watchAreasXml = root.MoveToSubNode("WatchAreas");
                watchAreasXml_vector = watchAreasXml.CreateChildrenArray();
                for each (watchAreaXml in watchAreasXml_vector)
                {
                    watchArea = new Vector.<cWatchData>();
                    id = watchAreaXml.GetAttributeInt("id");
                    gridsXml = watchAreaXml.MoveToSubNode("Grids");
                    grids_vector = gridsXml.CreateChildrenArray();
                    for each (gridXml in grids_vector)
                    {
                        watchData = new cWatchData(gridXml);
                        watchArea.push(watchData);
                    };
                    if (id != watchAreas_vector.length)
                    {
                        gMisc.Assert(false, (((("Want to add watch area at the wrong position: " + id) + " != ") + watchAreas_vector.length) + ". Please check the game settings!"));
                    };
                    watchAreas_vector.push(watchArea);
                };
                global.watchAreas_vector = watchAreas_vector;
                mailLifetimes_vector = new Vector.<Number>();
                mailXML = root.MoveToSubNode("Mail");
                mailLifetimesXml_vector = mailXML.MoveToSubNodeAndCreateChildrenArray("MailLifetimes");
                for each (mailLifetimeXml in mailLifetimesXml_vector)
                {
                    mailType = MAIL_TYPE.parse(mailLifetimeXml.GetAttributeString_string("type"));
                    lifeTime = (((mailLifetimeXml.GetAttributeFloatingPoint("timeHours") * 1000) * 60) * 60);
                    if (mailType != mailLifetimes_vector.length)
                    {
                        gMisc.Assert(false, (((("Lifetime for mail type " + MAIL_TYPE.toString(mailType)) + " is at wrong position: ") + mailLifetimes_vector.length) + "!"));
                        break;
                    };
                    if (lifeTime > 0)
                    {
                        global.expirableMailTypes.push(mailType);
                    };
                    mailLifetimes_vector.push(lifeTime);
                };
                global.mailLifetimes_vector = mailLifetimes_vector;
                global.mailboxWindowSize = mailXML.MoveToSubNode("WindowSize").GetAttributeInt("value");
                global.mailboxPageSize = mailXML.MoveToSubNode("PageSize").GetAttributeInt("value");
                global.maxRecipients = mailXML.MoveToSubNode("MaxMailRecipients").GetAttributeInt("value");
                global.adventureMaximumOwner = root.MoveToSubNode("Adventures").GetAttributeInt("maximumConcurrentOwner");
                global.adventureMaximumGuest = root.MoveToSubNode("Adventures").GetAttributeInt("maximumConcurrentGuest");
                cAdventureDefinition.parseXML(root);
                buildingUpgradeBonusesXml_vector = root.MoveToSubNodeAndCreateChildrenArray("BuildingUpgradeBonuses");
                for each (upgradeBuffXml in buildingUpgradeBonusesXml_vector)
                {
                    buildingUpgradeBonuses = cBuffDefinition.CreateBuffDefinitionFromXml(upgradeBuffXml);
                    if (buildingUpgradeBonuses.getUpgradeLevel() != global.buildingUpgradeBonuses_vector.length)
                    {
                        gMisc.Assert(false, (((("gParse: Want to add upgrade bonuses at the wrong position: " + buildingUpgradeBonuses.getUpgradeLevel()) + " != ") + global.buildingUpgradeBonuses_vector.length) + ". Please check the game settings!"));
                    };
                    global.buildingUpgradeBonuses_vector.push(buildingUpgradeBonuses);
                };
                cBuffDefinition.targetGroups = BuffTargetGroups.fromXML(root.MoveToSubNode("BuffTargetGroups"));
                availableBuffsXml_vector = root.MoveToSubNodeAndCreateChildrenArray("AvailableBuffs");
                for each (buffXml in availableBuffsXml_vector)
                {
                    buff = cBuffDefinition.CreateBuffDefinitionFromXml(buffXml);
                    gMisc.Assert((global.map_BuffId_BuffDefinition[buff.GetId()] == null), (("Buff '" + buff.GetType()) + "' ID is already in use!"));
                    global.map_BuffName_BuffDefinition[buff.GetType()] = buff;
                    global.map_BuffId_BuffDefinition[buff.GetId()] = buff;
                };
                BuffAdventureController.init(global.map_BuffName_BuffDefinition, cAdventureDefinition.map_AdventureName_AdventureDefinition.valueSet());
                global.GOListScale = globals.MoveToSubNode("GOList").GetAttributeInt("scale");
                xmlBuildingDefaultParameter = globals.MoveToSubNode("BuildingDefaultParameter");
                global.buildingDefaultParameterConstructionDuration = xmlBuildingDefaultParameter.GetAttributeInt("constructionDuration");
                global.buildingDefaultParameterDestructionDuration = xmlBuildingDefaultParameter.GetAttributeInt("destructionDuration");
                global.buildingDefaultParameterXP = xmlBuildingDefaultParameter.GetAttributeInt("xp");
                ConvertXMLNameListToStringIntDictionary(xmlBuildingDefaultParameter.MoveToSubNode("doNotCount"), global.buildingDefaultParameterDoNotCountList_dictionary);
                doNotShowMissingResourceIcon_string = xmlBuildingDefaultParameter.GetAttributeString_string("doNotShowMissingResourceIcon");
                ConvertStringListToStringIntDictionary(doNotShowMissingResourceIcon_string, global.buildingDefaultParameterDoNotShowMissingResourceIcon_dictionary);
                hiddenBanditCamps_string = xmlBuildingDefaultParameter.GetAttributeString_string("hiddenBanditCamps");
                ConvertStringListToStringIntDictionary(hiddenBanditCamps_string, global.hiddenBanditCamps_dictionary);
                hideMouseOverDepositAmount_string = xmlBuildingDefaultParameter.GetAttributeString_string("hideMouseOverDepositAmount");
                ConvertStringListToStringIntDictionary(hideMouseOverDepositAmount_string, global.hideMouseOverDepositAmount_dictionary);
                global.buildingDefaultFogRemoveList_vector = gCalculations.CalculateTileListFromRadius(globals.MoveToSubNode("BuildingDefaultParameter").GetAttributeInt("removeFogAttribute"));
                global.scrollSpeed = globals.MoveToSubNode("Scrolling").GetAttributeInt("speed");
                global.defaultMaximumBuildingCount = globals.MoveToSubNode("DefaultMaximumBuildingsCount").GetAttributeInt("value");
                global.defaultMaximumBuildingsCountAll = globals.MoveToSubNode("DefaultMaximumBuildingsCountAll").GetAttributeInt("value");
                global.flashPlayerRedirectURL = globals.MoveToSubNode("FlashPlayerRedirect").GetAttributeString_string("url");
                global.scrollSpeed = 50;
                folder_string = globals.MoveToSubNode("Skills").GetAttributeString_string("folder");
                tmpSkillSettings_vector = globals.MoveToSubNodeAndCreateChildrenArray("Skills");
                for each (outerXML in tmpSkillSettings_vector)
                {
                    global.skillSettingsFilenames_vector.push((folder_string + outerXML.GetAttributeString_string("FileName")));
                };
                ClientLogger.log(("Skill files to be used: " + global.skillSettingsFilenames_vector.join(", ")));
                global.maxAnimalsOnMap = globals.MoveToSubNode("Animals").GetAttributeInt("MaxAnimalsOnMap");
                newsXML = globals.MoveToSubNode("News");
                global.tipOfTheDayCount = newsXML.GetAttributeInt("TipOfTheDayCount");
                global.loadingMessageCount = newsXML.GetAttributeInt("LoadingMessageCount");
                global.loadingBannerImage = newsXML.GetAttributeString_string("LoadingBannerImage");
                guildXML = globals.MoveToSubNode("Guild");
                global.guildHighscorePageSize = guildXML.GetAttributeInt("HighscorePageSize");
                global.guildBannerCount = guildXML.GetAttributeInt("BannerCount");
                global.guildJoinCooldown = guildXML.GetAttributeInt("JoinCooldown");
                global.guildMaxSizeLimit = guildXML.GetAttributeInt("MaxSizeLimit");
                global.guildAppointedLeaderMaxWait = ((((guildXML.GetAttributeInt("AppointedLeaderMaxWait") * 1000) * 60) * 60) * 24);
                global.guildInactiveStepDown = ((((guildXML.GetAttributeInt("InactiveStepDown") * 1000) * 60) * 60) * 24);
                global.guildMaxSuccessionLimit = guildXML.GetAttributeInt("MaxSuccessionLimit");
                upgradeLevels = guildXML.CreateChildrenArray();
                for each (outerXML in upgradeLevels)
                {
                    global.guildUpgradeLevels[outerXML.GetAttributeInt("level")] = outerXML.GetAttributeInt("maxSize");
                };
                guildBankXML = globals.MoveToSubNode("GuildBank");
                global.guildBankInitialGoodsCapacity = guildBankXML.GetAttributeInt("InitialGoodsCapacity");
                global.guildBankMinWithdrawLimits = guildBankXML.GetAttributeInt("MinWithdrawLimits");
                global.guildBankInitialBuffsCapacity = guildBankXML.GetAttributeInt("InitialBuffsCapacity");
                global.guildBankMinBuffsWithdrawLimits = guildBankXML.GetAttributeInt("MinBuffsWithdrawLimits");
                paymentTabAllowedResources = guildBankXML.MoveToSubNode("PaymentTab").MoveToSubNodeAndCreateChildrenArray("AllowedResources");
                for each (paytabResource in paymentTabAllowedResources)
                {
                    global.guildBankPayTabAllowedResources.push(paytabResource.GetAttributeString_string("name"));
                };
                aditionalTabWithCoin = guildBankXML.MoveToSubNode("AditionalTabs").MoveToSubNodeAndCreateChildrenArray("AditionalTabWithCoin");
                for each (outerXML in aditionalTabWithCoin)
                {
                    global.guildBankAditionalTabCostCoin[outerXML.GetAttributeInt("count")] = outerXML.GetAttributeInt("costGuildCoins");
                };
                aditionalTabWithGem = guildBankXML.MoveToSubNode("AditionalTabs").MoveToSubNodeAndCreateChildrenArray("AditionalTabWithGems");
                for each (outerXML in aditionalTabWithGem)
                {
                    global.guildBankAditionalTabCostGem[outerXML.GetAttributeInt("count")] = outerXML.GetAttributeInt("costGems");
                };
                enlargeGuildBank = guildBankXML.MoveToSubNodeAndCreateChildrenArray("Enlarge");
                for each (guildEnlarge in enlargeGuildBank)
                {
                    global.guildBankEnlargeCostCoin[guildEnlarge.GetAttributeInt("count")] = guildEnlarge.GetAttributeInt("costGuildCoins");
                    global.guildBankEnlargeCostGem[guildEnlarge.GetAttributeInt("count")] = guildEnlarge.GetAttributeInt("costGems");
                    global.guildBankEnlargeAmount[guildEnlarge.GetAttributeInt("count")] = guildEnlarge.GetAttributeInt("size");
                    global.guildBankEnlargeBuffAmount[guildEnlarge.GetAttributeInt("count")] = guildEnlarge.GetAttributeInt("sizeBuff");
                };
                guildQuestRewardModifier = globals.MoveToSubNodeAndCreateChildrenArray("GuildQuestSettings");
                for each (guildQuestModifier in guildQuestRewardModifier)
                {
                    global.guildQuestRewardModifierPerSize[guildQuestModifier.GetAttributeInt("size")] = guildQuestModifier.GetAttributeFloatingPoint("multiplier");
                };
                gameObjectsTree = root.MoveToSubNode("GameObjects");
                cGOSetManager.setGOSetNode(gameObjectsTree.MoveToSubNode("GOSets"));
                global.guiIconGroup.SetGameSettingDefinitions(gameObjectsTree.MoveToSubNode("GuiIcons"));
                global.backgroundGroup.SetGameSettingDefinitions(gameObjectsTree.MoveToSubNode("Backgrounds"));
                global.streetGroup.SetGameSettingDefinitions(gameObjectsTree.MoveToSubNode("Streets"));
                global.buildingGroup.SetGameSettingDefinitions(gameObjectsTree.MoveToSubNode("Buildings"));
                global.landscapeGroup.SetGameSettingDefinitions(gameObjectsTree.MoveToSubNode("Landscapes"));
                global.settlerGroup.SetGameSettingDefinitions(gameObjectsTree.MoveToSubNode("Settlers"));
                global.animalGroup.SetGameSettingDefinitions(gameObjectsTree.MoveToSubNode("Animals"));
                global.effectGroup.SetGameSettingDefinitions(gameObjectsTree.MoveToSubNode("Effects"));
                cSpecialist.InitData(root.MoveToSubNode("Specialists"));
                specialistTasks_vector = root.MoveToSubNodeAndCreateChildrenArray("SpecialistTasks");
                for each (specialistTask in specialistTasks_vector)
                {
                    taskName = specialistTask.GetAttributeString_string("name");
                    specialistType = specialistTask.GetAttributeString_string("specialistType");
                    headstart = (specialistTask.GetAttributeInt("headstartSeconds") * 1000);
                    specialistTaskDefinition = new cSpecialistTaskDefinition(taskName, specialistType, headstart);
                    taskID = SPECIALIST_TASK_TYPES.parse(taskName);
                    while (global.specialistTaskDefinitions_vector.length <= taskID)
                    {
                        global.specialistTaskDefinitions_vector.push(null);
                    };
                    global.specialistTaskDefinitions_vector[taskID] = specialistTaskDefinition;
                    specialistSubTasks_vector = specialistTask.CreateChildrenArray();
                    for each (specialistSubTask in specialistSubTasks_vector)
                    {
                        subTaskID = specialistSubTask.GetAttributeInt("id");
                        taskType = specialistSubTask.GetAttributeString_string("type");
                        duration = (specialistSubTask.GetAttributeInt("durationSeconds") * 1000);
                        lootTableGroupID = specialistSubTask.GetAttributeInt("lootTableGroupID");
                        speedUpCosts = specialistSubTask.GetAttributeInt("speedUpCosts");
                        speedUpFactor = specialistSubTask.GetAttributeInt("speedUpFactor");
                        costs = ParseCosts(specialistSubTask);
                        specialistSubTaskDefinition = new cSpecialistSubTaskDefinition(specialistTaskDefinition, subTaskID, taskType, duration, lootTableGroupID, speedUpCosts, speedUpFactor, costs);
                        while (specialistTaskDefinition.subtasks_vector.length <= subTaskID)
                        {
                            specialistTaskDefinition.subtasks_vector.push(null);
                        };
                        specialistTaskDefinition.subtasks_vector[subTaskID] = specialistSubTaskDefinition;
                    };
                };
                miscConditionArray = root.MoveToSubNodeAndCreateChildrenArray("MiscConditions");
                for each (specialistTaskNode in miscConditionArray)
                {
                    miscConditionName = specialistTaskNode.GetAttributeString_string("name");
                    global.miscConditions.push(miscConditionName);
                };
                for each (outerXML in globals.MoveToSubNodeAndCreateChildrenArray("ResourceHardcurrencyValues"))
                {
                    name_string = outerXML.GetAttributeString_string("name");
                    value = outerXML.GetAttributeFloatingPoint("value");
                    global.resourceHardcurrencyValues[name_string] = value;
                };
                for each (outerXML in globals.MoveToSubNodeAndCreateChildrenArray("QuestCategoryOrder"))
                {
                    global.questCategoryOrder.push({
                        "name":outerXML.GetAttributeString_string("name"),
                        "cancelable":outerXML.GetAttributeBool("cancelable")
                    });
                };
                premiumAccountParamsXml = root.MoveToSubNode("PremiumAccountParams");
                global.premiumAccount.SetXpBonus(premiumAccountParamsXml.MoveToSubNode("xpBonus").GetAttributeFloatingPoint("percent"));
                global.premiumAccount.SetPvpXpBonus(premiumAccountParamsXml.MoveToSubNode("pvpXpBonus").GetAttributeFloatingPoint("percent"));
                global.premiumAccount.SetVpBonus(premiumAccountParamsXml.MoveToSubNode("vpBonus").GetAttributeFloatingPoint("percent"));
                global.premiumAccount.SetLootBonus(premiumAccountParamsXml.MoveToSubNode("lootBonus").GetAttributeFloatingPoint("percent"));
                global.premiumAccount.SetBuildingSlots(premiumAccountParamsXml.MoveToSubNode("builingSlots").GetAttributeInt("value"));
                global.premiumAccount.SetFriendZoneBuffTimeBonus(premiumAccountParamsXml.MoveToSubNode("friendZoneBuffTimeBonus").GetAttributeFloatingPoint("percent"));
                global.premiumAccount.SetRegularDailyQuests(premiumAccountParamsXml.MoveToSubNode("regularDailyQuests").GetAttributeInt("value"));
                for each (outerXML in premiumAccountParamsXml.MoveToSubNodeAndCreateChildrenArray("regularDailyQuests"))
                {
                    global.premiumAccount.addRegularDailyQuestList(outerXML.GetAttributeString_string("name"));
                };
                pickupManagerTypes = root.MoveToSubNodeAndCreateChildrenArray("PickupManager");
                for each (pickupManagerType in pickupManagerTypes)
                {
                    global.pickupManagerLimitsPerType.putItem(PICKUP_PROVIDER_TYPE.parse(pickupManagerType.GetAttributeString_string("name")), pickupManagerType.GetAttributeInt("limit"));
                };
                for each (outerXML in globals.MoveToSubNodeAndCreateChildrenArray("HelpCategoryOrder"))
                {
                    global.helpCategoryOrder.push(outerXML.GetAttributeString_string("name"));
                };
                for each (outerXML in globals.MoveToSubNodeAndCreateChildrenArray("ChannelMap"))
                {
                    for each (innerXML in outerXML.CreateChildrenArray())
                    {
                        ChannelMap.map(outerXML.GetName_string(), innerXML.GetName_string());
                        cLog.info((((("Mapping ChannelMap.map( " + outerXML.GetName_string()) + ", ") + innerXML.GetName_string()) + " )"));
                    };
                };
                for each (eventWindows in globals.MoveToSubNodeAndCreateChildrenArray("EventWindows"))
                {
                    eventWindow = new EventWindowDefinition();
                    eventWindow.requiresEvent_string = eventWindows.GetAttributeString_string("requiresEvent");
                    eventWindow.includesRanking = eventWindows.GetAttributeBool("includesRanking");
                    eventWindow.eventWindowImage_string = eventWindows.GetAttributeString_string("image");
                    eventWindow.eventWindowText_string = eventWindows.GetAttributeString_string("text");
                    global.eventWindowDefinitions.push(eventWindow);
                };
                donations = globals.MoveToSubNode("EventDonateResource");
                global.eventDonations.watchTime = (donations.GetAttributeInt("limitCheckIntervalSeconds") * 1000);
                global.eventDonations.requiredEventName = donations.GetAttributeString_string("requiresEvent");
                if (donations.HasSubNode("resource"))
                {
                    for each (outerXML in donations.CreateChildrenArray())
                    {
                        resourceName_string = outerXML.GetAttributeString_string("name", "");
                        global.eventDonations.enabledEventDonations[resourceName_string] = true;
                    };
                };
                global.homeZoneToolBoxSectionData = parseToolBoxContent(root.MoveToSubNode("HomeZoneToolBoxPanel"));
                global.defenseModeToolBoxSectionData = parseToolBoxContent(root.MoveToSubNode("DefenseModeToolBoxPanel"));
                global.attackModeToolBoxSectionData = parseToolBoxContent(root.MoveToSubNode("AttackModeToolBoxPanel"));
                chatChannelNotificationNode = globals.MoveToSubNode("ChatChannelNotifications");
                TSOChatMediator.registerChannelNotifications(chatChannelNotificationNode);
                gEconomics.setGameSettingsDefinitions(root.MoveToSubNode("ResourceDefinitions"));
                PostProcess();
            }
            catch(error:Error)
            {
                gMisc.MessageBox(("Error parsing game_settings.xml: " + error));
                ClientLogger.error(error);
            };
            mDispatcherGameSettings.doAction();
        }

        public static function DispatcherTriggers(rootXml:cXML):void
        {
            try
            {
                TriggerLocaManager.setInstance(new TriggerLocaParser(rootXml).buildTriggerLocaManager());
            }
            catch(error:Error)
            {
                gMisc.MessageBox(("Error parsing trigger_loca_definitions.xml: " + error));
            };
            mDispatcherTriggerLoca.doAction();
        }

        public static function ParseConditions(_arg_1:cXML):Vector.<TriggerVO>
        {
            var _local_5:cXML;
            var _local_2:Vector.<TriggerVO> = new Vector.<TriggerVO>();
            var _local_3:int;
            var _local_4:Vector.<cXML> = _arg_1.CreateChildrenArray();
            for each (_local_5 in _local_4)
            {
                _local_2.push(TriggerVO.createFromXML(_local_5, _local_3));
                _local_3++;
            };
            return (_local_2);
        }

        public static function DispatcherSkillConfig(root:cXML):void
        {
            var skillPointXML_vector:Vector.<cXML>;
            var skillPointXML:cXML;
            var skillsXML_vector:Vector.<cXML>;
            var skillsXML:cXML;
            var skillTreeXML_vector:Vector.<cXML>;
            var skillTreeXML:cXML;
            var skillDefinition:SkillDefinition;
            try
            {
                skillPointXML_vector = root.MoveToSubNodeAndCreateChildrenArray("skillPoints");
                for each (skillPointXML in skillPointXML_vector)
                {
                    global.skillPoints_vector.push(SkillpointDefinition.CreateFromXML(skillPointXML));
                };
                skillsXML_vector = root.MoveToSubNodeAndCreateChildrenArray("skills");
                for each (skillsXML in skillsXML_vector)
                {
                    skillDefinition = SkillDefinition.CreateFromXML(skillsXML);
                    while (global.skills_vector.length <= skillDefinition.id)
                    {
                        global.skills_vector.push(null);
                    };
                    if (global.skills_vector[skillDefinition.id] != null)
                    {
                        gMisc.Assert(false, ((((("Duplicate skill ID used! ID:" + skillDefinition.id) + " for ") + skillDefinition.name_string) + " and ") + global.skills_vector[skillDefinition.id].name_string));
                    };
                    global.skills_vector[skillDefinition.id] = skillDefinition;
                };
                skillTreeXML_vector = root.MoveToSubNodeAndCreateChildrenArray("skillTrees");
                for each (skillTreeXML in skillTreeXML_vector)
                {
                    global.skillTrees_vector.push(SkillTreeDefinition.CreateFromXML(skillTreeXML));
                };
            }
            catch(error:Error)
            {
                gMisc.MessageBox(("Error parsing skills.xml: " + error));
            };
            mDispatcherSkillConfig.doActionWithData(root.getFileName(), null);
        }

        public static function DispatcherItemLimits(_arg_1:cXML):void
        {
            var _local_2:cXML;
            var _local_3:int;
            var _local_4:String;
            var _local_5:String;
            var _local_6:String;
            var _local_7:int;
            var _local_8:IRItem;
            for each (_local_2 in _arg_1.CreateChildrenArray())
            {
                _local_3 = ITEM_CONTENT_TYPE.parse(_local_2.GetAttributeString_string("itemType", ""));
                _local_4 = _local_2.GetAttributeString_string("itemName");
                _local_5 = _local_2.GetAttributeString_string("resourceName");
                _local_6 = _local_2.GetAttributeString_string("requiresEvent", "");
                _local_7 = _local_2.GetAttributeInt("amount", -1);
                _local_8 = new IRItem(_local_3, _local_4, _local_5, _local_7, _local_6);
                global.itemLimits.push(_local_8);
            };
        }

        private static function ConvertStringListToStringIntDictionary(_arg_1:String, _arg_2:cStringIntDictionary):void
        {
            var _local_4:String;
            var _local_3:Array = _arg_1.split(",");
            _arg_2.Reset();
            for each (_local_4 in _local_3)
            {
                _arg_2.Put(_local_4, 1);
            };
        }

        public static function DispatcherEvents(rootXml:cXML):void
        {
            var events_XML_vector:Vector.<cXML>;
            var eventsXMLLoop:cXML;
            try
            {
                events_XML_vector = rootXml.CreateChildrenArray();
                for each (eventsXMLLoop in events_XML_vector)
                {
                    global.eventSwitchSettings.addItem(dEventVO.CreateFromXML(eventsXMLLoop));
                };
            }
            catch(error:Error)
            {
                gMisc.MessageBox(("Error parsing events_config.xml: " + error));
            };
            mDispatcherEvents.doAction();
        }

        public static function DispatcherVotes(rootXml:cXML):void
        {
            var voteItemXML:cXML;
            var name:String;
            var voteDefinition:cVoteDefinition;
            var votePoolDefinition:cVotePoolDefinition;
            try
            {
                for each (voteItemXML in rootXml.CreateChildrenArray())
                {
                    name = voteItemXML.GetAttributeString_string("name");
                    voteDefinition = cVoteDefinition.createFromXml(voteItemXML);
                    global.vote_definitions.putItem(name, voteDefinition);
                    for each (votePoolDefinition in voteDefinition.votePools)
                    {
                        global.vote_pool_definitions.putItem(votePoolDefinition.id, votePoolDefinition);
                    };
                };
            }
            catch(error:Error)
            {
                gMisc.MessageBox(("Error parsing votes_config_default.xml: " + error));
            };
            mDispatcherVote.doAction();
        }

        public static function DispatcherHelpDefinitions(root:cXML):void
        {
            var definitions:cXML;
            var def_vector:Vector.<cXML>;
            var definition:cXML;
            var helpDefinition:dHelpDefinitionVO;
            try
            {
                definitions = root.MoveToSubNode("HelpDefinitions");
                def_vector = definitions.CreateChildrenArray();
                for each (definition in def_vector)
                {
                    helpDefinition = new dHelpDefinitionVO();
                    helpDefinition.helpName_string = definition.GetAttributeString_string("id");
                    helpDefinition.type_string = definition.GetAttributeString_string("type");
                    helpDefinition.icon_string = definition.GetAttributeString_string("icon");
                    helpDefinition.helpImage_string = definition.GetAttributeString_string("image");
                    helpDefinition.pages = definition.GetAttributeInt("pages");
                    if (helpDefinition.pages == 0)
                    {
                        helpDefinition.pages = 1;
                    };
                    helpDefinition.hasButton = definition.GetAttributeBool("hasButton");
                    helpDefinition.buttonPositionX = definition.GetAttributeInt("buttonPositionX");
                    helpDefinition.buttonPositionY = definition.GetAttributeInt("buttonPositionY");
                    helpDefinition.url = definition.GetAttributeString_string("url");
                    global.map_HelpName_HelpDefinition[helpDefinition.helpName_string] = helpDefinition;
                };
            }
            catch(error:Error)
            {
                gMisc.MessageBox(("Error parsing help_definitions.xml: " + error));
            };
            mDispatcherHelpDefinitions.doAction();
        }

        public static function DispatcherGameEvents(root:cXML):void
        {
            var event_vector:Vector.<cXML>;
            var gameEvent:GameEventVO;
            var xml_vector:Vector.<cXML>;
            var eventxml:cXML;
            var triggerIdx:int;
            var trigger:cXML;
            var effect:cXML;
            try
            {
                event_vector = root.CreateChildrenArray();
                for each (eventxml in event_vector)
                {
                    gameEvent = new GameEventVO();
                    gameEvent.trigger_vector = new ArrayCollection();
                    gameEvent.effect_vector = new ArrayCollection();
                    xml_vector = eventxml.MoveToSubNodeAndCreateChildrenArray("trigger");
                    triggerIdx = 0;
                    for each (trigger in xml_vector)
                    {
                        gameEvent.trigger_vector.addItem(TriggerVO.createFromXML(trigger, triggerIdx));
                        triggerIdx = (triggerIdx + 1);
                    };
                    xml_vector = eventxml.MoveToSubNodeAndCreateChildrenArray("effects");
                    for each (effect in xml_vector)
                    {
                        gameEvent.effect_vector.addItem(EffectVO.CreateFromXML(effect));
                    };
                    global.gameEvent_vector.push(gameEvent);
                };
            }
            catch(error:Error)
            {
                gMisc.MessageBox(("Error parsing game_events.xml: " + error));
            };
            mDispatcherGameEvents.doAction();
        }

        public static function DispatcherCollections(rootXml:cXML):void
        {
            try
            {
                CollectionsManager.setInstance(new CollectionsParser(rootXml).buildCollectionsManager());
            }
            catch(error:Error)
            {
                gMisc.MessageBox(("Error parsing collections_definitions.xml: " + error));
            };
            mDispatcherCollections.doAction();
        }

        public static function DispatcherGenericValues(rootXml:cXML):void
        {
            var genericValues_XML_vector:Vector.<cXML>;
            var genericValueXMLLoop:cXML;
            var flag:GenericValueVO;
            try
            {
                genericValues_XML_vector = rootXml.CreateChildrenArray();
                for each (genericValueXMLLoop in genericValues_XML_vector)
                {
                    flag = GenericValueVO.CreateFromXML(genericValueXMLLoop);
                    global.genericValuesFromId.putItem(flag.id, flag);
                    global.genericValuesFromName.putItem(flag.name, flag);
                };
            }
            catch(error:Error)
            {
                gMisc.MessageBox(("Error parsing loottable_conditions.xml: " + error));
            };
            mDispatcherGenericValues.doAction();
        }

        public static function DispatcherAdventCalendar(rootXml:cXML):void
        {
            var doorXml:cXML;
            try
            {
                global.advent_calendar_required_event = rootXml.GetAttributeString_string("requiresEvent", "inactive");
                for each (doorXml in rootXml.CreateChildrenArray())
                {
                    global.advent_calendar_days.addItem(dAdventCalendarDoorVO.createFromXml(doorXml));
                };
            }
            catch(error:Error)
            {
                gMisc.MessageBox(("Error parsing advent_calendar_config.xml: " + error));
            };
            mDispatcherAdventCalendar.doAction();
        }

        public static function DispatcherLanguageConfig(root:cXML):void
        {
            var node:cXML;
            var shopBannerGroupsXML:Vector.<cXML>;
            var shopBannerGroupXml:cXML;
            var defaultLang:String;
            var facebookAchievementUrlXML:cXML;
            var banners:Vector.<dBanner>;
            var requiresEvent:String;
            var shopBannersXML:Vector.<cXML>;
            var shopBannerXML:cXML;
            var banner:dBanner;
            var achievementFacebookUrl:AchievementFacebookUrl;
            try
            {
                for each (node in root.MoveToSubNodeAndCreateChildrenArray("ChatDefaultChannels"))
                {
                    global.defaultChatChannels[node.GetAttributeString_string("country").toLowerCase()] = node.GetAttributeString_string("channel");
                };
                shopBannerGroupsXML = root.MoveToSubNodeAndCreateChildrenArray("ShopBanners");
                for each (shopBannerGroupXml in shopBannerGroupsXML)
                {
                    banners = new Vector.<dBanner>();
                    requiresEvent = shopBannerGroupXml.GetAttributeString_string("requiresEvent", defines.DEFAULT_UNDEFINED);
                    shopBannersXML = shopBannerGroupXml.CreateChildrenArray();
                    for each (shopBannerXML in shopBannersXML)
                    {
                        banner = new dBanner();
                        banner.url = cFilenameUtil.findHashMapping(shopBannerXML.GetAttributeString_string("url"));
                        banner.slot = shopBannerXML.GetAttributeInt("slot");
                        banner.target = shopBannerXML.GetAttributeString_string("target");
                        banner.linkType = shopBannerXML.GetAttributeString_string("linkType");
                        banner.id = shopBannerXML.GetAttributeInt("id");
                        banners.push(banner);
                    };
                    dBanner.mShopBannerList[requiresEvent] = banners;
                };
                defaultLang = global.lang;
                if (!defaultLang)
                {
                    defaultLang = root.MoveToSubNode("DefaultLanguage").GetAttributeString_string("name");
                };
                cLocaManager.GetInstance().SetDefaultLanguage(defaultLang);
                cLog.statusText(("Setting default language to: " + defaultLang));
                cLocaManager.GetInstance().LoadLanguage("en-uk");
                global.achievementFacebookUrl = new Object();
                for each (facebookAchievementUrlXML in root.MoveToSubNodeAndCreateChildrenArray("FacebookAchievementUrls"))
                {
                    achievementFacebookUrl = new AchievementFacebookUrl();
                    achievementFacebookUrl.pidLink = facebookAchievementUrlXML.GetAttributeString_string("pidlink");
                    achievementFacebookUrl.shortenerLink = facebookAchievementUrlXML.GetAttributeString_string("shortenerLink");
                    global.achievementFacebookUrl[facebookAchievementUrlXML.GetAttributeString_string("category")] = achievementFacebookUrl;
                };
                global.promoCodeUrl = root.MoveToSubNode("Links").GetAttributeString_string("PromotionCodeUrl");
                global.changeLogUrl = root.MoveToSubNode("News").GetAttributeString_string("ChangeLogUrl");
                cLog.statusText(("Setting ChangeLog URL to: " + global.changeLogUrl));
            }
            catch(error:Error)
            {
                gMisc.MessageBox(("Error parsing language config: " + error));
            };
            mDispatcherLanguageConfig.doAction();
        }

        public static function DispatcherReactions(_arg_1:cXML):void
        {
            global.gameReactionListVO = ReactionListVO.fromXML(_arg_1, "");
        }

        public static function DispatcherUnits(root:cXML):void
        {
            try
            {
                cMilitaryUnitData.InitData(root.MoveToSubNode("UnitData"));
            }
            catch(error:Error)
            {
                gMisc.MessageBox(("Error parsing game_units.xml: " + error));
            };
            mDispatcherUnits.doAction();
        }

        public static function parseIsAvailableForLocation(_arg_1:cXML, _arg_2:String):Boolean
        {
            var _local_3:String = _arg_1.GetAttributeString_string("availableIn");
            var _local_4:String = _arg_1.GetAttributeString_string("exceptFor");
            if (((!(_local_3 == "")) && (_local_3.indexOf(_arg_2) == -1)))
            {
                return (false);
            };
            if (_local_4.indexOf(_arg_2) > -1)
            {
                return (false);
            };
            return (true);
        }

        public static function ParseCosts(_arg_1:cXML):Vector.<dResource>
        {
            var _local_4:cXML;
            var _local_5:dResource;
            var _local_2:Vector.<dResource> = new Vector.<dResource>();
            var _local_3:Vector.<cXML> = _arg_1.CreateChildrenArray();
            for each (_local_4 in _local_3)
            {
                _local_5 = new dResource();
                _local_5.name_string = _local_4.GetAttributeString_string("name");
                _local_5.amount = _local_4.GetAttributeInt("count");
                _local_2.push(_local_5);
            };
            return (_local_2);
        }

        public static function DispatcherGfxSettings(root:cXML):void
        {
            var gameObjectsList:cXML;
            var x:cXML;
            var defaultZoom:Number;
            var defaultFilterNodes:Vector.<cXML>;
            var defaultFilterNode:cXML;
            var depositVector:Vector.<cXML>;
            var depositNode:cXML;
            var adventuresXml_vector:Vector.<cXML>;
            var adventureXml:cXML;
            var uiComponentHeaderNodes:Vector.<cXML>;
            var uiComponentHeaderNode:cXML;
            var resourceIcon:cXML;
            var depositDefinition:DepositDefinition;
            var iconName:String;
            var headerNodes:Vector.<cXML>;
            var headers:Vector.<GraphicsHeaderVO>;
            var headerNode:cXML;
            try
            {
                gameObjectsList = new cXML();
                x = root.MoveToSubNode("GameObjects");
                gameObjectsList.SetXMLString(x.toXMLString());
                global.gfxSettingsGameObjectsXML = gameObjectsList;
                global.battlegroundDefinition = new BattlegroundDefinition(cXML.getFirstChildNode(root.getXML(), "Combat3Battleground"));
                defaultZoom = gameObjectsList.GetAttributeFloatingPoint("DefaultZoom");
                global.defaultGosetBuffTwinkleName = gameObjectsList.GetAttributeString_string("gosetBuffTwinkleName");
                global.defaultGosetFriendBuffTwinkleName = gameObjectsList.GetAttributeString_string("gosetForeignBuffTwinkleName");
                global.backgroundGroup.defaultZoom = int(defaultZoom);
                global.streetGroup.defaultZoom = int(defaultZoom);
                global.buildingGroup.defaultZoom = int(defaultZoom);
                global.settlerGroup.defaultZoom = int(defaultZoom);
                global.animalGroup.defaultZoom = int(defaultZoom);
                global.guiIconGroup.SetGfxXML("GuiIcons");
                global.backgroundGroup.SetGfxXML("Backgrounds");
                global.streetGroup.SetGfxXML("Streets");
                global.buildingGroup.SetGfxXML("Buildings");
                global.landscapeGroup.SetGfxXML("Landscapes");
                global.settlerGroup.SetGfxXML("Settlers");
                global.animalGroup.SetGfxXML("Animals");
                global.effectGroup.SetGfxXML("Effects");
                global.defaultFilter_vector = new Vector.<dFilterVO>();
                defaultFilterNodes = root.MoveToSubNodeAndCreateChildrenArray("defaultFilter");
                for each (defaultFilterNode in defaultFilterNodes)
                {
                    global.defaultFilter_vector.push(dFilterVO.fromXML(defaultFilterNode));
                };
                depositVector = gameObjectsList.MoveToSubNodeAndCreateChildrenArray("Deposits");
                for each (depositNode in depositVector)
                {
                    depositDefinition = new DepositDefinition();
                    depositDefinition.depositName_String = depositNode.GetAttributeString_string("name");
                    depositDefinition.goSetList_String = depositNode.GetAttributeString_string("gosetlist");
                    depositDefinition.type_String = depositNode.GetAttributeString_string("type");
                    global.depositDefinitions[depositDefinition.depositName_String] = depositDefinition;
                };
                global.textureAtlas = cXML.getFirstChildNode(root.getXML(), "SpriteSheets");
                adventuresXml_vector = gameObjectsList.MoveToSubNodeAndCreateChildrenArray("Adventures");
                for each (adventureXml in adventuresXml_vector)
                {
                    iconName = adventureXml.GetAttributeString_string("difficultyIcon", "");
                    if (iconName != "")
                    {
                        cAdventureDefinition.mDifficultyIcons[adventureXml.GetAttributeString_string("name")] = cFilenameUtil.findHashMapping(("adventures/difficulty_icons/" + iconName));
                    };
                    cAdventureDefinition.mTeaserImages[adventureXml.GetAttributeString_string("name")] = cFilenameUtil.findHashMapping(("adventures/teasers/" + adventureXml.GetAttributeString_string("teaserImage")));
                    cAdventureDefinition.mAvatarImages[adventureXml.GetAttributeString_string("name")] = cFilenameUtil.findHashMapping(("adventures/avatars/" + adventureXml.GetAttributeString_string("avatarImage")));
                };
                uiComponentHeaderNodes = root.MoveToSubNodeAndCreateChildrenArray("uiComponentHeaders");
                for each (uiComponentHeaderNode in uiComponentHeaderNodes)
                {
                    headerNodes = uiComponentHeaderNode.CreateChildrenArray();
                    headers = new Vector.<GraphicsHeaderVO>();
                    for each (headerNode in headerNodes)
                    {
                        headers.push(new GraphicsHeaderVO(headerNode.GetAttributeString_string("class"), headerNode.GetAttributeString_string("requiresEvent")));
                    };
                    global.uiComponentHeaders.push(new UIComponentHeaderVO(uiComponentHeaderNode.GetAttributeString_string("ids"), headers));
                };
                for each (resourceIcon in gameObjectsList.MoveToSubNodeAndCreateChildrenArray("ResourceIcons"))
                {
                    if (((!(resourceIcon.GetAttributeString_string("slot") == "")) && (resourceIcon.GetAttributeString_string("group") == "Military")))
                    {
                        cBattleWindow.mSlotPreferences[resourceIcon.GetAttributeString_string("name")] = resourceIcon.GetAttributeInt("slot");
                    }
                    else
                    {
                        gEconomics.resourceDefaultCreationIcon.putItem(resourceIcon.GetAttributeString_string("name"), ((resourceIcon.GetAttributeString_string("group") + "|") + resourceIcon.GetAttributeString_string("category")));
                    };
                };
            }
            catch(error:Error)
            {
                gMisc.MessageBox(("Error parsing gfx_settings.xml: " + error));
            };
            mDispatcherGfxSettings.doAction();
        }

        private static function parseTimedProductions(_arg_1:cXML):void
        {
            var _local_2:cXML;
            var _local_3:int;
            var _local_4:String;
            var _local_5:Vector.<iTimedProductionDefinition>;
            var _local_6:cXML;
            var _local_7:EffectTimedProductionDefinition;
            var _local_8:cXML;
            for each (_local_2 in _arg_1.CreateChildrenArray())
            {
                _local_3 = _local_2.GetAttributeInt("id");
                _local_4 = _local_2.GetAttributeString_string("type", TIMED_PRODUCTION_TYPE.DEFAULT_TYPE_string);
                TIMED_PRODUCTION_TYPE.add(_local_3, _local_4);
                do 
                {
                    _local_5 = new Vector.<iTimedProductionDefinition>();
                    global.timedProductions_vector.push(_local_5);
                } while (global.timedProductions_vector.length <= _local_3);
                for each (_local_6 in _local_2.CreateChildrenArray())
                {
                    _local_7 = new EffectTimedProductionDefinition();
                    _local_7.name_string = _local_6.GetAttributeString_string("name");
                    _local_7.duration = (_local_6.GetAttributeInt("duration") * 1000);
                    _local_7.instantFinishCost = _local_6.GetAttributeInt("instantFinishCost");
                    _local_7.requiresEvent = _local_6.GetAttributeString_string("requiresEvent");
                    _local_7.requiresQuest = _local_6.GetAttributeString_string("requiresQuest");
                    _local_7.requiresUpgradeLevelMin = _local_6.GetAttributeInt("requiresUpgradeLevelMin", 0);
                    _local_7.requiresUpgradeLevelMax = _local_6.GetAttributeInt("requiresUpgradeLevelMax", gMisc.GetMaxIntValue());
                    _local_7.preventDefaultAvatarMessage = _local_6.GetAttributeBool("preventDefaultAvatarMessage");
                    _local_7.group = _local_6.GetAttributeInt("group");
                    _local_7.costs_vector = ParseCosts(_local_6.MoveToSubNode("Costs"));
                    for each (_local_8 in _local_6.MoveToSubNodeAndCreateChildrenArray("Effects"))
                    {
                        _local_7.effects_vector.push(EffectVO.CreateFromXML(_local_8));
                    };
                    _local_5.push(_local_7);
                };
            };
        }

        private static function parseToolBoxContent(_arg_1:cXML):ArrayCollection
        {
            var _local_3:cXML;
            var _local_4:cToolBoxSectionData;
            var _local_2:ArrayCollection = new ArrayCollection();
            for each (_local_3 in _arg_1.MoveToSubNodeAndCreateChildrenArray("Sections"))
            {
                _local_4 = new cToolBoxSectionData(_local_3.GetAttributeString_string("id"), _local_3.GetAttributeString_string("icon"), _local_3.GetAttributeInt("group"), _local_3.GetAttributeString_string("toolTip"));
                _local_2.addItem(_local_4);
            };
            return (_local_2);
        }

        private static function ConvertXMLNameListToStringIntDictionary(_arg_1:cXML, _arg_2:cStringIntDictionary):void
        {
            var _local_3:cXML;
            var _local_4:String;
            for each (_local_3 in _arg_1.CreateChildrenArray())
            {
                _local_4 = _local_3.GetAttributeString_string("name");
                if (!StringUtils.isEmpty(_local_4))
                {
                    _arg_2.Put(_local_4, 1);
                };
            };
        }

        public static function DispatcherShopConfig(root:cXML):void
        {
            var shopItemsXml:cXML;
            var shopItemGroupsXml_vector:Vector.<cXML>;
            var readShopItemIDs_vector:Vector.<int>;
            var shopItemGroupXml:cXML;
            var shopItemGroup:cShopItemGroup;
            var shopItemsXml_vector:Vector.<cXML>;
            var shopItemXml:cXML;
            var shopItem:cShopItem;
            try
            {
                shopItemsXml = root.MoveToSubNode("ShopItems");
                shopItemGroupsXml_vector = shopItemsXml.CreateChildrenArray();
                readShopItemIDs_vector = new Vector.<int>();
                for each (shopItemGroupXml in shopItemGroupsXml_vector)
                {
                    shopItemGroup = cShopItemGroup.ReadShopItemGroupFromXml(shopItemGroupXml, false);
                    shopItemsXml_vector = shopItemGroupXml.CreateChildrenArray();
                    for each (shopItemXml in shopItemsXml_vector)
                    {
                        shopItem = cShopItem.CreateShopItemFromXml(shopItemXml, shopItemGroup.GetId());
                        shopItemGroup.AddShopItem(shopItem);
                        shopItem.setIsGroupHidden(shopItemGroup.isHiddenInShop(null));
                        gMisc.Assert((readShopItemIDs_vector.indexOf(shopItem.GetId()) == -1), (("Shop item id " + shopItem.GetId()) + " already exists!"));
                        readShopItemIDs_vector.push(shopItem.GetId());
                    };
                };
            }
            catch(error:Error)
            {
                gMisc.MessageBox(("Error parsing shopconfig.xml: " + error));
            };
            mDispatcherShopConfig.doAction();
        }


    }
}
