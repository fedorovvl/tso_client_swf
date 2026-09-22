package Communication.VO
{
    public class dSpecialistTask_ExploreSectorVO extends dSpecialistTaskVO 
    {

        public var exploredSectorId:int;


        override public function toString():String
        {
            return (((("<dSpecialistTaskVO " + super.dataString()) + " exploredSectorId='") + this.exploredSectorId) + "' />");
        }


    }
}
