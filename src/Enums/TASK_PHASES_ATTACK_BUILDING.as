package Enums
{
    public class TASK_PHASES_ATTACK_BUILDING 
    {

        public static const GO_TO_TARGET:int = 0;
        public static const WAIT_AT_TARGET:int = 1;
        public static const ATTACK_TARGET:int = 2;
        public static const RETURN_TO_GARRISON:int = 3;
        public static const WAIT_FOR_ORDERS:int = 4;


        public static function toString(_arg_1:int):String
        {
            switch (_arg_1)
            {
                case GO_TO_TARGET:
                    return ("GoToTarget");
                case WAIT_AT_TARGET:
                    return ("WaitAtTarget");
                case ATTACK_TARGET:
                    return ("AttackTarget");
                case RETURN_TO_GARRISON:
                    return ("ReturnToGarrison");
                case WAIT_FOR_ORDERS:
                    return ("WaitForOrders");
                default:
                    return ("Unknown: " + _arg_1);
            };
        }


    }
}
