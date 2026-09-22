package Effects.Effects
{
    import Effects.Effect;
    import Communication.VO.EffectVO;
    import Interface.cGameInterface;
    import Communication.VO.dQuestElementVO;
    import Communication.VO.dQuestTriggerVO;

    public final class FinishQuest extends Effect 
    {

        public static const XML_string:String = "finishquest";


        override public function init(_arg_1:EffectVO, _arg_2:cGameInterface):void
        {
            super.init(_arg_1.clone(), _arg_2);
        }

        override protected function action():void
        {
            var _local_1:dQuestElementVO;
            var _local_2:dQuestTriggerVO;
        }


    }
}
