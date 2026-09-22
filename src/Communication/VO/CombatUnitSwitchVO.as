package Communication.VO
{
    public class CombatUnitSwitchVO 
    {

        public var round:int = 0;
        public var unitType:String = null;


        public static function Create(_arg_1:String, _arg_2:int):CombatUnitSwitchVO
        {
            var _local_3:CombatUnitSwitchVO = new (CombatUnitSwitchVO)();
            _local_3.round = _arg_2;
            _local_3.unitType = _arg_1;
            return (_local_3);
        }


    }
}
