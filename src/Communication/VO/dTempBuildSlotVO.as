package Communication.VO
{
    public class dTempBuildSlotVO 
    {

        public var buildingGridPos:int;
        public var expireAt:Number;
        public var timeOfPurchase:Number;
        public var dirtyIndicator:int;


        public function isPremiumSlot():Boolean
        {
            return (this.expireAt > 0.1);
        }

        public function toString():String
        {
            return (((((("<dTempBuildSlotVO timeOfPurchase='" + this.timeOfPurchase) + "'buildingGridPos='") + this.buildingGridPos) + "'expireAt='") + this.expireAt) + "'/>");
        }


    }
}
