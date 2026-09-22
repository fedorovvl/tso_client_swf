package Trigger
{
    import Utils.HashMapWrapper;
    import Interface.cGeneralInterface;
    import Enums.TRIGGER_ACTION;
    import Communication.VO.TriggerHashMapVO;
    import Trigger.Triggers.PlayerLevelTrigger;
    import Trigger.Triggers.OnMapTrigger;
    import Trigger.Triggers.ResourceTrigger;
    import Trigger.Triggers.QuestCompleteTrigger;
    import Trigger.Triggers.QuestDeactivateTrigger;
    import Trigger.Triggers.QuestActiveTrigger;
    import Trigger.Triggers.SectorExploredTrigger;
    import Trigger.Triggers.ClickGUITrigger;
    import Trigger.Triggers.WindowOpenTrigger;
    import Trigger.Triggers.WindowCloseTrigger;
    import Trigger.Triggers.PopulationTrigger;
    import Trigger.Triggers.GeneralTrigger;
    import Trigger.Triggers.BuildingQueueTrigger;
    import Trigger.Triggers.BuffOwnedTrigger;
    import Trigger.Triggers.BuffAppliedTrigger;
    import Trigger.Triggers.BuffProducedTrigger;
    import Trigger.Triggers.BuildingSelectedTrigger;
    import Trigger.Triggers.BuildingDestroyedTrigger;
    import Trigger.Triggers.BuildingUpgradedTrigger;
    import Trigger.Triggers.BuildingUpgradeLevelTrigger;
    import Trigger.Triggers.PremiumAccountDurationTrigger;
    import Trigger.Triggers.SkillLevelTrigger;
    import Trigger.Triggers.SkillTreePointTrigger;
    import Trigger.Triggers.PickupsTrigger;
    import Trigger.Triggers.BattleWonTrigger;
    import Trigger.Triggers.BuffAppliedOnFriendTrigger;
    import Trigger.Triggers.BuffReceivedFromFriendTrigger;
    import Trigger.Triggers.BuffAppliedOnAdventureTrigger;
    import Trigger.Triggers.HaveFriendsTrigger;
    import Trigger.Triggers.SpecialistOwnedListTrigger;
    import Trigger.Triggers.HaveDepositsTrigger;
    import Trigger.Triggers.OnMapListTrigger;
    import Trigger.Triggers.UnitsOwnedListTrigger;
    import Trigger.Triggers.OwnResourceListTrigger;
    import Trigger.Triggers.CompleteAdventureListTrigger;
    import Trigger.Triggers.CompleteExpeditionListTrigger;
    import Trigger.Triggers.CompleteAdventureInTimeTrigger;
    import Trigger.Triggers.BalancedProductionTrigger;
    import Trigger.Triggers.SpecialistSkillTrigger;
    import Trigger.Triggers.TimeInAdventureListTrigger;
    import Trigger.Triggers.DailyLoginBonusCounterTrigger;
    import Trigger.Triggers.HaveGuildSizeTrigger;
    import Trigger.Triggers.OwnStarMenuItemTypeListTrigger;
    import Trigger.Triggers.TimeInGameTrigger;
    import Trigger.Triggers.ProducedItemListTrigger;
    import Trigger.Triggers.SpecialistTaskResultTypeTrigger;
    import Trigger.Triggers.StreetsInSectorListTrigger;
    import Trigger.Triggers.BoughtGoodsTrigger;
    import Trigger.Triggers.GeneralTravelTrigger;
    import Trigger.Triggers.BoughtBuildQueueSlotTypeTrigger;
    import Trigger.Triggers.GeneralsVisitAdventure;
    import Trigger.Triggers.SoldGoodsTrigger;
    import Trigger.Triggers.TimeInGuildTrigger;
    import Trigger.Triggers.CompleteAdventureWithUnitTypeTrigger;
    import Trigger.Triggers.QuestTypeCompletedTrigger;
    import Trigger.Triggers.CountDepositTypeTrigger;
    import Trigger.Triggers.BattleWonWithoutCasualties;
    import Trigger.Triggers.UnitsLostTrigger;
    import Trigger.Triggers.BuildingListUpgradeLevelTrigger;
    import Trigger.Triggers.BattleFoughtTrigger;
    import Trigger.Triggers.CompleteAdventureUnitsLostListTrigger;
    import Trigger.Triggers.CountAnyBuildingOnMapList;
    import Trigger.Triggers.ProductionValueTrigger;
    import Trigger.Triggers.ProductionTimeTrigger;
    import Trigger.Triggers.CalendarDoorOpenedTrigger;
    import Trigger.Triggers.CalendarDoorOpenedCountTrigger;
    import Trigger.Triggers.OnDateTrigger;
    import Trigger.Triggers.GarrisonOnMap;
    import Trigger.Triggers.NewSpecialistTrigger;
    import Trigger.Triggers.VisitAdventureTrigger;
    import Trigger.Triggers.ZoneEventTrigger;
    import Trigger.Triggers.ContestPvPColonyTrigger;
    import Trigger.Triggers.SuccessfullyDefendColonyTrigger;
    import Trigger.Triggers.ColonyYieldTrigger;
    import Trigger.Triggers.CompleteAdventureUnitsLostTotalTrigger;
    import Trigger.Triggers.KillUnitsTrigger;
    import Trigger.Triggers.FillUpYourColonySlotsTrigger;
    import Trigger.Triggers.AchievementsPointsTrigger;
    import Trigger.Triggers.ResourceGatheredTrigger;
    import Trigger.Triggers.AdmiralTravelTrigger;
    import Trigger.Triggers.LootedResourcesTrigger;
    import Trigger.Triggers.CompleteQuestListTrigger;
    import Trigger.Triggers.PlayerPvpLevelTrigger;
    import Trigger.Triggers.ClaimColonyTrigger;
    import Trigger.Triggers.BuffInsufficientForEnemiesTrigger;
    import Trigger.Triggers.BuffInsufficientTargetBuildingsTrigger;
    import Trigger.Triggers.CollectedPickups;
    import Trigger.Triggers.AdventureLostTrigger;
    import Trigger.Triggers.PayToFinishTrigger;
    import Trigger.Triggers.RefillDepositsTrigger;
    import Trigger.Triggers.CheckGenericValueTrigger;
    import Trigger.Triggers.RollCollectionTrigger;
    import Trigger.Triggers.CompleteCollectionTrigger;
    import Trigger.Triggers.ZoneBuffActiveTrigger;
    import Trigger.Triggers.SpecialistTaskFinishedTrigger;
    import Trigger.Triggers.QuestCompletableTrigger;
    import Trigger.Triggers.FilterActiveTrigger;
    import Trigger.Triggers.FeatureAvailableTrigger;
    import Trigger.Triggers.QuestRunningTrigger;
    import Trigger.Triggers.SectorLiberatedTrigger;
    import Trigger.Triggers.QuestAdventureCompletedTrigger;
    import Trigger.Triggers.HoursElapsedTrigger;
    import Trigger.Triggers.EventRunningTrigger;
    import Trigger.Triggers.ResourceDonatedTrigger;
    import Trigger.Triggers.GlobalDonationTrigger;
    import Trigger.Triggers.EventTimeTrigger;
    import Trigger.Triggers.SpecialistHasSkillTrigger;
    import Trigger.Triggers.QuestFailedTrigger;
    import Trigger.Triggers.QuestTriggerValueTrigger;
    import Trigger.Triggers.BuffActiveTrigger;
    import Trigger.Triggers.QuestExistsTrigger;
    import Communication.VO.TriggerListVO;
    import GUI.Components.CustomAlert;
    import Communication.VO.TriggerVO;

    public final class TriggerFactory implements ITriggerFactory 
    {

        private static var triggerHashMap:HashMapWrapper = new HashMapWrapper();

        private var gi:cGeneralInterface;
        private var deltaValue:TriggerDeltaValue = null;

        {
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_PLAYERLEVEL_string, new TriggerHashMapVO(PlayerLevelTrigger, false));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_ONMAP_string, new TriggerHashMapVO(OnMapTrigger, false));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_RESOURCE_string, new TriggerHashMapVO(ResourceTrigger, false));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_QUEST_COMPLETE_string, new TriggerHashMapVO(QuestCompleteTrigger, false));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_QUEST_DEACTIVATE_string, new TriggerHashMapVO(QuestDeactivateTrigger, false));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_QUEST_ACTIVE_string, new TriggerHashMapVO(QuestActiveTrigger, false));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_SECTOR_EXPLORED_string, new TriggerHashMapVO(SectorExploredTrigger, false));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_CLICK_string, new TriggerHashMapVO(ClickGUITrigger, false));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_WINDOW_OPEN_string, new TriggerHashMapVO(WindowOpenTrigger, false));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_WINDOW_CLOSE_string, new TriggerHashMapVO(WindowCloseTrigger, false));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_POPULATION_string, new TriggerHashMapVO(PopulationTrigger, false));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_GENERAL_string, new TriggerHashMapVO(GeneralTrigger, false));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_BUILDINGQUEUE_string, new TriggerHashMapVO(BuildingQueueTrigger, false));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_BUFF_OWNED_string, new TriggerHashMapVO(BuffOwnedTrigger, false));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_BUFF_APPLIED_string, new TriggerHashMapVO(BuffAppliedTrigger, true));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_BUFF_PRODUCED_string, new TriggerHashMapVO(BuffProducedTrigger, true));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_BUILDING_SELECTED_string, new TriggerHashMapVO(BuildingSelectedTrigger, false));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_BUILDING_DESTROYED_string, new TriggerHashMapVO(BuildingDestroyedTrigger, true));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_BUILDING_UPGRADED_string, new TriggerHashMapVO(BuildingUpgradedTrigger, false));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_BUILDING_UPGRADELEVEL_string, new TriggerHashMapVO(BuildingUpgradeLevelTrigger, false));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_PREMIUM_ACCOUNT_DURATION_string, new TriggerHashMapVO(PremiumAccountDurationTrigger, false));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_SKILLLEVEL_string, new TriggerHashMapVO(SkillLevelTrigger, false));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_SKILLTREEPOINTS_string, new TriggerHashMapVO(SkillTreePointTrigger, false));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_PICKUPS_string, new TriggerHashMapVO(PickupsTrigger, false));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_BATTLE_WON_string, new TriggerHashMapVO(BattleWonTrigger, true));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_BUFF_APPLIED_ON_FRIEND_string, new TriggerHashMapVO(BuffAppliedOnFriendTrigger, true));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_BUFF_RECEIVED_FROM_FRIEND_string, new TriggerHashMapVO(BuffReceivedFromFriendTrigger, true));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_BUFF_APPLIED_ON_ADVENTURE_string, new TriggerHashMapVO(BuffAppliedOnAdventureTrigger, true));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_HAVE_FRIENDS_string, new TriggerHashMapVO(HaveFriendsTrigger, false));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_SPECIALIST_OWNED_LIST_string, new TriggerHashMapVO(SpecialistOwnedListTrigger, false));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_HAVE_DEPOSITS_string, new TriggerHashMapVO(HaveDepositsTrigger, false));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_ON_MAP_LIST_string, new TriggerHashMapVO(OnMapListTrigger, false));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_UNITS_OWNED_LIST_string, new TriggerHashMapVO(UnitsOwnedListTrigger, false));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_OWN_RESOURCE_LIST_string, new TriggerHashMapVO(OwnResourceListTrigger, false));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_COMPLETE_ADVENTURE_LIST_string, new TriggerHashMapVO(CompleteAdventureListTrigger, true));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_COMPLETE_EXPEDITION_LIST_string, new TriggerHashMapVO(CompleteExpeditionListTrigger, true));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_COMPLETE_ADVENTURE_IN_TIME_string, new TriggerHashMapVO(CompleteAdventureInTimeTrigger, false));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_BALANCED_PRODUCTION_string, new TriggerHashMapVO(BalancedProductionTrigger, false));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_SPECIALIST_SKILL_string, new TriggerHashMapVO(SpecialistSkillTrigger, false));
            triggerHashMap.putItem(TRIGGER_ACTION.TIME_IN_ADVENTURE_LIST_string, new TriggerHashMapVO(TimeInAdventureListTrigger, true));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_DAILY_LOGIN_BONUS_string, new TriggerHashMapVO(DailyLoginBonusCounterTrigger, true));
            triggerHashMap.putItem(TRIGGER_ACTION.HAVE_GUILD_SIZE_string, new TriggerHashMapVO(HaveGuildSizeTrigger, false));
            triggerHashMap.putItem(TRIGGER_ACTION.OWN_STAR_MENU_ITEM_TYPE_string, new TriggerHashMapVO(OwnStarMenuItemTypeListTrigger, false));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_TIME_IN_GAME_string, new TriggerHashMapVO(TimeInGameTrigger, true));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_TIMED_PRODUCED_ITEM_LIST_string, new TriggerHashMapVO(ProducedItemListTrigger, true));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_SPECIALIST_TASK_RESULT_TYPE_string, new TriggerHashMapVO(SpecialistTaskResultTypeTrigger, true));
            triggerHashMap.putItem(TRIGGER_ACTION.STREETS_IN_SECTOR_LIST_string, new TriggerHashMapVO(StreetsInSectorListTrigger, false));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_BOUGHT_GOODS_string, new TriggerHashMapVO(BoughtGoodsTrigger, true));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_GENERAL_TRAVEL_string, new TriggerHashMapVO(GeneralTravelTrigger, true));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_BOUGH_BUILD_QUEUE_SLOT_string, new TriggerHashMapVO(BoughtBuildQueueSlotTypeTrigger, true));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_GENERALS_VISIT_ADVENTURE_string, new TriggerHashMapVO(GeneralsVisitAdventure, true));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_SOLD_GOODS_string, new TriggerHashMapVO(SoldGoodsTrigger, true));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_TIME_IN_GUILD_string, new TriggerHashMapVO(TimeInGuildTrigger, false));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_COMPLETE_ADVENTURE_WITH_UNIT_TYPE_string, new TriggerHashMapVO(CompleteAdventureWithUnitTypeTrigger, false));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_QUEST_TYPE_COMPLETED_string, new TriggerHashMapVO(QuestTypeCompletedTrigger, true));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_COUNT_DEPOSIT_TYPE_string, new TriggerHashMapVO(CountDepositTypeTrigger, false));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_BATTLE_WON_WITHOUT_CASUALTIES_string, new TriggerHashMapVO(BattleWonWithoutCasualties, true));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_UNITS_LOST_string, new TriggerHashMapVO(UnitsLostTrigger, true));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_BUILDING_LIST_UPGRADE_LEVEL_string, new TriggerHashMapVO(BuildingListUpgradeLevelTrigger, false));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_BATTLE_FOUGHT_LEVEL_string, new TriggerHashMapVO(BattleFoughtTrigger, true));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_COMPLETE_ADVENTURE_UNITS_LOST_LIST_string, new TriggerHashMapVO(CompleteAdventureUnitsLostListTrigger, false));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_COUNT_ANY_BUILDING_ON_MAP_string, new TriggerHashMapVO(CountAnyBuildingOnMapList, false));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_PRODUCTION_VALUE_string, new TriggerHashMapVO(ProductionValueTrigger, false));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_PRODUCTION_TIME_string, new TriggerHashMapVO(ProductionTimeTrigger, false));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_CALENDAR_DOOR_OPENED_string, new TriggerHashMapVO(CalendarDoorOpenedTrigger, false));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_CALENDAR_DOOR_OPENED_COUNT_string, new TriggerHashMapVO(CalendarDoorOpenedCountTrigger, true));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_ON_DATE, new TriggerHashMapVO(OnDateTrigger, false));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_GARRISON_ON_MAP_string, new TriggerHashMapVO(GarrisonOnMap, false));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_NEW_SPECIALIST_string, new TriggerHashMapVO(NewSpecialistTrigger, false));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_VISIT_ADVENTURE_string, new TriggerHashMapVO(VisitAdventureTrigger, false));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_ZONE_EVENT_string, new TriggerHashMapVO(ZoneEventTrigger, false));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_CONTEST_PVP_COLONY_string, new TriggerHashMapVO(ContestPvPColonyTrigger, true));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_SUCCESSFULLY_DEFEND_COLONY_string, new TriggerHashMapVO(SuccessfullyDefendColonyTrigger, true));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_COLONY_YIELD_string, new TriggerHashMapVO(ColonyYieldTrigger, true));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_COMPLETE_ADVENTURE_UNITS_LOST_TOTAL_string, new TriggerHashMapVO(CompleteAdventureUnitsLostTotalTrigger, false));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_COMPLETE_ADVENTURE_KILL_UNITS_string, new TriggerHashMapVO(KillUnitsTrigger, true));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_FILL_UP_COLONY_SLOTS_string, new TriggerHashMapVO(FillUpYourColonySlotsTrigger, false));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_HAS_ACHIEVEMENT_POINTS_string, new TriggerHashMapVO(AchievementsPointsTrigger, false));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_RESOURCE_GATHERED_string, new TriggerHashMapVO(ResourceGatheredTrigger, true));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_ADMIRAL_TRAVEL_string, new TriggerHashMapVO(AdmiralTravelTrigger, true));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_LOOTED_RESOURCE_string, new TriggerHashMapVO(LootedResourcesTrigger, true));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_COMPLETE_QUEST_LIST_string, new TriggerHashMapVO(CompleteQuestListTrigger, true));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_PLAYERPVPLEVEL_string, new TriggerHashMapVO(PlayerPvpLevelTrigger, false));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_CLAIM_COLONY_string, new TriggerHashMapVO(ClaimColonyTrigger, true));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_BUFF_INSUFFICIENT_FOR_ENEMIES_string, new TriggerHashMapVO(BuffInsufficientForEnemiesTrigger, false));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_BUFF_INSUFFICIENT_TARGET_BUILDINGS_string, new TriggerHashMapVO(BuffInsufficientTargetBuildingsTrigger, false));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_COLLECTED_PICKUPS_string, new TriggerHashMapVO(CollectedPickups, true));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_ADVENTURE_LOST_string, new TriggerHashMapVO(AdventureLostTrigger, false));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_PAY_TO_FINISH_string, new TriggerHashMapVO(PayToFinishTrigger, false));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_REFILL_DEPOSITS_string, new TriggerHashMapVO(RefillDepositsTrigger, true));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_CHECK_GENERIC_VALUE_TRIGGER, new TriggerHashMapVO(CheckGenericValueTrigger, false));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_ROLL_COLLECTION_TRIGGER, new TriggerHashMapVO(RollCollectionTrigger, true));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_COMPLETE_COLLECTION_TRIGGER, new TriggerHashMapVO(CompleteCollectionTrigger, true));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_ZONE_BUFF_ACTIVE, new TriggerHashMapVO(ZoneBuffActiveTrigger, false));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_SPECIALIST_TASK_FINISHED_string, new TriggerHashMapVO(SpecialistTaskFinishedTrigger, true));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_QUEST_COMPLETABLE_string, new TriggerHashMapVO(QuestCompletableTrigger, false));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_FILTER_ACTIVE, new TriggerHashMapVO(FilterActiveTrigger, false));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_FEATURE_AVAILABLE, new TriggerHashMapVO(FeatureAvailableTrigger, false));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_QUEST_RUNNING_string, new TriggerHashMapVO(QuestRunningTrigger, false));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_SECTOR_LIBERATED, new TriggerHashMapVO(SectorLiberatedTrigger, false));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_QUEST_ADVENTURE_COMPLETED, new TriggerHashMapVO(QuestAdventureCompletedTrigger, true));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_HOURS_ELAPSED_string, new TriggerHashMapVO(HoursElapsedTrigger, true));
            triggerHashMap.putItem(TRIGGER_ACTION.ACTION_EVENT_RUNNING_string, new TriggerHashMapVO(EventRunningTrigger, false));
            triggerHashMap.putItem(ResourceDonatedTrigger.XML_string, new TriggerHashMapVO(ResourceDonatedTrigger, true));
            triggerHashMap.putItem(GlobalDonationTrigger.XML_string, new TriggerHashMapVO(GlobalDonationTrigger, false));
            triggerHashMap.putItem(EventTimeTrigger.XML_string, new TriggerHashMapVO(EventTimeTrigger, false));
            triggerHashMap.putItem(SpecialistHasSkillTrigger.XML_string, new TriggerHashMapVO(SpecialistHasSkillTrigger, false));
            triggerHashMap.putItem(QuestFailedTrigger.XML_string, new TriggerHashMapVO(QuestFailedTrigger, false));
            triggerHashMap.putItem(QuestTriggerValueTrigger.XML_string, new TriggerHashMapVO(QuestTriggerValueTrigger, false));
            triggerHashMap.putItem(BuffActiveTrigger.XML_string, new TriggerHashMapVO(BuffActiveTrigger, false));
            triggerHashMap.putItem(QuestExistsTrigger.XML_string, new TriggerHashMapVO(QuestExistsTrigger, false));
            triggerHashMap.putItem("contestpointcount", new TriggerHashMapVO(PayToFinishTrigger, false));
            triggerHashMap.putItem("contestrewardtier", new TriggerHashMapVO(PayToFinishTrigger, false));
        }

        public function TriggerFactory(_arg_1:cGeneralInterface)
        {
            super();
            this.gi = _arg_1;
        }

        public function setDeltaValue(_arg_1:TriggerDeltaValue):void
        {
            this.deltaValue = _arg_1;
        }

        public function createTrigger(_arg_1:TriggerVO, _arg_2:Triggerable):Trigger
        {
            if ((_arg_1 is TriggerListVO))
            {
                return (new TriggerList(_arg_2, (_arg_1 as TriggerListVO), this.gi));
            };
            var _local_3:Trigger;
            var _local_4:TriggerHashMapVO = (triggerHashMap.getItem(_arg_1.action_string) as TriggerHashMapVO);
            if (_local_4 == null)
            {
                CustomAlert.show(("Trigger not in hashmap for action:" + _arg_1.action_string), "Error");
                return (null);
            };
            _local_3 = _local_4.createInstance(this.deltaValue, _arg_2, _arg_1, this.gi);
            if (_arg_1.invert)
            {
                _local_3 = new InvertTriggerWrapper(_local_3);
            };
            if ((_local_3 is InteractivityTrigger))
            {
                (_local_3 as InteractivityTrigger).createUIObserver();
            };
            return (_local_3);
        }


    }
}
