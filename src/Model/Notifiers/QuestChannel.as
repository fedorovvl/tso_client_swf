package Model.Notifiers
{
    import Utils.TriggerUtils;
    import Communication.VO.dQuestElementVO;

    public class QuestChannel extends Channel 
    {

        public static const QUEST_COMPLETED:String = TriggerUtils.QUEST_TYPE_COMPLETED_NAME;
        public static const QUEST_COMPLETABLE:String = "questCompletable";
        public static const QUEST_FAILED:String = "questFailed";
        public static const DAILY_LOGIN:String = TriggerUtils.DAILY_LOGIN_PROPERTY_NAME;


        public function questModeChanged(_arg_1:dQuestElementVO):void
        {
            if (_arg_1.isFinished())
            {
                send(QUEST_COMPLETABLE, _arg_1);
            }
            else
            {
                if (_arg_1.isFailed())
                {
                    send(QUEST_FAILED, _arg_1);
                };
            };
        }


    }
}
