package Communication.VO
{
    import Enums.BUFF_APPLIANCE_MODE;

    public class dBuffApplianceVO 
    {

        public var sourceZoneId:int;
        public var uniqueId:dUniqueID;
        public var buffID:int;
        public var startTime:Number;
        public var applianceMode:int;
        public var resourceName_string:String;
        public var nextTickTime:Number;


        public function toString():String
        {
            return ((((((((((((((((((("<dBuffApplianceVO " + "buffName_string='") + this.buffID) + "' ") + "startTime='") + this.startTime) + "' ") + "applianceMode='") + BUFF_APPLIANCE_MODE.toString(this.applianceMode)) + "' ") + "resourceName='") + this.resourceName_string) + "' ") + "sourceZoneId='") + this.sourceZoneId) + "' ") + "nextTickTime='") + this.nextTickTime) + "' ") + " />");
        }


    }
}
