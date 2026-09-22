package Effects.Effects
{
    import Effects.Effect;
    import Communication.VO.EffectVO;
    import Interface.cGameInterface;

    public final class EventCounter extends Effect 
    {


        override public function init(_arg_1:EffectVO, _arg_2:cGameInterface):void
        {
            super.init(_arg_1, _arg_2);
        }

        override protected function action():void
        {
            var _local_1:String = effect.type_string.toLowerCase();
            if (_local_1 == "increase")
            {
            };
        }


    }
}
