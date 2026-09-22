package Model.Notifiers
{
    import Specialists.cSpecialist;

    public final class SpecialistNotifier extends Channel 
    {

        public static const GENERAL_LOST_string:String = "generallost";
        public static const GENERAL_WON_string:String = "generalwon";
        public static const GENERAL_CASUALTIES_STRING:String = "generalcasualties";
        public static const GENERAL_BATTLE_FOUGHT_string:String = "generalbattlefought";
        public static const SPECIALIST_OWNED_LIST_string:String = "specialistownedlist";
        public static const SPECIALIST_TASK_RESULT_TYPE_string:String = "specialisttaskresulttype";
        public static const SPECIALIST_TASK_FINISHED_string:String = "specialisttaskfinished";
        public static const COUNT_DEPOSIT_TYPE_string:String = "countdeposittype";
        public static const IN_GUILD:String = "inguild";
        public static const NAME_CHANGED:String = "nameChanged";
        public static const TASK_ATTACK_BUILDING_STARTED:String = "taskattackbuildingstarted";
        public static const SKILLS_CHANGED:String = "SkillsChanged";


        public function nameChanged(_arg_1:cSpecialist):void
        {
            send(NAME_CHANGED, _arg_1);
        }

        public function notify(_arg_1:String, _arg_2:Object):void
        {
            send(_arg_1, _arg_2);
        }


    }
}
