package Communication.VO
{
    public class dSpecialistTask_TravelToStarMenuVO extends dSpecialistTaskVO 
    {

        public var garrisonGridIdx:int;
        public var destinationZoneID:int;
        public var pathPos:int;


        override public function toString():String
        {
            return (((((((("<dSpecialistTask_TravelToZoneVO " + super.dataString()) + " destinationZoneID='") + this.destinationZoneID) + " pathPos='") + this.pathPos) + " garrisonGridIdx='") + this.garrisonGridIdx) + "' />");
        }


    }
}
