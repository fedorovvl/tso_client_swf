package GUI
{
    import Effects.Effect;
    import Communication.VO.EffectVO;
    import Effects.Effects.Frontend.CloseCurrentWindow;
    import Skill.cSkillList;
    import Effects.GUIReaction;
    import Interface.cGameInterface;

    public final class GUIObserver 
    {

        public function GUIObserver(_arg_1:cGameInterface)
        {
            var _local_3:Effect;
            super();
            var _local_2:EffectVO = new EffectVO();
            _local_2.effect_string = CloseCurrentWindow.XML_string;
            _local_3 = _arg_1.effectFactory.createEffect(_local_2);
            _arg_1.channels.SKILL.addPropertyObserver(cSkillList.SKILLLIST_APPLY_FAILED, new GUIReaction(_local_3));
        }

    }
}
