package GUI.Assets
{
    import flash.display.Shader;
    import flash.utils.ByteArray;
    import flash.filters.ShaderFilter;
    import __AS3__.vec.Vector;
    import flash.utils.Dictionary;
    import flash.display.Bitmap;
    import nLib.cFilenameUtil;
    import flash.filters.ColorMatrixFilter;
    import GUI.coloringFilter;
    import flash.geom.Point;
    import org.bytearray.display.ScaleBitmap;
    import flash.geom.Rectangle;
    import flash.display.BitmapData;
    import nLib.cLog;
    import nLib.gMisc;
    import nLib.TSOURLLoader;
    import flash.events.Event;
    import nLib.cXML;
    import flash.net.registerClassAlias;
    import Utils.StringUtils;
    import Enums.TRIGGER_ACTION;
    import MilitarySystem.cMilitaryUnitBase;
    import Communication.VO.TriggerVO;
    import AdventureSystem.cAdventureDefinition;
    import converted.bluebyte.tso.quests.logic.QuestManagerStatic;
    import Communication.VO.dQuestDefinitionTriggerVO;
    import __AS3__.vec.*;

    public class gAssetManager 
    {

        private static const GROUP_BUILDINGS:int = 0;
        private static const GROUP_RESOURCES:int = 1;

        [Embed(source="../../../assets/gAssetManager/IconInactiveFilter.bin", mimeType="application/octet-stream")]
        private static const IconInactiveFilter:Class;
        private static const inactiveShader:Shader = new Shader((new IconInactiveFilter() as ByteArray));
        private static const inactiveFilter:ShaderFilter = new ShaderFilter(inactiveShader);

        [Embed(source="../../../assets/gAssetManager/IconMailInbox.png")]
        private static const IconMailInbox:Class;

        [Embed(source="../../../assets/gAssetManager/IconMailOutbox.png")]
        private static const IconMailOutbox:Class;

        [Embed(source="../../../assets/gAssetManager/IconMailWrite.png")]
        private static const IconMailWrite:Class;

        [Embed(source="../../../assets/gAssetManager/IconMailReply.png")]
        private static const IconMailReply:Class;

        [Embed(source="../../../assets/gAssetManager/IconMailTypeMail.png")]
        private static const IconMailTypeMail:Class;

        [Embed(source="../../../assets/gAssetManager/IconMailTypeMailRead.png")]
        private static const IconMailTypeMailRead:Class;

        [Embed(source="../../../assets/gAssetManager/IconMailTypeNPC.png")]
        private static const IconMailTypeNPC:Class;

        [Embed(source="../../../assets/gAssetManager/IconMailTypeGuild.png")]
        private static const IconMailTypeGuild:Class;

        [Embed(source="../../../assets/gAssetManager/IconMailTypeTrade.png")]
        private static const IconMailTypeTrade:Class;

        [Embed(source="../../../assets/gAssetManager/IconMailTypeFriend.png")]
        private static const IconMailTypeFriend:Class;

        [Embed(source="../../../assets/embedded/mailwindow/mailwindow_icon_find_treasure.png")]
        private static const IconMailTypeLoot:Class;

        [Embed(source="../../../assets/gAssetManager/IconMailTypeBattleReport.png")]
        private static const IconMailTypeBattleReport:Class;

        [Embed(source="../../../assets/gAssetManager/IconMailTypeGift.png")]
        private static const IconMailTypeGift:Class;

        [Embed(source="../../../assets/gAssetManager/IconMailTypeBuffed.png")]
        private static const IconMailTypeBuffed:Class;

        [Embed(source="../../../assets/gAssetManager/IconMailTypeHardCurrency.png")]
        private static const IconMailTypeHardCurrency:Class;

        [Embed(source="../../../assets/gAssetManager/IconMailTypeAdventureLoot.png")]
        private static const IconMailTypeAdventureLoot:Class;

        [Embed(source="../../../assets/gAssetManager/IconMailContextMenuButton.png")]
        private static const IconMailContextMenuButton:Class;

        [Embed(source="../../../assets/gAssetManager/IconBlockedContextMenuButton.png")]
        private static const IconBlockedContextMenuButton:Class;

        [Embed(source="../../../assets/gAssetManager/BattleSlotBackground.png")]
        private static const BattleSlotBackground:Class;

        [Embed(source="../../../assets/gAssetManager/BattleSlotHighlightAttacker.png")]
        private static const BattleSlotHighlightAttacker:Class;

        [Embed(source="../../../assets/gAssetManager/BattleSlotHighlightDefender.png")]
        private static const BattleSlotHighlightDefender:Class;

        [Embed(source="../../../assets/gAssetManager/BattlePlayerColor01.png")]
        private static const BattlePlayerColor01:Class;

        [Embed(source="../../../assets/gAssetManager/BattlePlayerColor02.png")]
        private static const BattlePlayerColor02:Class;

        [Embed(source="../../../assets/gAssetManager/BattlePlayerColor03.png")]
        private static const BattlePlayerColor03:Class;

        [Embed(source="../../../assets/gAssetManager/BattlePlayerColor04.png")]
        private static const BattlePlayerColor04:Class;

        [Embed(source="../../../assets/gAssetManager/BattlePlayerColor05.png")]
        private static const BattlePlayerColor05:Class;

        [Embed(source="../../../assets/gAssetManager/BattlePlayerColor06.png")]
        private static const BattlePlayerColor06:Class;

        [Embed(source="../../../assets/gAssetManager/BattlePlayerColor07.png")]
        private static const BattlePlayerColor07:Class;

        [Embed(source="../../../assets/gAssetManager/BattlePlayerColor08.png")]
        private static const BattlePlayerColor08:Class;

        [Embed(source="../../../assets/gAssetManager/BattlePlayerColor09.png")]
        private static const BattlePlayerColor09:Class;

        [Embed(source="../../../assets/gAssetManager/BattlePlayerColor10.png")]
        private static const BattlePlayerColor10:Class;

        [Embed(source="../../../assets/gAssetManager/BattlePlayerColor11.png")]
        private static const BattlePlayerColor11:Class;

        [Embed(source="../../../assets/gAssetManager/BattlePlayerColor12.png")]
        private static const BattlePlayerColor12:Class;

        [Embed(source="../../../assets/gAssetManager/BattlePlayerColor13.png")]
        private static const BattlePlayerColor13:Class;

        [Embed(source="../../../assets/gAssetManager/BattlePlayerColor14.png")]
        private static const BattlePlayerColor14:Class;

        [Embed(source="../../../assets/gAssetManager/IconQuest.png")]
        private static const IconQuest:Class;

        [Embed(source="../../../assets/gAssetManager/IconQuestHighlight.png")]
        private static const IconQuestHighlight:Class;

        [Embed(source="../../../assets/gAssetManager/QuestAdvisor.png")]
        private static const QuestAdvisor:Class;

        [Embed(source="../../../assets/gAssetManager/QuestAdvisorMedium.png")]
        private static const QuestAdvisorMedium:Class;

        [Embed(source="../../../assets/gAssetManager/QuestAdvisorSmall.png")]
        private static const QuestAdvisorSmall:Class;

        [Embed(source="../../../assets/gAssetManager/DailyLoginFailed.png")]
        private static const DailyLoginFailed:Class;

        [Embed(source="../../../assets/gAssetManager/DailyLoginQuestionMark.png")]
        private static const DailyLoginQuestionMark:Class;

        [Embed(source="../../../assets/gAssetManager/DailyLoginPassed.png")]
        private static const DailyLoginPassed:Class;

        [Embed(source="../../../assets/gAssetManager/ChangeLogIcon.png")]
        private static const ChangeLogIcon:Class;

        [Embed(source="../../../assets/gAssetManager/AdventureQuality1.png")]
        private static const AdventureQuality1:Class;

        [Embed(source="../../../assets/gAssetManager/AdventureQuality2.png")]
        private static const AdventureQuality2:Class;

        [Embed(source="../../../assets/gAssetManager/AdventureQuality3.png")]
        private static const AdventureQuality3:Class;

        [Embed(source="../../../assets/gAssetManager/AdventureQuality4.png")]
        private static const AdventureQuality4:Class;

        [Embed(source="../../../assets/gAssetManager/AdventureAvatarDefault.png")]
        private static const AdventureAvatarDefault:Class;

        [Embed(source="../../../assets/vector/gAssetManager/QuestItemBgNormal.swf", symbol="GUI.Assets.gAssetManager_QuestItemBgNormal")]
        private static const QuestItemBgNormal:Class;

        [Embed(source="../../../assets/vector/gAssetManager/QuestItemBgSelected.swf", symbol="GUI.Assets.gAssetManager_QuestItemBgSelected")]
        private static const QuestItemBgSelected:Class;

        [Embed(source="../../../assets/vector/gAssetManager/QuestItemBgWon.swf", symbol="GUI.Assets.gAssetManager_QuestItemBgWon")]
        private static const QuestItemBgWon:Class;

        [Embed(source="../../../assets/vector/gAssetManager/QuestItemBgWonSelected.swf", symbol="GUI.Assets.gAssetManager_QuestItemBgWonSelected")]
        private static const QuestItemBgWonSelected:Class;

        [Embed(source="../../../assets/vector/gAssetManager/QuestItemBgFail.swf", symbol="GUI.Assets.gAssetManager_QuestItemBgFail")]
        private static const QuestItemBgFail:Class;

        [Embed(source="../../../assets/vector/gAssetManager/QuestItemBgFailSelected.swf", symbol="GUI.Assets.gAssetManager_QuestItemBgFailSelected")]
        private static const QuestItemBgFailSelected:Class;

        [Embed(source="../../../assets/vector/gAssetManager/QuestItemBgHead.swf", symbol="GUI.Assets.gAssetManager_QuestItemBgHead")]
        private static const QuestItemBgHead:Class;

        [Embed(source="../../../assets/vector/gAssetManager/QuestItemBgHeadSelected.swf", symbol="GUI.Assets.gAssetManager_QuestItemBgHeadSelected")]
        private static const QuestItemBgHeadSelected:Class;

        [Embed(source="../../../assets/vector/gAssetManager/QuestItemBg.swf", symbol="GUI.Assets.gAssetManager_QuestItemBg")]
        private static const QuestItemBg:Class;

        [Embed(source="../../../assets/vector/gAssetManager/TrackedQuestBackground.swf", symbol="GUI.Assets.gAssetManager_TrackedQuestBackground")]
        private static const TrackedQuestBackground:Class;

        [Embed(source="../../../assets/vector/gAssetManager/EventWidgetBackground.swf", symbol="GUI.Assets.gAssetManager_EventWidgetBackground")]
        private static const EventWidgetBackground:Class;

        [Embed(source="../../../assets/vector/gAssetManager/TrackedAdventureBackground.swf", symbol="GUI.Assets.gAssetManager_TrackedAdventureBackground")]
        private static const TrackedAdventureBackground:Class;

        [Embed(source="../../../assets/vector/gAssetManager/ExpeditionBackgroundActive.swf", symbol="GUI.Assets.gAssetManager_ExpeditionBackgroundActive")]
        private static const ExpeditionBackgroundActive:Class;

        [Embed(source="../../../assets/vector/gAssetManager/ExpeditionBackgroundInactive.swf", symbol="GUI.Assets.gAssetManager_ExpeditionBackgroundInactive")]
        private static const ExpeditionBackgroundInactive:Class;

        [Embed(source="../../../assets/vector/gAssetManager/ExpeditionBackgroundFrame.swf", symbol="GUI.Assets.gAssetManager_ExpeditionBackgroundFrame")]
        private static const ExpeditionBackgroundFrame:Class;

        [Embed(source="../../../assets/vector/gAssetManager/ExpeditionBackgroundNormal.swf", symbol="GUI.Assets.gAssetManager_ExpeditionBackgroundNormal")]
        private static const ExpeditionBackgroundNormal:Class;

        [Embed(source="../../../assets/vector/gAssetManager/ExpeditionPvEBackgroundNormal.swf", symbol="GUI.Assets.gAssetManager_ExpeditionPvEBackgroundNormal")]
        private static const ExpeditionPvEBackgroundNormal:Class;

        [Embed(source="../../../assets/vector/gAssetManager/ExpeditionPvEBackgroundHighlight.swf", symbol="GUI.Assets.gAssetManager_ExpeditionPvEBackgroundHighlight")]
        private static const ExpeditionPvEBackgroundHighlight:Class;

        [Embed(source="../../../assets/vector/gAssetManager/ExpeditionPvPBackgroundNormal.swf", symbol="GUI.Assets.gAssetManager_ExpeditionPvPBackgroundNormal")]
        private static const ExpeditionPvPBackgroundNormal:Class;

        [Embed(source="../../../assets/vector/gAssetManager/ExpeditionPvPBackgroundHighlight.swf", symbol="GUI.Assets.gAssetManager_ExpeditionPvPBackgroundHighlight")]
        private static const ExpeditionPvPBackgroundHighlight:Class;

        [Embed(source="../../../assets/gAssetManager/ExpeditionItemBackground.png")]
        private static const ExpeditionItemBackground:Class;

        [Embed(source="../../../assets/gAssetManager/ExpeditionPvEItemBackground.png")]
        private static const ExpeditionPvEItemBackground:Class;

        [Embed(source="../../../assets/gAssetManager/ExpeditionPvPItemBackground.png")]
        private static const ExpeditionPvPItemBackground:Class;

        [Embed(source="../../../assets/gAssetManager/ExpeditionPvPOrnamentTop.png")]
        private static const ExpeditionPvPOrnamentTop:Class;

        [Embed(source="../../../assets/gAssetManager/ExpeditionStateExplore.png")]
        private static const ExpeditionStateExplore:Class;

        [Embed(source="../../../assets/gAssetManager/ExpeditionStateFighting.png")]
        private static const ExpeditionStateFighting:Class;

        [Embed(source="../../../assets/gAssetManager/ExpeditionStateDefense.png")]
        private static const ExpeditionStateDefense:Class;

        [Embed(source="../../../assets/gAssetManager/ExpeditionStateAttention.png")]
        private static const ExpeditionStateAttention:Class;

        [Embed(source="../../../assets/gAssetManager/ExpeditionStateWorking.png")]
        private static const ExpeditionStateWorking:Class;

        [Embed(source="../../../assets/gAssetManager/QuestLocked.png")]
        private static const QuestLocked:Class;

        [Embed(source="../../../assets/gAssetManager/QuestUnlocked.png")]
        private static const QuestUnlocked:Class;

        [Embed(source="../../../assets/vector/gAssetManager/QuestBgWon.swf", symbol="GUI.Assets.gAssetManager_QuestBgWon")]
        private static const QuestBgWon:Class;

        [Embed(source="../../../assets/vector/gAssetManager/TriggerBGGrey.swf", symbol="GUI.Assets.gAssetManager_TriggerBGGrey")]
        private static const TriggerBGGrey:Class;

        [Embed(source="../../../assets/vector/gAssetManager/TriggerBGNormal.swf", symbol="GUI.Assets.gAssetManager_TriggerBGNormal")]
        private static const TriggerBGNormal:Class;

        [Embed(source="../../../assets/vector/gAssetManager/TriggerBGWon.swf", symbol="GUI.Assets.gAssetManager_TriggerBGWon")]
        private static const TriggerBGWon:Class;

        [Embed(source="../../../assets/vector/gAssetManager/TriggerBGFail.swf", symbol="GUI.Assets.gAssetManager_TriggerBGFail")]
        private static const TriggerBGFail:Class;

        [Embed(source="../../../assets/gAssetManager/ColonyBuffYield.png")]
        private static const ColonyBuffYield:Class;

        [Embed(source="../../../assets/gAssetManager/ColonyBuffResourcePool.png")]
        private static const ColonyBuffResourcePool:Class;

        [Embed(source="../../../assets/gAssetManager/ColonyBuffBanner.png")]
        private static const ColonyBuffBanner:Class;

        [Embed(source="../../../assets/vector/gAssetManager/AchievementListBg.swf", symbol="GUI.Assets.gAssetManager_AchievementListBg")]
        private static const AchievementListBg:Class;

        [Embed(source="../../../assets/gAssetManager/AchievementDetailHeaderAvatarBackground.jpg")]
        private static const AchievementDetailHeaderAvatarBackground:Class;

        [Embed(source="../../../assets/vector/gAssetManager/AchievementDetailHeaderBackground.swf", symbol="GUI.Assets.gAssetManager_AchievementDetailHeaderBackground")]
        private static const AchievementDetailHeaderBackground:Class;

        [Embed(source="../../../assets/vector/gAssetManager/AchievementDetailHeaderCategoryBackground.swf", symbol="GUI.Assets.gAssetManager_AchievementDetailHeaderCategoryBackground")]
        private static const AchievementDetailHeaderCategoryBackground:Class;

        [Embed(source="../../../assets/gAssetManager/AchievementDetailHeaderRing.png")]
        private static const AchievementDetailHeaderRing:Class;

        [Embed(source="../../../assets/gAssetManager/AchievementDetailHeaderRingSimple.png")]
        private static const AchievementDetailHeaderRingSimple:Class;

        [Embed(source="../../../assets/vector/gAssetManager/AchievementCategoryHeaderProgressBackground.swf", symbol="GUI.Assets.gAssetManager_AchievementCategoryHeaderProgressBackground")]
        private static const AchievementCategoryHeaderProgressBackground:Class;

        [Embed(source="../../../assets/gAssetManager/AchievementCategoryHeaderProgressBar.jpg")]
        private static const AchievementCategoryHeaderProgressBar:Class;

        [Embed(source="../../../assets/vector/gAssetManager/AchievementCategoryProgressBackground.swf", symbol="GUI.Assets.gAssetManager_AchievementCategoryProgressBackground")]
        private static const AchievementCategoryProgressBackground:Class;

        [Embed(source="../../../assets/vector/gAssetManager/AchievementCategoryProgressBar.swf", symbol="GUI.Assets.gAssetManager_AchievementCategoryProgressBar")]
        private static const AchievementCategoryProgressBar:Class;

        [Embed(source="../../../assets/vector/gAssetManager/AchievementCategoryBackground.swf", symbol="GUI.Assets.gAssetManager_AchievementCategoryBackground")]
        private static const AchievementCategoryBackground:Class;

        [Embed(source="../../../assets/vector/gAssetManager/AchievementCategoryEventBackground.swf", symbol="GUI.Assets.gAssetManager_AchievementCategoryEventBackground")]
        private static const AchievementCategoryEventBackground:Class;

        [Embed(source="../../../assets/gAssetManager/AchievementCategoryRing.png")]
        private static const AchievementCategoryRing:Class;

        [Embed(source="../../../assets/gAssetManager/AchievementCategoryRingFinished.png")]
        private static const AchievementCategoryRingFinished:Class;

        [Embed(source="../../../assets/gAssetManager/AchievementIconNormalBackground.png")]
        private static const AchievementIconNormalBackground:Class;

        [Embed(source="../../../assets/gAssetManager/AchievementIconFinishedBackground.png")]
        private static const AchievementIconFinishedBackground:Class;

        [Embed(source="../../../assets/vector/gAssetManager/AchievementCurrentUserBackground.swf", symbol="GUI.Assets.gAssetManager_AchievementCurrentUserBackground")]
        private static const AchievementCurrentUserBackground:Class;

        [Embed(source="../../../assets/vector/gAssetManager/AchievementComparedUserBackground.swf", symbol="GUI.Assets.gAssetManager_AchievementComparedUserBackground")]
        private static const AchievementComparedUserBackground:Class;

        [Embed(source="../../../assets/vector/gAssetManager/AchievementTriggerProgressBackgroundProgressBar.swf", symbol="GUI.Assets.gAssetManager_AchievementTriggerProgressBackgroundProgressBar")]
        private static const AchievementTriggerProgressBackgroundProgressBar:Class;

        [Embed(source="../../../assets/vector/gAssetManager/AchievementTriggerProgressBar.swf", symbol="GUI.Assets.gAssetManager_AchievementTriggerProgressBar")]
        private static const AchievementTriggerProgressBar:Class;

        [Embed(source="../../../assets/vector/gAssetManager/AchievementRewardBoxBackground.swf", symbol="GUI.Assets.gAssetManager_AchievementRewardBoxBackground")]
        private static const AchievementRewardBoxBackground:Class;

        [Embed(source="../../../assets/vector/gAssetManager/AchievementTriggerProgressBackground.swf", symbol="GUI.Assets.gAssetManager_AchievementTriggerProgressBackground")]
        private static const AchievementTriggerProgressBackground:Class;

        [Embed(source="../../../assets/vector/gAssetManager/AchievementTriggerCheckboxBackground.swf", symbol="GUI.Assets.gAssetManager_AchievementTriggerCheckboxBackground")]
        private static const AchievementTriggerCheckboxBackground:Class;

        [Embed(source="../../../assets/gAssetManager/ButtonIconOK.png")]
        private static const AchievementTriggerCheckboxCheckedIcon:Class;

        [Embed(source="../../../assets/gAssetManager/AchievementsCompletedAvatarMessageIcon.png")]
        private static const AchievementsCompletedAvatarMessageIcon:Class;

        [Embed(source="../../../assets/gAssetManager/AchievementCompletedCheckedIcon.png")]
        private static const AchievementCompletedCheckedIcon:Class;

        [Embed(source="../../../assets/vector/gAssetManager/EconomyResourceListBGNormal.swf", symbol="GUI.Assets.gAssetManager_EconomyResourceListBGNormal")]
        private static const EconomyResourceListBGNormal:Class;

        [Embed(source="../../../assets/vector/gAssetManager/EconomyResourceListBGOver.swf", symbol="GUI.Assets.gAssetManager_EconomyResourceListBGOver")]
        private static const EconomyResourceListBGOver:Class;

        [Embed(source="../../../assets/gAssetManager/ResourceListItemGreen.png")]
        private static const ResourceListItemGreen:Class;

        [Embed(source="../../../assets/gAssetManager/ResourceListItemGrey.png")]
        private static const ResourceListItemGrey:Class;

        [Embed(source="../../../assets/gAssetManager/ResourceListItemRed.png")]
        private static const ResourceListItemRed:Class;

        [Embed(source="../../../assets/gAssetManager/ResourceListItemYellow.png")]
        private static const ResourceListItemYellow:Class;

        [Embed(source="../../../assets/gAssetManager/MaxResourceArrow.png")]
        private static const MaxResourceArrow:Class;

        [Embed(source="../../../assets/gAssetManager/BuildingLevelIndicator1.png")]
        private static const BuildingLevelIndicator1:Class;

        [Embed(source="../../../assets/gAssetManager/BuildingLevelIndicator2.png")]
        private static const BuildingLevelIndicator2:Class;

        [Embed(source="../../../assets/gAssetManager/BuildingLevelIndicator3.png")]
        private static const BuildingLevelIndicator3:Class;

        [Embed(source="../../../assets/gAssetManager/BuildingLevelIndicator4.png")]
        private static const BuildingLevelIndicator4:Class;

        [Embed(source="../../../assets/gAssetManager/BuildingLevelIndicator5.png")]
        private static const BuildingLevelIndicator5:Class;

        [Embed(source="../../../assets/gAssetManager/BuildingLevelIndicator6.png")]
        private static const BuildingLevelIndicator6:Class;

        [Embed(source="../../../assets/gAssetManager/BuildingLevelIndicator7.png")]
        private static const BuildingLevelIndicator7:Class;

        [Embed(source="../../../assets/gAssetManager/BuffStarIndicator1.png")]
        private static const BuffStarIndicator1:Class;

        [Embed(source="../../../assets/gAssetManager/BuffStarIndicator2.png")]
        private static const BuffStarIndicator2:Class;

        [Embed(source="../../../assets/gAssetManager/TreeArrow1.png")]
        private static const TreeArrow1:Class;

        [Embed(source="../../../assets/gAssetManager/TreeArrow2.png")]
        private static const TreeArrow2:Class;

        [Embed(source="../../../assets/gAssetManager/TreeArrow3.png")]
        private static const TreeArrow3:Class;

        [Embed(source="../../../assets/gAssetManager/BuildingSleepMode.png")]
        private static const BuildingSleepMode:Class;

        [Embed(source="../../../assets/gAssetManager/BuildingNoResourceMode.png")]
        private static const BuildingNoResourceMode:Class;

        [Embed(source="../../../assets/gAssetManager/BuildingNoSettlerMode.png")]
        private static const BuildingNoSettlerMode:Class;

        [Embed(source="../../../assets/gAssetManager/BuildingWareHouseFullMode.png")]
        private static const BuildingWareHouseFullMode:Class;

        [Embed(source="../../../assets/gAssetManager/EconomyHighArrow.png")]
        private static const EconomyHighArrow:Class;

        [Embed(source="../../../assets/gAssetManager/EconomyNeutralArrow.png")]
        private static const EconomyNeutralArrow:Class;

        [Embed(source="../../../assets/gAssetManager/EconomyLowArrow.png")]
        private static const EconomyLowArrow:Class;

        [Embed(source="../../../assets/gAssetManager/EconomyOverviewIcon.png")]
        private static const EconomyOverviewIcon:Class;

        [Embed(source="../../../assets/gAssetManager/DepositQuestionIcon.png")]
        private static const DepositQuestionIcon:Class;

        [Embed(source="../../../assets/gAssetManager/ColonyWindowIcon.png")]
        private static const ColonyWindowIcon:Class;

        [Embed(source="../../../assets/gAssetManager/ColonyWindowIconHighlight.png")]
        private static const ColonyWindowIconHighlight:Class;

        [Embed(source="../../../assets/gAssetManager/ColonyWindowIconRank1.png")]
        private static const ColonyWindowIconRank1:Class;

        [Embed(source="../../../assets/gAssetManager/ColonyWindowIconRank2.png")]
        private static const ColonyWindowIconRank2:Class;

        [Embed(source="../../../assets/gAssetManager/ColonyWindowIconRank3.png")]
        private static const ColonyWindowIconRank3:Class;

        [Embed(source="../../../assets/gAssetManager/InfoOrnamentalTop1.png")]
        private static const InfoOrnamentalTop1:Class;

        [Embed(source="../../../assets/gAssetManager/StarmenuFrameEmpty.png")]
        private static const StarmenuFrameEmpty:Class;

        [Embed(source="../../../assets/gAssetManager/FrameDailyLogin.png")]
        private static const FrameDailyLogin:Class;

        [Embed(source="../../../assets/gAssetManager/FrameBuffInstant.png")]
        private static const FrameBuffInstant:Class;

        [Embed(source="../../../assets/gAssetManager/FrameBuffTimed.png")]
        private static const FrameBuffTimed:Class;

        [Embed(source="../../../assets/gAssetManager/FrameBuffUpgrade.png")]
        private static const FrameBuffUpgrade:Class;

        [Embed(source="../../../assets/gAssetManager/FrameDailyLoginLast.png")]
        private static const FrameDailyLoginLast:Class;

        [Embed(source="../../../assets/gAssetManager/FrameSpecialist.png")]
        private static const FrameSpecialist:Class;

        [Embed(source="../../../assets/gAssetManager/FrameFancy.png")]
        private static const FrameFancy:Class;

        [Embed(source="../../../assets/gAssetManager/FrameFlatBackGround.png")]
        private static const FrameFlatBackGround:Class;

        [Embed(source="../../../assets/gAssetManager/FrameZoneBuff.png")]
        private static const FrameZoneBuff:Class;

        [Embed(source="../../../assets/gAssetManager/FrameDummy.png")]
        private static const FrameContentGeneratorReward:Class;

        [Embed(source="../../../assets/gAssetManager/FrameDummy.png")]
        private static const FrameDummy:Class;

        [Embed(source="../../../assets/gAssetManager/FramePermanentBuff.png")]
        private static const FramePermanentBuff:Class;

        [Embed(source="../../../assets/gAssetManager/StarMenuIcon.png")]
        private static const StarMenuIcon:Class;

        [Embed(source="../../../assets/gAssetManager/FramePerk.png")]
        private static const FramePerk:Class;

        [Embed(source="../../../assets/gAssetManager/FrameContentGeneratorRewardPopup.png")]
        private static const FrameContentGeneratorRewardPopup:Class;

        [Embed(source="../../../assets/gAssetManager/FrameContentGeneratorRewardPopupJackpot.png")]
        private static const FrameContentGeneratorRewardPopupJackpot:Class;

        [Embed(source="../../../assets/gAssetManager/FrameContentGeneratorRewardPopupMouseOver.png")]
        private static const FrameContentGeneratorRewardPopupMouseOver:Class;

        [Embed(source="../../../assets/gAssetManager/FrameContentGeneratorRewardPopupJackpotMouseOver.png")]
        private static const FrameContentGeneratorRewardPopupJackpotMouseOver:Class;

        [Embed(source="../../../assets/gAssetManager/FrameContentGeneratorResultsJackpot.png")]
        private static const FrameContentGeneratorResultsJackpot:Class;

        [Embed(source="../../../assets/gAssetManager/IconAllGeologists.png")]
        private static const IconAllGeologists:Class;

        [Embed(source="../../../assets/gAssetManager/IconAllExplorers.png")]
        private static const IconAllExplorers:Class;

        [Embed(source="../../../assets/gAssetManager/IconAllGenerals.png")]
        private static const IconAllGenerals:Class;

        [Embed(source="../../../assets/vector/gAssetManager/BuildingMenuBG.swf", symbol="GUI.Assets.gAssetManager_BuildingMenuBG")]
        private static const BuildingMenuBG:Class;

        [Embed(source="../../../assets/vector/gAssetManager/IconBGNormal.swf", symbol="GUI.Assets.gAssetManager_IconBGNormal")]
        private static const IconBGNormal:Class;

        [Embed(source="../../../assets/vector/gAssetManager/IconBGHighlight.swf", symbol="GUI.Assets.gAssetManager_IconBGHighlight")]
        private static const IconBGHighlight:Class;

        [Embed(source="../../../assets/gAssetManager/IconCL1.png")]
        private static const IconCL1:Class;

        [Embed(source="../../../assets/gAssetManager/IconCL2.png")]
        private static const IconCL2:Class;

        [Embed(source="../../../assets/gAssetManager/IconCL3.png")]
        private static const IconCL3:Class;

        [Embed(source="../../../assets/gAssetManager/IconCL4.png")]
        private static const IconCL4:Class;

        [Embed(source="../../../assets/gAssetManager/IconCL5.png")]
        private static const IconCL5:Class;

        [Embed(source="../../../assets/gAssetManager/IconCL5.png")]
        private static const IconDefCamp:Class;

        [Embed(source="../../../assets/gAssetManager/IconCL5.png")]
        private static const IconDefTrap:Class;

        [Embed(source="../../../assets/gAssetManager/IconToolbox.png")]
        private static const IconToolbox:Class;

        [Embed(source="../../../assets/gAssetManager/IconToolboxStar.png")]
        private static const IconToolboxStar:Class;

        [Embed(source="../../../assets/gAssetManager/IconBuildStreet.png")]
        private static const IconBuildStreet:Class;

        [Embed(source="../../../assets/gAssetManager/IconEraseStreet.png")]
        private static const IconEraseStreet:Class;

        [Embed(source="../../../assets/gAssetManager/IconDeleteBuilding.png")]
        private static const IconDeleteBuilding:Class;

        [Embed(source="../../../assets/gAssetManager/IconMoveBuilding.png")]
        private static const IconMoveBuilding:Class;

        [Embed(source="../../../assets/gAssetManager/IconPathPreviewStart.png")]
        private static const IconPathPreviewStart:Class;

        [Embed(source="../../../assets/gAssetManager/IconPathPreviewDelete.png")]
        private static const IconPathPreviewDelete:Class;

        [Embed(source="../../../assets/gAssetManager/StarMenuTabIconAll.png")]
        private static const StarMenuTabIconAll:Class;

        [Embed(source="../../../assets/gAssetManager/StarMenuTabIconSpecialist.png")]
        private static const StarMenuTabIconSpecialist:Class;

        [Embed(source="../../../assets/gAssetManager/StarMenuTabIconResource.png")]
        private static const StarMenuTabIconResource:Class;

        [Embed(source="../../../assets/gAssetManager/StarMenuTabIconBuff.png")]
        private static const StarMenuTabIconBuff:Class;

        [Embed(source="../../../assets/gAssetManager/StarMenuTabIconBuilding.png")]
        private static const StarMenuTabIconBuilding:Class;

        [Embed(source="../../../assets/gAssetManager/ChatTabIconAdventure.png")]
        private static const StarMenuTabIconAdventure:Class;

        [Embed(source="../../../assets/gAssetManager/StarMenuTabIconMisc.png")]
        private static const StarMenuTabIconMisc:Class;

        [Embed(source="../../../assets/vector/gAssetManager/StarMenuComboboxItemUpSkin.swf", symbol="GUI.Assets.gAssetManager_StarMenuComboboxItemUpSkin")]
        private static const StarMenuComboboxItemUpSkin:Class;

        [Embed(source="../../../assets/vector/gAssetManager/StarMenuComboboxItemOverSkin.swf", symbol="GUI.Assets.gAssetManager_StarMenuComboboxItemOverSkin")]
        private static const StarMenuComboboxItemOverSkin:Class;

        [Embed(source="../../../assets/vector/gAssetManager/StarMenuComboboxItemDownSkin.swf", symbol="GUI.Assets.gAssetManager_StarMenuComboboxItemDownSkin")]
        private static const StarMenuComboboxItemDownSkin:Class;

        [Embed(source="../../../assets/gAssetManager/CombatPreview_Perfect.png")]
        private static const CombatPreview_Perfect:Class;

        [Embed(source="../../../assets/gAssetManager/CombatPreview_Ok.png")]
        private static const CombatPreview_Ok:Class;

        [Embed(source="../../../assets/gAssetManager/CombatPreview_Bad.png")]
        private static const CombatPreview_Bad:Class;

        [Embed(source="../../../assets/gAssetManager/CombatPreview_Fail.png")]
        private static const CombatPreview_Fail:Class;

        [Embed(source="../../../assets/gAssetManager/IconSkullWithBG.png")]
        private static const IconSkullWithBG:Class;

        [Embed(source="../../../assets/gAssetManager/IconSkullWithCrown.png")]
        private static const IconSkullWithCrown:Class;

        [Embed(source="../../../assets/gAssetManager/ArrowNext.png")]
        private static const ArrowNext:Class;

        [Embed(source="../../../assets/gAssetManager/Combat3FirstUnitArrow.png")]
        private static const Combat3FirstUnitArrow:Class;

        [Embed(source="../../../assets/gAssetManager/QuestionmarkGold.png")]
        private static const ChangeSlotLoading:Class;

        [Embed(source="../../../assets/gAssetManager/FrameEnemy.png")]
        private static const FrameEnemy:Class;

        [Embed(source="../../../assets/gAssetManager/FrameEnemyToolTip.png")]
        private static const FrameEnemyToolTip:Class;

        [Embed(source="../../../assets/gAssetManager/FrameEnemyToolTipFirst.png")]
        private static const FrameEnemyToolTipFirst:Class;

        [Embed(source="../../../assets/gAssetManager/FrameExpeditionUnitStandard.png")]
        private static const FrameExpeditionUnitStandard:Class;

        [Embed(source="../../../assets/gAssetManager/FrameExpeditionUnitMouseOver.png")]
        private static const FrameExpeditionUnitMouseOver:Class;

        [Embed(source="../../../assets/gAssetManager/FrameExpeditionUnitBareStandard.png")]
        private static const FrameExpeditionUnitBareStandard:Class;

        [Embed(source="../../../assets/gAssetManager/FrameExpeditionUnitBareMouseOver.png")]
        private static const FrameExpeditionUnitBareMouseOver:Class;

        [Embed(source="../../../assets/gAssetManager/FrameInvincibleUnitStandard.png")]
        private static const FrameInvincibleUnitStandard:Class;

        [Embed(source="../../../assets/gAssetManager/AttackSlot.png")]
        private static const AttackSlot:Class;

        [Embed(source="../../../assets/gAssetManager/AttackBonusSlot.png")]
        private static const AttackBonusSlot:Class;

        [Embed(source="../../../assets/gAssetManager/FrameEnemyToolTipDisabled.png")]
        private static const FrameEnemyToolTipDisabled:Class;

        [Embed(source="../../../assets/gAssetManager/BonusToolTip.png")]
        private static const BonusToolTip:Class;

        [Embed(source="../../../assets/gAssetManager/FrameEnemyBoss.png")]
        private static const FrameEnemyBoss:Class;

        [Embed(source="../../../assets/gAssetManager/FrameTier1.png")]
        private static const FrameTier1:Class;

        [Embed(source="../../../assets/gAssetManager/FrameTier2.png")]
        private static const FrameTier2:Class;

        [Embed(source="../../../assets/gAssetManager/FrameTier3.png")]
        private static const FrameTier3:Class;

        [Embed(source="../../../assets/gAssetManager/FrameTier4.png")]
        private static const FrameTier4:Class;

        [Embed(source="../../../assets/gAssetManager/IconBonusCavalry.png")]
        private static const IconBonusCavalry:Class;

        [Embed(source="../../../assets/gAssetManager/IconBonusMelee.png")]
        private static const IconBonusMelee:Class;

        [Embed(source="../../../assets/gAssetManager/IconCombat3BonusRanged.png")]
        private static const IconBonusRanged:Class;

        [Embed(source="../../../assets/gAssetManager/IconCavalry.png")]
        private static const IconCavalry:Class;

        [Embed(source="../../../assets/gAssetManager/IconCavalrySmall.png")]
        private static const IconCavalrySmall:Class;

        [Embed(source="../../../assets/gAssetManager/IconMelee.png")]
        private static const IconMelee:Class;

        [Embed(source="../../../assets/gAssetManager/IconMeleeSmall.png")]
        private static const IconMeleeSmall:Class;

        [Embed(source="../../../assets/gAssetManager/IconMixedSmall.png")]
        private static const IconMixedSmall:Class;

        [Embed(source="../../../assets/gAssetManager/IconRanged.png")]
        private static const IconRanged:Class;

        [Embed(source="../../../assets/gAssetManager/IconRangedSmall.png")]
        private static const IconRangedSmall:Class;

        [Embed(source="../../../assets/gAssetManager/IconMana.png")]
        private static const IconMana:Class;

        [Embed(source="../../../assets/gAssetManager/IconAddSpecialistItem.png")]
        private static const IconAddSpecialistItem:Class;

        [Embed(source="../../../assets/gAssetManager/WinConditionHealthBar7.png")]
        private static const WinConditionHealthBar7:Class;

        [Embed(source="../../../assets/gAssetManager/WinConditionHealthBar6.png")]
        private static const WinConditionHealthBar6:Class;

        [Embed(source="../../../assets/gAssetManager/WinConditionHealthBar5.png")]
        private static const WinConditionHealthBar5:Class;

        [Embed(source="../../../assets/gAssetManager/WinConditionHealthBar4.png")]
        private static const WinConditionHealthBar4:Class;

        [Embed(source="../../../assets/gAssetManager/WinConditionHealthBar3.png")]
        private static const WinConditionHealthBar3:Class;

        [Embed(source="../../../assets/gAssetManager/WinConditionHealthBar2.png")]
        private static const WinConditionHealthBar2:Class;

        [Embed(source="../../../assets/gAssetManager/WinConditionHealthBar1.png")]
        private static const WinConditionHealthBar1:Class;

        [Embed(source="../../../assets/gAssetManager/IconValorPoints.png")]
        private static const IconValorPoints:Class;

        [Embed(source="../../../assets/gAssetManager/IconWaterCastle.png")]
        private static const IconWaterCastle:Class;

        [Embed(source="../../../assets/vector/gAssetManager/QueueBackground.swf", symbol="GUI.Assets.gAssetManager_QueueBackground")]
        private static const QueueBackground:Class;

        [Embed(source="../../../assets/vector/gAssetManager/QueueStdBackground.swf", symbol="GUI.Assets.gAssetManager_QueueStdBackground")]
        private static const QueueStdBackground:Class;

        [Embed(source="../../../assets/vector/gAssetManager/QueuePaidBackground.swf", symbol="GUI.Assets.gAssetManager_QueuePaidBackground")]
        private static const QueuePaidBackground:Class;

        [Embed(source="../../../assets/vector/gAssetManager/QueueEmptyBackground.swf", symbol="GUI.Assets.gAssetManager_QueueEmptyBackground")]
        private static const QueueEmptyBackground:Class;

        [Embed(source="../../../assets/vector/gAssetManager/BackgroundNormal.swf", symbol="GUI.Assets.gAssetManager_BackgroundNormal")]
        private static const BackgroundNormal:Class;

        [Embed(source="../../../assets/vector/gAssetManager/BackgroundHighlight.swf", symbol="GUI.Assets.gAssetManager_BackgroundHighlight")]
        private static const BackgroundHighlight:Class;

        [Embed(source="../../../assets/gAssetManager/IconCombat3CavalrySmall.png")]
        private static const IconCombat3CavalrySmall:Class;

        [Embed(source="../../../assets/gAssetManager/BackgroundCombat3UnitAllocation.png")]
        private static const BackgroundCombat3UnitAllocation:Class;

        [Embed(source="../../../assets/gAssetManager/BackgroundCombat3UnitAllocationMouseOver.png")]
        private static const BackgroundCombat3UnitAllocationMouseOver:Class;

        [Embed(source="../../../assets/gAssetManager/BackgroundCombat3UnitSelection.png")]
        private static const BackgroundCombat3UnitSelection:Class;

        [Embed(source="../../../assets/gAssetManager/BackgroundCombat3UnitSelectionMouseOver.png")]
        private static const BackgroundCombat3UnitSelectionMouseOver:Class;

        [Embed(source="../../../assets/gAssetManager/BackgroundCombat3UnitAllocationAdd.png")]
        private static const BackgroundCombat3UnitAllocationAdd:Class;

        [Embed(source="../../../assets/gAssetManager/AddUnitCombat3UnitSelectionIcon.png")]
        private static const AddUnitCombat3UnitSelectionIcon:Class;

        [Embed(source="../../../assets/gAssetManager/IconCombat3BonusCavalry.png")]
        private static const IconCombat3BonusCavalry:Class;

        [Embed(source="../../../assets/gAssetManager/IconBonusMelee.png")]
        private static const IconCombat3BonusMelee:Class;

        [Embed(source="../../../assets/gAssetManager/IconCombat3BonusRanged.png")]
        private static const IconCombat3BonusRanged:Class;

        [Embed(source="../../../assets/gAssetManager/IconCombat3BonusTank.png")]
        private static const IconCombat3BonusTank:Class;

        [Embed(source="../../../assets/gAssetManager/IconBonusDamagePlayer.png")]
        private static const IconBonusDamagePlayer:Class;

        [Embed(source="../../../assets/gAssetManager/IconBonusDamageNPC.png")]
        private static const IconBonusDamageNPC:Class;

        [Embed(source="../../../assets/gAssetManager/BackgroundSendSpecialistCombat3Standard.png")]
        private static const BackgroundSendSpecialistCombat3Standard:Class;

        [Embed(source="../../../assets/gAssetManager/BackgroundSendSpecialistCombat3Selected.png")]
        private static const BackgroundSendSpecialistCombat3Selected:Class;

        [Embed(source="../../../assets/embedded/checkbox/checkbox_checkbox01_inactive.png")]
        private static const RadioButtonInactive:Class;

        [Embed(source="../../../assets/gAssetManager/CheckMarkYellow.png")]
        private static const CheckMarkYellow:Class;

        [Embed(source="../../../assets/gAssetManager/SwordsIconGeneral.png")]
        private static const SwordsIconGeneral:Class;

        [Embed(source="../../../assets/vector/gAssetManager/ShopItemBackground.swf", symbol="GUI.Assets.gAssetManager_ShopItemBackground")]
        private static const ShopItemBackground:Class;

        [Embed(source="../../../assets/vector/gAssetManager/ShopItemBackgroundHighlight.swf", symbol="GUI.Assets.gAssetManager_ShopItemBackgroundHighlight")]
        private static const ShopItemBackgroundHighlight:Class;

        [Embed(source="../../../assets/vector/gAssetManager/AvatarMessageRed.swf", symbol="GUI.Assets.gAssetManager_AvatarMessageRed")]
        private static const AvatarMessageRed:Class;

        [Embed(source="../../../assets/vector/gAssetManager/AvatarMessageAchievement.swf", symbol="GUI.Assets.gAssetManager_AvatarMessageAchievement")]
        private static const AvatarMessageAchievement:Class;

        [Embed(source="../../../assets/vector/gAssetManager/AvatarMessageAchievementHighlight.swf", symbol="GUI.Assets.gAssetManager_AvatarMessageAchievementHighlight")]
        private static const AvatarMessageAchievementHighlight:Class;

        [Embed(source="../../../assets/vector/gAssetManager/AvatarMessageRedHighlight.swf", symbol="GUI.Assets.gAssetManager_AvatarMessageRedHighlight")]
        private static const AvatarMessageRedHighlight:Class;

        [Embed(source="../../../assets/vector/gAssetManager/BuildQueueExtensionBar.swf", symbol="GUI.Assets.gAssetManager_BuildQueueExtensionBar")]
        private static const BuildQueueExtensionBar:Class;

        [Embed(source="../../../assets/gAssetManager/BuildQueueResourceMissing.png")]
        private static const BuildQueueResourceMissing:Class;

        [Embed(source="../../../assets/gAssetManager/BuildQueueTempSlotTimeLeftIcon.png")]
        private static const BuildQueueTempSlotTimeLeftIcon:Class;

        [Embed(source="../../../assets/gAssetManager/BuyTempSlot.png")]
        private static const BuyTempSlot:Class;

        [Embed(source="../../../assets/gAssetManager/NewsOrnamentalTop.png")]
        private static const NewsOrnamentalTop:Class;

        [Embed(source="../../../assets/gAssetManager/HelpOrnamentalTop.png")]
        private static const HelpOrnamentalTop:Class;

        [Embed(source="../../../assets/vector/gAssetManager/ChatTabNormal.swf", symbol="GUI.Assets.gAssetManager_ChatTabNormal")]
        private static const ChatTabNormal:Class;

        [Embed(source="../../../assets/vector/gAssetManager/ChatTabSelected.swf", symbol="GUI.Assets.gAssetManager_ChatTabSelected")]
        private static const ChatTabSelected:Class;

        [Embed(source="../../../assets/vector/gAssetManager/ChatTabHighlight.swf", symbol="GUI.Assets.gAssetManager_ChatTabHighlight")]
        private static const ChatTabHighlight:Class;

        [Embed(source="../../../assets/vector/gAssetManager/ChatTab.swf", symbol="GUI.Assets.gAssetManager_ChatTab")]
        private static const ChatTab:Class;

        [Embed(source="../../../assets/vector/gAssetManager/ChatTabMinimized.swf", symbol="GUI.Assets.gAssetManager_ChatTabMinimized")]
        private static const ChatTabMinimized:Class;

        [Embed(source="../../../assets/gAssetManager/ActionBarIcon01.png")]
        private static const ActionBarIcon01:Class;

        [Embed(source="../../../assets/gAssetManager/ActionBarIcon01Highlight.png")]
        private static const ActionBarIcon01Highlight:Class;

        [Embed(source="../../../assets/gAssetManager/ActionBarIcon01Deactivated.png")]
        private static const ActionBarIcon01Deactivated:Class;

        [Embed(source="../../../assets/gAssetManager/ActionBarIcon02.png")]
        private static const ActionBarIcon02:Class;

        [Embed(source="../../../assets/gAssetManager/ActionBarIcon02Highlight.png")]
        private static const ActionBarIcon02Highlight:Class;

        [Embed(source="../../../assets/gAssetManager/ActionBarIcon02Deactivated.png")]
        private static const ActionBarIcon02Deactivated:Class;

        [Embed(source="../../../assets/gAssetManager/ActionBarIcon03.png")]
        private static const ActionBarIcon03:Class;

        [Embed(source="../../../assets/gAssetManager/ActionBarIcon03Highlight.png")]
        private static const ActionBarIcon03Highlight:Class;

        [Embed(source="../../../assets/gAssetManager/ActionBarIcon03Deactivated.png")]
        private static const ActionBarIcon03Deactivated:Class;

        [Embed(source="../../../assets/gAssetManager/ActionBarIcon04.png")]
        private static const ActionBarIcon04:Class;

        [Embed(source="../../../assets/gAssetManager/ActionBarIcon04Highlight.png")]
        private static const ActionBarIcon04Highlight:Class;

        [Embed(source="../../../assets/gAssetManager/ActionBarIcon04Deactivated.png")]
        private static const ActionBarIcon04Deactivated:Class;

        [Embed(source="../../../assets/gAssetManager/ActionBarIcon05.png")]
        private static const ActionBarIcon05:Class;

        [Embed(source="../../../assets/gAssetManager/ActionBarIcon05Highlight.png")]
        private static const ActionBarIcon05Highlight:Class;

        [Embed(source="../../../assets/gAssetManager/ActionBarIcon05Deactivated.png")]
        private static const ActionBarIcon05Deactivated:Class;

        [Embed(source="../../../assets/gAssetManager/ActionBarIcon06.png")]
        private static const ActionBarIcon06:Class;

        [Embed(source="../../../assets/gAssetManager/ActionBarIcon06Highlight.png")]
        private static const ActionBarIcon06Highlight:Class;

        [Embed(source="../../../assets/gAssetManager/ActionBarIcon06Deactivated.png")]
        private static const ActionBarIcon06Deactivated:Class;

        [Embed(source="../../../assets/gAssetManager/ActionBarIcon07.png")]
        private static const ActionBarIcon07:Class;

        [Embed(source="../../../assets/gAssetManager/ActionBarIcon07Highlight.png")]
        private static const ActionBarIcon07Highlight:Class;

        [Embed(source="../../../assets/gAssetManager/ActionBarIcon07Deactivated.png")]
        private static const ActionBarIcon07Deactivated:Class;

        [Embed(source="../../../assets/gAssetManager/ActionBarIcon08.png")]
        private static const ActionBarIcon08:Class;

        [Embed(source="../../../assets/gAssetManager/ActionBarIcon08Highlight.png")]
        private static const ActionBarIcon08Highlight:Class;

        [Embed(source="../../../assets/gAssetManager/ActionBarIcon08Deactivated.png")]
        private static const ActionBarIcon08Deactivated:Class;

        [Embed(source="../../../assets/gAssetManager/ActionBarIcon09.png")]
        private static const ActionBarIcon09:Class;

        [Embed(source="../../../assets/gAssetManager/ActionBarIcon09Highlight.png")]
        private static const ActionBarIcon09Highlight:Class;

        [Embed(source="../../../assets/gAssetManager/ActionBarIcon09Deactivated.png")]
        private static const ActionBarIcon09Deactivated:Class;

        [Embed(source="../../../assets/vector/gAssetManager/TooltipBackgroundRed.swf", symbol="GUI.Assets.gAssetManager_TooltipBackgroundRed")]
        private static const TooltipBackgroundRed:Class;

        [Embed(source="../../../assets/vector/gAssetManager/TooltipBackgroundBlue.swf", symbol="GUI.Assets.gAssetManager_TooltipBackgroundBlue")]
        private static const TooltipBackgroundBlue:Class;

        [Embed(source="../../../assets/vector/gAssetManager/TooltipBackgroundGreen.swf", symbol="GUI.Assets.gAssetManager_TooltipBackgroundGreen")]
        private static const TooltipBackgroundGreen:Class;

        [Embed(source="../../../assets/vector/gAssetManager/TooltipFrame.swf", symbol="GUI.Assets.gAssetManager_TooltipFrame")]
        private static const TooltipFrame:Class;

        [Embed(source="../../../assets/gAssetManager/ExpeditionStateAttention.png")]
        private static const IconToolTipWarning:Class;

        [Embed(source="../../../assets/vector/gAssetManager/ButtonNormal.swf", symbol="GUI.Assets.gAssetManager_ButtonNormal")]
        private static const ButtonNormal:Class;

        [Embed(source="../../../assets/vector/gAssetManager/ButtonHighlight.swf", symbol="GUI.Assets.gAssetManager_ButtonHighlight")]
        private static const ButtonHighlight:Class;

        [Embed(source="../../../assets/gAssetManager/ButtonNormalSmall.png")]
        private static const ButtonNormalSmall:Class;

        [Embed(source="../../../assets/gAssetManager/ButtonHighlightSmall.png")]
        private static const ButtonHighlightSmall:Class;

        [Embed(source="../../../assets/gAssetManager/ButtonIconHalfTheTime.png")]
        private static const ButtonIconHalfTheTime:Class;

        [Embed(source="../../../assets/gAssetManager/ButtonIconInstant.png")]
        private static const ButtonIconInstant:Class;

        [Embed(source="../../../assets/gAssetManager/ButtonIconNewMail.png")]
        private static const ButtonIconNewMail:Class;

        [Embed(source="../../../assets/gAssetManager/ButtonIconHardCurrency.png")]
        private static const ButtonIconHardCurrency:Class;

        [Embed(source="../../../assets/gAssetManager/ButtonNormalIconHardCurrency.png")]
        private static const ButtonNormalIconHardCurrency:Class;

        [Embed(source="../../../assets/gAssetManager/ButtonIconStart.png")]
        private static const ButtonIconStart:Class;

        [Embed(source="../../../assets/gAssetManager/ButtonIconStop.png")]
        private static const ButtonIconStop:Class;

        [Embed(source="../../../assets/gAssetManager/ButtonIconPay.png")]
        private static const ButtonIconPay:Class;

        [Embed(source="../../../assets/gAssetManager/ButtonIconAbort.png")]
        private static const ButtonIconAbort:Class;

        [Embed(source="../../../assets/gAssetManager/ButtonIconThrowAway.png")]
        private static const ButtonIconThrowAway:Class;

        [Embed(source="../../../assets/gAssetManager/ButtonIconOK.png")]
        private static const ButtonIconOK:Class;

        [Embed(source="../../../assets/gAssetManager/RefreshTradeIcon.png")]
        private static const ButtonIconReload:Class;

        [Embed(source="../../../assets/gAssetManager/ButtonIconDiplomacy.png")]
        private static const ButtonIconDiplomacy:Class;

        [Embed(source="../../../assets/gAssetManager/ButtonIconTrade.png")]
        private static const ButtonIconTrade:Class;

        [Embed(source="../../../assets/gAssetManager/ButtonIconMagnifier.png")]
        private static const ButtonIconMagnifier:Class;

        [Embed(source="../../../assets/gAssetManager/ButtonIconFlag.png")]
        private static const ButtonIconFlag:Class;

        [Embed(source="../../../assets/gAssetManager/ButtonIconTrumpet.png")]
        private static const ButtonIconTrumpet:Class;

        [Embed(source="../../../assets/gAssetManager/ButtonIconUnitSwitchToNew.png")]
        private static const ButtonIconUnitSwitchToNew:Class;

        [Embed(source="../../../assets/gAssetManager/ButtonIconUnitSwitchToOld.png")]
        private static const ButtonIconUnitSwitchToOld:Class;

        [Embed(source="../../../assets/gAssetManager/ButtonIconSwords.png")]
        private static const ButtonIconSwords:Class;

        [Embed(source="../../../assets/gAssetManager/ButtonIconBattleTest.png")]
        private static const ButtonIconBattleTest:Class;

        [Embed(source="../../../assets/gAssetManager/ButtonIconSendToOtherZone.png")]
        private static const ButtonIconSendToOtherZone:Class;

        [Embed(source="../../../assets/gAssetManager/ButtonIconExploreSector.png")]
        private static const ButtonIconExploreSector:Class;

        [Embed(source="../../../assets/gAssetManager/ButtonIconExploreFarSector.png")]
        private static const ButtonIconExploreFarSector:Class;

        [Embed(source="../../../assets/gAssetManager/ButtonIconTaskShort.png")]
        private static const ButtonIconTaskShort:Class;

        [Embed(source="../../../assets/gAssetManager/ButtonIconTaskMedium.png")]
        private static const ButtonIconTaskMedium:Class;

        [Embed(source="../../../assets/gAssetManager/ButtonIconTaskLong.png")]
        private static const ButtonIconTaskLong:Class;

        [Embed(source="../../../assets/gAssetManager/ButtonIconTaskEvenLonger.png")]
        private static const ButtonIconTaskEvenLonger:Class;

        [Embed(source="../../../assets/gAssetManager/ButtonIconTaskLongest.png")]
        private static const ButtonIconTaskLongest:Class;

        [Embed(source="../../../assets/gAssetManager/ButtonIconFindTreasure.png")]
        private static const ButtonIconFindTreasure:Class;

        [Embed(source="../../../assets/gAssetManager/ButtonIconFindAdventure.png")]
        private static const ButtonIconFindAdventure:Class;

        [Embed(source="../../../assets/gAssetManager/ButtonIconFindWildZone.png")]
        private static const ButtonIconFindWildZone:Class;

        [Embed(source="../../../assets/gAssetManager/ButtonIconBronze.png")]
        private static const ButtonIconBronze:Class;

        [Embed(source="../../../assets/gAssetManager/ButtonIconIron.png")]
        private static const ButtonIconIron:Class;

        [Embed(source="../../../assets/gAssetManager/ButtonIconGold.png")]
        private static const ButtonIconGold:Class;

        [Embed(source="../../../assets/gAssetManager/ButtonIconCoal.png")]
        private static const ButtonIconCoal:Class;

        [Embed(source="../../../assets/gAssetManager/ButtonIconStone.png")]
        private static const ButtonIconStone:Class;

        [Embed(source="../../../assets/gAssetManager/ButtonIconTitanium.png")]
        private static const ButtonIconTitanium:Class;

        [Embed(source="../../../assets/gAssetManager/ButtonIconGranite.png")]
        private static const ButtonIconGranite:Class;

        [Embed(source="../../../assets/gAssetManager/ButtonIconMarble.png")]
        private static const ButtonIconMarble:Class;

        [Embed(source="../../../assets/gAssetManager/ButtonIconSalpeter.png")]
        private static const ButtonIconSalpeter:Class;

        [Embed(source="../../../assets/gAssetManager/ButtonIconGift.png")]
        private static const ButtonIconGift:Class;

        [Embed(source="../../../assets/gAssetManager/ButtonIconUpgrade.png")]
        private static const ButtonIconUpgrade:Class;

        [Embed(source="../../../assets/gAssetManager/ButtonIconUpgradeGems.png")]
        private static const ButtonIconUpgradeGems:Class;

        [Embed(source="../../../assets/gAssetManager/icon_go_link.png")]
        private static const ButtonArrowGreenRight:Class;

        [Embed(source="../../../assets/gAssetManager/ButtonIconTools.png")]
        private static const ButtonIconTools:Class;

        [Embed(source="../../../assets/gAssetManager/ButtonIconBomb.png")]
        private static const ButtonIconBomb:Class;

        [Embed(source="../../../assets/gAssetManager/ButtonIconCrown.png")]
        private static const ButtonIconCrown:Class;

        [Embed(source="../../../assets/gAssetManager/ButtonIconCrownGems.png")]
        private static const ButtonIconCrownGems:Class;

        [Embed(source="../../../assets/gAssetManager/ButtonIconScroll.png")]
        private static const ButtonIconScroll:Class;

        [Embed(source="../../../assets/gAssetManager/Close.png")]
        private static const Close:Class;

        [Embed(source="../../../assets/gAssetManager/CloseHighlight.png")]
        private static const CloseHighlight:Class;

        [Embed(source="../../../assets/embedded/buttons/buttons_x_inactive.png")]
        private static const CloseDisabled:Class;

        [Embed(source="../../../assets/gAssetManager/HalfTime.png")]
        private static const HalfTime:Class;

        [Embed(source="../../../assets/gAssetManager/HalfTimeHighlight.png")]
        private static const HalfTimeHighlight:Class;

        [Embed(source="../../../assets/gAssetManager/HalfTimeDisabled.png")]
        private static const HalfTimeDisabled:Class;

        [Embed(source="../../../assets/gAssetManager/ProductionArrow.png")]
        private static const ProductionArrow:Class;

        [Embed(source="../../../assets/gAssetManager/ProductionArrowDown.png")]
        private static const ProductionArrowDown:Class;

        [Embed(source="../../../assets/gAssetManager/ArrowUp.png")]
        private static const ArrowUp:Class;

        [Embed(source="../../../assets/gAssetManager/ArrowUpHighlight.png")]
        private static const ArrowUpHighlight:Class;

        [Embed(source="../../../assets/gAssetManager/ArrowUpDisabled.png")]
        private static const ArrowUpDisabled:Class;

        [Embed(source="../../../assets/gAssetManager/ArrowDown.png")]
        private static const ArrowDown:Class;

        [Embed(source="../../../assets/gAssetManager/ArrowDownHighlight.png")]
        private static const ArrowDownHighlight:Class;

        [Embed(source="../../../assets/gAssetManager/ArrowDownDisabled.png")]
        private static const ArrowDownDisabled:Class;

        [Embed(source="../../../assets/gAssetManager/ButtonContextMenu.png")]
        private static const ButtonContextMenu:Class;

        [Embed(source="../../../assets/gAssetManager/ButtonContextMenuHighlight.png")]
        private static const ButtonContextMenuHighlight:Class;

        [Embed(source="../../../assets/gAssetManager/ButtonContextMenuDisabled.png")]
        private static const ButtonContextMenuDisabled:Class;

        [Embed(source="../../../assets/gAssetManager/AvatarSelectionPanelLeftArrow.png")]
        private static const ArrowLeft:Class;

        [Embed(source="../../../assets/gAssetManager/ArrowLeftHighlight.png")]
        private static const ArrowLeftHighlight:Class;

        [Embed(source="../../../assets/gAssetManager/ArrowLeftDisabled.png")]
        private static const ArrowLeftDisabled:Class;

        [Embed(source="../../../assets/gAssetManager/ArrowLeftScroll.png")]
        private static const ArrowLeftScroll:Class;

        [Embed(source="../../../assets/gAssetManager/ArrowLeftScrollHighlight.png")]
        private static const ArrowLeftScrollHighlight:Class;

        [Embed(source="../../../assets/gAssetManager/ArrowLeftScrollDisabled.png")]
        private static const ArrowLeftScrollDisabled:Class;

        [Embed(source="../../../assets/gAssetManager/ArrowLeftEnd.png")]
        private static const ArrowLeftEnd:Class;

        [Embed(source="../../../assets/gAssetManager/ArrowLeftEndHighlight.png")]
        private static const ArrowLeftEndHighlight:Class;

        [Embed(source="../../../assets/gAssetManager/ArrowLeftEndDisabled.png")]
        private static const ArrowLeftEndDisabled:Class;

        [Embed(source="../../../assets/gAssetManager/ButtonIconStart.png")]
        private static const ArrowRight:Class;

        [Embed(source="../../../assets/gAssetManager/ArrowRightHighlight.png")]
        private static const ArrowRightHighlight:Class;

        [Embed(source="../../../assets/gAssetManager/ArrowRightDisabled.png")]
        private static const ArrowRightDisabled:Class;

        [Embed(source="../../../assets/gAssetManager/ArrowRightScroll.png")]
        private static const ArrowRightScroll:Class;

        [Embed(source="../../../assets/gAssetManager/ArrowRightScrollHighlight.png")]
        private static const ArrowRightScrollHighlight:Class;

        [Embed(source="../../../assets/gAssetManager/ArrowRightScrollDisabled.png")]
        private static const ArrowRightScrollDisabled:Class;

        [Embed(source="../../../assets/gAssetManager/ArrowRightEnd.png")]
        private static const ArrowRightEnd:Class;

        [Embed(source="../../../assets/gAssetManager/ArrowRightEndHighlight.png")]
        private static const ArrowRightEndHighlight:Class;

        [Embed(source="../../../assets/gAssetManager/ArrowRightEndDisabled.png")]
        private static const ArrowRightEndDisabled:Class;

        [Embed(source="../../../assets/gAssetManager/ChangeLogIcon.png")]
        private static const icon_changelog:Class;

        [Embed(source="../../../assets/embedded/buttons/buttons_icon_questionmark2.png")]
        private static const icon_infopanel:Class;

        [Embed(source="../../../assets/gAssetManager/icon_event_info.png")]
        private static const icon_event_info:Class;

        [Embed(source="../../../assets/gAssetManager/icon_go_shop.png")]
        private static const icon_go_shop:Class;

        [Embed(source="../../../assets/gAssetManager/icon_go_link.png")]
        private static const icon_go_link:Class;

        [Embed(source="../../../assets/gAssetManager/ArrowLeftGreen.png")]
        private static const ArrowLeftGreen:Class;

        [Embed(source="../../../assets/gAssetManager/ArrowRightGreen.png")]
        private static const ArrowRightGreen:Class;

        [Embed(source="../../../assets/gAssetManager/QuestionMark.png")]
        private static const QuestionMark:Class;

        [Embed(source="../../../assets/gAssetManager/ButtonAddCashUp.png")]
        private static const ButtonAddCashUp:Class;

        [Embed(source="../../../assets/gAssetManager/ButtonAddCashOver.png")]
        private static const ButtonAddCashOver:Class;

        [Embed(source="../../../assets/gAssetManager/ButtonAddCashDisabled.png")]
        private static const ButtonAddCashDisabled:Class;

        [Embed(source="../../../assets/gAssetManager/OptionsButtonOptions.png")]
        private static const OptionsButtonOptions:Class;

        [Embed(source="../../../assets/gAssetManager/OptionsButtonMinus.png")]
        private static const OptionsButtonMinus:Class;

        [Embed(source="../../../assets/gAssetManager/OptionsButtonPlus.png")]
        private static const OptionsButtonPlus:Class;

        [Embed(source="../../../assets/gAssetManager/OptionsPanelSeparator.png")]
        private static const OptionsPanelSeparator:Class;

        [Embed(source="../../../assets/gAssetManager/QuestLocked.png")]
        private static const IconPadlock:Class;

        [Embed(source="../../../assets/gAssetManager/IconSkull.png")]
        private static const IconSkull:Class;

        [Embed(source="../../../assets/gAssetManager/ArrowSmallNUp.png")]
        private static const ArrowSmallNUp:Class;

        [Embed(source="../../../assets/gAssetManager/ArrowSmallNOver.png")]
        private static const ArrowSmallNOver:Class;

        [Embed(source="../../../assets/gAssetManager/ArrowSmallWUp.png")]
        private static const ArrowSmallWUp:Class;

        [Embed(source="../../../assets/gAssetManager/ArrowSmallWOver.png")]
        private static const ArrowSmallWOver:Class;

        [Embed(source="../../../assets/gAssetManager/ArrowSmallEUp.png")]
        private static const ArrowSmallEUp:Class;

        [Embed(source="../../../assets/gAssetManager/ArrowSmallEOver.png")]
        private static const ArrowSmallEOver:Class;

        [Embed(source="../../../assets/gAssetManager/ArrowSmallSUp.png")]
        private static const ArrowSmallSUp:Class;

        [Embed(source="../../../assets/gAssetManager/ArrowSmallSOver.png")]
        private static const ArrowSmallSOver:Class;

        [Embed(source="../../../assets/gAssetManager/RefreshTradeIcon.png")]
        private static const RefreshTradeIcon:Class;

        [Embed(source="../../../assets/gAssetManager/ButtonIconCoin.png")]
        private static const ButtonIconCoin:Class;

        [Embed(source="../../../assets/gAssetManager/SearchBtnIcon.png")]
        private static const SearchBtnIcon:Class;

        [Embed(source="../../../assets/gAssetManager/SkillTreeBtnIcon.png")]
        private static const SkillTreeBtnIcon:Class;

        [Embed(source="../../../assets/gAssetManager/FailedIcon.png")]
        private static const FailedIcon:Class;

        [Embed(source="../../../assets/gAssetManager/OKIcon.png")]
        private static const OKIcon:Class;

        [Embed(source="../../../assets/gAssetManager/QuestionIcon.png")]
        private static const QuestionIcon:Class;

        [Embed(source="../../../assets/gAssetManager/BackIcon.png")]
        private static const BackIcon:Class;

        [Embed(source="../../../assets/gAssetManager/DestroyEpicWorkyardProductionChain.png")]
        private static const DestroyEpicWorkyardProductionChain:Class;

        [Embed(source="../../../assets/gAssetManager/LoopForward.png")]
        private static const LoopForward:Class;

        [Embed(source="../../../assets/gAssetManager/LoopBackward.png")]
        private static const LoopBackward:Class;

        [Embed(source="../../../assets/gAssetManager/ButtonIconAcceptLoot.png")]
        private static const ButtonIconAcceptLoot:Class;

        [Embed(source="../../../assets/gAssetManager/ButtonIconClaimLoot.png")]
        private static const ButtonIconClaimLoot:Class;

        [Embed(source="../../../assets/gAssetManager/Help_window_combat3_tutorial.png")]
        private static const Help_window_combat3_tutorial:Class;

        [Embed(source="../../../assets/gAssetManager/icon_get_gems.png")]
        private static const icon_get_gems:Class;
        private static var ButtonIconTravellingErudite:Class;
        private static var ButtonIconBeanACollada:Class;

        [Embed(source="../../../assets/gAssetManager/AvatarAdventureZone.png")]
        private static const AvatarAdventureZone:Class;

        [Embed(source="../../../assets/gAssetManager/AvatarSmall00.png")]
        private static const AvatarSmall00:Class;

        [Embed(source="../../../assets/gAssetManager/IconPlayerIn.png")]
        private static const IconPlayerIn:Class;

        [Embed(source="../../../assets/gAssetManager/IconPlayerWait.png")]
        private static const IconPlayerWait:Class;

        [Embed(source="../../../assets/gAssetManager/AvatarAdd.png")]
        private static const AvatarAdd:Class;

        [Embed(source="../../../assets/gAssetManager/AvatarAddMouseOver.png")]
        private static const AvatarAddMouseOver:Class;

        [Embed(source="../../../assets/gAssetManager/AvatarCancel.png")]
        private static const AvatarCancel:Class;

        [Embed(source="../../../assets/gAssetManager/AvatarCancelMouseOver.png")]
        private static const AvatarCancelMouseOver:Class;

        [Embed(source="../../../assets/gAssetManager/AvatarBanditSmall01.png")]
        private static const AvatarBanditSmall01:Class;

        [Embed(source="../../../assets/gAssetManager/AvatarBackground01.png")]
        private static const AvatarBackground01:Class;

        [Embed(source="../../../assets/gAssetManager/AvatarBackground02.png")]
        private static const AvatarBackground02:Class;

        [Embed(source="../../../assets/gAssetManager/AvatarBackground03.png")]
        private static const AvatarBackground03:Class;

        [Embed(source="../../../assets/gAssetManager/AvatarBackground04.png")]
        private static const AvatarBackground04:Class;

        [Embed(source="../../../assets/gAssetManager/AvatarBackground05.png")]
        private static const AvatarBackground05:Class;

        [Embed(source="../../../assets/gAssetManager/AvatarBackground06.png")]
        private static const AvatarBackground06:Class;

        [Embed(source="../../../assets/gAssetManager/AvatarBackground07.png")]
        private static const AvatarBackground07:Class;

        [Embed(source="../../../assets/gAssetManager/AvatarBackground08.png")]
        private static const AvatarBackground08:Class;

        [Embed(source="../../../assets/gAssetManager/AvatarBackground09.png")]
        private static const AvatarBackground09:Class;

        [Embed(source="../../../assets/gAssetManager/AvatarBackground10.png")]
        private static const AvatarBackground10:Class;

        [Embed(source="../../../assets/gAssetManager/AvatarBackground11.png")]
        private static const AvatarBackground11:Class;

        [Embed(source="../../../assets/gAssetManager/AvatarBackground12.png")]
        private static const AvatarBackground12:Class;

        [Embed(source="../../../assets/gAssetManager/AvatarBackground13.png")]
        private static const AvatarBackground13:Class;

        [Embed(source="../../../assets/gAssetManager/AvatarBackground14.png")]
        private static const AvatarBackground14:Class;

        [Embed(source="../../../assets/gAssetManager/AvatarBackgroundSmall00Background.png")]
        private static const AvatarBackgroundSmall00Background:Class;

        [Embed(source="../../../assets/gAssetManager/AvatarBackgroundSmall00BackgroundNeutral.png")]
        private static const AvatarBackgroundSmall00BackgroundNeutral:Class;

        [Embed(source="../../../assets/gAssetManager/AvatarBackgroundSmall00.png")]
        private static const AvatarBackgroundSmall00:Class;

        [Embed(source="../../../assets/gAssetManager/AvatarBackgroundSmall01.png")]
        private static const AvatarBackgroundSmall01:Class;

        [Embed(source="../../../assets/gAssetManager/AvatarBackgroundSmall02.png")]
        private static const AvatarBackgroundSmall02:Class;

        [Embed(source="../../../assets/gAssetManager/AvatarBackgroundSmall03.png")]
        private static const AvatarBackgroundSmall03:Class;

        [Embed(source="../../../assets/gAssetManager/AvatarBackgroundSmall04.png")]
        private static const AvatarBackgroundSmall04:Class;

        [Embed(source="../../../assets/gAssetManager/AvatarBackgroundSmall05.png")]
        private static const AvatarBackgroundSmall05:Class;

        [Embed(source="../../../assets/gAssetManager/AvatarBackgroundSmall06.png")]
        private static const AvatarBackgroundSmall06:Class;

        [Embed(source="../../../assets/gAssetManager/AvatarBackgroundSmall07.png")]
        private static const AvatarBackgroundSmall07:Class;

        [Embed(source="../../../assets/gAssetManager/AvatarBackgroundSmall08.png")]
        private static const AvatarBackgroundSmall08:Class;

        [Embed(source="../../../assets/gAssetManager/AvatarBackgroundSmall09.png")]
        private static const AvatarBackgroundSmall09:Class;

        [Embed(source="../../../assets/gAssetManager/AvatarBackgroundSmall10.png")]
        private static const AvatarBackgroundSmall10:Class;

        [Embed(source="../../../assets/gAssetManager/AvatarBackgroundSmall11.png")]
        private static const AvatarBackgroundSmall11:Class;

        [Embed(source="../../../assets/gAssetManager/AvatarBackgroundSmall12.png")]
        private static const AvatarBackgroundSmall12:Class;

        [Embed(source="../../../assets/gAssetManager/AvatarBackgroundSmall13.png")]
        private static const AvatarBackgroundSmall13:Class;

        [Embed(source="../../../assets/gAssetManager/AvatarBackgroundSmall14.png")]
        private static const AvatarBackgroundSmall14:Class;

        [Embed(source="../../../assets/gAssetManager/PremiumAccountGenericIcon.png")]
        private static const PremiumAccountGenericIcon:Class;

        [Embed(source="../../../assets/vector/gAssetManager/AvatarSelectionPanelHeaderCurtain.swf", symbol="GUI.Assets.gAssetManager_AvatarSelectionPanelHeaderCurtain")]
        private static const AvatarSelectionPanelHeaderCurtain:Class;

        [Embed(source="../../../assets/gAssetManager/AvatarSelectionPanelBackground.png")]
        private static const AvatarSelectionPanelBackground:Class;

        [Embed(source="../../../assets/vector/gAssetManager/AvatarSelectionPanelArrowBackgroundNormal.swf", symbol="GUI.Assets.gAssetManager_AvatarSelectionPanelArrowBackgroundNormal")]
        private static const AvatarSelectionPanelArrowBackgroundNormal:Class;

        [Embed(source="../../../assets/vector/gAssetManager/AvatarSelectionPanelArrowBackgroundHighlight.swf", symbol="GUI.Assets.gAssetManager_AvatarSelectionPanelArrowBackgroundHighlight")]
        private static const AvatarSelectionPanelArrowBackgroundHighlight:Class;

        [Embed(source="../../../assets/vector/gAssetManager/AvatarSelectionPanelArrowBackgroundDisabled.swf", symbol="GUI.Assets.gAssetManager_AvatarSelectionPanelArrowBackgroundDisabled")]
        private static const AvatarSelectionPanelArrowBackgroundDisabled:Class;

        [Embed(source="../../../assets/gAssetManager/AvatarSelectionPanelNameBackground.png")]
        private static const AvatarSelectionPanelNameBackground:Class;

        [Embed(source="../../../assets/gAssetManager/AvatarSelectionPanelNameInputBackground.png")]
        private static const AvatarSelectionPanelNameInputBackground:Class;

        [Embed(source="../../../assets/gAssetManager/ButtonIconStart.png")]
        private static const AvatarSelectionPanelRightArrow:Class;

        [Embed(source="../../../assets/gAssetManager/AvatarSelectionPanelLeftArrow.png")]
        private static const AvatarSelectionPanelLeftArrow:Class;

        [Embed(source="../../../assets/vector/gAssetManager/AvatarSelectionPanelErrorBackground.swf", symbol="GUI.Assets.gAssetManager_AvatarSelectionPanelErrorBackground")]
        private static const AvatarSelectionPanelErrorBackground:Class;

        [Embed(source="../../../assets/gAssetManager/AvatarBackgroundSmall01.png")]
        private static const AvatarSelectionPanelSmallAvatarBackground:Class;

        [Embed(source="../../../assets/gAssetManager/AvatarSelectionPanelSmallAvatarOverlay.png")]
        private static const AvatarSelectionPanelSmallAvatarOverlay:Class;

        [Embed(source="../../../assets/gAssetManager/AvatarBackground01.png")]
        private static const AvatarSelectionPanelBigAvatarBackground:Class;

        [Embed(source="../../../assets/gAssetManager/InputMissingBackground.png")]
        private static const InputMissingBackground:Class;

        [Embed(source="../../../assets/gAssetManager/InputMissingForeground.png")]
        private static const InputMissingForeground:Class;

        [Embed(source="../../../assets/gAssetManager/OutputBuffedBackground.png")]
        private static const OutputBuffedBackground:Class;

        [Embed(source="../../../assets/gAssetManager/OutputBuffedForeground.png")]
        private static const OutputBuffedForeground:Class;

        [Embed(source="../../../assets/gAssetManager/DetailsIconOverallTime.png")]
        private static const DetailsIconOverallTime:Class;

        [Embed(source="../../../assets/gAssetManager/DetailsIconProductionTime.png")]
        private static const DetailsIconProductionTime:Class;

        [Embed(source="../../../assets/gAssetManager/DetailsIconInternal.png")]
        private static const DetailsIconInternal:Class;

        [Embed(source="../../../assets/gAssetManager/DetailsIconDeposit.png")]
        private static const DetailsIconDeposit:Class;

        [Embed(source="../../../assets/gAssetManager/DetailsIconWarehouse.png")]
        private static const DetailsIconWarehouse:Class;

        [Embed(source="../../../assets/gAssetManager/DetailsIconWorkyard.png")]
        private static const DetailsIconWorkyard:Class;

        [Embed(source="../../../assets/gAssetManager/PayshopIndicator.png")]
        private static const PayshopIndicator:Class;

        [Embed(source="../../../assets/gAssetManager/IconCannotBuild.png")]
        private static const IconCannotBuild:Class;

        [Embed(source="../../../assets/gAssetManager/ArrowSmallRight.png")]
        private static const ArrowSmallRight:Class;

        [Embed(source="../../../assets/gAssetManager/HouseBg.png")]
        private static const HouseBg:Class;

        [Embed(source="../../../assets/gAssetManager/IconGuild.png")]
        private static const IconGuild:Class;

        [Embed(source="../../../assets/gAssetManager/OnlineStatusGreen.png")]
        private static const OnlineStatusGreen:Class;

        [Embed(source="../../../assets/gAssetManager/FrameArrow.png")]
        private static const FrameArrow:Class;

        [Embed(source="../../../assets/gAssetManager/AddFriendBackground.png")]
        private static const AddFriendBackground:Class;

        [Embed(source="../../../assets/embedded/friendslist/friendslist_neighbours00_highlight.png")]
        private static const AddFriendBackgroundHighlight:Class;

        [Embed(source="../../../assets/embedded/friendslist/friendslist_neighbours01.png")]
        private static const FriendBackground:Class;

        [Embed(source="../../../assets/embedded/friendslist/friendslist_neighbours01_highlight.png")]
        private static const FriendBackgroundHighlight:Class;

        [Embed(source="../../../assets/gAssetManager/FriendFilterBackground.png")]
        private static const FriendFilterBackground:Class;

        [Embed(source="../../../assets/gAssetManager/FriendVisit.png")]
        private static const FriendVisit:Class;

        [Embed(source="../../../assets/gAssetManager/FriendIndicatorAdventure.png")]
        private static const FriendIndicatorAdventure:Class;

        [Embed(source="../../../assets/gAssetManager/FriendIndicatorEnemy.png")]
        private static const FriendIndicatorEnemy:Class;

        [Embed(source="../../../assets/gAssetManager/FriendIndicatorGuild.png")]
        private static const FriendIndicatorGuild:Class;

        [Embed(source="../../../assets/gAssetManager/SmallIconHardCurrency.png")]
        private static const SmallIconHardCurrency:Class;

        [Embed(source="../../../assets/gAssetManager/IconGemPitAlert.png")]
        private static const IconGemPitAlert:Class;

        [Embed(source="../../../assets/gAssetManager/GuildBankIcon.png")]
        private static const GuildBankIcon:Class;

        [Embed(source="../../../assets/embedded/starmenu/starmenu_icon_star_small.png")]
        private static const SmallIconStar:Class;

        [Embed(source="../../../assets/gAssetManager/GuildmarketOrnamental.png")]
        private static const GuildmarketOrnamental:Class;

        [Embed(source="../../../assets/gAssetManager/ScrollbarArrowDownHighlight.png")]
        private static const ScrollbarArrowDownHighlight:Class;

        [Embed(source="../../../assets/gAssetManager/ScrollbarArrowDown.png")]
        private static const ScrollbarArrowDown:Class;

        [Embed(source="../../../assets/gAssetManager/LevelUpDigit0.png")]
        private static const LevelUpDigit0:Class;

        [Embed(source="../../../assets/gAssetManager/LevelUpDigit1.png")]
        private static const LevelUpDigit1:Class;

        [Embed(source="../../../assets/gAssetManager/LevelUpDigit2.png")]
        private static const LevelUpDigit2:Class;

        [Embed(source="../../../assets/gAssetManager/LevelUpDigit3.png")]
        private static const LevelUpDigit3:Class;

        [Embed(source="../../../assets/gAssetManager/LevelUpDigit4.png")]
        private static const LevelUpDigit4:Class;

        [Embed(source="../../../assets/gAssetManager/LevelUpDigit5.png")]
        private static const LevelUpDigit5:Class;

        [Embed(source="../../../assets/gAssetManager/LevelUpDigit6.png")]
        private static const LevelUpDigit6:Class;

        [Embed(source="../../../assets/gAssetManager/LevelUpDigit7.png")]
        private static const LevelUpDigit7:Class;

        [Embed(source="../../../assets/gAssetManager/LevelUpDigit8.png")]
        private static const LevelUpDigit8:Class;

        [Embed(source="../../../assets/gAssetManager/LevelUpDigit9.png")]
        private static const LevelUpDigit9:Class;

        [Embed(source="../../../assets/gAssetManager/PvPProgressionDigit0.png")]
        private static const PvPProgressionDigit0:Class;

        [Embed(source="../../../assets/gAssetManager/PvPProgressionDigit1.png")]
        private static const PvPProgressionDigit1:Class;

        [Embed(source="../../../assets/gAssetManager/PvPProgressionDigit2.png")]
        private static const PvPProgressionDigit2:Class;

        [Embed(source="../../../assets/gAssetManager/PvPProgressionDigit3.png")]
        private static const PvPProgressionDigit3:Class;

        [Embed(source="../../../assets/gAssetManager/PvPProgressionDigit4.png")]
        private static const PvPProgressionDigit4:Class;

        [Embed(source="../../../assets/gAssetManager/PvPProgressionDigit5.png")]
        private static const PvPProgressionDigit5:Class;

        [Embed(source="../../../assets/gAssetManager/PvPProgressionDigit6.png")]
        private static const PvPProgressionDigit6:Class;

        [Embed(source="../../../assets/gAssetManager/PvPProgressionDigit7.png")]
        private static const PvPProgressionDigit7:Class;

        [Embed(source="../../../assets/gAssetManager/PvPProgressionDigit8.png")]
        private static const PvPProgressionDigit8:Class;

        [Embed(source="../../../assets/gAssetManager/PvPProgressionDigit9.png")]
        private static const PvPProgressionDigit9:Class;

        [Embed(source="../../../assets/gAssetManager/PvPProgressionDigitSmall0.png")]
        private static const PvPProgressionDigitSmall0:Class;

        [Embed(source="../../../assets/gAssetManager/PvPProgressionDigitSmall1.png")]
        private static const PvPProgressionDigitSmall1:Class;

        [Embed(source="../../../assets/gAssetManager/PvPProgressionDigitSmall2.png")]
        private static const PvPProgressionDigitSmall2:Class;

        [Embed(source="../../../assets/gAssetManager/PvPProgressionDigitSmall3.png")]
        private static const PvPProgressionDigitSmall3:Class;

        [Embed(source="../../../assets/gAssetManager/PvPProgressionDigitSmall4.png")]
        private static const PvPProgressionDigitSmall4:Class;

        [Embed(source="../../../assets/gAssetManager/PvPProgressionDigitSmall5.png")]
        private static const PvPProgressionDigitSmall5:Class;

        [Embed(source="../../../assets/gAssetManager/PvPProgressionDigitSmall6.png")]
        private static const PvPProgressionDigitSmall6:Class;

        [Embed(source="../../../assets/gAssetManager/PvPProgressionDigitSmall7.png")]
        private static const PvPProgressionDigitSmall7:Class;

        [Embed(source="../../../assets/gAssetManager/PvPProgressionDigitSmall8.png")]
        private static const PvPProgressionDigitSmall8:Class;

        [Embed(source="../../../assets/gAssetManager/PvPProgressionDigitSmall9.png")]
        private static const PvPProgressionDigitSmall9:Class;

        [Embed(source="../../../assets/gAssetManager/PvPTierLocked.png")]
        private static const PvPTierLocked:Class;

        [Embed(source="../../../assets/gAssetManager/PvPTierUnlocked.png")]
        private static const PvPTierUnlocked:Class;

        [Embed(source="../../../assets/gAssetManager/PvPNumerics1.png")]
        private static const PvPNumerics1:Class;

        [Embed(source="../../../assets/gAssetManager/PvPNumerics2.png")]
        private static const PvPNumerics2:Class;

        [Embed(source="../../../assets/gAssetManager/PvPNumerics3.png")]
        private static const PvPNumerics3:Class;

        [Embed(source="../../../assets/gAssetManager/CalendarDateDigit0.png")]
        private static const CalendarDateDigit0:Class;

        [Embed(source="../../../assets/gAssetManager/CalendarDateDigit1.png")]
        private static const CalendarDateDigit1:Class;

        [Embed(source="../../../assets/gAssetManager/CalendarDateDigit2.png")]
        private static const CalendarDateDigit2:Class;

        [Embed(source="../../../assets/gAssetManager/CalendarDateDigit3.png")]
        private static const CalendarDateDigit3:Class;

        [Embed(source="../../../assets/gAssetManager/CalendarDateDigit4.png")]
        private static const CalendarDateDigit4:Class;

        [Embed(source="../../../assets/gAssetManager/CalendarDateDigit5.png")]
        private static const CalendarDateDigit5:Class;

        [Embed(source="../../../assets/gAssetManager/CalendarDateDigit6.png")]
        private static const CalendarDateDigit6:Class;

        [Embed(source="../../../assets/gAssetManager/CalendarDateDigit7.png")]
        private static const CalendarDateDigit7:Class;

        [Embed(source="../../../assets/gAssetManager/CalendarDateDigit8.png")]
        private static const CalendarDateDigit8:Class;

        [Embed(source="../../../assets/gAssetManager/CalendarDateDigit9.png")]
        private static const CalendarDateDigit9:Class;

        [Embed(source="../../../assets/gAssetManager/dot.png")]
        private static const dot:Class;

        [Embed(source="../../../assets/gAssetManager/slimDot.png")]
        private static const slimDot:Class;

        [Embed(source="../../../assets/gAssetManager/HappyHourDigit0.png")]
        private static const HappyHourDigit0:Class;

        [Embed(source="../../../assets/gAssetManager/HappyHourDigit1.png")]
        private static const HappyHourDigit1:Class;

        [Embed(source="../../../assets/gAssetManager/HappyHourDigit2.png")]
        private static const HappyHourDigit2:Class;

        [Embed(source="../../../assets/gAssetManager/HappyHourDigit3.png")]
        private static const HappyHourDigit3:Class;

        [Embed(source="../../../assets/gAssetManager/HappyHourDigit4.png")]
        private static const HappyHourDigit4:Class;

        [Embed(source="../../../assets/gAssetManager/HappyHourDigit5.png")]
        private static const HappyHourDigit5:Class;

        [Embed(source="../../../assets/gAssetManager/plus.png")]
        private static const plus:Class;

        [Embed(source="../../../assets/gAssetManager/percent.png")]
        private static const percent:Class;

        [Embed(source="../../../assets/gAssetManager/PanelOrnamentalTop.png")]
        private static const PanelOrnamentalTop:Class;

        [Embed(source="../../../assets/gAssetManager/SkillTreeBG.png")]
        private static const SkillTreeBG:Class;

        [Embed(source="../../../assets/gAssetManager/greyDot.png")]
        private static const greyDot:Class;

        [Embed(source="../../../assets/gAssetManager/IconBomb.png")]
        private static const IconBomb:Class;

        [Embed(source="../../../assets/gAssetManager/IconGuildShield.png")]
        private static const IconGuildShield:Class;

        [Embed(source="../../../assets/gAssetManager/EventWindowHeader.png")]
        private static const EventWindowHeader:Class;

        [Embed(source="../../../assets/gAssetManager/EventWindowOrnamental.png")]
        private static const EventWindowOrnamental:Class;

        [Embed(source="../../../assets/gAssetManager/EventWindowBanner.png")]
        private static const EventWindowBanner:Class;

        [Embed(source="../../../assets/gAssetManager/PremiumAccountDays1.png")]
        public static const PremiumAccountDays1:Class;

        [Embed(source="../../../assets/gAssetManager/PremiumAccountDays3.png")]
        public static const PremiumAccountDays3:Class;

        [Embed(source="../../../assets/gAssetManager/PremiumAccountDays7.png")]
        public static const PremiumAccountDays7:Class;

        [Embed(source="../../../assets/gAssetManager/PremiumAccountDays30.png")]
        public static const PremiumAccountDays30:Class;

        [Embed(source="../../../assets/gAssetManager/PremiumAccountDays180.png")]
        public static const PremiumAccountDays180:Class;

        [Embed(source="../../../assets/gAssetManager/PremiumAccountDays360.png")]
        public static const PremiumAccountDays360:Class;

        [Embed(source="../../../assets/gAssetManager/PremiumAccountHeader.png")]
        private static const PremiumAccountHeader:Class;

        [Embed(source="../../../assets/vector/gAssetManager/CollectionItemBackground.swf", symbol="GUI.Assets.gAssetManager_CollectionItemBackground")]
        private static const CollectionItemBackground:Class;

        [Embed(source="../../../assets/vector/gAssetManager/CollectionResourceBackgroundNeutral.swf", symbol="GUI.Assets.gAssetManager_CollectionResourceBackgroundNeutral")]
        private static const CollectionResourceBackgroundNeutral:Class;

        [Embed(source="../../../assets/vector/gAssetManager/CollectionResourceBackgroundRarity0.swf", symbol="GUI.Assets.gAssetManager_CollectionResourceBackgroundRarity0")]
        private static const CollectionResourceBackgroundRarity0:Class;

        [Embed(source="../../../assets/vector/gAssetManager/CollectionResourceBackgroundRarity1.swf", symbol="GUI.Assets.gAssetManager_CollectionResourceBackgroundRarity1")]
        private static const CollectionResourceBackgroundRarity1:Class;

        [Embed(source="../../../assets/vector/gAssetManager/CollectionResourceBackgroundRarity2.swf", symbol="GUI.Assets.gAssetManager_CollectionResourceBackgroundRarity2")]
        private static const CollectionResourceBackgroundRarity2:Class;

        [Embed(source="../../../assets/vector/gAssetManager/CollectionResourceBackgroundRarity3.swf", symbol="GUI.Assets.gAssetManager_CollectionResourceBackgroundRarity3")]
        private static const CollectionResourceBackgroundRarity3:Class;

        [Embed(source="../../../assets/gAssetManager/CollectionRevealBuff.png")]
        private static const CollectionRevealBuff:Class;

        [Embed(source="../../../assets/gAssetManager/QuestionmarkGold.png")]
        private static const QuestionmarkGold:Class;

        [Embed(source="../../../assets/gAssetManager/RegularWindowClosed.png")]
        private static const RegularWindowClosed:Class;

        [Embed(source="../../../assets/gAssetManager/RegularWindowOpened.png")]
        private static const RegularWindowOpened:Class;

        [Embed(source="../../../assets/gAssetManager/SilvesterWindowClosed.png")]
        private static const SilvesterWindowClosed:Class;

        [Embed(source="../../../assets/gAssetManager/SilvesterWindowOpened.png")]
        private static const SilvesterWindowOpened:Class;

        [Embed(source="../../../assets/gAssetManager/SpecialWindowClosed.png")]
        private static const SpecialWindowClosed:Class;

        [Embed(source="../../../assets/gAssetManager/SpecialWindowOpened.png")]
        private static const SpecialWindowOpened:Class;

        [Embed(source="../../../assets/gAssetManager/XmasWindowClosed.png")]
        private static const XmasWindowClosed:Class;

        [Embed(source="../../../assets/gAssetManager/XmasWindowOpened.png")]
        private static const XmasWindowOpened:Class;

        [Embed(source="../../../assets/gAssetManager/WMEventAdventureClosed.png")]
        private static const WMEventAdventureClosed:Class;

        [Embed(source="../../../assets/gAssetManager/WMEventAdventureOpened.png")]
        private static const WMEventAdventureOpened:Class;

        [Embed(source="../../../assets/gAssetManager/WMEventBonusClosed.png")]
        private static const WMEventBonusClosed:Class;

        [Embed(source="../../../assets/gAssetManager/WMEventBonusOpened.png")]
        private static const WMEventBonusOpened:Class;

        [Embed(source="../../../assets/gAssetManager/PresentsWindowClosed.png")]
        private static const PresentsWindowClosed:Class;

        [Embed(source="../../../assets/gAssetManager/PresentsWindowOpened.png")]
        private static const PresentsWindowOpened:Class;

        [Embed(source="../../../assets/gAssetManager/PromotionBG0.png")]
        private static const PromotionBG0:Class;

        [Embed(source="../../../assets/gAssetManager/PromotionBG1.png")]
        private static const PromotionBG1:Class;

        [Embed(source="../../../assets/gAssetManager/PromotionBG2.png")]
        private static const PromotionBG2:Class;

        [Embed(source="../../../assets/gAssetManager/PromotionBG3.png")]
        private static const PromotionBG3:Class;

        [Embed(source="../../../assets/gAssetManager/dragon.png")]
        private static const dragon:Class;

        [Embed(source="../../../assets/gAssetManager/dragonEaster.png")]
        private static const dragonEaster:Class;

        [Embed(source="../../../assets/gAssetManager/dragonHalloween.png")]
        private static const dragonHalloween:Class;

        [Embed(source="../../../assets/gAssetManager/dragonChristmas.png")]
        private static const dragonChristmas:Class;

        [Embed(source="../../../assets/gAssetManager/dragonFootball.png")]
        private static const dragonFootball:Class;

        [Embed(source="../../../assets/gAssetManager/dragonValentines.png")]
        private static const dragonValentines:Class;

        [Embed(source="../../../assets/gAssetManager/dragonAnniversary.png")]
        private static const dragonAnniversary:Class;

        [Embed(source="../../../assets/embedded/adventure/adventure_adventure_ornamental_top.png")]
        private static const adventureHeader:Class;

        [Embed(source="../../../assets/gAssetManager/adventureChristmasHeader.png")]
        private static const adventureChristmasHeader:Class;

        [Embed(source="../../../assets/gAssetManager/PvPReportMapOverlay.png")]
        private static const PvPReportMapOverlay:Class;

        [Embed(source="../../../assets/gAssetManager/PvPReportMapBackground.jpg")]
        private static const PvPReportMapBackground:Class;

        [Embed(source="../../../assets/gAssetManager/PvPReportHeader.png")]
        private static const PvPReportHeader:Class;

        [Embed(source="../../../assets/gAssetManager/PvPReportCampMarkerStandard.png")]
        private static const PvPReportCampMarkerStandard:Class;

        [Embed(source="../../../assets/gAssetManager/PvPReportCampMarkerMouseOver.png")]
        private static const PvPReportCampMarkerMouseOver:Class;

        [Embed(source="../../../assets/gAssetManager/PvPReportCampMarkerDisabled.png")]
        private static const PvPReportCampMarkerDisabled:Class;

        [Embed(source="../../../assets/gAssetManager/PvPReportInfoFrameTop.png")]
        private static const PvPReportInfoFrameTop:Class;

        [Embed(source="../../../assets/gAssetManager/PvPReportInfoFrameMid.png")]
        private static const PvPReportInfoFrameMid:Class;

        [Embed(source="../../../assets/embedded/combat3pvpreport/combat3pvpreport_info_frame_bottom.png")]
        private static const PvPReportInfoFrameBottom:Class;

        [Embed(source="../../../assets/gAssetManager/PvPRankItemRendererBGNormal.png")]
        private static const PvPRankItemRendererBGNormal:Class;

        [Embed(source="../../../assets/gAssetManager/PvPRankItemRendererBGDisabled.png")]
        private static const PvPRankItemRendererBGDisabled:Class;

        [Embed(source="../../../assets/gAssetManager/PvPRankItemRendererBGButtonNormal.png")]
        private static const PvPRankItemRendererBGButtonNormal:Class;

        [Embed(source="../../../assets/gAssetManager/PvPRankItemRendererBGButtonMouseOver.png")]
        private static const PvPRankItemRendererBGButtonMouseOver:Class;

        [Embed(source="../../../assets/gAssetManager/PvPRankItemRendererBGButtonPressed.png")]
        private static const PvPRankItemRendererBGButtonPressed:Class;

        [Embed(source="../../../assets/gAssetManager/SideTabBackGroundNormal.png")]
        private static const SideTabBackGroundNormal:Class;

        [Embed(source="../../../assets/gAssetManager/SideTabBackGroundSelected.png")]
        private static const SideTabBackGroundSelected:Class;

        [Embed(source="../../../assets/gAssetManager/SideTabBackGroundMouseOver.png")]
        private static const SideTabBackGroundMouseOver:Class;

        [Embed(source="../../../assets/gAssetManager/ProgressionTabOverviewIcon.png")]
        private static const ProgressionTabOverviewIcon:Class;

        [Embed(source="../../../assets/gAssetManager/ProgressionTabProgressionIcon.png")]
        private static const ProgressionTabProgressionIcon:Class;

        [Embed(source="../../../assets/gAssetManager/ProgressionBlackKnight.png")]
        private static const ProgressionBlackKnight:Class;

        [Embed(source="../../../assets/gAssetManager/ProgressionBlackKnightGlowOverview.png")]
        private static const ProgressionBlackKnightGlowOverview:Class;

        [Embed(source="../../../assets/gAssetManager/ProgressionBlackKnightGlowPopup.png")]
        private static const ProgressionBlackKnightGlowPopup:Class;

        [Embed(source="../../../assets/gAssetManager/ProgressionPopupHeader.png")]
        private static const ProgressionPopupHeader:Class;

        [Embed(source="../../../assets/gAssetManager/UnloadTroopsIcon.png")]
        private static const UnloadTroopsIcon:Class;

        [Embed(source="../../../assets/gAssetManager/ReturnToStarIcon.png")]
        private static const ReturnToStarIcon:Class;

        [Embed(source="../../../assets/gAssetManager/CombatUIPlateEnemyNext.png")]
        private static const CombatUIPlateEnemyNext:Class;

        [Embed(source="../../../assets/gAssetManager/CombatUIPlateEnemy.png")]
        private static const CombatUIPlateEnemy:Class;

        [Embed(source="../../../assets/gAssetManager/CombatUIPlatePlayerNext.png")]
        private static const CombatUIPlatePlayerNext:Class;

        [Embed(source="../../../assets/gAssetManager/CombatUIPlatePlayerNextHovered.png")]
        private static const CombatUIPlatePlayerNextHovered:Class;

        [Embed(source="../../../assets/gAssetManager/CombatUIPlatePlayerNextOpened.png")]
        private static const CombatUIPlatePlayerNextOpened:Class;

        [Embed(source="../../../assets/gAssetManager/CombatUIPlatePlayer.png")]
        private static const CombatUIPlatePlayer:Class;

        [Embed(source="../../../assets/gAssetManager/CombatUIPlatePlayerHovered.png")]
        private static const CombatUIPlatePlayerHovered:Class;

        [Embed(source="../../../assets/gAssetManager/CombatUICircle1.png")]
        private static const CombatUICircle1:Class;

        [Embed(source="../../../assets/gAssetManager/CombatUICircle1Hovered.png")]
        private static const CombatUICircle1Hovered:Class;

        [Embed(source="../../../assets/gAssetManager/CombatUICircle2.png")]
        private static const CombatUICircle2:Class;

        [Embed(source="../../../assets/gAssetManager/CombatUICircle2Hovered.png")]
        private static const CombatUICircle2Hovered:Class;

        [Embed(source="../../../assets/gAssetManager/CombatUICircle3.png")]
        private static const CombatUICircle3:Class;

        [Embed(source="../../../assets/gAssetManager/CombatUICircle3Hovered.png")]
        private static const CombatUICircle3Hovered:Class;

        [Embed(source="../../../assets/gAssetManager/CombatUICircle4.png")]
        private static const CombatUICircle4:Class;

        [Embed(source="../../../assets/gAssetManager/CombatUICircle4Hovered.png")]
        private static const CombatUICircle4Hovered:Class;

        [Embed(source="../../../assets/gAssetManager/CombatUICircle5.png")]
        private static const CombatUICircle5:Class;

        [Embed(source="../../../assets/gAssetManager/CombatUICircle5Hovered.png")]
        private static const CombatUICircle5Hovered:Class;

        [Embed(source="../../../assets/gAssetManager/CombatUICircle6.png")]
        private static const CombatUICircle6:Class;

        [Embed(source="../../../assets/gAssetManager/CombatUICircle6Hovered.png")]
        private static const CombatUICircle6Hovered:Class;

        [Embed(source="../../../assets/gAssetManager/GeneralStateIconAttack.png")]
        private static const GeneralStateIconAttack:Class;

        [Embed(source="../../../assets/gAssetManager/GeneralStateIconRecovery.png")]
        private static const GeneralStateIconRecovery:Class;

        [Embed(source="../../../assets/gAssetManager/GeneralStateIconRetreat.png")]
        private static const GeneralStateIconRetreat:Class;

        [Embed(source="../../../assets/gAssetManager/AdventButtonPushed.png")]
        private static const AdventButtonPushed:Class;

        [Embed(source="../../../assets/gAssetManager/AdventButtonStandard.png")]
        private static const AdventButtonStandard:Class;

        [Embed(source="../../../assets/gAssetManager/xmasAdventHeader.png")]
        private static const xmasAdventHeader:Class;

        [Embed(source="../../../assets/gAssetManager/xmasAdventBackground.png")]
        private static const xmasAdventBackground:Class;

        [Embed(source="../../../assets/gAssetManager/soccerAdventHeader.png")]
        private static const soccerAdventHeader:Class;

        [Embed(source="../../../assets/gAssetManager/anniversaryAdventBackground.png")]
        private static const soccerAdventBackground:Class;

        [Embed(source="../../../assets/gAssetManager/anniversaryAdventHeader.png")]
        private static const anniversaryAdventHeader:Class;

        [Embed(source="../../../assets/gAssetManager/anniversaryAdventBackground.png")]
        private static const anniversaryAdventBackground:Class;

        [Embed(source="../../../assets/gAssetManager/hwAdventHeader.png")]
        private static const hwAdventHeader:Class;

        [Embed(source="../../../assets/gAssetManager/anniversaryAdventBackground.png")]
        private static const hwAdventBackground:Class;

        [Embed(source="../../../assets/gAssetManager/valentinesAdventHeader.png")]
        private static const valentinesAdventHeader:Class;

        [Embed(source="../../../assets/gAssetManager/anniversaryAdventBackground.png")]
        private static const valentinesAdventBackground:Class;

        [Embed(source="../../../assets/gAssetManager/easterAdventHeader.png")]
        private static const easterAdventHeader:Class;

        [Embed(source="../../../assets/gAssetManager/anniversaryAdventBackground.png")]
        private static const easterAdventBackground:Class;

        [Embed(source="../../../assets/gAssetManager/adventureTypeCoop.png")]
        private static const adventureTypeCoop:Class;

        [Embed(source="../../../assets/gAssetManager/adventureTypeFairytale.png")]
        private static const adventureTypeFairytale:Class;

        [Embed(source="../../../assets/gAssetManager/adventureTypeMission.png")]
        private static const adventureTypeMission:Class;

        [Embed(source="../../../assets/gAssetManager/adventureTypeFollowUp.png")]
        private static const adventureTypeFollowUp:Class;

        [Embed(source="../../../assets/gAssetManager/adventureTypeEpic.png")]
        private static const adventureTypeEpic:Class;

        [Embed(source="../../../assets/gAssetManager/adventureTypeMini.png")]
        private static const adventureTypeMini:Class;

        [Embed(source="../../../assets/gAssetManager/adventureTypeResource.png")]
        private static const adventureTypeResource:Class;

        [Embed(source="../../../assets/gAssetManager/adventureTypeExperience.png")]
        private static const adventureTypeExperience:Class;

        [Embed(source="../../../assets/gAssetManager/adventureTypeSpecial.png")]
        private static const adventureTypeSpecial:Class;

        [Embed(source="../../../assets/gAssetManager/adventureTypeScenario.png")]
        private static const adventureTypeScenario:Class;

        [Embed(source="../../../assets/gAssetManager/adventureTypeVenture.png")]
        private static const adventureTypeVenture:Class;

        [Embed(source="../../../assets/gAssetManager/scenarioUICircle1.png")]
        private static const scenarioUICircle1:Class;

        [Embed(source="../../../assets/gAssetManager/scenarioUICircle2.png")]
        private static const scenarioUICircle2:Class;

        [Embed(source="../../../assets/gAssetManager/scenarioUICircle3.png")]
        private static const scenarioUICircle3:Class;

        [Embed(source="../../../assets/gAssetManager/scenarioUICircle1Hoverd.png")]
        private static const scenarioUICircle1Hoverd:Class;

        [Embed(source="../../../assets/gAssetManager/scenarioUICircle2Hoverd.png")]
        private static const scenarioUICircle2Hoverd:Class;

        [Embed(source="../../../assets/gAssetManager/scenarioUICircle3Hoverd.png")]
        private static const scenarioUICircle3Hoverd:Class;

        [Embed(source="../../../assets/gAssetManager/StripedEgg.png")]
        private static const StripedEgg:Class;

        [Embed(source="../../../assets/gAssetManager/congen_number_00.png")]
        private static const congen_number_00:Class;

        [Embed(source="../../../assets/gAssetManager/congen_number_01.png")]
        private static const congen_number_01:Class;

        [Embed(source="../../../assets/gAssetManager/congen_number_02.png")]
        private static const congen_number_02:Class;

        [Embed(source="../../../assets/gAssetManager/congen_number_03.png")]
        private static const congen_number_03:Class;

        [Embed(source="../../../assets/gAssetManager/congen_number_04.png")]
        private static const congen_number_04:Class;

        [Embed(source="../../../assets/gAssetManager/congen_number_05.png")]
        private static const congen_number_05:Class;

        [Embed(source="../../../assets/gAssetManager/congen_number_06.png")]
        private static const congen_number_06:Class;

        [Embed(source="../../../assets/gAssetManager/congen_number_07.png")]
        private static const congen_number_07:Class;

        [Embed(source="../../../assets/gAssetManager/congen_number_08.png")]
        private static const congen_number_08:Class;

        [Embed(source="../../../assets/gAssetManager/congen_number_09.png")]
        private static const congen_number_09:Class;

        [Embed(source="../../../assets/gAssetManager/congen_up.png")]
        private static const congen_up:Class;

        [Embed(source="../../../assets/gAssetManager/congen_up_highlight.png")]
        private static const congen_up_highlight:Class;

        [Embed(source="../../../assets/gAssetManager/congen_up_pressed.png")]
        private static const congen_up_pressed:Class;

        [Embed(source="../../../assets/gAssetManager/congen_down.png")]
        private static const congen_down:Class;

        [Embed(source="../../../assets/gAssetManager/congen_down_highlight.png")]
        private static const congen_down_highlight:Class;

        [Embed(source="../../../assets/gAssetManager/congen_down_pressed.png")]
        private static const congen_down_pressed:Class;

        [Embed(source="../../../assets/gAssetManager/congen_collection.png")]
        private static const congen_collection:Class;

        [Embed(source="../../../assets/gAssetManager/congen_collection_mouseover.png")]
        private static const congen_collection_mouseover:Class;

        [Embed(source="../../../assets/gAssetManager/congen_collection_pushed.png")]
        private static const congen_collection_pushed:Class;

        [Embed(source="../../../assets/gAssetManager/congen_button.png")]
        private static const congen_button:Class;

        [Embed(source="../../../assets/gAssetManager/congen_button_pushed.png")]
        private static const congen_button_pushed:Class;

        [Embed(source="../../../assets/gAssetManager/congen_button_mouseover.png")]
        private static const congen_button_mouseover:Class;

        [Embed(source="../../../assets/gAssetManager/ChatTabIconAdventure.png")]
        private static const ChatTabIconAdventure:Class;

        [Embed(source="../../../assets/gAssetManager/ChatTabIconCoopAdventure.png")]
        private static const ChatTabIconCoopAdventure:Class;

        [Embed(source="../../../assets/gAssetManager/ChatTabIconGlobal.png")]
        private static const ChatTabIconGlobal:Class;

        [Embed(source="../../../assets/gAssetManager/ChatTabIconGuild.png")]
        private static const ChatTabIconGuild:Class;

        [Embed(source="../../../assets/gAssetManager/ChatTabIconGuildOfficer.png")]
        private static const ChatTabIconGuildOfficer:Class;

        [Embed(source="../../../assets/gAssetManager/ChatTabIconHelp.png")]
        private static const ChatTabIconHelp:Class;

        [Embed(source="../../../assets/gAssetManager/ChatTabIconNews.png")]
        private static const ChatTabIconNews:Class;

        [Embed(source="../../../assets/gAssetManager/ChatTabIconTrade.png")]
        private static const ChatTabIconTrade:Class;

        [Embed(source="../../../assets/gAssetManager/ChatTabIconWhisper.png")]
        private static const ChatTabIconWhisper:Class;

        [Embed(source="../../../assets/gAssetManager/ContentGeneratorButtonDecoLeft.png")]
        private static const ContentGeneratorButtonDecoLeft:Class;

        [Embed(source="../../../assets/gAssetManager/ContentGeneratorButtonDecoRight.png")]
        private static const ContentGeneratorButtonDecoRight:Class;

        [Embed(source="../../../assets/gAssetManager/AdventurePanelDifficultyOrnaments.png")]
        private static const AdventurePanelDifficultyBackground:Class;

        [Embed(source="../../../assets/gAssetManager/AdventurePanelDifficultyColoredRing1.png")]
        private static const AdventurePanelDifficultyColoredRing1:Class;

        [Embed(source="../../../assets/gAssetManager/AdventurePanelDifficultyOrnaments.png")]
        private static const AdventurePanelDifficultyOrnaments:Class;

        [Embed(source="../../../assets/gAssetManager/AdventurePanelDifficultyOuterRing.png")]
        private static const AdventurePanelDifficultyOuterRing:Class;

        [Embed(source="../../../assets/gAssetManager/AdventurePanelDifficulty0.png")]
        private static const AdventurePanelDifficulty0:Class;

        [Embed(source="../../../assets/gAssetManager/AdventurePanelDifficulty1.png")]
        private static const AdventurePanelDifficulty1:Class;

        [Embed(source="../../../assets/gAssetManager/AdventurePanelDifficulty2.png")]
        private static const AdventurePanelDifficulty2:Class;

        [Embed(source="../../../assets/gAssetManager/AdventurePanelDifficulty3.png")]
        private static const AdventurePanelDifficulty3:Class;

        [Embed(source="../../../assets/gAssetManager/AdventurePanelDifficulty4.png")]
        private static const AdventurePanelDifficulty4:Class;

        [Embed(source="../../../assets/gAssetManager/AdventurePanelDifficulty5.png")]
        private static const AdventurePanelDifficulty5:Class;

        [Embed(source="../../../assets/gAssetManager/AdventurePanelDifficulty6.png")]
        private static const AdventurePanelDifficulty6:Class;

        [Embed(source="../../../assets/gAssetManager/AdventurePanelDifficulty7.png")]
        private static const AdventurePanelDifficulty7:Class;

        [Embed(source="../../../assets/gAssetManager/AdventurePanelDifficulty8.png")]
        private static const AdventurePanelDifficulty8:Class;

        [Embed(source="../../../assets/gAssetManager/AdventurePanelDifficulty9.png")]
        private static const AdventurePanelDifficulty9:Class;

        [Embed(source="../../../assets/gAssetManager/PvPTierIndicator01.png")]
        private static const PvPTierIndicator01:Class;

        [Embed(source="../../../assets/gAssetManager/PvPTierIndicator02.png")]
        private static const PvPTierIndicator02:Class;

        [Embed(source="../../../assets/gAssetManager/PvPTierIndicator03.png")]
        private static const PvPTierIndicator03:Class;

        [Embed(source="../../../assets/gAssetManager/CampHealthBar.png")]
        private static const CampHealthBar:Class;
        private static var binFiles:BinFileMap;
        private static var buildings:BitmapFileMap = new BitmapFileMap();
        private static var resources:BitmapFileMap = new BitmapFileMap();
        private static var military:BitmapFileMap = new BitmapFileMap();
        private static var buffs:BitmapFileMap = new BitmapFileMap();
        private static var shopItems:BitmapFileMap = new BitmapFileMap();
        private static var iconspack:BitmapFileMap = new BitmapFileMap();
        private static var loadedGfxVector:Vector.<BitmapFileMap> = new Vector.<BitmapFileMap>();
        private static var countTotal:int = 0;
        private static var countLoaded:int = 0;
        private static var completeFunction:Function;
        private static var buffCursorTypes:Dictionary = new Dictionary();
        private static var buffCursorTypesForeign:Dictionary = new Dictionary();
        private static var renderedNumbers:Dictionary = new Dictionary();
        private static var renderedDates:Dictionary = new Dictionary();
        private static var renderedModifiers:Dictionary = new Dictionary();
        public static var dummy:Bitmap;

        [Embed(source="../../../assets/gAssetManager/FileHashing_Mapping.bin", mimeType="application/octet-stream")]
        public static const FileHashing_Mapping:Class;

        [Embed(source="../../../assets/gAssetManager/DailyLoginHeaderOrnamental.png")]
        public static const DailyLoginHeaderOrnamental:Class;


        public static function GetResourceIcon(_arg_1:String, _arg_2:Boolean=true):Bitmap
        {
            return (GetGfx(_arg_1, _arg_2, resources));
        }

        private static function CloneBitmap(_arg_1:Bitmap):Bitmap
        {
            if (!_arg_1)
            {
                return (null);
            };
            var _local_2:Bitmap = new Bitmap();
            _local_2.bitmapData = _arg_1.bitmapData.clone();
            return (_local_2);
        }

        public static function GetAchievementUrl(_arg_1:String):String
        {
            return (cFilenameUtil.findHashMapping(("icons/achievements/" + _arg_1)));
        }

        public static function GetMilitaryIcon(_arg_1:String, _arg_2:Boolean=true):Bitmap
        {
            return (GetGfx(_arg_1, _arg_2, military));
        }

        public static function GetNPCUrl(_arg_1:String):String
        {
            return (cFilenameUtil.findHashMapping(("icons/npc/" + _arg_1)));
        }

        public static function GetBuffCursorType_string(_arg_1:String):String
        {
            return (buffCursorTypes[_arg_1]);
        }

        public static function ColorFilterImage(_arg_1:Bitmap, _arg_2:uint):Bitmap
        {
            var _local_3:ColorMatrixFilter;
            if (((!(_arg_1 == null)) && (!(_arg_1.bitmapData == null))))
            {
                _local_3 = coloringFilter(_arg_2);
                _arg_1.bitmapData.applyFilter(_arg_1.bitmapData, _arg_1.bitmapData.rect, new Point(), _local_3);
            };
            return (_arg_1);
        }

        public static function GetBin(_arg_1:String):ByteArray
        {
            if (binFiles == null)
            {
                return (null);
            };
            var _local_2:ByteArray = binFiles.getBytes(_arg_1);
            if (_local_2 == null)
            {
                while (_arg_1.indexOf("/") > -1)
                {
                    _arg_1 = _arg_1.replace("/", "\\");
                };
                _local_2 = binFiles.getBytes(_arg_1);
            };
            return (_local_2);
        }

        public static function GetWidgetUrl(_arg_1:String):String
        {
            return (cFilenameUtil.findHashMapping((("widget/" + _arg_1) + ".png")));
        }

        public static function GetScaleBitmap(_arg_1:String, _arg_2:Rectangle, _arg_3:int, _arg_4:int, _arg_5:Boolean=true):Bitmap
        {
            var _local_6:ScaleBitmap = new ScaleBitmap(GetGfx(_arg_1, _arg_5).bitmapData);
            _local_6.scale9Grid = _arg_2;
            _local_6.width = _arg_3;
            _local_6.height = _arg_4;
            return (_local_6);
        }

        public static function GetShaderFilter():ShaderFilter
        {
            return (inactiveFilter);
        }

        public static function GetBuildingIcon(_arg_1:String, _arg_2:Boolean=true):Bitmap
        {
            return (GetGfx(_arg_1, _arg_2, buildings));
        }

        public static function GetBitmapNumber(_arg_1:int, _arg_2:String):Bitmap
        {
            var _local_3:int;
            var _local_4:Bitmap;
            var _local_5:int;
            var _local_6:int;
            var _local_7:BitmapData;
            var _local_8:Point;
            if (!renderedNumbers[(_arg_2 + _arg_1)])
            {
                _local_3 = Math.max(1, int(((Math.log(_arg_1) * Math.LOG10E) + 1)));
                _local_5 = 0;
                _local_6 = _arg_1;
                do 
                {
                    _local_4 = new (gAssetManager[(_arg_2 + (_local_6 % 10))])();
                    _local_5 = (_local_5 + _local_4.width);
                    _local_6 = int((_local_6 / 10));
                } while (_local_6 > 0);
                _local_7 = new BitmapData(_local_5, _local_4.height);
                _local_7.lock();
                _local_8 = new Point(_local_7.width, 0);
                _local_6 = _arg_1;
                do 
                {
                    _local_4 = new (gAssetManager[(_arg_2 + (_local_6 % 10))])();
                    _local_8.x = (_local_8.x - _local_4.width);
                    _local_7.copyPixels(_local_4.bitmapData, _local_4.getRect(_local_4), _local_8);
                    _local_6 = int((_local_6 / 10));
                } while (_local_6 > 0);
                _local_7.unlock();
                renderedNumbers[(_arg_2 + _arg_1)] = new Bitmap(_local_7);
            };
            return (renderedNumbers[(_arg_2 + _arg_1)]);
        }

        public static function GetBuffCursorTypeForeign_string(_arg_1:String):String
        {
            return (buffCursorTypesForeign[_arg_1]);
        }

        public static function GetBitmap(_arg_1:String, _arg_2:Boolean=true):Bitmap
        {
            return (GetGfx(_arg_1, _arg_2));
        }

        public static function GetClass(_name_string:String):Class
        {
            var c:Class;
            if (_name_string == "")
            {
                cLog.warning(("gAssetManager.GetClass(): Empty class name given! Called from: " + gMisc.GetCallingMethodName(3)));
                return (new Class());
            };
            try
            {
                c = (gAssetManager[_name_string] as Class);
            }
            catch(e:Error)
            {
                cLog.warning(((('gAssetManager.GetClass(): Class "' + _name_string) + '" not found! Called from: ') + gMisc.GetCallingMethodName(3)));
                c = new Class();
            };
            return (c);
        }

        private static function CompleteHandlerAMFPackLoaderBIN(_arg_1:Event):void
        {
            var _local_2:BinDataHolderVO = ((_arg_1.target as TSOURLLoader).data as ByteArray).readObject();
            binFiles = new BinFileMap(_local_2);
            countLoaded++;
            completeFunction(_arg_1);
            LoadExtraParts(_local_2, (_arg_1.target as TSOURLLoader).filename);
        }

        public static function GetEventWindowImageUrl(_arg_1:String):String
        {
            return (cFilenameUtil.findHashMapping(("eventwindow/" + _arg_1)));
        }

        private static function TurnToGreyScale(_arg_1:Bitmap):Bitmap
        {
            if (_arg_1 == null)
            {
                return (null);
            };
            var _local_2:BitmapData = _arg_1.bitmapData;
            _local_2.applyFilter(_local_2, _local_2.rect, new Point(), inactiveFilter);
            _arg_1.bitmapData = _local_2;
            return (_arg_1);
        }

        public static function GetGfx(_arg_1:String, _arg_2:Boolean=true, _arg_3:BitmapFileMap=null):Bitmap
        {
            var _local_6:int;
            var _local_7:BitmapFileMap;
            var _local_4:Bitmap;
            var _local_5:Boolean;
            if (((_arg_1 == null) || (_arg_1.length == 0)))
            {
                cLog.warning(((('gAssetManager.GetGfx(): Bitmap "' + _arg_1) + '"   Not found! Called from: ') + gMisc.GetCallingMethodName(3)));
                _local_5 = true;
            }
            else
            {
                if (_arg_3 == null)
                {
                    if (gAssetManager[_arg_1])
                    {
                        _local_4 = (new (gAssetManager[_arg_1])() as Bitmap);
                    }
                    else
                    {
                        _local_5 = true;
                    };
                }
                else
                {
                    _local_4 = CloneBitmap(_arg_3.getBitmap(_arg_1));
                };
                if (((_local_5) || (!(_local_4))))
                {
                    _local_6 = 0;
                    while (_local_6 < loadedGfxVector.length)
                    {
                        _local_7 = (loadedGfxVector[_local_6] as BitmapFileMap);
                        if (_local_7.getBitmap(_arg_1) != null)
                        {
                            _local_4 = CloneBitmap(_local_7.getBitmap(_arg_1));
                            break;
                        };
                        if (((_arg_1.indexOf("$") == 0) && (_arg_1.indexOf("_") > 2)))
                        {
                            _local_4 = CloneBitmap(_local_7.getBitmap((_arg_1.split("_")[0] + "*")));
                            if (_local_4 != null) break;
                        };
                        _local_6++;
                    };
                    if (!_local_4)
                    {
                        cLog.warning(((('gAssetManager.GetGfx(): Bitmap "' + _arg_1) + '"   Not found! Called from: ') + gMisc.GetCallingMethodName(3)));
                    };
                };
            };
            if (!_local_4)
            {
                return (dummy);
            };
            return ((_arg_2) ? _local_4 : TurnToGreyScale(_local_4));
        }

        private static function CompleteHandlerAMFPackLoader(event:Event):void
        {
            var dictionary:String;
            var gfxArray:BinDataHolderVO = ((event.target as TSOURLLoader).data as ByteArray).readObject();
            var filename:String = (event.target as TSOURLLoader).filename;
            switch (filename.substring(10, (filename.length - 4)).replace(/[0-9]/g, ""))
            {
                case "buildingicons":
                    dictionary = defines.RESOURCE_DICTIONARY_BUILDINGS;
                    break;
                case "ressourceicons":
                    dictionary = defines.RESOURCE_DICTIONARY_RESOURCES;
                    break;
                case "battleicons":
                    dictionary = defines.RESOURCE_DICTIONARY_MILITARY;
                    break;
                case "bufficons":
                case "adventureicons":
                    dictionary = defines.RESOURCE_DICTIONARY_BUFFS;
                    break;
                case "shopicons":
                    dictionary = defines.RESOURCE_DICTIONARY_SHOPITEMS;
                    break;
                case "iconspack":
                    dictionary = defines.RESOURCE_DICTIONARY_ICONSPACK;
                    break;
            };
            var mapped:BitmapFileMap = (gAssetManager[dictionary] as BitmapFileMap);
            mapped.loadBitmaps(gfxArray, function ():void
            {
                completeFunction(null);
            });
            countLoaded++;
            LoadExtraParts(gfxArray, filename);
        }

        public static function GetBuffIcon(_arg_1:String, _arg_2:Boolean=true):Bitmap
        {
            return (GetGfx(_arg_1, _arg_2, buffs));
        }

        public static function GetIcon(_arg_1:String, _arg_2:String, _arg_3:Boolean=true):Bitmap
        {
            return (GetGfx(_arg_1, _arg_3, gAssetManager[_arg_2]));
        }

        public static function GetPvPMinimapUrl(_arg_1:String):String
        {
            return (cFilenameUtil.findHashMapping((("combat3pvpreport/" + _arg_1) + ".png")));
        }

        private static function getIconFromLookupName(_arg_1:String, _arg_2:Boolean=true):*
        {
            var _local_4:BitmapFileMap;
            var _local_3:Array = _arg_1.split(":");
            if (_local_3.length == 2)
            {
                _local_4 = null;
                switch (String(_local_3[0]).toLowerCase())
                {
                    case "buildings":
                        _local_4 = buildings;
                        break;
                    case "buffs":
                        _local_4 = buffs;
                        break;
                    case "military":
                        _local_4 = military;
                        break;
                    case "resources":
                        _local_4 = resources;
                        break;
                    case "shopitems":
                        _local_4 = shopItems;
                        break;
                    case "iconspack":
                        _local_4 = iconspack;
                        break;
                };
                if (_local_4)
                {
                    return (GetGfx(_local_3[1], true, _local_4));
                };
            };
            return (null);
        }

        public static function GetBitmapData(_arg_1:String, _arg_2:Boolean=true):BitmapData
        {
            return (GetGfx(_arg_1, _arg_2).bitmapData);
        }

        public static function LoadIcons(_arg_1:String, _arg_2:Function):void
        {
            var _local_6:cXML;
            var _local_7:String;
            var _local_8:String;
            var _local_9:String;
            var _local_10:String;
            completeFunction = _arg_2;
            var _local_3:BitmapData = new BitmapData(1, 1);
            _local_3.setPixel32(0, 0, 0);
            dummy = new Bitmap(_local_3);
            var _local_4:cXML = global.gfxSettingsGameObjectsXML.MoveToSubNode("AvailableBuffs");
            var _local_5:Vector.<cXML> = _local_4.CreateChildrenArray();
            for each (_local_6 in _local_5)
            {
                _local_7 = _local_6.GetAttributeString_string("name");
                _local_8 = _local_6.GetAttributeString_string("iconfilename");
                _local_9 = _local_6.GetAttributeString_string("cursorType");
                if (_local_9 != "")
                {
                    buffCursorTypes[_local_7] = _local_9;
                };
                _local_10 = _local_6.GetAttributeString_string("foreignCursorType");
                if (_local_10 != "")
                {
                    buffCursorTypesForeign[_local_7] = _local_10;
                };
            };
            loadedGfxVector.push(iconspack);
            loadedGfxVector.push(resources);
            loadedGfxVector.push(buffs);
            loadedGfxVector.push(shopItems);
            loadedGfxVector.push(buildings);
            loadedGfxVector.push(military);
            registerClassAlias(BinDataHolderVO.JAVA_NAME, BinDataHolderVO);
            registerClassAlias(NamedDataBinVO.JAVA_NAME, NamedDataBinVO);
            registerClassAlias(NameToNamedDataVO.JAVA_NAME, NameToNamedDataVO);
            loadBin("buildingicons.bin", CompleteHandlerAMFPackLoader);
            loadBin("ressourceicons.bin", CompleteHandlerAMFPackLoader);
            loadBin("battleicons.bin", CompleteHandlerAMFPackLoader);
            loadBin("bufficons.bin", CompleteHandlerAMFPackLoader);
            loadBin("adventureicons.bin", CompleteHandlerAMFPackLoader);
            loadBin("shopicons.bin", CompleteHandlerAMFPackLoader);
            loadBin("iconspack.bin", CompleteHandlerAMFPackLoader);
            loadBin("binlibs.bin", CompleteHandlerAMFPackLoaderBIN);
            ButtonIconTravellingErudite = ButtonIconTravellingEruditeClass;
            ButtonIconBeanACollada = ButtonIconBeanAColladaClass;
        }

        public static function GetGuildBannerUrlById(_arg_1:int):String
        {
            return (cFilenameUtil.findHashMapping((("icons/guildbanner/banner" + ((_arg_1 < 10) ? ("0" + _arg_1) : _arg_1)) + ".png")));
        }

        public static function AddIconToImage(_arg_1:Bitmap, _arg_2:Bitmap, _arg_3:Point):Bitmap
        {
            _arg_1.bitmapData.copyPixels(_arg_2.bitmapData, _arg_2.bitmapData.rect, _arg_3, null, null, true);
            return (_arg_1);
        }

        public static function GetBitmapModifier(_arg_1:int, _arg_2:String):Bitmap
        {
            var _local_3:BitmapData;
            var _local_4:Bitmap;
            var _local_5:Bitmap;
            var _local_6:Bitmap;
            if (!renderedModifiers[(_arg_1.toString() + _arg_2)])
            {
                _local_4 = GetBitmapNumber(_arg_1, "HappyHourDigit");
                if (StringUtils.equalsIgnoreCase(_arg_2, "percent"))
                {
                    _local_5 = new (gAssetManager["percent"])();
                    _local_3 = new BitmapData((_local_5.width + _local_4.width), _local_4.height);
                    _local_3.lock();
                    _local_3.copyPixels(_local_4.bitmapData, _local_4.getRect(_local_4), new Point(0, 0));
                    _local_3.copyPixels(_local_5.bitmapData, _local_5.getRect(_local_4), new Point(_local_4.width, 0));
                }
                else
                {
                    _local_6 = new (gAssetManager["plus"])();
                    _local_3 = new BitmapData((_local_6.width + _local_4.width), _local_4.height);
                    _local_3.lock();
                    _local_3.copyPixels(_local_6.bitmapData, _local_6.getRect(_local_4), new Point(0, 0));
                    _local_3.copyPixels(_local_4.bitmapData, _local_4.getRect(_local_4), new Point(_local_6.width, 0));
                };
                _local_3.unlock();
                renderedModifiers[(_arg_1.toString() + _arg_2)] = new Bitmap(_local_3);
            };
            return (renderedModifiers[(_arg_1.toString() + _arg_2)]);
        }

        public static function IsLoaded():Boolean
        {
            if (countTotal == countLoaded)
            {
                return (true);
            };
            return (false);
        }

        public static function GetShopIcon(_arg_1:String, _arg_2:Boolean=true):Bitmap
        {
            return (GetGfx(_arg_1, _arg_2, shopItems));
        }

        public static function CheckGraphicsFileNameExtension(_arg_1:String):void
        {
            var _local_2:String = _arg_1.substr(_arg_1.lastIndexOf("."));
            if (((!(_local_2 == ".png")) && (!(_local_2 == ".jpg"))))
            {
                throw (new Error((("Error!: Extension " + _local_2) + " is not allowed!")));
            };
        }

        public static function GetDummyIcon(_arg_1:String, _arg_2:Boolean=true):*
        {
            return (getIconFromLookupName(_arg_1, _arg_2));
        }

        public static function GetNewQuestTriggerIcon(_arg_1:TriggerVO, _arg_2:Boolean=true):*
        {
            var _local_3:*;
            if (_arg_1.icon_string)
            {
                _local_3 = getIconFromLookupName(_arg_1.icon_string, _arg_2);
                if (!_local_3)
                {
                    _local_3 = GetGfx(_arg_1.icon_string, _arg_2);
                };
            }
            else
            {
                switch (_arg_1.action_string)
                {
                    case TRIGGER_ACTION.ACTION_COMPLETE_ADVENTURE_LIST_string:
                        if (_arg_1.loca_string == "Adv_Single")
                        {
                            _local_3 = GetBuffIcon(_arg_1.type_string);
                        }
                        else
                        {
                            _local_3 = GetBitmap("AdventureAvatarDefault");
                        };
                        break;
                    case TRIGGER_ACTION.ACTION_TIMED_PRODUCED_ITEM_LIST_string:
                    case TRIGGER_ACTION.ACTION_PRODUCTION_VALUE_string:
                        if (((_arg_1.type_string == "Military") || (!(cMilitaryUnitBase.GetUnitBaseForType(_arg_1.item_string) == null))))
                        {
                            _local_3 = GetMilitaryIcon(_arg_1.item_string);
                        }
                        else
                        {
                            _local_3 = GetResourceIcon(_arg_1.item_string);
                        };
                        break;
                    case TRIGGER_ACTION.ACTION_RESOURCE_GATHERED_string:
                        _local_3 = GetResourceIcon((((!(_arg_1.item_string == null)) && (_arg_1.item_string.length > 0)) ? _arg_1.item_string : _arg_1.type_string));
                        break;
                    case TRIGGER_ACTION.ACTION_PLAYERLEVEL_string:
                        _local_3 = GetResourceIcon("XP");
                        break;
                    case TRIGGER_ACTION.ACTION_BUFF_APPLIED_string:
                    case TRIGGER_ACTION.ACTION_BUFF_APPLIED_ON_ADVENTURE_string:
                    case TRIGGER_ACTION.ACTION_BUFF_OWNED_string:
                    case TRIGGER_ACTION.ACTION_BUILDING_DESTROYED_string:
                    case TRIGGER_ACTION.ACTION_BUFF_PRODUCED_string:
                        if (_arg_1.item_string != "")
                        {
                            _local_3 = GetBuffIcon(_arg_1.item_string);
                        }
                        else
                        {
                            if (_arg_1.target_string != "")
                            {
                                _local_3 = GetBuildingIcon(_arg_1.target_string);
                            }
                            else
                            {
                                _local_3 = GetBitmap("ButtonIconCrown");
                            };
                        };
                        break;
                    case TRIGGER_ACTION.ACTION_SECTOR_EXPLORED_string:
                        _local_3 = GetBitmap("ButtonIconExploreSector");
                        break;
                    case TRIGGER_ACTION.ACTION_BUILDING_UPGRADED_string:
                    case TRIGGER_ACTION.ACTION_BUILDING_UPGRADELEVEL_string:
                        _local_3 = GetBitmap("ButtonIconUpgrade");
                        break;
                    case TRIGGER_ACTION.ACTION_ONMAP_string:
                        if (_arg_1.item_string == "Deco")
                        {
                            _local_3 = GetBuildingIcon("flowerbed_yellow");
                            break;
                        };
                    case TRIGGER_ACTION.ACTION_BUILDING_SELECTED_string:
                        _local_3 = GetBuildingIcon(_arg_1.item_string);
                        break;
                    case TRIGGER_ACTION.ACTION_GARRISON_ON_MAP_string:
                        _local_3 = GetBuildingIcon("Garrison");
                        break;
                    case TRIGGER_ACTION.ACTION_LOOTED_RESOURCE_string:
                        if (_arg_1.type_string != "")
                        {
                            _local_3 = GetResourceIcon(_arg_1.type_string);
                        };
                        break;
                    default:
                        _local_3 = GetBitmap("ButtonIconScroll");
                };
            };
            if (((!(_local_3)) || (_local_3 == dummy)))
            {
                _local_3 = GetBitmap("ButtonIconScroll");
            };
            if (((_local_3 is Bitmap) && (!(_arg_2))))
            {
                _local_3 = TurnToGreyScale((_local_3 as Bitmap));
            };
            return (_local_3);
        }

        public static function GetHelpImageUrl(_arg_1:String, _arg_2:int):String
        {
            return (cFilenameUtil.findHashMapping((((("help/" + _arg_1) + "_") + _arg_2) + ".png")));
        }

        private static function LoadExtraParts(_arg_1:BinDataHolderVO, _arg_2:String):void
        {
            var _local_3:int;
            var _local_4:String;
            if (_arg_1.extraParts > 0)
            {
                _local_3 = 2;
                while (_local_3 <= _arg_1.extraParts)
                {
                    _local_4 = _arg_2.replace("amfpacker/", "");
                    loadBin(_local_4.replace(".bin", ((_local_3 - 1) + ".bin")), CompleteHandlerAMFPackLoader);
                    _local_3++;
                };
            };
        }

        public static function GetAvatarUrl(_arg_1:int, _arg_2:String="large"):String
        {
            return (cFilenameUtil.findHashMapping((((("icons/avatars/" + _arg_2) + "/Avatar") + ((_arg_1 < 10) ? ("0" + _arg_1) : _arg_1)) + ".png")));
        }

        private static function loadBin(_arg_1:String, _arg_2:Function):void
        {
            var _local_3:TSOURLLoader = new TSOURLLoader();
            _local_3.addEventListener(Event.COMPLETE, _arg_2, false, 0, true);
            _local_3.loadFile(("amfpacker/" + _arg_1));
            countTotal++;
        }

        public static function GetFacebookAchievementUrl(_arg_1:String):String
        {
            return (cFilenameUtil.findHashMapping(("icons/achievements/facebook/" + _arg_1)));
        }

        public static function GetSpecialistIcon(_arg_1:String, _arg_2:Boolean=true):Bitmap
        {
            return (GetGfx((("icon_" + _arg_1.toLowerCase()) + ".png"), _arg_2));
        }

        public static function GetQuestTriggerIcon(_arg_1:dQuestDefinitionTriggerVO, _arg_2:Boolean=true):*
        {
            var _local_3:*;
            var _local_4:String;
            var _local_5:cAdventureDefinition;
            if (_arg_1.icon_string)
            {
                return (getIconFromLookupName(_arg_1.icon_string, _arg_2));
            };
            switch (_arg_1.type)
            {
                case QuestManagerStatic.TYPE_BUILDING:
                    if (_arg_1.condition == QuestManagerStatic.CONDITION_DESTROYED)
                    {
                        if (_arg_1.name_string.indexOf(defines.EVENT_MONSTER_NAME_string) != -1)
                        {
                            _local_3 = GetBuildingIcon(_arg_1.name_string);
                        }
                        else
                        {
                            _local_3 = GetBuildingIcon("Bandits");
                        };
                    }
                    else
                    {
                        if (((_arg_1.condition == QuestManagerStatic.CONDITION_UPGRADED) || (_arg_1.condition == QuestManagerStatic.CONDITION_LEVEL_UPGRADE)))
                        {
                            _local_3 = GetBitmap("ButtonIconUpgrade");
                        }
                        else
                        {
                            if (buildings.getBitmap(_arg_1.name_string) != null)
                            {
                                _local_3 = GetBuildingIcon(_arg_1.name_string);
                            }
                            else
                            {
                                _local_3 = GetBitmap("ButtonIconScroll");
                            };
                        };
                    };
                    break;
                case QuestManagerStatic.TYPE_RESOURCE:
                case QuestManagerStatic.TYPE_PAY_FOR_QUEST_FINISH:
                    if (_arg_1.name_string != "")
                    {
                        _local_4 = _arg_1.name_string;
                        if (_local_4 == "Adventure")
                        {
                            _local_4 = _arg_1.resourceType_string;
                        };
                        if (global.resourceDefinitions_vector.indexOf(_local_4) != -1)
                        {
                            _local_3 = GetResourceIcon(_local_4);
                        }
                        else
                        {
                            if (cMilitaryUnitBase.GetUnitBaseForType(_local_4) != null)
                            {
                                _local_3 = GetMilitaryIcon(_local_4);
                            }
                            else
                            {
                                _local_3 = GetBitmap("ButtonIconScroll");
                            };
                        };
                    }
                    else
                    {
                        _local_3 = GetBitmap("ButtonIconScroll");
                    };
                    break;
                case QuestManagerStatic.TYPE_SPECIALIST:
                    if (_arg_1.condition == QuestManagerStatic.CONDITION_FOUND_DEPOSIT)
                    {
                        _local_3 = GetResourceIcon(_arg_1.name_string);
                    }
                    else
                    {
                        if (_arg_1.condition == QuestManagerStatic.CONDITION_ASSIGNED_UNITS)
                        {
                            _local_3 = GetBitmap("IconGeneral");
                        }
                        else
                        {
                            _local_3 = GetBitmap(("Icon" + _arg_1.name_string));
                        };
                    };
                    break;
                case QuestManagerStatic.TYPE_BUFF:
                case QuestManagerStatic.TYPE_BUFF_BY_FRIEND:
                case QuestManagerStatic.TYPE_BUFF_ON_FRIEND:
                    if (_arg_1.actionName_string != "")
                    {
                        _local_3 = GetBuffIcon(_arg_1.actionName_string);
                    }
                    else
                    {
                        if (_arg_1.name_string.indexOf(defines.EVENT_MONSTER_NAME_string) != -1)
                        {
                            _local_3 = GetMilitaryIcon("EpicMonsterHeart1");
                        }
                        else
                        {
                            if (_arg_1.condition == QuestManagerStatic.CONDITION_CONSUME)
                            {
                                _local_3 = GetBitmap("StarMenuIcon");
                            }
                            else
                            {
                                if (_arg_1.condition == QuestManagerStatic.CONDITION_PRODUCE)
                                {
                                    _local_3 = GetBuildingIcon("ProvisionHouse");
                                }
                                else
                                {
                                    _local_3 = GetBitmap("ButtonIconCrown");
                                };
                            };
                        };
                    };
                    break;
                case QuestManagerStatic.TYPE_MILITARYUNIT:
                    _local_3 = GetMilitaryIcon(_arg_1.name_string);
                    break;
                case QuestManagerStatic.TYPE_PLAYERLEVEL:
                    _local_3 = GetResourceIcon("XP");
                    break;
                case QuestManagerStatic.TYPE_ADVENTURE:
                    if (_arg_1.name_string != "")
                    {
                        _local_5 = cAdventureDefinition.FindAdventureDefinition(_arg_1.name_string);
                        if (_local_5 != null)
                        {
                            _local_3 = _local_5.GetAvatarImage();
                        }
                        else
                        {
                            _local_3 = GetBitmap("AdventureAvatarDefault");
                        };
                    }
                    else
                    {
                        _local_3 = GetBitmap("AdventureAvatarDefault");
                    };
                    break;
                case QuestManagerStatic.TYPE_SECTOR:
                    if ((((_arg_1.condition == QuestManagerStatic.CONDITION_EXPLORED) || (_arg_1.condition == QuestManagerStatic.CONDITION_EXPLORE_GREATER_OR_EQUAL_DELTA)) || (_arg_1.condition == QuestManagerStatic.CONDITION_EXPLORE_GREATER_OR_EQUAL)))
                    {
                        _local_3 = GetBitmap("ButtonIconExploreSector");
                    }
                    else
                    {
                        if ((((_arg_1.condition == QuestManagerStatic.CONDITION_CLAIMED) || (_arg_1.condition == QuestManagerStatic.CONDITION_CLAIMED_GREATER_OR_EQUAL)) || (_arg_1.condition == QuestManagerStatic.CONDITION_CLAIMED_LESS)))
                        {
                            _local_3 = GetBuildingIcon(defines.WAREHOUSES_NAME_string);
                        }
                        else
                        {
                            _local_3 = GetBitmap("ButtonIconScroll");
                        };
                    };
                    break;
                case QuestManagerStatic.TYPE_FINISHPERCENTAGE:
                    _local_3 = GetBitmap("ButtonIconCrown");
                    break;
                case QuestManagerStatic.TYPE_BANDITS:
                    _local_3 = GetBuildingIcon("Bandits");
                    break;
                default:
                    _local_3 = GetBitmap("ButtonIconScroll");
            };
            if (((_local_3 is Bitmap) && (!(_arg_2))))
            {
                _local_3 = TurnToGreyScale((_local_3 as Bitmap));
            };
            return (_local_3);
        }


    }
}//package GUI.Assets

import mx.core.BitmapAsset;
import GUI.Assets.gAssetManager;

class ButtonIconBeanAColladaClass extends BitmapAsset 
{

    public function ButtonIconBeanAColladaClass()
    {
        super(gAssetManager.GetBitmap("icon_bean_a_colada.png").bitmapData);
    }

}

class ButtonIconTravellingEruditeClass extends BitmapAsset 
{

    public function ButtonIconTravellingEruditeClass()
    {
        super(gAssetManager.GetBitmap("icon_travelling_erudite.png").bitmapData);
    }

}






