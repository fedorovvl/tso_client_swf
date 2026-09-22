package Communication.VO
{
    import mx.collections.ArrayCollection;
    import Enums.SPECIALIST_TYPE;

    public class dSpecialistVO 
    {

        public var eventSkills:ArrayCollection;
        public var name_string:String;
        public var garrisonBuildingGridPos:int;
        public var skills:ArrayCollection;
        public var specialistType:int;
        public var task:dSpecialistTaskVO;
        public var xp:int;
        public var buildingsDestroyed:int;
        public var battlesWon:int;
        public var xpProduced:int;
        public var currentHitPoints:int;
        public var unitsDefeated:int;
        public var retreatThreshold:int;
        public var armyVO:dArmyVO = new dArmyVO();
        public var insertedAt:uint;
        public var uniqueID:dUniqueID;
        public var diceBonus:int;
        public var playerID:int;
        public var faceType:int;


        public function toString():String
        {
            var _local_1:* = (("<dSpecialistVO type='" + SPECIALIST_TYPE.toString(this.specialistType)) + "'");
            _local_1 = (_local_1 + ((" currentHitPoints='" + this.currentHitPoints) + "'"));
            _local_1 = (_local_1 + ((" uniqueId='" + this.uniqueID) + "'"));
            _local_1 = (_local_1 + ((" playerId='" + this.playerID) + "'"));
            _local_1 = (_local_1 + ((" name='" + this.name_string) + "'"));
            _local_1 = (_local_1 + ((" faceType='" + this.faceType) + "'"));
            _local_1 = (_local_1 + ((" xp='" + this.xp) + "'"));
            _local_1 = (_local_1 + ((" diceBonus='" + this.diceBonus) + "'"));
            _local_1 = (_local_1 + ((" retreatThreshold='" + this.retreatThreshold) + "'"));
            _local_1 = (_local_1 + ((" task='" + this.task) + "'"));
            _local_1 = (_local_1 + ((" garrisonBuildingGridPos='" + this.garrisonBuildingGridPos) + "'"));
            _local_1 = (_local_1 + ((" xpProduced='" + this.xpProduced) + "'"));
            _local_1 = (_local_1 + ((" battlesWon='" + this.battlesWon) + "'"));
            _local_1 = (_local_1 + ((" unitsDefeated='" + this.unitsDefeated) + "'"));
            _local_1 = (_local_1 + ((" buildingsDestroyed='" + this.buildingsDestroyed) + "'"));
            _local_1 = (_local_1 + ((" skills='" + this.skills) + "'"));
            _local_1 = (_local_1 + " >");
            if (this.task != null)
            {
                _local_1 = (_local_1 + ("\n" + this.task));
            };
            _local_1 = (_local_1 + ("\n" + this.armyVO));
            return (_local_1 + "</dSpecialistVO>");
        }


    }
}
