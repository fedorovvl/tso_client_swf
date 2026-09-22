package Utils
{
    import Interface.cGeneralInterface;

    public class RequirementsHelper 
    {


        public static function checkRequirements(_arg_1:cGeneralInterface, _arg_2:String, _arg_3:String):Boolean
        {
            return ((checkEvent(_arg_1, _arg_2)) && (checkQuest(_arg_1, _arg_3)));
        }

        public static function checkEvent(_arg_1:cGeneralInterface, _arg_2:String):Boolean
        {
            return ((StringUtils.isEmpty(_arg_2)) || (_arg_1.mEventManager.isEventStarted(_arg_2)));
        }

        public static function checkQuest(_arg_1:cGeneralInterface, _arg_2:String):Boolean
        {
            return ((StringUtils.isEmpty(_arg_2)) || (_arg_1.mNewQuestManager.GetQuestPool().IsQuestActiveList(_arg_2)));
        }


    }
}
