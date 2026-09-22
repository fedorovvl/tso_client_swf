package Enums
{
    public class TASK_PHASES_ATTACK_BUILDING_NEW_COMBAT 
    {

        public static const GO_TO_TARGET:int = 0;
        public static const WAIT_AT_TARGET:int = 1;
        public static const BEGIN_ATTACK:int = 2;
        public static const ATTACK_TARGET:int = 3;
        public static const RETURN_TO_GARRISON:int = 4;
        public static const WAIT_FOR_ORDERS:int = 5;


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
                case BEGIN_ATTACK:
                    return ("BeginAttack");
                case WAIT_FOR_ORDERS:
                    return ("WaitForOrders");
                default:
                    return ("Unknown: " + _arg_1);
            };
        }


    }
}
