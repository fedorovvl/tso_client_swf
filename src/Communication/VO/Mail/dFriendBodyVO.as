package Communication.VO.Mail
{
    import Communication.VO.dPlayerListItemVO;

    public class dFriendBodyVO 
    {

        public var player:dPlayerListItemVO;


        public function toString():String
        {
            var _local_1:* = "<dFriendBodyVO ";
            _local_1 = (_local_1 + (("player='" + this.player) + "' "));
            return (_local_1 + " />\n");
        }


    }
}
