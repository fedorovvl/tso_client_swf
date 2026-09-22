package Effects.Effects
{
    import Effects.Effect;
    import Communication.VO.EffectVO;
    import Interface.cGameInterface;
    import nLib.cLog;

    public final class CancelQuest extends Effect 
    {

        public static const XML_string:String = "cancelquest";


        override public function init(_arg_1:EffectVO, _arg_2:cGameInterface):void
        {
            super.init(_arg_1, _arg_2);
        }

        override protected function action():void
        {
            if (cLog.isInfoEnabled())
            {
                cLog.info(("CancelQuest.action() " + effect));
            };
            if (effect.name_string != null)
            {
                gi.mNewQuestManager.cancelQuest(effect.name_string, effect.type_string);
            };
        }


    }
}
