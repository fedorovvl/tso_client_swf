package Communication.VO
{
    import mx.collections.ArrayCollection;

    public class CombatVO 
    {

        public var upcomingUnitPlayer:String = null;
        public var upcomingUnitNPC:String = null;
        public var combatKillStats:ArrayCollection = new ArrayCollection();
        public var random1:int;
        public var random2:int;
        public var random3:int;
        public var currentFightingUnitNPC:String = null;
        public var combatSlotPlayer:CombatSlotVO = null;
        public var randomSeed:int;
        public var currentFightingUnitPlayer:String = null;
        public var combatUnitSwitch:ArrayCollection = new ArrayCollection();
        public var combatSlotNPC:CombatSlotVO = null;
        public var combatResult:int;
        public var combatRound:int;
        public var combatState:int;


        public function toString():String
        {
            return (((((((((((((('<CombatVO random1="' + this.random1) + '" random2="') + this.random2) + '" random3="') + this.random3) + '" randomSeed="') + this.randomSeed) + "\" combatRound='") + this.combatRound) + '" combatStats="') + this.combatState) + '" combatResult="') + this.combatResult) + '" />');
        }


    }
}
