package Communication.VO
{
    public class dSpecialistTask_TravelToZoneVO extends dSpecialistTaskVO 
    {

        public var recoveryExtraTime:int;
        public var garrisonGridIdx:int;
        public var destinationZoneID:int;
        public var pathPos:int;
        public var landingFieldId:int;


        override public function toString():String
        {
            return (((((((("<dSpecialistTask_TravelToZoneVO " + super.dataString()) + " destinationZoneID='") + this.destinationZoneID) + " pathPos='") + this.pathPos) + " garrisonGridIdx='") + this.garrisonGridIdx) + "' />");
        }


    }
}
