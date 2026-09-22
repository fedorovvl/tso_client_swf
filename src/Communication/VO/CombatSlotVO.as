package Communication.VO
{
    public class CombatSlotVO 
    {

        public var slotType:int = -1;
        public var hitPointsLeft:Number = 0;
        public var unitType:String = null;


        public function toString():String
        {
            return (((((('<CombatSlotVO slotType="' + this.slotType) + '" unitType="') + this.unitType) + '" hitPointsLeft="') + this.hitPointsLeft) + '" />');
        }


    }
}
