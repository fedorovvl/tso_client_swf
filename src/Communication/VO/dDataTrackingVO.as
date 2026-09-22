package Communication.VO
{
    import mx.collections.ArrayCollection;

    public class dDataTrackingVO 
    {

        public var dataTracking:ArrayCollection = new ArrayCollection();
        public var amount:int;


        public function toString():String
        {
            var _local_2:dDataIntStringVO;
            var _local_1:* = "";
            if (this.dataTracking.length > 0)
            {
                _local_1 = (_local_1 + ((" <dDataTrackingVO amount='" + this.amount) + "'>\n"));
                _local_1 = (_local_1 + "  <dDataIntStringArray>\n");
                for each (_local_2 in this.dataTracking)
                {
                    _local_1 = (_local_1 + (("  " + _local_2) + "\n"));
                };
                _local_1 = (_local_1 + "  </dDataIntStringArray>\n");
                _local_1 = (_local_1 + " </dDataTrackingVO>");
            }
            else
            {
                _local_1 = (("<dDataTrackingVO amount='" + this.amount) + "'/>");
            };
            return (_local_1);
        }


    }
}
