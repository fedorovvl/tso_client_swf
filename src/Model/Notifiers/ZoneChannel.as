package Model.Notifiers
{
    import Utils.TriggerUtils;
    import ServerState.cPlayerData;

    public final class ZoneChannel extends Channel 
    {

        public static const ZONE_REFRESHED:String = "ZONE_REFRESHED";
        public static const ZONE_REFRESHED_CLIENT:String = "ZONE_REFRESHED_CLIENT";
        public static const ZONE_LOADED:String = "ZONE_LOADED";
        public static const FOG_RECALCULATED:String = "FOG_RECALCULATED";
        public static const COLLECTIBLES_UPDATED:String = "COLLECTIBLES_UPDATED";
        public static const FILTER_APPLIED:String = "FILTER_APPLIED";
        public static const COOLDOWN_EXPIRED:String = "COOLDOWN_EXPIRED";
        public static const SECTOR_LIBERATED:String = "SECTOR_LIBERATED";
        public static const ON_MAP_NOTIFICATION:String = TriggerUtils.ON_MAP_NOTIFICATION_PROPERTY_NAME;
        public static const LEVELUP:String = cPlayerData.PLAYER_LEVEL_CHANGED;


        public function collectiblesUpdated(_arg_1:int):void
        {
            send(COLLECTIBLES_UPDATED, _arg_1);
        }

        public function filterApplied(_arg_1:String):void
        {
            send(FILTER_APPLIED, _arg_1);
        }

        public function cooldownExpired(_arg_1:int):void
        {
            send(COOLDOWN_EXPIRED, _arg_1);
        }

        public function loaded():void
        {
            send(ZONE_LOADED, null);
        }

        public function sectorLiberated(_arg_1:int, _arg_2:int):void
        {
            send(SECTOR_LIBERATED, _arg_1);
        }

        public function levelup():void
        {
            send(LEVELUP, null);
        }


    }
}
