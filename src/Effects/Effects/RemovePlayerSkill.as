package Effects.Effects
{
    import Effects.Effect;
    import Communication.VO.EffectVO;
    import Interface.cGameInterface;

    public class RemovePlayerSkill extends Effect 
    {

        public static const XML_string:String = "removeplayerskill";


        override public function init(_arg_1:EffectVO, _arg_2:cGameInterface):void
        {
            super.init(_arg_1, _arg_2);
        }

        override protected function action():void
        {
            gi.mCurrentPlayer.getSkills().removeSkill(effect.id);
        }


    }
}
