package Communication.VO
{
    import Enums.TIMED_PRODUCTION_TYPE;

    public class dTimedProductionVO 
    {

        public var modifiedProductionMultiplier:Number = 1;
        public var collectedTime:Number;
        public var modifiedProductionAdder:int = 0;
        public var index:int;
        public var productionType:int;
        public var modifiedInstantFinishCostMultiplier:Number = 1;
        public var buildingGrid:int;
        public var uniqueId:dUniqueID;
        public var producedItems:int;
        public var amount:int;
        public var playerId:int;
        public var stacks:int = 1;
        public var modifiedInstantFinishCostAdder:int = 0;
        public var type_string:String;


        public function toString():String
        {
            var _local_1:* = (((((((((((((("<dTimedProductionVO uniqueId='" + this.uniqueId) + "' playerId='") + this.playerId) + "productionType='") + TIMED_PRODUCTION_TYPE.toString(this.productionType)) + "' type='") + this.type_string) + "' amount='") + this.amount) + "' producedItems='") + this.producedItems) + "' mCollectedTime='") + this.collectedTime) + " >");
            return (_local_1 + "</dTimedProductionVO>");
        }

        public function ResetModifiers():void
        {
            this.modifiedProductionAdder = 0;
            this.modifiedProductionMultiplier = 1;
            this.modifiedInstantFinishCostAdder = 0;
            this.modifiedInstantFinishCostMultiplier = 1;
        }


    }
}
