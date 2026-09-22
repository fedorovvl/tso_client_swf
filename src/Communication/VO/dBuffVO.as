package Communication.VO
{
    import BuffSystem.cBuff;

    public class dBuffVO implements Tradeable 
    {

        public var mapLevel:int;
        public var randomSeed:int;
        public var resourceName_string:String;
        public var amount:int;
        public var uniqueId1:int;
        public var uniqueId2:int;
        public var sourceZoneId:int;
        public var insertedAt:uint;
        public var recurringChance:int;
        public var buffName_string:String;


        public static function cloneDBuffVO(_arg_1:dBuffVO):dBuffVO
        {
            var _local_2:dBuffVO = new (dBuffVO)();
            _local_2.uniqueId1 = _arg_1.uniqueId1;
            _local_2.uniqueId2 = _arg_1.uniqueId2;
            _local_2.buffName_string = _arg_1.buffName_string;
            _local_2.resourceName_string = _arg_1.resourceName_string;
            _local_2.amount = _arg_1.amount;
            _local_2.recurringChance = _arg_1.recurringChance;
            _local_2.randomSeed = _arg_1.randomSeed;
            _local_2.sourceZoneId = _arg_1.sourceZoneId;
            _local_2.mapLevel = _arg_1.mapLevel;
            _local_2.insertedAt = _arg_1.insertedAt;
            return (_local_2);
        }


        public function getName():String
        {
            return (cBuff.CreateBuffFromVO(this).getLocalizedBuffName());
        }

        public function getAmount():int
        {
            return (this.amount);
        }

        public function GetResourceName_string():String
        {
            return (this.resourceName_string);
        }

        public function toString():String
        {
            var _local_1:* = "<dBuffVO ";
            _local_1 = (_local_1 + (("uniqueId1='" + this.uniqueId1) + "' "));
            _local_1 = (_local_1 + (("uniqueId2='" + this.uniqueId2) + "' "));
            _local_1 = (_local_1 + (("buffName_string='" + this.buffName_string) + "' "));
            _local_1 = (_local_1 + (("resourceName='" + this.resourceName_string) + "' "));
            _local_1 = (_local_1 + (("amount='" + this.amount) + "' "));
            _local_1 = (_local_1 + (("recurringChance='" + this.recurringChance) + "' "));
            _local_1 = (_local_1 + (("randomSeed='" + this.randomSeed) + "' "));
            _local_1 = (_local_1 + (("sourceZoneId='" + this.sourceZoneId) + "' "));
            _local_1 = (_local_1 + (("mapLevel='" + this.mapLevel) + "' "));
            return (_local_1 + "/>");
        }


    }
}
