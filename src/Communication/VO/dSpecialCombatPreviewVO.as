package Communication.VO
{
    public class dSpecialCombatPreviewVO 
    {

        public var unitType_string:String;
        public var amount:int;
        public var combatPreviewText_string:String;


        public function init(_arg_1:String, _arg_2:int, _arg_3:String):dSpecialCombatPreviewVO
        {
            this.unitType_string = _arg_1;
            this.amount = _arg_2;
            this.combatPreviewText_string = _arg_3;
            return (this);
        }


    }
}
