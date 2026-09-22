package Communication.VO.UpdateVO
{
    import Enums.ADVENTURE_INVITATION_STATUS;

    public class dAdventurePlayerVO 
    {

        public var adventureID:int;
        public var playerName:String;
        public var status:int = 0;
        public var avatarID:int;
        public var playerID:int;
        public var landingFieldID:int;


        public function Init(_arg_1:int, _arg_2:int):dAdventurePlayerVO
        {
            this.adventureID = _arg_1;
            this.playerID = _arg_2;
            return (this);
        }

        public function toString():String
        {
            return (((((("<dAdventurePlayerVO adventureID='" + this.adventureID) + "' playerID='") + this.playerID) + "' status='") + ADVENTURE_INVITATION_STATUS.toString(this.status)) + "' />");
        }


    }
}
