package Communication.VO
{
    public class dSpecialistTask_AttackBuildingNewCombatVO extends dSpecialistTaskVO 
    {

        public var targetBuildingGridPos:int;
        public var startWaitPhase:Number;
        public var startingArmySize:int;
        public var lastRound:Number;
        public var armyDestinationBuildingGridPos:int;
        public var startGridPos:int;
        public var combatVO:CombatVO = null;
        public var startingUnitName:String;
        public var pathPos:int;
        public var attackBuildingMode:int;


        override public function toString():String
        {
            var _local_1:* = "<dSpecialistTask_AttackBuildingNewCombatVO ";
            _local_1 = (_local_1 + super.dataString());
            _local_1 = (_local_1 + (" targetBuildingGridPos='" + this.targetBuildingGridPos));
            _local_1 = (_local_1 + ("' armyDestinationBuildingGridPos='" + this.armyDestinationBuildingGridPos));
            _local_1 = (_local_1 + ("' startingArmySize='" + this.startingArmySize));
            _local_1 = (_local_1 + ("' lastRound='" + this.lastRound));
            _local_1 = (_local_1 + ("' pathPost='" + this.pathPos));
            _local_1 = (_local_1 + ("' attackBuildingMode='" + this.attackBuildingMode));
            _local_1 = (_local_1 + ("' startingUnitName='" + this.startingUnitName));
            return (_local_1 + "' />");
        }


    }
}
