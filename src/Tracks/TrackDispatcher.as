package Tracks
{
    import Model.Notifier;
    import __AS3__.vec.Vector;
    import Communication.VO.UpdateVO.dAdventurePlayerVO;
    import Utils.HashMapWrapper;
    import ServerState.cPlayerData;
    import MilitarySystem.cCombat;
    import Specialists.cSpecialistSubTaskDefinition;
    import Specialists.cSpecialist;
    import AdventureSystem.cAdventure;
    import Colony.cColony;
    import ServerState.dResource;
    import Skill.cSkillTree;
    import Communication.VO.Skill.ChangeSkillsVO;
    import GO.cBuilding;
    import Communication.VO.dTradeCompleteVO;
    import Communication.VO.Skill.ResetSkillsVO;
    import TimedProduction.cTimedProductionQueue;
    import GO.cDeposit;
    import Communication.VO.dContentGeneratorRollVO;
    import Communication.VO.dAdventCalendarDoorVO;
    import BuffSystem.cBuff;
    import GO.cGO;
    import Communication.VO.Fulfilments.IdentityVO;
    import Fulfilments.IdentityDefinition;
    import Communication.VO.EffectListVO;
    import ServerState.cTradeObject;
    import Communication.VO.dAcceptTradeVO;
    import Communication.VO.dResourceVO;
    import Communication.VO.dBuffVO;
    import Communication.VO.UpdateVO.dLootItemsVO;
    import Communication.VO.ColonyVO;
    import Achievements.UserAchievement;
    import Interface.cGeneralInterface;
    import Communication.VO.UpdateVO.dBattleResultVO;
    import Communication.VO.dArmyVO;
    import Communication.VO.dQuestElementVO;
    import TimedProduction.cTimedProduction;
    import Communication.VO.Votes.dPlayerVoteVO;

    public class TrackDispatcher extends Notifier 
    {


        public function flush():void
        {
        }

        public function trackAdventure(_arg_1:int, _arg_2:int, _arg_3:String, _arg_4:Number, _arg_5:Vector.<dAdventurePlayerVO>, _arg_6:HashMapWrapper, _arg_7:int, _arg_8:Number):void
        {
        }

        public function trackGemsProduction(_arg_1:cPlayerData, _arg_2:String, _arg_3:int, _arg_4:int, _arg_5:String):void
        {
        }

        public function trackCombat3BattleResult(_arg_1:int, _arg_2:int, _arg_3:cCombat, _arg_4:int):void
        {
        }

        public function trackBuyGuildBankTabForGems(_arg_1:cPlayerData, _arg_2:String, _arg_3:int, _arg_4:int):void
        {
        }

        public function trackSpecialistTaskFinished(_arg_1:cPlayerData, _arg_2:int, _arg_3:cSpecialistSubTaskDefinition, _arg_4:cSpecialist, _arg_5:Object, _arg_6:String):void
        {
        }

        public function trackEventCleanedUp(_arg_1:int, _arg_2:String):void
        {
        }

        public function trackExpeditionTimeout(_arg_1:cPlayerData, _arg_2:cAdventure, _arg_3:cColony, _arg_4:int, _arg_5:int, _arg_6:int, _arg_7:Number, _arg_8:Boolean):void
        {
        }

        public function trackBuyEnlargeGuildBank(_arg_1:cPlayerData, _arg_2:String, _arg_3:Vector.<dResource>, _arg_4:int):void
        {
        }

        public function trackUseSkillPoint(_arg_1:cPlayerData, _arg_2:cSkillTree, _arg_3:ChangeSkillsVO):void
        {
        }

        public function trackUI(_arg_1:int, _arg_2:String, _arg_3:String, _arg_4:int, _arg_5:Boolean):void
        {
        }

        public function trackBuyGuildBankTab(_arg_1:cPlayerData, _arg_2:String, _arg_3:Vector.<dResource>, _arg_4:int):void
        {
        }

        public function trackReimbursedAdventure(_arg_1:int, _arg_2:int, _arg_3:String, _arg_4:Number, _arg_5:Vector.<dAdventurePlayerVO>, _arg_6:HashMapWrapper):void
        {
        }

        public function trackLeaveGuild(_arg_1:int, _arg_2:String):void
        {
        }

        public function trackBuildingPlace(_arg_1:cPlayerData, _arg_2:cBuilding):void
        {
        }

        public function trackQuestStarted(_arg_1:cPlayerData, _arg_2:String, _arg_3:int):void
        {
        }

        public function trackTradeDeletedMarketplace(_arg_1:dTradeCompleteVO):void
        {
        }

        public function trackResetSkillTree(_arg_1:cPlayerData, _arg_2:cSkillTree, _arg_3:ResetSkillsVO, _arg_4:int):void
        {
        }

        public function trackProductionAllCancelled(_arg_1:cPlayerData, _arg_2:cTimedProductionQueue):void
        {
        }

        public function trackSessionLogout(_arg_1:int, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Boolean):void
        {
        }

        public function trackPvpLevelClaimed(_arg_1:cPlayerData, _arg_2:int):void
        {
        }

        public function trackGainSpecialist(_arg_1:cSpecialist, _arg_2:int, _arg_3:int, _arg_4:Boolean, _arg_5:int):void
        {
        }

        public function trackFoundGuild(_arg_1:int, _arg_2:String):void
        {
        }

        public function trackAdventureInvitationSent(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:String):void
        {
        }

        public function trackDepositDepleted(_arg_1:cPlayerData, _arg_2:cDeposit, _arg_3:cBuilding):void
        {
        }

        public function trackSendGift(_arg_1:int, _arg_2:int, _arg_3:String):void
        {
        }

        public function trackBuyEnlargeGuildBankForGems(_arg_1:cPlayerData, _arg_2:String, _arg_3:int, _arg_4:int):void
        {
        }

        public function trackAdventureInvitationAccepted(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:String):void
        {
        }

        public function trackDeleteBuff(_arg_1:int, _arg_2:String, _arg_3:String, _arg_4:int, _arg_5:int, _arg_6:int):void
        {
        }

        public function trackExpeditionWon(_arg_1:cPlayerData, _arg_2:cAdventure, _arg_3:cColony, _arg_4:int, _arg_5:int, _arg_6:int, _arg_7:Number, _arg_8:Boolean, _arg_9:int):void
        {
        }

        public function trackLeaveAdventure(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:String):void
        {
        }

        public function trackExpeditionStarted(_arg_1:cPlayerData, _arg_2:int, _arg_3:int, _arg_4:int, _arg_5:String):void
        {
        }

        public function trackDonateEventResource(_arg_1:String, _arg_2:int, _arg_3:cPlayerData):void
        {
        }

        public function trackBuyItemPromotion(_arg_1:cPlayerData, _arg_2:String, _arg_3:Vector.<dResource>, _arg_4:int):void
        {
        }

        public function trackGemAdded(_arg_1:cPlayerData, _arg_2:String, _arg_3:int, _arg_4:int, _arg_5:String):void
        {
        }

        public function trackSessionLogin(_arg_1:int, _arg_2:Number):void
        {
        }

        public function trackPvpLevelUp(_arg_1:cPlayerData, _arg_2:int):void
        {
        }

        public function trackContentGeneratorCompleteCollection(_arg_1:cPlayerData, _arg_2:dContentGeneratorRollVO):void
        {
        }

        public function trackPickupCollectible(_arg_1:cPlayerData, _arg_2:String, _arg_3:String, _arg_4:int):void
        {
        }

        public function trackUsePremiumAccountItem(_arg_1:cPlayerData, _arg_2:String, _arg_3:int):void
        {
        }

        public function trackGemsContentGenerator(_arg_1:cPlayerData, _arg_2:int, _arg_3:int):void
        {
        }

        public function trackUsernameUpdate(_arg_1:int, _arg_2:String):void
        {
        }

        public function trackGemQuestRewarded(_arg_1:cPlayerData, _arg_2:String, _arg_3:int, _arg_4:int, _arg_5:String):void
        {
        }

        public function trackAvatarUpdate(_arg_1:int, _arg_2:int):void
        {
        }

        public function trackEventStarted(_arg_1:int, _arg_2:String):void
        {
        }

        public function trackAdventureInvitationCancelled(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:String):void
        {
        }

        public function trackLevelUp(_arg_1:cPlayerData, _arg_2:String, _arg_3:int):void
        {
        }

        public function trackAdventCalendarDoorOpened(_arg_1:dAdventCalendarDoorVO, _arg_2:cPlayerData):void
        {
        }

        public function trackGuildBankTransaction(_arg_1:int, _arg_2:String, _arg_3:String, _arg_4:int):void
        {
        }

        public function trackUnitsHired(_arg_1:cPlayerData, _arg_2:String, _arg_3:int, _arg_4:String):void
        {
        }

        public function trackBuffFriend(_arg_1:cBuff, _arg_2:cGO, _arg_3:int):void
        {
        }

        public function trackExpeditionCanceled(_arg_1:cPlayerData, _arg_2:cAdventure, _arg_3:cColony, _arg_4:int, _arg_5:int, _arg_6:int, _arg_7:Number, _arg_8:Boolean):void
        {
        }

        public function trackVisitFriend(_arg_1:int, _arg_2:int, _arg_3:Number, _arg_4:Number):void
        {
        }

        public function trackLockedZone(_arg_1:int, _arg_2:int, _arg_3:String):void
        {
        }

        public function trackAdventCalendarDoorOpenedWithGems(_arg_1:dAdventCalendarDoorVO, _arg_2:cPlayerData, _arg_3:int):void
        {
        }

        public function trackTaskBuildingResult(_arg_1:cPlayerData, _arg_2:Vector.<IdentityVO>, _arg_3:Vector.<IdentityDefinition>):void
        {
        }

        public function trackBuildingUpdgrade(_arg_1:cPlayerData, _arg_2:cBuilding, _arg_3:Boolean):void
        {
        }

        public function trackBuffsProduction(_arg_1:cPlayerData, _arg_2:String, _arg_3:int):void
        {
        }

        public function trackBuildingMove(_arg_1:cPlayerData, _arg_2:cBuilding, _arg_3:Boolean):void
        {
        }

        public function trackTaskBuildingReward(_arg_1:int, _arg_2:String, _arg_3:EffectListVO, _arg_4:Boolean):void
        {
        }

        public function trackAddFriend(_arg_1:int, _arg_2:int):void
        {
        }

        public function trackEventMonsterDestroyed(_arg_1:int, _arg_2:String):void
        {
        }

        public function trackExpeditionDefenseDone(_arg_1:cPlayerData, _arg_2:int, _arg_3:int, _arg_4:int, _arg_5:int, _arg_6:int, _arg_7:int, _arg_8:int):void
        {
        }

        public function trackGeneralTravel(_arg_1:cSpecialist, _arg_2:int):void
        {
        }

        public function trackTradeDeclinedF2F(_arg_1:cTradeObject):void
        {
        }

        public function trackExternalFriendInviteCall(_arg_1:int):void
        {
        }

        public function trackBuyItemForGems(_arg_1:cPlayerData, _arg_2:String, _arg_3:int, _arg_4:int):void
        {
        }

        public function trackTradeAccepted(_arg_1:cPlayerData, _arg_2:dAcceptTradeVO, _arg_3:dResourceVO, _arg_4:dBuffVO, _arg_5:dResourceVO, _arg_6:dBuffVO, _arg_7:int):void
        {
        }

        public function trackGuildLeaderChange(_arg_1:int, _arg_2:String):void
        {
        }

        public function trackGuildRankAssigned(_arg_1:int, _arg_2:String, _arg_3:int, _arg_4:int):void
        {
        }

        public function trackCollectionsProduction(_arg_1:cPlayerData, _arg_2:String, _arg_3:int):void
        {
        }

        public function trackStackDeleteCollectibles(_arg_1:int):void
        {
        }

        public function trackProcessedExternalMessages(_arg_1:int, _arg_2:String, _arg_3:String):void
        {
        }

        public function trackClientLoaded():void
        {
        }

        public function trackGemReset(_arg_1:cPlayerData, _arg_2:String, _arg_3:int, _arg_4:int):void
        {
        }

        public function trackResourceMissing(_arg_1:cPlayerData, _arg_2:cBuilding, _arg_3:dResource):void
        {
        }

        public function trackExpeditionColonyAssigned(_arg_1:cPlayerData, _arg_2:int, _arg_3:int, _arg_4:int, _arg_5:int):void
        {
        }

        public function trackPickupReward(_arg_1:int, _arg_2:String, _arg_3:int, _arg_4:int, _arg_5:int):void
        {
        }

        public function trackMysteryBox(_arg_1:int, _arg_2:String, _arg_3:dLootItemsVO):void
        {
        }

        public function trackExpeditionColonyRemoved(_arg_1:cPlayerData, _arg_2:ColonyVO):void
        {
        }

        public function trackEpicWorkyardChainEnabled(_arg_1:cPlayerData, _arg_2:String, _arg_3:int):void
        {
        }

        public function trackEventStopped(_arg_1:int, _arg_2:String):void
        {
        }

        public function trackSpecialistTaskStarted(_arg_1:cPlayerData, _arg_2:int, _arg_3:cSpecialistSubTaskDefinition, _arg_4:cSpecialist, _arg_5:String):void
        {
        }

        public function trackConcurrentUsers(_arg_1:int):void
        {
        }

        public function trackAdventureInvitationExpired(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:String):void
        {
        }

        public function trackGainSkillPoint(_arg_1:cPlayerData, _arg_2:String, _arg_3:int, _arg_4:Vector.<dResource>, _arg_5:int):void
        {
        }

        public function trackAdventureInvitationDeclined(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:String):void
        {
        }

        public function trackGainAdventure(_arg_1:int, _arg_2:String):void
        {
        }

        public function trackAchievementCompleted(_arg_1:UserAchievement, _arg_2:cGeneralInterface):void
        {
        }

        public function trackAddBuff(_arg_1:int, _arg_2:String, _arg_3:String, _arg_4:int, _arg_5:int, _arg_6:int):void
        {
        }

        public function trackBuyItemWidget(_arg_1:cPlayerData, _arg_2:String, _arg_3:Vector.<dResource>, _arg_4:int, _arg_5:String):void
        {
        }

        public function trackApplyBuff(_arg_1:int, _arg_2:int, _arg_3:String, _arg_4:String, _arg_5:int, _arg_6:int, _arg_7:int):void
        {
        }

        public function trackTradeTimeoutF2F(_arg_1:cTradeObject):void
        {
        }

        public function trackBuildingDestroy(_arg_1:cPlayerData, _arg_2:cBuilding, _arg_3:String):void
        {
        }

        public function trackStackDeleteBuilding(_arg_1:int, _arg_2:String):void
        {
        }

        public function trackJoinGuild(_arg_1:int, _arg_2:String):void
        {
        }

        public function trackGemPurchased(_arg_1:cPlayerData, _arg_2:String, _arg_3:int, _arg_4:int, _arg_5:String):void
        {
        }

        public function trackBattleResult(_arg_1:cPlayerData, _arg_2:int, _arg_3:dBattleResultVO, _arg_4:cSpecialist, _arg_5:dArmyVO, _arg_6:dArmyVO, _arg_7:int):void
        {
        }

        public function trackContentGeneratorRoll(_arg_1:cPlayerData, _arg_2:dContentGeneratorRollVO):void
        {
        }

        public function trackDeleteVote(_arg_1:int, _arg_2:int):void
        {
        }

        public function trackQuestFinished(_arg_1:cPlayerData, _arg_2:String, _arg_3:int, _arg_4:dQuestElementVO, _arg_5:int):void
        {
        }

        public function trackGuildQuestFinished(_arg_1:int, _arg_2:int, _arg_3:String, _arg_4:dLootItemsVO):void
        {
        }

        public function trackEpicWorkyardBuffed(_arg_1:cPlayerData, _arg_2:String, _arg_3:String):void
        {
        }

        public function trackBuyItem(_arg_1:cPlayerData, _arg_2:String, _arg_3:Vector.<dResource>, _arg_4:int, _arg_5:String):void
        {
        }

        public function trackUseIslandDeed(_arg_1:cPlayerData, _arg_2:String):void
        {
        }

        public function trackProductionFinished(_arg_1:cPlayerData, _arg_2:cTimedProduction):void
        {
        }

        public function trackSendVote(_arg_1:int, _arg_2:dPlayerVoteVO):void
        {
        }


    }
}
