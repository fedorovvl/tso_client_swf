package Effects.Effects
{
    import Effects.Effect;
    import Communication.VO.EffectVO;
    import Interface.cGameInterface;
    import nLib.cLog;
    import Communication.VO.Skill.SkillVO;

    public class SkillPlayer extends Effect 
    {

        public static const XML_string:String = "skillplayer";
        public static const TYPE_TEMP:String = "temp";
        public static const TYPE_PERSISTED:String = "persisted";


        override public function init(_arg_1:EffectVO, _arg_2:cGameInterface):void
        {
            super.init(_arg_1, _arg_2);
        }

        override protected function action():void
        {
            if (((effect.type_string.indexOf(TYPE_TEMP) == -1) && (effect.type_string.indexOf(TYPE_PERSISTED) == -1)))
            {
                cLog.warning(("No type specified for SkillPlayer effect! " + effect));
                return;
            };
            var _local_1:* = (!(effect.type_string.indexOf(TYPE_TEMP) == -1));
            var _local_2:SkillVO = new SkillVO();
            _local_2.id = effect.id;
            _local_2.level = effect.value;
            gi.mHomePlayer.addSkill(_local_2, gi.mHomePlayer, gi, _local_1);
        }


    }
}
