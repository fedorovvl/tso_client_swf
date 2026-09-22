package Communication.VO.UpdateVO
{
    import mx.collections.ArrayCollection;

    public class dAdventureClientInfoVO 
    {

        public var admiralCount:int;
        public var players:ArrayCollection = new ArrayCollection();
        public var isAssignedToTempSlot:Boolean;
        public var zoneID:int;
        public var mapLevel:int = 0;
        public var troopLimit:int = -1;
        public var colonyStatus:int;
        public var ownerPlayerID:int;
        public var isLookingForHelp:Boolean = false;
        public var isTrackedMission:Boolean = false;
        public var colonyID:int;
        public var colonyOwnerPlayerId:int = 0;
        public var colonyPreviousOwnerId:int = 0;
        public var colonyYieldStartTime:Number;
        public var colonyDuration:Number = 0;
        public var rewardId:int = -1;
        public var status:int;
        public var totalDuration:Number = 0;
        public var adventureName:String;
        public var collectedTime:Number = 0;


        public function getNumPlayers():int
        {
            return (int(this.adventureName.split("_")[3]));
        }

        public function IsColony():Boolean
        {
            return (this.colonyID > 0);
        }

        public function getLevelRange():int
        {
            return (int(this.adventureName.split("_")[1]));
        }

        public function toString():String
        {
            return (((((((((((("<dAdventureVO adventureName='" + this.adventureName) + "' zoneID='") + this.zoneID) + "' status='") + this.status) + "' collectedTime='") + this.collectedTime) + "' totalDuration='") + this.totalDuration) + "' ownerPlayerID='") + this.ownerPlayerID) + "/>");
        }

        public function getDifficulty():int
        {
            return (int(this.adventureName.split("_")[2]));
        }

        public function IsFromMapPool():Boolean
        {
            if (global.ui.mCurrentPlayer.getPlayerID() == this.colonyOwnerPlayerId)
            {
                return ((this.colonyPreviousOwnerId == 0) || (this.colonyPreviousOwnerId == defines.PVP_USER_ID));
            };
            return ((this.colonyOwnerPlayerId == 0) || (this.colonyOwnerPlayerId == defines.PVP_USER_ID));
        }


    }
}
