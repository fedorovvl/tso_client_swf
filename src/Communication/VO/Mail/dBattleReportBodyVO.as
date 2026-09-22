package Communication.VO.Mail
{
    public class dBattleReportBodyVO 
    {

        public var battleScript:String;


        public function toString():String
        {
            var _local_1:* = "<dBattleReportBodyVO ";
            _local_1 = (_local_1 + (("battleScript='" + this.battleScript) + "' "));
            return (_local_1 + " />\n");
        }


    }
}
