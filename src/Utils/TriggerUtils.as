package Utils
{
    import Communication.VO.ExpeditionMapSizeDataVO;

    public class TriggerUtils 
    {

        public static const ON_MAP_NOTIFICATION_PROPERTY_NAME:String = "mCurrentlyBuildingsCount";
        public static const UNITS_OWNED_NOTIFICATION_PROPERTY_NAME:String = "unitsOwned";
        public static const NON_GUILD_FRIENDS_PROPERTY_NAME:String = "nonGuildFriends";
        public static const BUFF_APPLIED_ON_FRIEND_PROPERTY_NAME:String = "buffAppliedOnFriend";
        public static const BUFF_RECEIVED_FROM_FRIEND_PROPERTY_NAME:String = "buffReceivedFromFriend";
        public static const OWN_RESOURCE_PROPERTY_NAME:String = "ownResource";
        public static const ADVENTURE_COMPLETED_PROPERTY_NAME:String = "adventureCompleted";
        public static const ADVENTURE_DEFENDED_PROPERTY_NAME:String = "adventureDefended";
        public static const ADVENTURE_COMPLETED_CHECK_UNITS_PROPERTY_NAME:String = "adventureCompletedCheckUnits";
        public static const ADVENTURE_PVP_COMPLETED_CHECK_UNITS_PROPERTY_NAME:String = "adventurePvPCompletedCheckUnits";
        public static const SKILL_CHANGED_PROPERTY_NAME:String = "skillChanged";
        public static const DAILY_LOGIN_PROPERTY_NAME:String = "dailyLogin";
        public static const GUILD_UPDATED_PROPERTY_NAME:String = "guildUpdated";
        public static const STAR_MENU_UPDATED_PROPERTY_NAME:String = "starMenuUpdated";
        public static const TIMED_PRODUCED_ITEMS_PROPERTY_NAME:String = "timedProducedItems";
        public static const STREETS_UPDATED_PROPERTY_NAME:String = "streetsUpdated";
        public static const BOUGHT_SUCCESSFUL_PROPERTY_NAME:String = "boughtSuccessful";
        public static const GENERAL_TRAVEL_PROPERTY_NAME:String = "generalTravel";
        public static const ADMIRAL_TRAVEL_PROPERTY_NAME:String = "admiralTravel";
        public static const TRADE_QUEUE_SLOT_PROPERTY_NAME:String = "tradeQueueSlot";
        public static const TRADE_QUEUE_SLOT_TEMPORARY_TYPE_NAME:String = "Temp";
        public static const TRADE_QUEUE_SLOT_PERMANENT_TYPE_NAME:String = "Permanent";
        public static const COLONY_SLOT_PROPERTY_NAME:String = "colonySlot";
        public static const SOLD_SUCCESSFUL_PROPERTY_NAME:String = "soldSuccessful";
        public static const QUEST_TYPE_COMPLETED_NAME:String = "questtypecompleted";
        public static const ZONE_UPDATED:String = "zoneUpdated";
        public static const RESOURCE_MANAGER_ADD_RESOURCE_NAME:String = "resourcemanageraddresource";
        public static const COLONY_SLOTS_TOTAL:String = "colonyslotstotal";
        public static const ADD_RESOURCE_NAME:String = "addResource";
        public static const LOOT_RESOURCE_NAME:String = "lootedResource";
        public static const QUEST_COMPLETED_PROPERTY_NAME:String = "questCompleted";
        public static const ZONE_VISITOR:String = "zoneVisitor";
        public static const ZONE_LOADED:String = "zoneLoaded";
        public static const COLLECTED_PICKUP_NAME:String = "collectedpickup";
        public static const COLLECTION_BOUGHT_PROPERTY_NAME:String = "collectionBought";
        public static const ADVENTURE_LOST_string:String = "adventureLost";
        public static const PAY_TO_FINISH_string:String = "paytofinish";


        public static function contains(_arg_1:Array, _arg_2:String):Boolean
        {
            var _local_3:String;
            for each (_local_3 in _arg_1)
            {
                if (_local_3 == _arg_2)
                {
                    return (true);
                };
                if (((StringUtils.startsWith(_local_3, "%")) && (StringUtils.contains(StringUtils.SubString(_local_3, 1, (_local_3.length - 1)), _arg_2))))
                {
                    return (true);
                };
            };
            return (false);
        }

        public static function containsIgnoreCase(_arg_1:Array, _arg_2:String):Boolean
        {
            var _local_4:String;
            var _local_3:String = _arg_2.toLowerCase();
            for each (_local_4 in _arg_1)
            {
                if (_local_4.toLowerCase() == _local_3)
                {
                    return (true);
                };
            };
            return (false);
        }

        public static function CheckAdventureSize(_arg_1:String, _arg_2:int):Boolean
        {
            var _local_3:ExpeditionMapSizeDataVO = global.expeditionMapSizeVO.GetMapSizeDataForMapLevel(_arg_2);
            if (_local_3 == null)
            {
                return (false);
            };
            if (_arg_1 == "small")
            {
                return (_local_3.id == 1);
            };
            if (_arg_1 == "medium")
            {
                return (_local_3.id == 2);
            };
            if (_arg_1 == "large")
            {
                return (_local_3.id == 3);
            };
            return (true);
        }


    }
}
