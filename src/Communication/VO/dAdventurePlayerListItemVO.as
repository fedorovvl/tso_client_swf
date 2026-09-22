package Communication.VO
{
    import Communication.VO.UpdateVO.dAdventurePlayerVO;

    public class dAdventurePlayerListItemVO extends dPlayerListItemVO 
    {

        public var status:int;


        public function InitFromAdventurePlayerVO(_arg_1:dAdventurePlayerVO):dAdventurePlayerListItemVO
        {
            this.id = _arg_1.playerID;
            this.status = _arg_1.status;
            this.username = _arg_1.playerName;
            this.avatarId = _arg_1.avatarID;
            return (this);
        }

        public function InitFromPlayerListItemVO(_arg_1:dPlayerListItemVO):dAdventurePlayerListItemVO
        {
            this.adventureVO = _arg_1.adventureVO;
            this.avatarId = _arg_1.avatarId;
            this.id = _arg_1.id;
            this.onlineStatus = _arg_1.onlineStatus;
            this.playerLevel = _arg_1.playerLevel;
            this.username = _arg_1.username;
            return (this);
        }


    }
}
