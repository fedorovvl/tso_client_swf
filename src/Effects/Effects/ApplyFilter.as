package Effects.Effects
{
    import Effects.Effect;
    import Communication.VO.EffectVO;
    import Interface.cGameInterface;

    public final class ApplyFilter extends Effect 
    {

        public static const XML_string:String = "filter";


        override public function init(_arg_1:EffectVO, _arg_2:cGameInterface):void
        {
            super.init(_arg_1, _arg_2);
            applyAsGameTick = false;
        }

        override protected function action():void
        {
            gGfxResource.applyFilter(effect.type_string, gi);
        }


    }
}
