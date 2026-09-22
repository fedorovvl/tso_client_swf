package Communication.VO
{
    import mx.collections.ArrayCollection;

    public class dAdventureVO 
    {

        public var isDefenseMode:Boolean;
        public var adventureDuration:int;
        public var mapLevel:int;
        public var troopLimit:int;
        public var players:ArrayCollection = new ArrayCollection();
        public var ownerPlayerID:int;
        public var state:int;
        public var randomSeed:int;
        public var startTime:Number;
        public var isLookingForHelp:Boolean;
        public var adventureID:int;
        public var adventureDefinitionName:String;
        public var admiralCount:int;
        public var colonyId:int;
        public var serverDownDuration:int;


    }
}
