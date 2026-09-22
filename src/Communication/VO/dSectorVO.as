package Communication.VO
{
    import flash.utils.IDataInput;
    import flash.utils.IDataOutput;

    public class dSectorVO 
    {

        public var sectorID:int;
        public var islandDeedType:int;
        public var cityLevelAtWhichSectorIsActivated:int;
        public var explorePriority:int;
        public var isExplored:Boolean;
        public var playerID:int;
        public var isIsland:Boolean;


        public function readExternal(_arg_1:IDataInput):void
        {
            this.sectorID = _arg_1.readInt();
            this.playerID = _arg_1.readInt();
            this.explorePriority = _arg_1.readInt();
            this.cityLevelAtWhichSectorIsActivated = _arg_1.readInt();
            this.isIsland = _arg_1.readBoolean();
            this.islandDeedType = _arg_1.readInt();
            this.isExplored = _arg_1.readBoolean();
        }

        public function writeExternal(_arg_1:IDataOutput):void
        {
            _arg_1.writeInt(this.sectorID);
            _arg_1.writeInt(this.playerID);
            _arg_1.writeInt(this.explorePriority);
            _arg_1.writeInt(this.cityLevelAtWhichSectorIsActivated);
            _arg_1.writeBoolean(this.isIsland);
            _arg_1.writeInt(this.islandDeedType);
            _arg_1.writeBoolean(this.isExplored);
        }

        public function toString():String
        {
            return (((((((((((("<dSectorVO sectorID='" + this.sectorID) + "' playerID='") + this.playerID) + "' explorePriority='") + this.explorePriority) + "' cityLevelAtWhichSectorIsActivated='") + this.cityLevelAtWhichSectorIsActivated) + "' isIsland='") + this.isIsland) + "' islandDeedType='") + this.islandDeedType) + "' />");
        }


    }
}
