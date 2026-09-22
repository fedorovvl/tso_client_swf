package Effects.Effects
{
    import Effects.Effect;
    import nLib.cLog;
    import converted.bluebyte.tso.quests.logic.QuestManagerStatic;
    import Communication.VO.dQuestElementVO;
    import Communication.VO.dQuestDefinitionVO;
    import EpicWorkyard.EpicWorkyardsManager;
    import Communication.VO.EffectVO;
    import Interface.cGameInterface;

    public final class UpgradeEpicWorkyardChain extends Effect 
    {

        public static const dummy1:cLog = null;
        public static const dummy2:QuestManagerStatic = null;
        public static const dummy3:dQuestElementVO = null;
        public static const dummy4:dQuestDefinitionVO = null;
        public static const dummy5:EpicWorkyardsManager = null;
        public static const XML_string:String = "upgradeepicchain";


        override public function init(_arg_1:EffectVO, _arg_2:cGameInterface):void
        {
            super.init(_arg_1, _arg_2);
        }

        override protected function action():void
        {
        }


    }
}
