package Communication.VO.UpdateVO
{
    import Communication.VO.dArmyVO;
    import Communication.VO.dUniqueID;
    import Enums.BATTLE_RESULT;

    public class dBattleResultVO 
    {

        public var buildingHitPoints:int;
        public var specialistPlayerID:int;
        public var casualtiesDefender:int;
        public var gainedBonusValidXP:int;
        public var lostPopulationDefender:int;
        public var attackingArmyVO:dArmyVO;
        public var attackedBuildingGridIdx:int;
        public var unitFightDuration:int;
        public var casualtiesAttacker:int;
        public var lostPopulationAttacker:int;
        public var combatDuration:int;
        public var defendingArmyVO:dArmyVO;
        public var battleScript:String;
        public var battleResult:int;
        public var gainedXp:int;
        public var specialistUniqueID:dUniqueID;


        public function toString():String
        {
            var _local_1:* = ((((((((((((((((((((((((((("<dBattleResultVO " + "attackedBuildingGridIdx='") + this.attackedBuildingGridIdx) + "' specialistPlayerID='") + this.specialistPlayerID) + "' specialistUniqueID='") + this.specialistUniqueID) + "' combatDuration='") + this.combatDuration) + "' unitFightDuration='") + this.unitFightDuration) + "' casualtiesAttacker='") + this.casualtiesAttacker) + "' casualtiesDefender='") + this.casualtiesDefender) + "' lostPopulationAttacker='") + this.lostPopulationAttacker) + "' lostPopulationDefender='") + this.lostPopulationDefender) + "' gainedXp='") + this.gainedXp) + "' gainedBonusValidXP='") + this.gainedBonusValidXP) + "' buildingHitPoints='") + this.buildingHitPoints) + "' battleResult='") + BATTLE_RESULT.toString(this.battleResult)) + "' >\n");
            _local_1 = (_local_1 + (this.attackingArmyVO + "\n"));
            _local_1 = (_local_1 + (this.defendingArmyVO + "\n"));
            _local_1 = (_local_1 + (this.battleScript + "\n"));
            return (_local_1 + "</dBattleResultVO>");
        }


    }
}
