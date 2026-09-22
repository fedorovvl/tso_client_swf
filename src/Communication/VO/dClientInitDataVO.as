package Communication.VO
{
    public class dClientInitDataVO 
    {

        public var clientCapabilities:String;
        public var clientInitDuration:int;


        public function toString():String
        {
            var _local_1:* = ((((("<dClientInitDataVO" + " clientInitDuration='") + this.clientInitDuration) + "' clientCapabilities='") + this.clientCapabilities) + "' >\n");
            return (_local_1 + "</dClientInitDataVO>");
        }


    }
}
