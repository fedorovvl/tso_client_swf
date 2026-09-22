package Enums
{
    public class COOLDOWN_TYPE 
    {

        public static const TIMEDPRODUCTION_RANGE:int = 100;


        public static function fromTimedProduction(_arg_1:int):int
        {
            return (_arg_1 * TIMEDPRODUCTION_RANGE);
        }


    }
}
