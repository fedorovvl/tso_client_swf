package Communication.VO.Mail
{
    public class dHardCurrencyMailBodyVO 
    {

        public var amount:int;
        public var text:String;


        public function toString():String
        {
            var _local_1:* = "<dFriendBodyVO ";
            _local_1 = (_local_1 + (("text='" + this.text) + "' "));
            _local_1 = (_local_1 + (("amount='" + this.amount) + "' "));
            return (_local_1 + " />\n");
        }


    }
}
