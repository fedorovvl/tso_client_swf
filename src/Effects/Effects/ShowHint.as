package Effects.Effects
{
    import Effects.Effect;
    import Communication.VO.EffectVO;
    import Interface.cGameInterface;
    import Communication.VO.dQuestDefinitionHintVO;
    import Enums.HINT_TYPE;
    import GUI.Effects.gHintManager;
    import mx.collections.ArrayCollection;

    public final class ShowHint extends Effect 
    {

        public static const XML_string:String = "hint";


        override public function init(_arg_1:EffectVO, _arg_2:cGameInterface):void
        {
            super.init(_arg_1, _arg_2);
            applyAsGameTick = false;
        }

        override protected function action():void
        {
            var _local_1:dQuestDefinitionHintVO = new dQuestDefinitionHintVO();
            _local_1.type = HINT_TYPE[effect.type_string.toLocaleUpperCase()];
            _local_1.pointTo = effect.target_string;
            gHintManager.ShowHints(new ArrayCollection([_local_1]));
        }


    }
}
