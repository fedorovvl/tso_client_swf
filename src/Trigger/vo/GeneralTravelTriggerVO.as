package Trigger.vo
{
    public class GeneralTravelTriggerVO 
    {

        private var generalName:String;
        private var travelTime:int;
        private var zoneId:int;

        public function GeneralTravelTriggerVO(_arg_1:String, _arg_2:int, _arg_3:int)
        {
            super();
            this.generalName = _arg_1;
            this.zoneId = _arg_2;
            this.travelTime = _arg_3;
        }

        public function getZoneId():int
        {
            return (this.zoneId);
        }

        public function getTravelTime():int
        {
            return (this.travelTime);
        }

        public function getGeneralName():String
        {
            return (this.generalName);
        }


    }
}
