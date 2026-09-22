package Effects.Effects
{
    import Effects.Effect;
    import Communication.VO.EffectVO;
    import Interface.cGameInterface;
    import nLib.cLog;

    public final class ResetQuest extends Effect 
    {

        public static const XML_string:String = "resetquest";


        override public function init(_arg_1:EffectVO, _arg_2:cGameInterface):void
        {
            super.init(_arg_1, _arg_2);
        }

        override protected function action():void
        {
            if (cLog.isInfoEnabled())
            {
                cLog.info(("ResetQuest.action() " + effect));
            };
            if (effect.name_string != null)
            {
                gi.mNewQuestManager.resetQuest(effect.name_string, effect.startDelay);
            };
        }


    }
}
