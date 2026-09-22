package Tracks
{
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
    import ServerState.cTradeObject;
    import Communication.VO.EffectListVO;
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
    import __AS3__.vec.*;

    public class TrackManager extends TrackDispatcher 
    {

        public static var FLUSH_EVENT:String = "FLUSH_EVENT";
        private static var instance:TrackManager;

        private var dispatchers:Vector.<TrackDispatcher> = new Vector.<TrackDispatcher>();

        public function TrackManager(_arg_1:SingletonEnforcer)
        {
            super();
            if (_arg_1 == null)
            {
                throw (new Error("TrackManager is a Singleton. Use getInstance() to use this class."));
            };
        }

        public static function getInstance():TrackManager
        {
            if (instance == null)
            {
                instance = new TrackManager(new SingletonEnforcer());
                instance.addTrackDispatcher(new WebGameObjectsTracking());
            };
            return (instance);
        }


        override public function flush():void
        {
            var _local_1:TrackDispatcher;
            for each (_local_1 in this.dispatchers)
            {
                _local_1.flush();
            };
        }

        override public function trackAdventure(_arg_1:int, _arg_2:int, _arg_3:String, _arg_4:Number, _arg_5:Vector.<dAdventurePlayerVO>, _arg_6:HashMapWrapper, _arg_7:int, _arg_8:Number):void
        {
            var _local_9:TrackDispatcher;
            for each (_local_9 in this.dispatchers)
            {
                _local_9.trackAdventure(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8);
            };
        }

        override public function trackGemsProduction(_arg_1:cPlayerData, _arg_2:String, _arg_3:int, _arg_4:int, _arg_5:String):void
        {
            var _local_6:TrackDispatcher;
            for each (_local_6 in this.dispatchers)
            {
                _local_6.trackGemsProduction(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
            };
        }

        override public function trackCombat3BattleResult(_arg_1:int, _arg_2:int, _arg_3:cCombat, _arg_4:int):void
        {
            var _local_5:TrackDispatcher;
            for each (_local_5 in this.dispatchers)
            {
                _local_5.trackCombat3BattleResult(_arg_1, _arg_2, _arg_3, _arg_4);
            };
        }

        override public function trackBuyGuildBankTabForGems(_arg_1:cPlayerData, _arg_2:String, _arg_3:int, _arg_4:int):void
        {
            var _local_5:TrackDispatcher;
            for each (_local_5 in this.dispatchers)
            {
                _local_5.trackBuyGuildBankTabForGems(_arg_1, _arg_2, _arg_3, _arg_4);
            };
        }

        override public function trackSpecialistTaskFinished(_arg_1:cPlayerData, _arg_2:int, _arg_3:cSpecialistSubTaskDefinition, _arg_4:cSpecialist, _arg_5:Object, _arg_6:String):void
        {
            var _local_7:TrackDispatcher;
            for each (_local_7 in this.dispatchers)
            {
                _local_7.trackSpecialistTaskFinished(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6);
            };
        }

        override public function trackEventCleanedUp(_arg_1:int, _arg_2:String):void
        {
            var _local_3:TrackDispatcher;
            for each (_local_3 in this.dispatchers)
            {
                _local_3.trackEventCleanedUp(_arg_1, _arg_2);
            };
        }

        override public function trackExpeditionTimeout(_arg_1:cPlayerData, _arg_2:cAdventure, _arg_3:cColony, _arg_4:int, _arg_5:int, _arg_6:int, _arg_7:Number, _arg_8:Boolean):void
        {
            var _local_9:TrackDispatcher;
            for each (_local_9 in this.dispatchers)
            {
                _local_9.trackExpeditionTimeout(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8);
            };
        }

        override public function trackBuyEnlargeGuildBank(_arg_1:cPlayerData, _arg_2:String, _arg_3:Vector.<dResource>, _arg_4:int):void
        {
            var _local_5:TrackDispatcher;
            for each (_local_5 in this.dispatchers)
            {
                _local_5.trackBuyEnlargeGuildBank(_arg_1, _arg_2, _arg_3, _arg_4);
            };
        }

        override public function trackUseSkillPoint(_arg_1:cPlayerData, _arg_2:cSkillTree, _arg_3:ChangeSkillsVO):void
        {
            var _local_4:TrackDispatcher;
            for each (_local_4 in this.dispatchers)
            {
                _local_4.trackUseSkillPoint(_arg_1, _arg_2, _arg_3);
            };
        }

        override public function trackUI(_arg_1:int, _arg_2:String, _arg_3:String, _arg_4:int, _arg_5:Boolean):void
        {
            var _local_6:TrackDispatcher;
            for each (_local_6 in this.dispatchers)
            {
                _local_6.trackUI(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
            };
        }

        override public function trackBuyGuildBankTab(_arg_1:cPlayerData, _arg_2:String, _arg_3:Vector.<dResource>, _arg_4:int):void
        {
            var _local_5:TrackDispatcher;
            for each (_local_5 in this.dispatchers)
            {
                _local_5.trackBuyGuildBankTab(_arg_1, _arg_2, _arg_3, _arg_4);
            };
        }

        override public function trackReimbursedAdventure(_arg_1:int, _arg_2:int, _arg_3:String, _arg_4:Number, _arg_5:Vector.<dAdventurePlayerVO>, _arg_6:HashMapWrapper):void
        {
            var _local_7:TrackDispatcher;
            for each (_local_7 in this.dispatchers)
            {
                _local_7.trackReimbursedAdventure(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6);
            };
        }

        override public function trackLeaveGuild(_arg_1:int, _arg_2:String):void
        {
            var _local_3:TrackDispatcher;
            for each (_local_3 in this.dispatchers)
            {
                _local_3.trackLeaveGuild(_arg_1, _arg_2);
            };
        }

        override public function trackBuildingPlace(_arg_1:cPlayerData, _arg_2:cBuilding):void
        {
            var _local_3:TrackDispatcher;
            for each (_local_3 in this.dispatchers)
            {
                _local_3.trackBuildingPlace(_arg_1, _arg_2);
            };
        }

        override public function trackQuestStarted(_arg_1:cPlayerData, _arg_2:String, _arg_3:int):void
        {
            var _local_4:TrackDispatcher;
            for each (_local_4 in this.dispatchers)
            {
                _local_4.trackQuestStarted(_arg_1, _arg_2, _arg_3);
            };
        }

        override public function trackTradeDeletedMarketplace(_arg_1:dTradeCompleteVO):void
        {
            var _local_2:TrackDispatcher;
            for each (_local_2 in this.dispatchers)
            {
                _local_2.trackTradeDeletedMarketplace(_arg_1);
            };
        }

        override public function trackResetSkillTree(_arg_1:cPlayerData, _arg_2:cSkillTree, _arg_3:ResetSkillsVO, _arg_4:int):void
        {
            var _local_5:TrackDispatcher;
            for each (_local_5 in this.dispatchers)
            {
                _local_5.trackResetSkillTree(_arg_1, _arg_2, _arg_3, _arg_4);
            };
        }

        override public function trackProductionAllCancelled(_arg_1:cPlayerData, _arg_2:cTimedProductionQueue):void
        {
            var _local_3:TrackDispatcher;
            for each (_local_3 in this.dispatchers)
            {
                _local_3.trackProductionAllCancelled(_arg_1, _arg_2);
            };
        }

        override public function trackExpeditionStarted(_arg_1:cPlayerData, _arg_2:int, _arg_3:int, _arg_4:int, _arg_5:String):void
        {
            var _local_6:TrackDispatcher;
            for each (_local_6 in this.dispatchers)
            {
                _local_6.trackExpeditionStarted(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
            };
        }

        override public function trackPvpLevelClaimed(_arg_1:cPlayerData, _arg_2:int):void
        {
            var _local_3:TrackDispatcher;
            for each (_local_3 in this.dispatchers)
            {
                _local_3.trackPvpLevelClaimed(_arg_1, _arg_2);
            };
        }

        override public function trackGainSpecialist(_arg_1:cSpecialist, _arg_2:int, _arg_3:int, _arg_4:Boolean, _arg_5:int):void
        {
            var _local_6:TrackDispatcher;
            for each (_local_6 in this.dispatchers)
            {
                _local_6.trackGainSpecialist(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
            };
        }

        override public function trackFoundGuild(_arg_1:int, _arg_2:String):void
        {
            var _local_3:TrackDispatcher;
            for each (_local_3 in this.dispatchers)
            {
                _local_3.trackFoundGuild(_arg_1, _arg_2);
            };
        }

        override public function trackAdventureInvitationSent(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:String):void
        {
            var _local_5:TrackDispatcher;
            for each (_local_5 in this.dispatchers)
            {
                _local_5.trackAdventureInvitationSent(_arg_1, _arg_2, _arg_3, _arg_4);
            };
        }

        override public function trackDepositDepleted(_arg_1:cPlayerData, _arg_2:cDeposit, _arg_3:cBuilding):void
        {
            var _local_4:TrackDispatcher;
            for each (_local_4 in this.dispatchers)
            {
                _local_4.trackDepositDepleted(_arg_1, _arg_2, _arg_3);
            };
        }

        override public function trackSendGift(_arg_1:int, _arg_2:int, _arg_3:String):void
        {
            var _local_4:TrackDispatcher;
            for each (_local_4 in this.dispatchers)
            {
                _local_4.trackSendGift(_arg_1, _arg_2, _arg_3);
            };
        }

        override public function trackBuyEnlargeGuildBankForGems(_arg_1:cPlayerData, _arg_2:String, _arg_3:int, _arg_4:int):void
        {
            var _local_5:TrackDispatcher;
            for each (_local_5 in this.dispatchers)
            {
                _local_5.trackBuyEnlargeGuildBankForGems(_arg_1, _arg_2, _arg_3, _arg_4);
            };
        }

        override public function trackAdventureInvitationAccepted(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:String):void
        {
            var _local_5:TrackDispatcher;
            for each (_local_5 in this.dispatchers)
            {
                _local_5.trackAdventureInvitationAccepted(_arg_1, _arg_2, _arg_3, _arg_4);
            };
        }

        override public function trackDeleteBuff(_arg_1:int, _arg_2:String, _arg_3:String, _arg_4:int, _arg_5:int, _arg_6:int):void
        {
            var _local_7:TrackDispatcher;
            for each (_local_7 in this.dispatchers)
            {
                _local_7.trackDeleteBuff(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6);
            };
        }

        override public function trackExpeditionWon(_arg_1:cPlayerData, _arg_2:cAdventure, _arg_3:cColony, _arg_4:int, _arg_5:int, _arg_6:int, _arg_7:Number, _arg_8:Boolean, _arg_9:int):void
        {
            var _local_10:TrackDispatcher;
            for each (_local_10 in this.dispatchers)
            {
                _local_10.trackExpeditionWon(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9);
            };
        }

        override public function trackLeaveAdventure(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:String):void
        {
            var _local_5:TrackDispatcher;
            for each (_local_5 in this.dispatchers)
            {
                _local_5.trackLeaveAdventure(_arg_1, _arg_2, _arg_3, _arg_4);
            };
        }

        override public function trackSessionLogout(_arg_1:int, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Boolean):void
        {
            var _local_6:TrackDispatcher;
            for each (_local_6 in this.dispatchers)
            {
                _local_6.trackSessionLogout(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
            };
        }

        override public function trackDonateEventResource(_arg_1:String, _arg_2:int, _arg_3:cPlayerData):void
        {
            var _local_4:TrackDispatcher;
            for each (_local_4 in this.dispatchers)
            {
                _local_4.trackDonateEventResource(_arg_1, _arg_2, _arg_3);
            };
        }

        override public function trackBuyItemPromotion(_arg_1:cPlayerData, _arg_2:String, _arg_3:Vector.<dResource>, _arg_4:int):void
        {
            var _local_5:TrackDispatcher;
            for each (_local_5 in this.dispatchers)
            {
                _local_5.trackBuyItemPromotion(_arg_1, _arg_2, _arg_3, _arg_4);
            };
        }

        override public function trackContentGeneratorCompleteCollection(_arg_1:cPlayerData, _arg_2:dContentGeneratorRollVO):void
        {
            var _local_3:TrackDispatcher;
            for each (_local_3 in this.dispatchers)
            {
                _local_3.trackContentGeneratorCompleteCollection(_arg_1, _arg_2);
            };
        }

        override public function trackSessionLogin(_arg_1:int, _arg_2:Number):void
        {
            var _local_3:TrackDispatcher;
            for each (_local_3 in this.dispatchers)
            {
                _local_3.trackSessionLogin(_arg_1, _arg_2);
            };
        }

        override public function trackPvpLevelUp(_arg_1:cPlayerData, _arg_2:int):void
        {
            var _local_3:TrackDispatcher;
            for each (_local_3 in this.dispatchers)
            {
                _local_3.trackPvpLevelUp(_arg_1, _arg_2);
            };
        }

        override public function trackGemAdded(_arg_1:cPlayerData, _arg_2:String, _arg_3:int, _arg_4:int, _arg_5:String):void
        {
            var _local_6:TrackDispatcher;
            for each (_local_6 in this.dispatchers)
            {
                _local_6.trackGemAdded(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
            };
        }

        override public function trackPickupCollectible(_arg_1:cPlayerData, _arg_2:String, _arg_3:String, _arg_4:int):void
        {
            var _local_5:TrackDispatcher;
            for each (_local_5 in this.dispatchers)
            {
                _local_5.trackPickupCollectible(_arg_1, _arg_2, _arg_3, _arg_4);
            };
        }

        override public function trackUsePremiumAccountItem(_arg_1:cPlayerData, _arg_2:String, _arg_3:int):void
        {
            var _local_4:TrackDispatcher;
            for each (_local_4 in this.dispatchers)
            {
                _local_4.trackUsePremiumAccountItem(_arg_1, _arg_2, _arg_3);
            };
        }

        override public function trackGemsContentGenerator(_arg_1:cPlayerData, _arg_2:int, _arg_3:int):void
        {
            var _local_4:TrackDispatcher;
            for each (_local_4 in this.dispatchers)
            {
                _local_4.trackGemsContentGenerator(_arg_1, _arg_2, _arg_3);
            };
        }

        override public function trackUsernameUpdate(_arg_1:int, _arg_2:String):void
        {
            var _local_3:TrackDispatcher;
            for each (_local_3 in this.dispatchers)
            {
                _local_3.trackUsernameUpdate(_arg_1, _arg_2);
            };
        }

        override public function trackGemQuestRewarded(_arg_1:cPlayerData, _arg_2:String, _arg_3:int, _arg_4:int, _arg_5:String):void
        {
            var _local_6:TrackDispatcher;
            for each (_local_6 in this.dispatchers)
            {
                _local_6.trackGemQuestRewarded(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
            };
        }

        override public function trackAvatarUpdate(_arg_1:int, _arg_2:int):void
        {
            var _local_3:TrackDispatcher;
            for each (_local_3 in this.dispatchers)
            {
                _local_3.trackAvatarUpdate(_arg_1, _arg_2);
            };
        }

        public function addTrackDispatcher(_arg_1:TrackDispatcher):void
        {
            this.dispatchers.push(_arg_1);
        }

        override public function trackEventStarted(_arg_1:int, _arg_2:String):void
        {
            var _local_3:TrackDispatcher;
            for each (_local_3 in this.dispatchers)
            {
                _local_3.trackEventStarted(_arg_1, _arg_2);
            };
        }

        override public function trackAdventureInvitationCancelled(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:String):void
        {
            var _local_5:TrackDispatcher;
            for each (_local_5 in this.dispatchers)
            {
                _local_5.trackAdventureInvitationCancelled(_arg_1, _arg_2, _arg_3, _arg_4);
            };
        }

        override public function trackLevelUp(_arg_1:cPlayerData, _arg_2:String, _arg_3:int):void
        {
            var _local_4:TrackDispatcher;
            for each (_local_4 in this.dispatchers)
            {
                _local_4.trackLevelUp(_arg_1, _arg_2, _arg_3);
            };
        }

        override public function trackAdventCalendarDoorOpened(_arg_1:dAdventCalendarDoorVO, _arg_2:cPlayerData):void
        {
            var _local_3:TrackDispatcher;
            for each (_local_3 in this.dispatchers)
            {
                _local_3.trackAdventCalendarDoorOpened(_arg_1, _arg_2);
            };
        }

        override public function trackGuildBankTransaction(_arg_1:int, _arg_2:String, _arg_3:String, _arg_4:int):void
        {
            var _local_5:TrackDispatcher;
            for each (_local_5 in this.dispatchers)
            {
                _local_5.trackGuildBankTransaction(_arg_1, _arg_2, _arg_3, _arg_4);
            };
        }

        override public function trackUnitsHired(_arg_1:cPlayerData, _arg_2:String, _arg_3:int, _arg_4:String):void
        {
            var _local_5:TrackDispatcher;
            for each (_local_5 in this.dispatchers)
            {
                _local_5.trackUnitsHired(_arg_1, _arg_2, _arg_3, _arg_4);
            };
        }

        override public function trackBuffFriend(_arg_1:cBuff, _arg_2:cGO, _arg_3:int):void
        {
            var _local_4:TrackDispatcher;
            for each (_local_4 in this.dispatchers)
            {
                _local_4.trackBuffFriend(_arg_1, _arg_2, _arg_3);
            };
        }

        override public function trackExpeditionCanceled(_arg_1:cPlayerData, _arg_2:cAdventure, _arg_3:cColony, _arg_4:int, _arg_5:int, _arg_6:int, _arg_7:Number, _arg_8:Boolean):void
        {
            var _local_9:TrackDispatcher;
            for each (_local_9 in this.dispatchers)
            {
                _local_9.trackExpeditionCanceled(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8);
            };
        }

        override public function trackVisitFriend(_arg_1:int, _arg_2:int, _arg_3:Number, _arg_4:Number):void
        {
            var _local_5:TrackDispatcher;
            for each (_local_5 in this.dispatchers)
            {
                _local_5.trackVisitFriend(_arg_1, _arg_2, _arg_3, _arg_4);
            };
        }

        override public function trackLockedZone(_arg_1:int, _arg_2:int, _arg_3:String):void
        {
            var _local_4:TrackDispatcher;
            for each (_local_4 in this.dispatchers)
            {
                _local_4.trackLockedZone(_arg_1, _arg_2, _arg_3);
            };
        }

        override public function trackAdventCalendarDoorOpenedWithGems(_arg_1:dAdventCalendarDoorVO, _arg_2:cPlayerData, _arg_3:int):void
        {
            var _local_4:TrackDispatcher;
            for each (_local_4 in this.dispatchers)
            {
                _local_4.trackAdventCalendarDoorOpenedWithGems(_arg_1, _arg_2, _arg_3);
            };
        }

        override public function trackTaskBuildingResult(_arg_1:cPlayerData, _arg_2:Vector.<IdentityVO>, _arg_3:Vector.<IdentityDefinition>):void
        {
            var _local_4:TrackDispatcher;
            for each (_local_4 in this.dispatchers)
            {
                _local_4.trackTaskBuildingResult(_arg_1, _arg_2, _arg_3);
            };
        }

        override public function trackBuildingUpdgrade(_arg_1:cPlayerData, _arg_2:cBuilding, _arg_3:Boolean):void
        {
            var _local_4:TrackDispatcher;
            for each (_local_4 in this.dispatchers)
            {
                _local_4.trackBuildingUpdgrade(_arg_1, _arg_2, _arg_3);
            };
        }

        override public function trackBuffsProduction(_arg_1:cPlayerData, _arg_2:String, _arg_3:int):void
        {
            var _local_4:TrackDispatcher;
            for each (_local_4 in this.dispatchers)
            {
                _local_4.trackBuffsProduction(_arg_1, _arg_2, _arg_3);
            };
        }

        override public function trackBuildingMove(_arg_1:cPlayerData, _arg_2:cBuilding, _arg_3:Boolean):void
        {
            var _local_4:TrackDispatcher;
            for each (_local_4 in this.dispatchers)
            {
                _local_4.trackBuildingMove(_arg_1, _arg_2, _arg_3);
            };
        }

        override public function trackTradeDeclinedF2F(_arg_1:cTradeObject):void
        {
            var _local_2:TrackDispatcher;
            for each (_local_2 in this.dispatchers)
            {
                _local_2.trackTradeDeclinedF2F(_arg_1);
            };
        }

        override public function trackAddFriend(_arg_1:int, _arg_2:int):void
        {
            var _local_3:TrackDispatcher;
            for each (_local_3 in this.dispatchers)
            {
                _local_3.trackAddFriend(_arg_1, _arg_2);
            };
        }

        override public function trackEventMonsterDestroyed(_arg_1:int, _arg_2:String):void
        {
            var _local_3:TrackDispatcher;
            for each (_local_3 in this.dispatchers)
            {
                _local_3.trackEventMonsterDestroyed(_arg_1, _arg_2);
            };
        }

        override public function trackExpeditionDefenseDone(_arg_1:cPlayerData, _arg_2:int, _arg_3:int, _arg_4:int, _arg_5:int, _arg_6:int, _arg_7:int, _arg_8:int):void
        {
            var _local_9:TrackDispatcher;
            for each (_local_9 in this.dispatchers)
            {
                _local_9.trackExpeditionDefenseDone(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8);
            };
        }

        override public function trackGeneralTravel(_arg_1:cSpecialist, _arg_2:int):void
        {
            var _local_3:TrackDispatcher;
            for each (_local_3 in this.dispatchers)
            {
                _local_3.trackGeneralTravel(_arg_1, _arg_2);
            };
        }

        override public function trackTaskBuildingReward(_arg_1:int, _arg_2:String, _arg_3:EffectListVO, _arg_4:Boolean):void
        {
            var _local_5:TrackDispatcher;
            for each (_local_5 in this.dispatchers)
            {
                _local_5.trackTaskBuildingReward(_arg_1, _arg_2, _arg_3, _arg_4);
            };
        }

        override public function trackExternalFriendInviteCall(_arg_1:int):void
        {
            var _local_2:TrackDispatcher;
            for each (_local_2 in this.dispatchers)
            {
                _local_2.trackExternalFriendInviteCall(_arg_1);
            };
        }

        override public function trackBuyItemForGems(_arg_1:cPlayerData, _arg_2:String, _arg_3:int, _arg_4:int):void
        {
            var _local_5:TrackDispatcher;
            for each (_local_5 in this.dispatchers)
            {
                _local_5.trackBuyItemForGems(_arg_1, _arg_2, _arg_3, _arg_4);
            };
        }

        override public function trackTradeAccepted(_arg_1:cPlayerData, _arg_2:dAcceptTradeVO, _arg_3:dResourceVO, _arg_4:dBuffVO, _arg_5:dResourceVO, _arg_6:dBuffVO, _arg_7:int):void
        {
            var _local_8:TrackDispatcher;
            for each (_local_8 in this.dispatchers)
            {
                _local_8.trackTradeAccepted(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7);
            };
        }

        override public function trackGuildLeaderChange(_arg_1:int, _arg_2:String):void
        {
            var _local_3:TrackDispatcher;
            for each (_local_3 in this.dispatchers)
            {
                _local_3.trackGuildLeaderChange(_arg_1, _arg_2);
            };
        }

        override public function trackGuildRankAssigned(_arg_1:int, _arg_2:String, _arg_3:int, _arg_4:int):void
        {
            var _local_5:TrackDispatcher;
            for each (_local_5 in this.dispatchers)
            {
                _local_5.trackGuildRankAssigned(_arg_1, _arg_2, _arg_3, _arg_4);
            };
        }

        override public function trackCollectionsProduction(_arg_1:cPlayerData, _arg_2:String, _arg_3:int):void
        {
            var _local_4:TrackDispatcher;
            for each (_local_4 in this.dispatchers)
            {
                _local_4.trackCollectionsProduction(_arg_1, _arg_2, _arg_3);
            };
        }

        override public function trackStackDeleteCollectibles(_arg_1:int):void
        {
            var _local_2:TrackDispatcher;
            for each (_local_2 in this.dispatchers)
            {
                _local_2.trackStackDeleteCollectibles(_arg_1);
            };
        }

        override public function trackProcessedExternalMessages(_arg_1:int, _arg_2:String, _arg_3:String):void
        {
            var _local_4:TrackDispatcher;
            for each (_local_4 in this.dispatchers)
            {
                _local_4.trackProcessedExternalMessages(_arg_1, _arg_2, _arg_3);
            };
        }

        override public function trackClientLoaded():void
        {
            var _local_1:TrackDispatcher;
            for each (_local_1 in this.dispatchers)
            {
                _local_1.trackClientLoaded();
            };
        }

        override public function trackGemReset(_arg_1:cPlayerData, _arg_2:String, _arg_3:int, _arg_4:int):void
        {
            var _local_5:TrackDispatcher;
            for each (_local_5 in this.dispatchers)
            {
                _local_5.trackGemReset(_arg_1, _arg_2, _arg_3, _arg_4);
            };
        }

        override public function trackResourceMissing(_arg_1:cPlayerData, _arg_2:cBuilding, _arg_3:dResource):void
        {
            var _local_4:TrackDispatcher;
            for each (_local_4 in this.dispatchers)
            {
                _local_4.trackResourceMissing(_arg_1, _arg_2, _arg_3);
            };
        }

        override public function trackExpeditionColonyAssigned(_arg_1:cPlayerData, _arg_2:int, _arg_3:int, _arg_4:int, _arg_5:int):void
        {
            var _local_6:TrackDispatcher;
            for each (_local_6 in this.dispatchers)
            {
                _local_6.trackExpeditionColonyAssigned(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
            };
        }

        override public function trackPickupReward(_arg_1:int, _arg_2:String, _arg_3:int, _arg_4:int, _arg_5:int):void
        {
            var _local_6:TrackDispatcher;
            for each (_local_6 in this.dispatchers)
            {
                _local_6.trackPickupReward(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
            };
        }

        override public function trackMysteryBox(_arg_1:int, _arg_2:String, _arg_3:dLootItemsVO):void
        {
            var _local_4:TrackDispatcher;
            for each (_local_4 in this.dispatchers)
            {
                _local_4.trackMysteryBox(_arg_1, _arg_2, _arg_3);
            };
        }

        override public function trackExpeditionColonyRemoved(_arg_1:cPlayerData, _arg_2:ColonyVO):void
        {
            var _local_3:TrackDispatcher;
            for each (_local_3 in this.dispatchers)
            {
                _local_3.trackExpeditionColonyRemoved(_arg_1, _arg_2);
            };
        }

        override public function trackEpicWorkyardChainEnabled(_arg_1:cPlayerData, _arg_2:String, _arg_3:int):void
        {
            var _local_4:TrackDispatcher;
            for each (_local_4 in this.dispatchers)
            {
                _local_4.trackEpicWorkyardChainEnabled(_arg_1, _arg_2, _arg_3);
            };
        }

        override public function trackEventStopped(_arg_1:int, _arg_2:String):void
        {
            var _local_3:TrackDispatcher;
            for each (_local_3 in this.dispatchers)
            {
                _local_3.trackEventStopped(_arg_1, _arg_2);
            };
        }

        override public function trackSpecialistTaskStarted(_arg_1:cPlayerData, _arg_2:int, _arg_3:cSpecialistSubTaskDefinition, _arg_4:cSpecialist, _arg_5:String):void
        {
            var _local_6:TrackDispatcher;
            for each (_local_6 in this.dispatchers)
            {
                _local_6.trackSpecialistTaskStarted(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
            };
        }

        override public function trackConcurrentUsers(_arg_1:int):void
        {
            var _local_2:TrackDispatcher;
            for each (_local_2 in this.dispatchers)
            {
                _local_2.trackConcurrentUsers(_arg_1);
            };
        }

        override public function trackAchievementCompleted(_arg_1:UserAchievement, _arg_2:cGeneralInterface):void
        {
            var _local_3:TrackDispatcher;
            for each (_local_3 in this.dispatchers)
            {
                _local_3.trackAchievementCompleted(_arg_1, _arg_2);
            };
        }

        override public function trackGainSkillPoint(_arg_1:cPlayerData, _arg_2:String, _arg_3:int, _arg_4:Vector.<dResource>, _arg_5:int):void
        {
            var _local_6:TrackDispatcher;
            for each (_local_6 in this.dispatchers)
            {
                _local_6.trackGainSkillPoint(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
            };
        }

        override public function trackAdventureInvitationDeclined(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:String):void
        {
            var _local_5:TrackDispatcher;
            for each (_local_5 in this.dispatchers)
            {
                _local_5.trackAdventureInvitationDeclined(_arg_1, _arg_2, _arg_3, _arg_4);
            };
        }

        override public function trackGainAdventure(_arg_1:int, _arg_2:String):void
        {
            var _local_3:TrackDispatcher;
            for each (_local_3 in this.dispatchers)
            {
                _local_3.trackGainAdventure(_arg_1, _arg_2);
            };
        }

        override public function trackAdventureInvitationExpired(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:String):void
        {
            var _local_5:TrackDispatcher;
            for each (_local_5 in this.dispatchers)
            {
                _local_5.trackAdventureInvitationExpired(_arg_1, _arg_2, _arg_3, _arg_4);
            };
        }

        override public function trackAddBuff(_arg_1:int, _arg_2:String, _arg_3:String, _arg_4:int, _arg_5:int, _arg_6:int):void
        {
            var _local_7:TrackDispatcher;
            for each (_local_7 in this.dispatchers)
            {
                _local_7.trackAddBuff(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6);
            };
        }

        override public function trackBuyItemWidget(_arg_1:cPlayerData, _arg_2:String, _arg_3:Vector.<dResource>, _arg_4:int, _arg_5:String):void
        {
            var _local_6:TrackDispatcher;
            for each (_local_6 in this.dispatchers)
            {
                _local_6.trackBuyItemWidget(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
            };
        }

        override public function trackApplyBuff(_arg_1:int, _arg_2:int, _arg_3:String, _arg_4:String, _arg_5:int, _arg_6:int, _arg_7:int):void
        {
            var _local_8:TrackDispatcher;
            for each (_local_8 in this.dispatchers)
            {
                _local_8.trackApplyBuff(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7);
            };
        }

        override public function trackTradeTimeoutF2F(_arg_1:cTradeObject):void
        {
            var _local_2:TrackDispatcher;
            for each (_local_2 in this.dispatchers)
            {
                _local_2.trackTradeTimeoutF2F(_arg_1);
            };
        }

        override public function trackBuildingDestroy(_arg_1:cPlayerData, _arg_2:cBuilding, _arg_3:String):void
        {
            var _local_4:TrackDispatcher;
            for each (_local_4 in this.dispatchers)
            {
                _local_4.trackBuildingDestroy(_arg_1, _arg_2, _arg_3);
            };
        }

        override public function trackStackDeleteBuilding(_arg_1:int, _arg_2:String):void
        {
            var _local_3:TrackDispatcher;
            for each (_local_3 in this.dispatchers)
            {
                _local_3.trackStackDeleteBuilding(_arg_1, _arg_2);
            };
        }

        override public function trackJoinGuild(_arg_1:int, _arg_2:String):void
        {
            var _local_3:TrackDispatcher;
            for each (_local_3 in this.dispatchers)
            {
                _local_3.trackJoinGuild(_arg_1, _arg_2);
            };
        }

        override public function trackGemPurchased(_arg_1:cPlayerData, _arg_2:String, _arg_3:int, _arg_4:int, _arg_5:String):void
        {
            var _local_6:TrackDispatcher;
            for each (_local_6 in this.dispatchers)
            {
                _local_6.trackGemPurchased(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
            };
        }

        override public function trackBattleResult(_arg_1:cPlayerData, _arg_2:int, _arg_3:dBattleResultVO, _arg_4:cSpecialist, _arg_5:dArmyVO, _arg_6:dArmyVO, _arg_7:int):void
        {
            var _local_8:TrackDispatcher;
            for each (_local_8 in this.dispatchers)
            {
                _local_8.trackBattleResult(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7);
            };
        }

        override public function trackContentGeneratorRoll(_arg_1:cPlayerData, _arg_2:dContentGeneratorRollVO):void
        {
            var _local_3:TrackDispatcher;
            for each (_local_3 in this.dispatchers)
            {
                _local_3.trackContentGeneratorRoll(_arg_1, _arg_2);
            };
        }

        override public function trackDeleteVote(_arg_1:int, _arg_2:int):void
        {
            var _local_3:TrackDispatcher;
            for each (_local_3 in this.dispatchers)
            {
                _local_3.trackDeleteVote(_arg_1, _arg_2);
            };
        }

        override public function trackQuestFinished(_arg_1:cPlayerData, _arg_2:String, _arg_3:int, _arg_4:dQuestElementVO, _arg_5:int):void
        {
            var _local_6:TrackDispatcher;
            for each (_local_6 in this.dispatchers)
            {
                _local_6.trackQuestFinished(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
            };
        }

        override public function trackGuildQuestFinished(_arg_1:int, _arg_2:int, _arg_3:String, _arg_4:dLootItemsVO):void
        {
            var _local_5:TrackDispatcher;
            for each (_local_5 in this.dispatchers)
            {
                _local_5.trackGuildQuestFinished(_arg_1, _arg_2, _arg_3, _arg_4);
            };
        }

        override public function trackEpicWorkyardBuffed(_arg_1:cPlayerData, _arg_2:String, _arg_3:String):void
        {
            var _local_4:TrackDispatcher;
            for each (_local_4 in this.dispatchers)
            {
                _local_4.trackEpicWorkyardBuffed(_arg_1, _arg_2, _arg_3);
            };
        }

        override public function trackBuyItem(_arg_1:cPlayerData, _arg_2:String, _arg_3:Vector.<dResource>, _arg_4:int, _arg_5:String):void
        {
            var _local_6:TrackDispatcher;
            for each (_local_6 in this.dispatchers)
            {
                _local_6.trackBuyItem(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
            };
        }

        override public function trackUseIslandDeed(_arg_1:cPlayerData, _arg_2:String):void
        {
            var _local_3:TrackDispatcher;
            for each (_local_3 in this.dispatchers)
            {
                _local_3.trackUseIslandDeed(_arg_1, _arg_2);
            };
        }

        override public function trackProductionFinished(_arg_1:cPlayerData, _arg_2:cTimedProduction):void
        {
            var _local_3:TrackDispatcher;
            for each (_local_3 in this.dispatchers)
            {
                _local_3.trackProductionFinished(_arg_1, _arg_2);
            };
        }

        override public function trackSendVote(_arg_1:int, _arg_2:dPlayerVoteVO):void
        {
            var _local_3:TrackDispatcher;
            for each (_local_3 in this.dispatchers)
            {
                _local_3.trackSendVote(_arg_1, _arg_2);
            };
        }


    }
}//package Tracks

class SingletonEnforcer 
{

    public function SingletonEnforcer()
    {
        super();
    }

}


