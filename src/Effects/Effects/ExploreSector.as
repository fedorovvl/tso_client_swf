package Effects.Effects
{
    import Effects.Effect;
    import Communication.VO.EffectVO;
    import Interface.cGameInterface;
    import ServerState.cPlayerData;

    public final class ExploreSector extends Effect 
    {

        public static const XML_string:String = "exploresector";


        override public function init(_arg_1:EffectVO, _arg_2:cGameInterface):void
        {
            super.init(_arg_1, _arg_2);
        }

        override protected function action():void
        {
            var _local_1:cPlayerData;
            if (effect.id > -1)
            {
                for each (_local_1 in gi.GetPlayerList_vector())
                {
                    gi.mCurrentPlayerZone.exploreSector(_local_1, effect.id);
                };
            };
        }


    }
}
