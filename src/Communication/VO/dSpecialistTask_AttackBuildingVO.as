package Communication.VO
{
    import Communication.VO.UpdateVO.dBattleResultVO;

    public class dSpecialistTask_AttackBuildingVO extends dSpecialistTaskVO 
    {

        public var targetBuildingGridPos:int;
        public var battleReport_string:String;
        public var startingArmySize:int;
        public var attackBuildingMode:int;
        public var armyDestinationBuildingGridPos:int;
        public var startWaitPhase:Number;
        public var startGridPos:int;
        public var battleResultVO:dBattleResultVO;
        public var pathPos:int;
        public var battleScript_string:String;
        public var lastRound:Number;


        override public function toString():String
        {
            var _local_1:* = "<dSpecialistTask_AttackBuildingVO ";
            _local_1 = (_local_1 + super.dataString());
            _local_1 = (_local_1 + (" targetBuildingGridPos='" + this.targetBuildingGridPos));
            _local_1 = (_local_1 + ("' armyDestinationBuildingGridPos='" + this.armyDestinationBuildingGridPos));
            _local_1 = (_local_1 + ("' startingArmySize='" + this.startingArmySize));
            _local_1 = (_local_1 + ("' lastRound='" + this.lastRound));
            _local_1 = (_local_1 + ("' pathPos='" + this.pathPos));
            _local_1 = (_local_1 + ("' attackBuildingMode='" + this.attackBuildingMode));
            _local_1 = (_local_1 + ("' battleReport='" + this.battleReport_string));
            _local_1 = (_local_1 + ("' battleScript='" + this.battleScript_string));
            _local_1 = (_local_1 + ("' battleResultVO='" + this.battleResultVO));
            return (_local_1 + "' />");
        }


    }
}
