package Effects.Effects
{
    import Effects.Effect;
    import Communication.VO.EffectVO;
    import Interface.cGameInterface;

    public final class GiveCollectibleResource extends Effect 
    {

        public static const XML_string:String = "givecollectibleresource";


        override public function init(_arg_1:EffectVO, _arg_2:cGameInterface):void
        {
            super.init(_arg_1, _arg_2);
        }

        override protected function action():void
        {
            if (((effect.playerId == 0) && (gi.IsAdventureZone())))
            {
                return;
            };
        }


    }
}
