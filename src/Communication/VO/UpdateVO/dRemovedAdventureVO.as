package Communication.VO.UpdateVO
{
    import flash.utils.IDataInput;
    import flash.utils.IDataOutput;

    public class dRemovedAdventureVO 
    {

        public var adventureStatus:int;
        public var playerRemoverID:int;
        public var removedAdventureID:int;
        public var mapLevel:int;
        public var contestedPvPColony:Boolean;
        public var colonyId:int;
        public var completedTime:int;
        public var adventureName:String;


        public function readExternal(_arg_1:IDataInput):void
        {
            this.playerRemoverID = _arg_1.readInt();
            this.removedAdventureID = _arg_1.readInt();
            this.adventureName = _arg_1.readUTF();
            this.adventureStatus = _arg_1.readInt();
            this.completedTime = _arg_1.readInt();
            this.mapLevel = _arg_1.readInt();
            this.contestedPvPColony = _arg_1.readBoolean();
            this.colonyId = _arg_1.readInt();
        }

        public function toString():String
        {
            return (((((((((((("<dRemovedAdventureVO playerRemoverID='" + this.playerRemoverID) + "' removedAdventureID='") + this.removedAdventureID) + "' adventureName='") + this.adventureName) + "' adventureStatus='") + this.adventureStatus) + "' mapLevel='") + this.mapLevel) + "' completedTime='") + this.completedTime) + "' />");
        }

        public function writeExternal(_arg_1:IDataOutput):void
        {
            _arg_1.writeInt(this.playerRemoverID);
            _arg_1.writeInt(this.removedAdventureID);
            _arg_1.writeUTF(this.adventureName);
            _arg_1.writeInt(this.adventureStatus);
            _arg_1.writeInt(this.completedTime);
            _arg_1.writeInt(this.mapLevel);
            _arg_1.writeBoolean(this.contestedPvPColony);
            _arg_1.writeInt(this.colonyId);
        }


    }
}
