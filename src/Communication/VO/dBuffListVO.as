package Communication.VO
{
    import mx.collections.ArrayCollection;

    public class dBuffListVO 
    {

        public var buffList:ArrayCollection = new ArrayCollection();
        public var target_string:String;


        public function toString():String
        {
            var _local_2:dBuffVO;
            var _local_1:* = (("<dBuffVO target='" + this.target_string) + "'>");
            for each (_local_2 in this.buffList)
            {
                _local_1 = (_local_1 + _local_2.toString());
            };
            return (_local_1 + "</dBuffVO>");
        }


    }
}
