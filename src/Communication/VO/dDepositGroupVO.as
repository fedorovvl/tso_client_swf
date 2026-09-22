package Communication.VO
{
    import mx.collections.ArrayCollection;

    public class dDepositGroupVO 
    {

        public var mDepositsVector:ArrayCollection = new ArrayCollection();
        public var mId:int;
        public var mDepositType_string:String;
        public var mMaxAccessible:int;
        public var mAverageAmount:int;
        public var mAccessibleFromStart:int;


        public function toString():String
        {
            var _local_3:int;
            var _local_1:* = "";
            var _local_2:Boolean = true;
            for each (_local_3 in this.mDepositsVector)
            {
                if (!_local_2)
                {
                    _local_1 = (_local_1 + ",");
                    _local_2 = true;
                };
                _local_1 = (_local_1 + ("" + _local_3));
            };
            return (((((((((("<DepositGroups mId='" + this.mId) + "' mDepositType_string='") + this.mDepositType_string) + "' mMaxAccessible='") + this.mMaxAccessible) + "' mAverageAmount='") + this.mAverageAmount) + "' mDepositsVector='") + _local_1) + "' />");
        }


    }
}
