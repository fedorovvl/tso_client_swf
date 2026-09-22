package Communication.VO.UpdateVO
{
    import mx.collections.ArrayCollection;

    public class dMailsDismissedVO 
    {

        public var claim:Boolean;
        public var items:ArrayCollection = new ArrayCollection();


        public function toString():String
        {
            var _local_2:dLootItemsVO;
            var _local_1:* = "";
            _local_1 = (_local_1 + (("<dMailsDismissedVO claim='" + this.claim) + "' >"));
            for each (_local_2 in this.items)
            {
                _local_1 = (_local_1 + (("  " + _local_2) + "\n"));
            };
            return (_local_1);
        }


    }
}
