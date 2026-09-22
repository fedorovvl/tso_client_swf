package Effects.Effects
{
    import Effects.Effect;
    import Communication.VO.EffectVO;
    import Interface.cGameInterface;
    import ServerState.cPlayerData;

    public class LevelupEffect extends Effect 
    {

        public static const XML_string:String = "levelup";


        override public function init(_arg_1:EffectVO, _arg_2:cGameInterface):void
        {
            super.init(_arg_1, _arg_2);
        }

        override protected function action():void
        {
            var _local_1:int = ((effect.amount > 0) ? effect.amount : 1);
            var _local_2:int;
            var _local_3:int;
            var _local_4:cPlayerData = gi.mHomePlayer;
            if ("pvp" == effect.type_string)
            {
                _local_2 = (global.playerPvPLevels_vector.length - 1);
                if (_local_4.GetPlayerLevel() < _local_2)
                {
                    _local_3 = global.playerPvPLevels_vector[Math.min(_local_2, (_local_4.GetPlayerPvPLevel() + _local_1))].pvpXp;
                    _local_4.AddPvPXp((_local_3 - _local_4.GetPlayerPvPXp()));
                };
            }
            else
            {
                _local_2 = (global.playerLevels_vector.length - 1);
                if (_local_4.GetPlayerLevel() < _local_2)
                {
                    _local_3 = global.playerLevels_vector[Math.min(_local_2, (_local_4.GetPlayerLevel() + _local_1))];
                    _local_4.AddXP((_local_3 - _local_4.GetXP()));
                };
            };
        }


    }
}
