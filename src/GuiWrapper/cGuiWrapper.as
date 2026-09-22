package GuiWrapper
{
    import flash.events.IEventDispatcher;
    import GUI.GAME.cHintPointer;
    import GUI.GAME.cApplyBuffResourcePanel;
    import nLib.MapTextRenderer;
    import GUI.GAME.cTrackedMissionList;
    import GUI.GAME.cGameActionBar;
    import GUI.GAME.cTimedProductionInfoPanel;
    import GUI.GAME.cCombat30ToolTip;
    import GUI.GAME.cSkillTreeWindow;
    import GUI.GAME.cAvatar;
    import GUI.GAME.cSupportLockZone;
    import GUI.GAME.cGenericLinkBuildingInfoPanel;
    import GUI.GAME.cCombatScenarioTooltip;
    import GUI.GAME.cSkillProductionPanel;
    import GUI.GAME.cEventInfoPanel;
    import GUI.GAME.cGuildBankTransactionHistory;
    import GUI.GAME.cStarMenu;
    import GUI.GAME.cPvPReportWindow;
    import GUI.GAME.cLoadingZonePanel;
    import GUI.GAME.cTradingPanel;
    import GUI.GAME.cMoveBuildingPanel;
    import GUI.GAME.cGuildPayResourcePanel;
    import GUI.GAME.cAdventWindow;
    import GUI.GAME.cPremiumAccountActivationWindow;
    import GUI.GAME.cSpecialistCooldownPanel;
    import GUI.GAME.cEventPanel;
    import GUI.GAME.cAddFriendsPanel;
    import GUI.GAME.cWelcomeWindow;
    import GUI.GAME.cGuildTransferResourcePanel;
    import GUI.GAME.cColonyWindow;
    import GUI.GAME.cAdventurePanel;
    import GUI.GAME.cLevelUpWindow;
    import GUI.GAME.achievement.AchievementPanel;
    import GUI.GAME.cSpecialistTravelPanel;
    import GUI.GAME.cCultureBuildingPanel;
    import GUI.GAME.cBuildingInfoPanel;
    import flash.events.EventDispatcher;
    import GUI.GAME.cContentGeneratorRewardPanel;
    import GUI.GAME.cPacketLossAlert;
    import GUI.GAME.cFoundGuildPanel;
    import GUI.GAME.cSplashScreen;
    import GUI.cGuiBaseElement;
    import GUI.GAME.cShopWindow;
    import GUI.GAME.cMailWindow;
    import GUI.GAME.cPlayerOptionsPanel;
    import GUI.GAME.cResidenceInfoPanel;
    import GUI.GAME.cBlockList;
    import GUI.GAME.cHelpWindow;
    import GUI.GAME.cPvPLevelRewardsPanel;
    import GUI.GAME.cHiredTroopsPoolPanel;
    import GUI.GAME.cEventMonster;
    import GUI.GAME.cHelpOverview;
    import GUI.GAME.cNewsWindow;
    import GUI.GAME.cGuildBankEnlargePanel;
    import GUI.GAME.cCancelActionPanel;
    import GUI.GAME.cDailyLoginPanel;
    import GUI.GAME.MountainInfoPanel;
    import com.bluebyte.tso.quests.view.controller.cQuestBook;
    import GUI.GAME.cEventWidgetList;
    import GUI.GAME.cMayorhouseInfoPanel;
    import GUI.GAME.cOptionsPanel;
    import GUI.GAME.cGuildWindow;
    import GUI.GAME.cSpecialistPanel;
    import GUI.GAME.cMysteryBoxPanel;
    import GUI.GAME.cFriendsList;
    import GUI.GAME.cTradeOfficePanel;
    import GUI.GAME.cAvatarMessageList;
    import GUI.GAME.cLoadingMailPanel;
    import GUI.GAME.cTaskBuildingPanel;
    import GUI.GAME.cSingleInfoBar;
    import GUI.GAME.cDefenseBuildingPanel;
    import GUI.GAME.cInfoBar;
    import GUI.GAME.cContentGeneratorPanel;
    import GUI.GAME.cDeleteBuffResourcePanel;
    import GUI.GAME.cDecorationInfoPanel;
    import GUI.GAME.cCombatPreviewPanel;
    import GUI.GAME.cEpicWorkyardInfoPanel;
    import GUI.GAME.cPvPProgressionPanel;
    import GUI.GAME.cTavernInfoPanel;
    import GUI.GAME.cBuildQueue;
    import GUI.GAME.cGuildBankWindow;
    import GUI.GAME.cToolboxPanel;
    import GUI.GAME.Chat.TSOChatMediator;
    import GUI.GAME.cFriendsListMenu;
    import GUI.GAME.WindowController;
    import GUI.GAME.avatarSelection.AvatarSelectionPanel;
    import GUI.GAME.cEconomyOverview;
    import GUI.GAME.cConstructionInfoPanel;
    import GUI.GAME.cCameraControlPanel;
    import Interface.cGeneralInterface;
    import GUI.GAME.cZoneBuffPanel;
    import GUI.GAME.cWarehouseInfoPanel;
    import GUI.GAME.cEnemyBuildingInfoPanel;
    import GUI.GAME.cGuildBankBuyTabPanel;
    import GUI.GAME.cTradeWindow;
    import GUI.GAME.cBattleWindow;
    import GUI.GAME.cMinimalInfoPanel;
    import GUI.GAME.cPvPColoniesWindow;
    import GUI.GAME.cWatchTowerInfoPanel;
    import GUI.GAME.cDarkenPanel;
    import flash.utils.Dictionary;
    import __AS3__.vec.Vector;
    import Interface.cGameInterface;
    import mx.core.Application;
    import flash.events.Event;
    import Communication.VO.dContextItemVO;
    import flash.events.MouseEvent;
    import Communication.VO.dPlayerListItemVO;
    import nLib.gMisc;
    import Utils.StringUtils;
    import GO.cBuilding;
    import ServerState.dResourceDefaultDefinition;
    import flash.display.BitmapData;
    import GUI.GAME.cBasicPanel;
    import com.bluebyte.tso.adventure.logic.AdventureManager;
    import mx.events.PropertyChangeEvent;
    import GUI.ApplicationFacade;
    import Achievements.AchievementConsts;
    import GUI.GAME.cBasicInfoPanel;
    import flash.utils.setTimeout;
    import Enums.COMMAND;
    import nLib.cPosInt;
    import nLib.cBackbuffer;
    import Specialists.cSpecialist;
    import __AS3__.vec.*;

    public class cGuiWrapper implements IEventDispatcher 
    {

        public var mQuestHintPointer:cHintPointer;
        public var mApplyBuffResourcePanel:cApplyBuffResourcePanel;
        private var mRenderTextDebug:MapTextRenderer;
        public var mTrackedMissionList:cTrackedMissionList;
        public var mActionBar:cGameActionBar;
        public var mTimedProductionInfoPanel:cTimedProductionInfoPanel;
        public var mCombat30ToolTip:cCombat30ToolTip;
        public var mSkillTreeWindow:cSkillTreeWindow;
        public var mAvatar:cAvatar;
        public var mSupportLockZone:cSupportLockZone;
        public var mGenericLinkBuildingInfoPanel:cGenericLinkBuildingInfoPanel;
        public var mCombatScenarioToolTip:cCombatScenarioTooltip;
        public var mSkillProductionPanel:cSkillProductionPanel;
        public var mEventInfoPanel:cEventInfoPanel;
        public var mGuildBankTransactionHistory:cGuildBankTransactionHistory;
        public var mStarMenu:cStarMenu;
        public var mPvpReportWindow:cPvPReportWindow;
        public var mLoadingZonePanel:cLoadingZonePanel;
        public var mTradingPanel:cTradingPanel;
        public var mMoveBuildingPanel:cMoveBuildingPanel;
        public var mGuildPayResourcePanel:cGuildPayResourcePanel;
        public var mAdventWindow:cAdventWindow;
        public var mPremiumAccountActivationWindow:cPremiumAccountActivationWindow;
        public var mSpecialistCooldownPanel:cSpecialistCooldownPanel;
        public var mEventWindow:cEventPanel;
        public var mAddFriendsPanel:cAddFriendsPanel;
        public var mWelcomeWindow:cWelcomeWindow;
        public var mGuildTransferResourcePanel:cGuildTransferResourcePanel;
        public var mColonyWindow:cColonyWindow;
        public var mAdventurePanel:cAdventurePanel;
        public var mLevelUpWindow:cLevelUpWindow;
        public var mAchievementPanel:AchievementPanel;
        public var mSpecialistTravelPanel:cSpecialistTravelPanel;
        public var mCultureBuildingPanel:cCultureBuildingPanel;
        public var mBuildingInfoPanel:cBuildingInfoPanel;
        private var _bindingEventDispatcher:EventDispatcher;
        public var mContentGeneratorRewardPanel:cContentGeneratorRewardPanel;
        public var mBarracksInfoPanel:cTimedProductionInfoPanel;
        public var mPacketLostAlert:cPacketLossAlert;
        public var mFoundGuildPanel:cFoundGuildPanel;
        public var mSplashScreen:cSplashScreen;
        private var mDelayedPanel:cGuiBaseElement;
        public var mShopWindow:cShopWindow;
        public var mMailWindow:cMailWindow;
        public var mPlayerOptionsPanel:cPlayerOptionsPanel;
        public var mResidenceInfoPanel:cResidenceInfoPanel;
        public var mBlockList:cBlockList;
        public var mHelpWindow:cHelpWindow;
        public var mPvPLeveLRewardsPanel:cPvPLevelRewardsPanel;
        public var mHiredTroopsPoolPanel:cHiredTroopsPoolPanel;
        public var mExpeditionWeaponSmithInfoPanel:cTimedProductionInfoPanel;
        public var mEventMonster:cEventMonster;
        public var mHelpOverview:cHelpOverview;
        public var mNewsWindow:cNewsWindow;
        public var mGuildBankEnlargePanel:cGuildBankEnlargePanel;
        private var _1434131879mCancelActionPanel:cCancelActionPanel;
        public var mDailyLoginPanel:cDailyLoginPanel;
        public var mMountainInfoPanel:MountainInfoPanel;
        public var mQuestBook:cQuestBook;
        public var mEventWidgetList:cEventWidgetList;
        public var mMayorhouseInfoPanel:cMayorhouseInfoPanel;
        public var mOptionsPanel:cOptionsPanel;
        public var mGuildWindow:cGuildWindow;
        private var mRenderTextBigFont:MapTextRenderer;
        public var mSpecialistPanel:cSpecialistPanel;
        public var mMysteryBoxPanel:cMysteryBoxPanel;
        public var mFriendsList:cFriendsList;
        public var mTradeOfficePanel:cTradeOfficePanel;
        public var mPvPLevelUpHintPointer:cHintPointer;
        public var mAvatarMessageList:cAvatarMessageList;
        public var mLoadingMailPanel:cLoadingMailPanel;
        public var mTaskBuildingPanel:cTaskBuildingPanel;
        private var mDefaultGuiElementsLoaded:Boolean;
        public var mExpeditionInfoBar:cSingleInfoBar;
        public var mDefenseBuildingPanel:cDefenseBuildingPanel;
        public var mInfoBar:cInfoBar;
        public var mBarracks3InfoPanel:cTimedProductionInfoPanel;
        public var mContentGeneratorPanel:cContentGeneratorPanel;
        public var mDeleteBuffResourcePanel:cDeleteBuffResourcePanel;
        public var mDecorationInfoPanel:cDecorationInfoPanel;
        public var mCombatPreviewPanel:cCombatPreviewPanel;
        public var mEpicWorkyardInfoPanel:cEpicWorkyardInfoPanel;
        public var mPvPProgressionPanel:cPvPProgressionPanel;
        public var mTavernInfoPanel:cTavernInfoPanel;
        public var mBuildQueue:cBuildQueue;
        private var _274569870mGuildBankWindow:cGuildBankWindow;
        public var mToolboxPanel:cToolboxPanel;
        public var mChatPanel:TSOChatMediator;
        public var mFriendsListMenu:cFriendsListMenu;
        public var windowController:WindowController;
        public var mAvatarSelectionPanel:AvatarSelectionPanel;
        public var mEconomyOverview:cEconomyOverview;
        public var mConstructionInfoPanel:cConstructionInfoPanel;
        public var mCameraControlPanel:cCameraControlPanel;
        private var mGeneralInterface:cGeneralInterface;
        public var mZoneBuffPanel:cZoneBuffPanel;
        public var mWarehouseInfoPanel:cWarehouseInfoPanel;
        public var mEnemyBuildingInfoPanel:cEnemyBuildingInfoPanel;
        public var mGuildBankBuyTabPanel:cGuildBankBuyTabPanel;
        public var mTradeWindow:cTradeWindow;
        public var mBattleWindow:cBattleWindow;
        public var mMinimalInfoPanel:cMinimalInfoPanel;
        public var mPvPColoniesWindow:cPvPColoniesWindow;
        public var mCalendarHintPointer:cHintPointer;
        public var mWatchTowerInfoPanel:cWatchTowerInfoPanel;
        public var mDarkenPanel:cDarkenPanel;

        public var map_BuildingName_InfoPanel:Dictionary = new Dictionary();
        public var map_BuildingName_UIContent:Dictionary = new Dictionary();
        private var mWindowQueue:Vector.<cGuiBaseElement> = new Vector.<cGuiBaseElement>();

        public function cGuiWrapper()
        {
            this._bindingEventDispatcher = new EventDispatcher(IEventDispatcher(this));
            super();
        }

        public function InitGuiElements(_arg_1:cGeneralInterface):void
        {
            var _local_2:SWMMO = global.getApplication();
            this.windowController = new WindowController(_local_2.GAMESTATE_ID_DARKEN_PANEL);
            this.mGeneralInterface = _arg_1;
            cGuiBaseElement.InitStatic();
            this.mActionBar = new cGameActionBar();
            this.mActionBar.Init(_local_2.GAMESTATE_ID_ACTIONBAR);
            this.mToolboxPanel = new cToolboxPanel();
            this.mToolboxPanel.Init(_local_2.GAMESTATE_ID_TOOLBOX_PANEL);
            this.mInfoBar = new cInfoBar();
            this.mInfoBar.Init(_local_2.GAMESTATE_ID_INFO_BAR);
            this.mExpeditionInfoBar = new cSingleInfoBar();
            this.mExpeditionInfoBar.Init(_local_2.GAMESTATE_ID_EXPEDITION_INFO_BAR);
            this.mWatchTowerInfoPanel = new cWatchTowerInfoPanel();
            this.mWatchTowerInfoPanel.Init(_local_2.GAMESTATE_ID_WATCHTOWER_INFO_PANEL);
            this.mTimedProductionInfoPanel = new cTimedProductionInfoPanel();
            this.mTimedProductionInfoPanel.Init(_local_2.GAMESTATE_ID_TIMED_PRODUCTION_INFO_PANEL);
            this.mBarracksInfoPanel = new cTimedProductionInfoPanel();
            this.mBarracksInfoPanel.Init(_local_2.GAMESTATE_ID_BARRACKS);
            this.mBarracks3InfoPanel = new cTimedProductionInfoPanel();
            this.mBarracks3InfoPanel.Init(_local_2.GAMESTATE_ID_BARRACKS3, true);
            this.mExpeditionWeaponSmithInfoPanel = new cTimedProductionInfoPanel();
            this.mExpeditionWeaponSmithInfoPanel.Init(_local_2.GAMESTATE_ID_EXPEDITION_WEAPONSMITH, true);
            this.mSkillProductionPanel = new cSkillProductionPanel();
            this.mSkillProductionPanel.Init(_local_2.GAMESTATE_ID_SKILL_PRODUCTION_PANEL);
            this.mTavernInfoPanel = new cTavernInfoPanel();
            this.mTavernInfoPanel.Init(_local_2.GAMESTATE_ID_TAVERN_INFO_PANEL);
            this.mBuildingInfoPanel = new cBuildingInfoPanel();
            this.mBuildingInfoPanel.Init(_local_2.GAMESTATE_ID_BUILDING_INFO_PANEL);
            this.mEpicWorkyardInfoPanel = new cEpicWorkyardInfoPanel();
            this.mEpicWorkyardInfoPanel.Init(_local_2.GAMESTATE_ID_EPIC_WORKYARD_INFO_PANEL);
            this.mMoveBuildingPanel = new cMoveBuildingPanel();
            this.mMoveBuildingPanel.Init(_local_2.GAMESTATE_ID_MOVE_BUILDING_PANEL);
            this.mResidenceInfoPanel = new cResidenceInfoPanel();
            this.mResidenceInfoPanel.Init(_local_2.GAMESTATE_ID_RESIDENCE_INFO_PANEL);
            this.mConstructionInfoPanel = new cConstructionInfoPanel();
            this.mConstructionInfoPanel.Init(_local_2.GAMESTATE_ID_CONSTRUCTION_INFO_PANEL);
            this.mDecorationInfoPanel = new cDecorationInfoPanel();
            this.mDecorationInfoPanel.Init(_local_2.GAMESTATE_ID_DECORATION_INFO_PANEL);
            this.mMinimalInfoPanel = new cMinimalInfoPanel();
            this.mMinimalInfoPanel.Init(_local_2.GAMESTATE_ID_MINIMAL_INFO_PANEL);
            this.mTradeOfficePanel = new cTradeOfficePanel();
            this.mTradeOfficePanel.Init(_local_2.GAMESTATE_ID_TRADE_OFFICE_PANEL);
            this.mSpecialistCooldownPanel = new cSpecialistCooldownPanel();
            this.mSpecialistCooldownPanel.Init(_local_2.SPECIALIST_COOLDOWN_PANEL);
            this.mMysteryBoxPanel = new cMysteryBoxPanel();
            this.mMysteryBoxPanel.Init(_local_2.GAMESTATE_ID_MYSTERYBOX_PANEL);
            this.mEnemyBuildingInfoPanel = new cEnemyBuildingInfoPanel();
            this.mEnemyBuildingInfoPanel.Init(_local_2.GAMESTATE_ID_ENEMY_BUILDING_INFO_PANEL);
            this.mWarehouseInfoPanel = new cWarehouseInfoPanel();
            this.mWarehouseInfoPanel.Init(_local_2.GAMESTATE_ID_WAREHOUSE_INFO_PANEL);
            this.mMayorhouseInfoPanel = new cMayorhouseInfoPanel();
            this.mMayorhouseInfoPanel.Init(_local_2.GAMESTATE_ID_WAREHOUSE_INFO_PANEL);
            this.mLoadingZonePanel = new cLoadingZonePanel();
            this.mLoadingZonePanel.Init(_local_2.GAMESTATE_ID_LOADING_ZONE_PANEL);
            this.mBuildQueue = new cBuildQueue();
            this.mBuildQueue.Init(_local_2.GAMESTATE_ID_BUILD_QUEUE);
            this.mOptionsPanel = new cOptionsPanel();
            this.mOptionsPanel.Init(_local_2.GAMESTATE_ID_AVATAR.options);
            this.mCameraControlPanel = new cCameraControlPanel();
            this.mCameraControlPanel.Init(_local_2.GAMESTATE_ID_CAMERA_CONTROL_PANEL);
            this.mAvatar = new cAvatar();
            this.mAvatar.Init(_local_2.GAMESTATE_ID_AVATAR);
            this.mHiredTroopsPoolPanel = new cHiredTroopsPoolPanel();
            this.mHiredTroopsPoolPanel.Init(_local_2.GAMESTATE_HIRED_TROOPS_POOL_PANEL);
            this.mFriendsListMenu = new cFriendsListMenu();
            this.mFriendsListMenu.Init(_local_2.GAMESTATE_ID_FRIENDS_LIST_MENU);
            this.mFriendsList = new cFriendsList();
            this.mFriendsList.Init(_local_2.GAMESTATE_ID_FRIENDS_LIST);
            this.mTradingPanel = new cTradingPanel();
            this.mShopWindow = new cShopWindow();
            this.mShopWindow.Init(_local_2.GAMESTATE_ID_SHOP_WINDOW);
            this.mStarMenu = new cStarMenu();
            this.mStarMenu.Init(_local_2.GAMESTATE_ID_STAR_MENU);
            this.mSpecialistPanel = new cSpecialistPanel();
            this.mSpecialistPanel.Init(_local_2.GAMESTATE_ID_SPECIALIST_PANEL);
            this.mCombatPreviewPanel = new cCombatPreviewPanel();
            this.mCombatPreviewPanel.Init(_local_2.GAMESTATE_ID_PRECOMBAT_PANEL);
            this.mColonyWindow = new cColonyWindow();
            this.mColonyWindow.Init(_local_2.GAMESTATE_ID_COLONY_WINDOW);
            this.mPvPColoniesWindow = new cPvPColoniesWindow();
            this.mPvPColoniesWindow.Init(_local_2.GAMESTATE_ID_PVPCOLONIES_WINDOW);
            this.mSpecialistTravelPanel = new cSpecialistTravelPanel();
            this.mSpecialistTravelPanel.Init(_local_2.GAMESTATE_ID_SPECIALIST_TRAVEL_PANEL);
            this.mCancelActionPanel = new cCancelActionPanel();
            this.mCancelActionPanel.Init(_local_2.GAMESTATE_ID_CANCEL_ACTION_PANEL);
            this.mAvatarMessageList = new cAvatarMessageList();
            this.mAvatarMessageList.Init(_local_2.GAMESTATE_ID_AVATAR_MESSAGE_LIST);
            this.mTrackedMissionList = new cTrackedMissionList();
            this.mTrackedMissionList.Init(_local_2.GAMESTATE_ID_TRACKED_MISSION_LIST);
            this.mEventWidgetList = new cEventWidgetList();
            this.mEventWidgetList.Init(_local_2.GAMESTATE_ID_EVENT_WIDGET_LIST);
            this.mAddFriendsPanel = new cAddFriendsPanel();
            this.mAddFriendsPanel.Init(_local_2.GAMESTATE_ID_ADD_FRIENDS_PANEL);
            this.mLoadingMailPanel = new cLoadingMailPanel();
            this.mLoadingMailPanel.init(_local_2.GAMESTATE_ID_LOADING_MAIL_PANEL);
            this.mMailWindow = new cMailWindow();
            this.mQuestBook = new cQuestBook();
            this.mQuestBook.Init(_local_2.GAMESTATE_ID_QUEST_BOOK);
            this.mHelpWindow = new cHelpWindow();
            this.mHelpWindow.Init(_local_2.GAMESTATE_ID_HELP_WINDOW);
            this.mHelpOverview = new cHelpOverview();
            this.mHelpOverview.Init(_local_2.GAMESTATE_ID_HELP_OVERVIEW);
            this.mEventWindow = new cEventPanel();
            this.mEventWindow.Init(_local_2.GAMESTATE_ID_EVENT_WINDOW);
            this.mLevelUpWindow = new cLevelUpWindow();
            this.mLevelUpWindow.Init(_local_2.GAMESTATE_ID_LEVELUP_WINDOW);
            this.mWelcomeWindow = new cWelcomeWindow();
            this.mWelcomeWindow.Init(_local_2.GAMESTATE_ID_WELCOME_WINDOW);
            this.mEconomyOverview = new cEconomyOverview();
            this.mEconomyOverview.Init(_local_2.GAMESTATE_ID_ECONOMY_OVERVIEW);
            this.mQuestHintPointer = new cHintPointer();
            this.mQuestHintPointer.Init(_local_2.GAMESTATE_ID_QUEST_HINT_POINTER);
            this.mPvPLevelUpHintPointer = new cHintPointer();
            this.mPvPLevelUpHintPointer.Init(_local_2.GAMESTATE_ID_PVP_LEVEL_UP_HINT_POINTER);
            this.mCalendarHintPointer = new cHintPointer();
            this.mCalendarHintPointer.Init(_local_2.GAMESTATE_ID_CALENDAR_HINT_POINTER);
            this.mDarkenPanel = new cDarkenPanel();
            this.mDarkenPanel.Init(_local_2.GAMESTATE_ID_DARKEN_PANEL);
            this.mNewsWindow = new cNewsWindow();
            this.mNewsWindow.Init(_local_2.GAMESTATE_ID_NEWS_WINDOW);
            this.mAdventurePanel = new cAdventurePanel();
            this.mAdventurePanel.Init(_local_2.GAMESTATE_ID_ADVENTURE_PANEL);
            this.mGuildWindow = new cGuildWindow();
            this.mGuildWindow.Init(_local_2.GAMESTATE_ID_GUILD_WINDOW);
            this.mTradeWindow = new cTradeWindow();
            this.mTradeWindow.Init(_local_2.GAMESTATE_ID_TRADE_WINDOW);
            this.mFoundGuildPanel = new cFoundGuildPanel();
            this.mFoundGuildPanel.Init(_local_2.GAMESTATE_ID_FOUND_GUILD_PANEL);
            this.mDailyLoginPanel = new cDailyLoginPanel();
            this.mDailyLoginPanel.Init(_local_2.GAMESTATE_ID_DAILY_LOGIN_PANEL);
            this.mPremiumAccountActivationWindow = new cPremiumAccountActivationWindow();
            this.mPremiumAccountActivationWindow.Init(_local_2.GAMESTATE_ID_ACTIVATE_PREMIUM_ACCOUNT_WINDOW);
            this.mSkillTreeWindow = new cSkillTreeWindow();
            this.mSkillTreeWindow.Init(_local_2.GAMESTATE_ID_SKILLTREEWINDOW);
            this.mEventMonster = new cEventMonster();
            this.mEventMonster.Init(_local_2.GAMESTATE_ID_EVENT_MONSTER);
            this.mAchievementPanel = new AchievementPanel();
            this.mAchievementPanel.init((_arg_1 as cGameInterface), _local_2.GAMESTATE_ID_ACHIEVEMENT_PANEL);
            this.mBlockList = new cBlockList();
            this.mBlockList.Init(_local_2.GAMESTATE_ID_BLOCK_LIST);
            this.mAvatarSelectionPanel = new AvatarSelectionPanel();
            this.mAvatarSelectionPanel.init(_arg_1, Application.application.GAMESTATE_ID_AVATAR_SELECTION);
            this.mGuildBankWindow = new cGuildBankWindow();
            this.mGuildBankWindow.Init(_local_2.GAMESTATE_ID_GUILD_BANK_WINDOW);
            this.mGuildPayResourcePanel = new cGuildPayResourcePanel();
            this.mGuildPayResourcePanel.Init(_local_2.GAMESTATE_ID_GUILD_PAY_RESOURCE_PANEL);
            this.mGuildTransferResourcePanel = new cGuildTransferResourcePanel();
            this.mGuildTransferResourcePanel.Init(_local_2.GAMESTATE_ID_GUILD_TRANSFER_RESOURCE_PANEL);
            this.mApplyBuffResourcePanel = new cApplyBuffResourcePanel();
            this.mApplyBuffResourcePanel.Init(_local_2.GAMESTATE_ID_APPLY_BUFF_RESOURCE_PANEL);
            this.mDeleteBuffResourcePanel = new cDeleteBuffResourcePanel();
            this.mDeleteBuffResourcePanel.Init(_local_2.GAMESTATE_ID_DELETE_BUFF_RESOURCE_PANEL);
            this.mGuildBankBuyTabPanel = new cGuildBankBuyTabPanel();
            this.mGuildBankBuyTabPanel.Init(_local_2.GAMESTATE_ID_GUILD_BUY_TAB_PANEL);
            this.mGuildBankEnlargePanel = new cGuildBankEnlargePanel();
            this.mGuildBankEnlargePanel.Init(_local_2.GAMESTATE_ID_GUILD_ENLARGE_PANEL);
            this.mGuildBankTransactionHistory = new cGuildBankTransactionHistory();
            this.mGuildBankTransactionHistory.Init(_local_2.GAMESTATE_ID_GUILD_TRANSACTION_HISTORY);
            this.mAdventWindow = new cAdventWindow();
            this.mAdventWindow.init(_local_2.GAMESTATE_ID_ADVENT_WINDOW);
            this.mPacketLostAlert = new cPacketLossAlert();
            this.mPacketLostAlert.Init(Application.application.GAMESTATE_ID_PACKET_LOST_ALERT);
            this.mMountainInfoPanel = new MountainInfoPanel();
            this.mMountainInfoPanel.Init(_local_2.GAMESTATE_ID_MOUNTAIN_INFO_PANEL);
            this.mCombat30ToolTip = new cCombat30ToolTip();
            this.mCombat30ToolTip.Init(_local_2.GAMESTATE_ID_COMBAT30_TOOLTIP);
            this.mCombatScenarioToolTip = new cCombatScenarioTooltip();
            this.mCombatScenarioToolTip.Init(_local_2.GAMESTATE_ID_COMBAT_SCENARIO_TOOLTIP);
            this.mDefenseBuildingPanel = new cDefenseBuildingPanel();
            this.mDefenseBuildingPanel.Init(_local_2.GAMESTATE_ID_DEFENSE_BUILDING);
            this.mPvpReportWindow = new cPvPReportWindow();
            this.mPvpReportWindow.Init(_local_2.GAMESTATE_ID_PVP_REPORT_WINDOW);
            this.mSplashScreen = new cSplashScreen();
            this.mSplashScreen.Init(_local_2.GAMESTATE_ID_SPLASH_SCREEN);
            this.mGenericLinkBuildingInfoPanel = new cGenericLinkBuildingInfoPanel();
            this.mGenericLinkBuildingInfoPanel.Init(_local_2.GAMESTATE_ID_GENERIC_LINK_BUILDING_INFO_PANEL);
            this.mSupportLockZone = new cSupportLockZone();
            this.mSupportLockZone.Init(_local_2.GAMESTATE_ID_SUPPORT_LOCK_ZONE_CLOCK);
            this.mPvPProgressionPanel = new cPvPProgressionPanel();
            this.mPvPLeveLRewardsPanel = new cPvPLevelRewardsPanel();
            this.mPvPLeveLRewardsPanel.Init(_local_2.GAMESTATE_ID_PVP_LEVEL_REWARDS);
            this.mSupportLockZone = new cSupportLockZone();
            this.mSupportLockZone.Init(_local_2.GAMESTATE_ID_SUPPORT_LOCK_ZONE_CLOCK);
            this.mPlayerOptionsPanel = new cPlayerOptionsPanel();
            this.mPlayerOptionsPanel.Init(_local_2.GAMESTATE_ID_PLAYER_OPTIONS);
            this.mEventInfoPanel = new cEventInfoPanel();
            this.mEventInfoPanel.Init(_local_2.GAMESTATE_ID_EVENT_INFO_PANEL);
            this.mZoneBuffPanel = new cZoneBuffPanel();
            this.mZoneBuffPanel.Init(_local_2.GAMESTATE_ID_ZONE_BUFF_PANEL);
            this.mTaskBuildingPanel = new cTaskBuildingPanel();
            this.mTaskBuildingPanel.Init(_local_2.GAMESTATE_ID_TASK_BUILDING_PANEL);
            this.mCultureBuildingPanel = new cCultureBuildingPanel();
            this.mCultureBuildingPanel.Init(_local_2.GAMESTATE_ID_CULTURE_BUILDING_PANEL);
            this.mContentGeneratorPanel = new cContentGeneratorPanel();
            this.mContentGeneratorPanel.Init(_local_2.GAMESTATE_ID_CONTENT_GENERATOR_PANEL);
            this.mContentGeneratorRewardPanel = new cContentGeneratorRewardPanel();
            this.mContentGeneratorRewardPanel.Init(_local_2.GAMESTATE_ID_CONTENT_GENERATOR_REWARD_PANEL);
            _local_2.nLibFlexBridgeManager.init();
            this.AssignInfoPannels();
        }

        public function dispatchEvent(_arg_1:Event):Boolean
        {
            return (this._bindingEventDispatcher.dispatchEvent(_arg_1));
        }

        public function addEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false, _arg_4:int=0, _arg_5:Boolean=false):void
        {
            this._bindingEventDispatcher.addEventListener(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
        }

public function ShowDefaultGuiElements():void
{
if (this.mChatPanel != null)
            {
                this.mChatPanel.Show();
            };
            this.mActionBar.Show();
            this.mInfoBar.Show();
            this.mAvatar.Show();
            this.mFriendsList.Show();
this.mOptionsPanel.Show();
this.mDefaultGuiElementsLoaded = true;
}

        public function ShowContextMenu(_arg_1:Vector.<dContextItemVO>, _arg_2:int, _arg_3:int):void
        {
            if (_arg_1.length == 0)
            {
                return;
            };
            this.mFriendsListMenu.SetContextMenu(_arg_1);
            this.mFriendsListMenu.Show();
        }

        public function ShowFriendListMenu(_arg_1:MouseEvent, _arg_2:dPlayerListItemVO):void
        {
            this.mFriendsListMenu.SetData(_arg_2);
            _arg_1.stopPropagation();
            this.mFriendsListMenu.Show();
        }

        public function ToggleTradeWindow(_arg_1:Event):void
        {
            if (this.mTradeWindow.IsVisible())
            {
                this.mTradeWindow.Hide();
            }
            else
            {
                this.mTradeWindow.Show();
            };
        }

        public function ToggleStarMenu(_arg_1:Event):void
        {
            if (this.mStarMenu.IsVisible())
            {
                this.mStarMenu.ClosePanel(_arg_1);
            }
            else
            {
                this.mStarMenu.Show();
            };
        }

        public function RegisterBuildingType(_arg_1:String, _arg_2:String, _arg_3:String):void
        {
            if (((_arg_1 == "") || (_arg_2 == "")))
            {
                gMisc.Assert(false, ("No UI type specified for building: " + _arg_1));
            };
            this.map_BuildingName_InfoPanel[_arg_1] = _arg_2;
            this.map_BuildingName_UIContent[_arg_1] = _arg_3;
        }

        public function ToggleShop(_arg_1:Event):void
        {
            if (this.mShopWindow.IsVisible())
            {
                this.mShopWindow.Hide();
            }
            else
            {
                this.mShopWindow.Show();
            };
        }

        public function AssignInfoPannels():void
        {
            var _local_2:String;
            var _local_1:Dictionary = new Dictionary();
            for (_local_2 in this.map_BuildingName_InfoPanel)
            {
                switch (this.map_BuildingName_InfoPanel[_local_2])
                {
                    case "achievementWorkyard":
                    case "workyard":
                        _local_1[_local_2] = this.mBuildingInfoPanel;
                        break;
                    case "epicWorkyard":
                        _local_1[_local_2] = this.mEpicWorkyardInfoPanel;
                        break;
                    case "residence":
                        _local_1[_local_2] = this.mResidenceInfoPanel;
                        break;
                    case "genericLink":
                        _local_1[_local_2] = this.mGenericLinkBuildingInfoPanel;
                        break;
                    case "timedproduction":
                        if (this.map_BuildingName_UIContent[_local_2] == 2)
                        {
                            _local_1[_local_2] = this.mSkillProductionPanel;
                        }
                        else
                        {
                            if (_local_2 == defines.BARRACKS_NAME_string)
                            {
                                _local_1[_local_2] = this.mBarracksInfoPanel;
                            }
                            else
                            {
                                if (_local_2 == defines.BARRACKS3_NAME_string)
                                {
                                    _local_1[_local_2] = this.mBarracks3InfoPanel;
                                }
                                else
                                {
                                    if (_local_2 == defines.EXPEDITION_WEAPONSMITH_NAME_string)
                                    {
                                        _local_1[_local_2] = this.mExpeditionWeaponSmithInfoPanel;
                                    }
                                    else
                                    {
                                        _local_1[_local_2] = this.mTimedProductionInfoPanel;
                                    };
                                };
                            };
                        };
                        break;
                    case "achievementWarehouse":
                    case "warehouse":
                        if (defines.MAYORHOUSE_NAME_string == _local_2)
                        {
                            _local_1[_local_2] = this.mMayorhouseInfoPanel;
                        }
                        else
                        {
                            _local_1[_local_2] = this.mWarehouseInfoPanel;
                        };
                        break;
                    case "decoration":
                        _local_1[_local_2] = this.mDecorationInfoPanel;
                        break;
                    case "enemy":
                        if (StringUtils.startsWith(_local_2, defines.DESTROYABLE_MOUNTAIN_string))
                        {
                            _local_1[_local_2] = this.mMountainInfoPanel;
                        }
                        else
                        {
                            _local_1[_local_2] = this.mEnemyBuildingInfoPanel;
                        };
                        break;
                    case "minimal":
                        _local_1[_local_2] = this.mMinimalInfoPanel;
                        break;
                    case "tradeOffice":
                        _local_1[_local_2] = this.mTradeWindow;
                        break;
                    case "tavern":
                        _local_1[_local_2] = this.mTavernInfoPanel;
                        break;
                    case "watchtower":
                        _local_1[_local_2] = this.mWatchTowerInfoPanel;
                        break;
                    case "guildbank":
                        _local_1[_local_2] = this.mGuildBankWindow;
                        break;
                    case "guild":
                        _local_1[_local_2] = this.mGuildWindow;
                        break;
                    case defines.TASK_BUILDING_UI_NAME_string:
                        _local_1[_local_2] = this.mTaskBuildingPanel;
                        break;
                    case "culture":
                        _local_1[_local_2] = this.mCultureBuildingPanel;
                        break;
                    case "contentgenerator":
                        _local_1[_local_2] = this.mContentGeneratorPanel;
                        break;
                    case "player_camp":
                    case "none":
                        break;
                    case "garrison":
                        break;
                    default:
                        gMisc.Assert(false, ((('Unknown UI type "' + this.map_BuildingName_InfoPanel[_local_2]) + '" for building: ') + _local_2));
                };
            };
            this.map_BuildingName_InfoPanel = _local_1;
        }

        public function ShowBarracks():void
        {
            var _local_1:cBuilding;
            for each (_local_1 in global.ui.mCurrentPlayerZone.mStreetDataMap.GetBuildings_vector())
            {
                if (_local_1 != null)
                {
                    if (_local_1.GetBuildingName_string() == defines.BARRACKS_NAME_string)
                    {
                        global.ui.SelectBuilding(_local_1);
                        this.mBarracksInfoPanel.SetData(_local_1);
                        this.mBarracksInfoPanel.Show();
                        return;
                    };
                };
            };
        }

        public function ShowEconomy(_arg_1:dResourceDefaultDefinition):void
        {
            if (_arg_1 != null)
            {
                this.mEconomyOverview.SetSelection(_arg_1);
            };
            this.mEconomyOverview.Show();
        }

        public function WriteDebugTextCenterBackground(_arg_1:BitmapData, _arg_2:String, _arg_3:int, _arg_4:int, _arg_5:int):void
        {
            this.mRenderTextDebug.render(_arg_2, _arg_1, _arg_3, _arg_4, true, _arg_5);
        }

        public function InitFonts(_arg_1:String):void
        {
            trace((('cGUIWrapper::InitFonts("' + _arg_1) + '")'));
            MapTextRenderer.DEFAULT_FONT_NAME = _arg_1;
            this.mRenderTextDebug = new MapTextRenderer();
            this.mRenderTextBigFont = new MapTextRenderer(16, 0xFF00);
        }

        public function ToggleEconomyWindow(_arg_1:Event):void
        {
            if (this.mEconomyOverview.IsVisible())
            {
                this.mEconomyOverview.Hide();
            }
            else
            {
                this.mEconomyOverview.Show();
            };
        }

        public function UpdateGuiOnZoneLoad():void
        {
            if (this.mEventInfoPanel.IsVisible())
            {
                this.mEventInfoPanel.StartEventInfoState();
            }
            else
            {
                cBasicPanel.HideCurrentActivePanel();
            };
            AdventureManager.getInstance().SetScoutingForPvP(false);
            this.mLoadingZonePanel.Hide();
            globalFlash.gui.windowController.closeModal();
            if (!global.ui.isOnHomzone())
            {
                this.mEventInfoPanel.Hide();
                this.mEventWidgetList.Hide();
            }
            else
            {
                if (!global.hasEventInfoPanelBeenShown)
                {
                    this.mEventInfoPanel.Show();
                };
                this.mEventWidgetList.Show();
            };
            this.mTradeWindow.Hide();
            this.mToolboxPanel.ClosePanel(null);
            this.mStarMenu.ClosePanel(null);
            this.mDeleteBuffResourcePanel.Hide();
        }

        public function ShowBuilding(_arg_1:String):cBuilding
        {
            var _local_2:cBuilding = global.ui.mCurrentPlayerZone.mStreetDataMap.getBuildingByName(_arg_1);
            this.mGeneralInterface.SelectBuilding(_local_2);
            return (_local_2);
        }

        public function set mGuildBankWindow(_arg_1:cGuildBankWindow):void
        {
            var _local_2:Object = this._274569870mGuildBankWindow;
            if (_local_2 !== _arg_1)
            {
                this._274569870mGuildBankWindow = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "mGuildBankWindow", _local_2, _arg_1));
            };
        }

        public function WriteDebugTextCenter(_arg_1:BitmapData, _arg_2:String, _arg_3:int, _arg_4:int):void
        {
            this.mRenderTextDebug.render(_arg_2, _arg_1, _arg_3, _arg_4, true);
        }

        public function hasEventListener(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.hasEventListener(_arg_1));
        }

        public function OpenWindow(_arg_1:String, _arg_2:String=null):void
        {
            var _local_3:cGuiBaseElement;
            switch (_arg_1)
            {
                case "GAMESTATE_ID_PVP_PROGRESSION":
                    this.mPvPProgressionPanel.SetState(cPvPProgressionPanel.STATE_RANKS);
                    this.mPvPProgressionPanel.Show();
                    return;
                case "GAMESTATE_ID_ACHIEVEMENT_PANEL":
                    ApplicationFacade.sendNotification(AchievementConsts.SHOW_HIDE_ACHIEVEMENT_PANEL, null, AchievementConsts.NORMAL_MODE);
                    if (!isNaN(parseInt(_arg_2)))
                    {
                        ApplicationFacade.sendNotification(AchievementConsts.ACHIEVEMENT_CATEGORY_SELECTED, parseInt(_arg_2), null);
                    };
                    return;
                case "GAMESTATE_ID_HELP_WINDOW":
                    this.mHelpOverview.ShowItem(global.map_HelpName_HelpDefinition[_arg_2], 1);
                    this.mHelpOverview.Show();
                    return;
                case "GAMESTATE_ID_SHOP_WINDOW":
                    if (!isNaN(parseInt(_arg_2)))
                    {
                        this.mShopWindow.ShowDeepLink("OpenWindowEffect", -1, parseInt(_arg_2));
                    }
                    else
                    {
                        this.mShopWindow.Show();
                    };
                    return;
                case "CLOSE_WINDOW":
                    cBasicPanel.HideCurrentActivePanel();
                    return;
                case "GAMESTATE_ID_QUEST_BOOK_START_WITH":
                    this.mQuestBook.SetPreselectedQuestThatStartsWith(_arg_2);
                    this.mQuestBook.Show();
                default:
                    _local_3 = cGuiBaseElement.GetPanelController(_arg_1);
                    if (_local_3 != null)
                    {
                        _local_3.Show();
                    };
            };
        }

        public function GetDefaultGuiElementsLoaded():Boolean
        {
            return (this.mDefaultGuiElementsLoaded);
        }

        public function ToggleColonyWindow(_arg_1:Event=null):void
        {
            if (this.mColonyWindow.IsVisible())
            {
                this.mColonyWindow.Hide();
            }
            else
            {
                this.mColonyWindow.Show();
            };
        }

        public function WriteDebugText(_arg_1:BitmapData, _arg_2:String, _arg_3:int, _arg_4:int):void
        {
            this.mRenderTextDebug.render(_arg_2, _arg_1, _arg_3, _arg_4);
        }

        public function ToggleMailWindow(_arg_1:Event):void
        {
            if (this.mMailWindow.IsVisible())
            {
                this.mMailWindow.Hide();
            }
            else
            {
                this.mMailWindow.Show();
            };
        }

        public function ToggleToolbox(_arg_1:Event):void
        {
            if (this.mToolboxPanel.IsVisible())
            {
                this.mToolboxPanel.ClosePanel(_arg_1);
            }
            else
            {
                this.mToolboxPanel.Show();
            };
        }

        public function ExitGuiElements():void
        {
        }

        public function set mCancelActionPanel(_arg_1:cCancelActionPanel):void
        {
            var _local_2:Object = this._1434131879mCancelActionPanel;
            if (_local_2 !== _arg_1)
            {
                this._1434131879mCancelActionPanel = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "mCancelActionPanel", _local_2, _arg_1));
            };
        }

        public function removeEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false):void
        {
            this._bindingEventDispatcher.removeEventListener(_arg_1, _arg_2, _arg_3);
        }

        public function GetInfoPanel(_arg_1:String):cBasicInfoPanel
        {
            return (this.map_BuildingName_InfoPanel[_arg_1]);
        }

        [Bindable(event="propertyChange")]
        public function get mGuildBankWindow():cGuildBankWindow
        {
            return (this._274569870mGuildBankWindow);
        }

        public function ShowQuestWindowDelayed():void
        {
            if ((((this.mWindowQueue.length > 0) && (!(cBasicPanel.IsCurrentActivePanelVisible()))) && (this.mDelayedPanel == null)))
            {
                this.mDelayedPanel = this.mWindowQueue.shift();
                setTimeout(function ():void
                {
                    if (!cBasicPanel.IsCurrentActivePanelVisible())
                    {
                        mDelayedPanel.Show();
                    }
                    else
                    {
                        mWindowQueue.unshift(mDelayedPanel);
                    };
                    mDelayedPanel = null;
                }, 100);
            };
        }

        public function GetInfoPanelString(_arg_1:String):String
        {
            return (this.map_BuildingName_InfoPanel[_arg_1]);
        }

        [Bindable(event="propertyChange")]
        public function get mCancelActionPanel():cCancelActionPanel
        {
            return (this._1434131879mCancelActionPanel);
        }

        public function TryShowPanel(_arg_1:cGuiBaseElement):void
        {
            if (((!(_arg_1 is cBasicPanel)) || (((!(cBasicPanel.IsCurrentActivePanelVisible())) && (this.mDelayedPanel == null)) && (this.mGeneralInterface.mCurrentCursor.GetEditMode() == COMMAND.SELECT_BUILDING))))
            {
                _arg_1.Show();
            }
            else
            {
                if ((((!(_arg_1.IsVisible())) && (!(this.mDelayedPanel == _arg_1))) && (this.mWindowQueue.indexOf(_arg_1) == -1)))
                {
                    this.mWindowQueue.push(_arg_1);
                };
            };
        }

        public function TogglePvPColoniesWindow(_arg_1:Event=null):void
        {
            if (this.mPvPColoniesWindow.IsVisible())
            {
                this.mPvPColoniesWindow.Hide();
            }
            else
            {
                this.mPvPColoniesWindow.Show();
            };
        }

        public function willTrigger(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.willTrigger(_arg_1));
        }

        public function ToggleGuildWindow(_arg_1:Event):void
        {
            if (this.mGuildWindow.IsVisible())
            {
                this.mGuildWindow.Hide();
            }
            else
            {
                this.mGuildWindow.Show();
            };
        }

        public function WriteTextBig(_arg_1:BitmapData, _arg_2:String, _arg_3:int, _arg_4:int):void
        {
            this.mRenderTextBigFont.render(_arg_2, _arg_1, _arg_3, _arg_4);
        }

        public function WriteDebugTextMapPos(_arg_1:BitmapData, _arg_2:String, _arg_3:int, _arg_4:int):void
        {
            var _local_5:cPosInt = new cPosInt();
            _local_5.x = int(_arg_3);
            _local_5.y = int(_arg_4);
            global.getApplication().mGameInterface.mZoom.CalculateScrollPos(_local_5);
            globalFlash.gui.WriteDebugText(cBackbuffer.mBackBuffer, _arg_2, _local_5.x, _local_5.y);
        }

        public function ShowNextGarrison():void
        {
            var _local_4:cSpecialist;
            var _local_1:cBuilding;
            if (((!(this.mGeneralInterface.GetSelectedBuilding() == null)) && (this.mGeneralInterface.GetSelectedBuilding().isGarrison())))
            {
                _local_1 = this.mGeneralInterface.GetSelectedBuilding();
            };
            var _local_2:cSpecialist;
            var _local_3:Vector.<cSpecialist> = this.mGeneralInterface.mCurrentPlayerZone.GetSpecialists_vector();
            for each (_local_4 in _local_3)
            {
                if ((((_local_4.GetSpecialistDescription().isGeneral()) || (_local_4.GetSpecialistDescription().isAdmiral())) && (!(_local_4.GetGarrison() == null))))
                {
                    if (_local_1 == null)
                    {
                        this.mGeneralInterface.SelectBuilding(_local_4.GetGarrison());
                        this.mSpecialistPanel.SetData(_local_4);
                        this.mSpecialistPanel.Show();
                        this.mGeneralInterface.mCurrentPlayerZone.ScrollToGrid(_local_4.GetGarrisonGridIdx());
                        return;
                    };
                    if (_local_1 == _local_4.GetGarrison())
                    {
                        _local_1 = null;
                    };
                    if (_local_2 == null)
                    {
                        _local_2 = _local_4;
                    };
                };
            };
            if (_local_2 != null)
            {
                this.mGeneralInterface.SelectBuilding(_local_2.GetGarrison());
                this.mSpecialistPanel.SetData(_local_2);
                this.mSpecialistPanel.Show();
                this.mGeneralInterface.mCurrentPlayerZone.ScrollToGrid(_local_2.GetGarrisonGridIdx());
            };
        }


    }
}
