package Communication.VO
{
    import Communication.VO.UpdateVO.dAdventureClientInfoVO;

    public class ColonyVO 
    {

        public var isAssignedToTempSlot:Boolean = false;
        public var mapLevel:int;
        public var troopLimit:int;
        public var playerName:String;
        public var startTime:Number = 0;
        public var state:int;
        public var currentAdventureId:int;
        public var randomSeed:int;
        public var colonyYieldStartTime:Number = 0;
        public var guildName:String;
        public var rewardId:int;
        public var ownerPlayerId:int;
        public var colonyId:int;
        public var defenseCount:int = 0;
        public var previousOwnerId:int;
        public var adventureName:String;


        public static function Create(_arg_1:int, _arg_2:String, _arg_3:int, _arg_4:int, _arg_5:int, _arg_6:int, _arg_7:int, _arg_8:Number, _arg_9:Boolean, _arg_10:Number, _arg_11:int, _arg_12:int, _arg_13:int):ColonyVO
        {
            var _local_14:ColonyVO = new (ColonyVO)();
            _local_14.colonyId = _arg_1;
            _local_14.adventureName = _arg_2;
            _local_14.state = _arg_3;
            _local_14.startTime = _arg_8;
            _local_14.ownerPlayerId = _arg_4;
            _local_14.rewardId = _arg_5;
            _local_14.mapLevel = _arg_6;
            _local_14.previousOwnerId = _arg_7;
            _local_14.isAssignedToTempSlot = _arg_9;
            _local_14.colonyYieldStartTime = _arg_10;
            _local_14.defenseCount = _arg_11;
            _local_14.randomSeed = _arg_12;
            _local_14.currentAdventureId = _arg_13;
            return (_local_14);
        }


        public function getNumPlayers():int
        {
            return (int(this.adventureName.split("_")[3]));
        }

        public function GetAdventureClientVO():dAdventureClientInfoVO
        {
            var _local_1:dAdventureClientInfoVO = new dAdventureClientInfoVO();
            _local_1.colonyID = this.colonyId;
            _local_1.adventureName = this.adventureName;
            _local_1.colonyStatus = this.state;
            _local_1.rewardId = this.rewardId;
            _local_1.mapLevel = this.mapLevel;
            _local_1.colonyOwnerPlayerId = this.ownerPlayerId;
            _local_1.colonyPreviousOwnerId = this.previousOwnerId;
            _local_1.isAssignedToTempSlot = this.isAssignedToTempSlot;
            _local_1.colonyYieldStartTime = this.colonyYieldStartTime;
            _local_1.troopLimit = this.troopLimit;
            return (_local_1);
        }

        public function getDifficulty():int
        {
            return (int(this.adventureName.split("_")[2]));
        }

        public function getLevelRange():int
        {
            return (int(this.adventureName.split("_")[1]));
        }

        public function IsFromMapPool():Boolean
        {
            return (((this.ownerPlayerId == defines.PVP_USER_ID) || (this.previousOwnerId == defines.PVP_USER_ID)) || ((this.previousOwnerId == 0) && (this.ownerPlayerId == defines.PVP_USER_ID)));
        }

        public function toString():String
        {
            return (((((((((((((((((((((('<ColonyVO colonyId="' + this.colonyId) + "' adventureName='") + this.adventureName) + "' state='") + this.state) + "' startTime='") + this.startTime) + "' ownerPlayerID='") + this.ownerPlayerId) + "' rewardId='") + this.rewardId) + "' mapLevel='") + this.mapLevel) + "' isAssignedToTempSlot='") + this.isAssignedToTempSlot) + "' colonyYieldStartTime='") + this.colonyYieldStartTime) + "' defenseCount='") + this.defenseCount) + "' randomSeed='") + this.randomSeed) + "/>");
        }


    }
}
