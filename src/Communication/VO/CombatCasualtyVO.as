package Communication.VO
{
    public class CombatCasualtyVO 
    {

        public var sequencePrio:int;
        public var actualRecoverValue:int;
        public var interimRecoverValue:Number;
        public var unitName:String;

        public function CombatCasualtyVO(_arg_1:String, _arg_2:int, _arg_3:Number, _arg_4:int)
        {
            super();
            this.unitName = _arg_1;
            this.sequencePrio = _arg_2;
            this.interimRecoverValue = _arg_3;
            this.actualRecoverValue = _arg_4;
        }

        public static function sortInterimThenSequencePrio(_arg_1:CombatCasualtyVO, _arg_2:CombatCasualtyVO):Number
        {
            if (_arg_1.interimRecoverValue < _arg_2.interimRecoverValue)
            {
                return (1);
            };
            if (_arg_1.interimRecoverValue > _arg_2.interimRecoverValue)
            {
                return (-1);
            };
            if (_arg_1.sequencePrio < _arg_2.sequencePrio)
            {
                return (-1);
            };
            if (_arg_2.sequencePrio > _arg_2.sequencePrio)
            {
                return (1);
            };
            return (0);
        }


    }
}
