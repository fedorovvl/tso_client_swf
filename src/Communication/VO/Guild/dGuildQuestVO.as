package Communication.VO.Guild
{
    public class dGuildQuestVO 
    {

        public var status:int;
        public var uniqueID:int;
        public var questname:String;


        public function toString():String
        {
            return (((((("<GuildQuestVO uniqueID='" + this.uniqueID) + "' questname='") + this.questname) + "' status='") + this.status) + "' />\n");
        }


    }
}
