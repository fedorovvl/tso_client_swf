package Communication.VO
{
    public class dTimedProductionQueueChangeVO 
    {

        public var productionType:int;
        public var doAlways:Boolean = false;
        public var itemID:dUniqueID;


        public function toString():String
        {
            return (((("<dTimedProductionVO productionType='" + this.productionType) + "' itemID='") + this.itemID) + "' />");
        }


    }
}
