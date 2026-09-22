package Communication.VO
{
    import mx.collections.ArrayCollection;

    public class dBuildQueueVO 
    {

        public var permanentSlotsCount:int;
        public var maxCount:int;
        public var tempSlotsCount:int;

        public var buildings:ArrayCollection = new ArrayCollection();
        public var tempSlots:ArrayCollection = new ArrayCollection();


        public function toString():String
        {
            var _local_1:* = (((((("<dBuildQueueVO maxCount='" + this.maxCount) + "' permanentSlotsCount='") + this.permanentSlotsCount) + "' tempSlotsCount='") + this.tempSlotsCount) + "' >\n");
            _local_1 = (_local_1 + gCalculations.createListString("Buildings", this.buildings));
            return (_local_1 + "</dBuildQueueVO>");
        }


    }
}
