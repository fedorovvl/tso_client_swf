package Communication.VO.Mail
{
    public class dGuildBodyVO 
    {

        public var guildName:String;
        public var bannerId:int;


        public function toString():String
        {
            var _local_1:* = "<dBattleReportBodyVO ";
            _local_1 = (_local_1 + (("guildName='" + this.guildName) + "' "));
            _local_1 = (_local_1 + (("bannerId='" + this.bannerId) + "' "));
            return (_local_1 + " />\n");
        }


    }
}
