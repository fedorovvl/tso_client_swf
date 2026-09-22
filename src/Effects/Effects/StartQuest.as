package Effects.Effects
{
    import Effects.Effect;
    import Communication.VO.EffectVO;
    import Interface.cGameInterface;
    import Communication.VO.dQuestDefinitionVO;

    public final class StartQuest extends Effect 
    {

        public static const XML_string:String = "startquest";


        override public function init(_arg_1:EffectVO, _arg_2:cGameInterface):void
        {
            super.init(_arg_1.clone(), _arg_2);
        }

        override protected function action():void
        {
            var _local_1:int;
            var _local_2:Array;
            var _local_3:dQuestDefinitionVO;
        }


    }
}
