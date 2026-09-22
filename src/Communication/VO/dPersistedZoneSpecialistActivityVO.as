package Communication.VO
{
    import ServerOnly.DirtyIndicator;

    public class dPersistedZoneSpecialistActivityVO 
    {

        public var zoneID:int;
        public var activityType:int;
        public var uniqueID:dUniqueID;
        public var count:int;
        public var lastActivityTime:Number;
        public var playerID:int;
        public var dirtyIndicator:DirtyIndicator = new DirtyIndicator();

        public function dPersistedZoneSpecialistActivityVO()
        {
            super();
            this.dirtyIndicator.created();
        }

        public function toString():String
        {
            return ((((((((((((((((((("<dPersistedZoneSpecialistActivityVO " + "zoneID='") + this.zoneID) + "' ") + "playerID='") + this.playerID) + "' ") + "uniqueID='") + this.uniqueID) + "' ") + "activityType='") + this.activityType) + "' ") + "lastActivityTime='") + this.lastActivityTime) + "' ") + "count='") + this.count) + "' ") + " />");
        }


    }
}
