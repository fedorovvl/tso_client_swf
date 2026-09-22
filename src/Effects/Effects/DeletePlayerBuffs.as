package Effects.Effects
{
    import Effects.Effect;
    import Communication.VO.EffectVO;
    import Interface.cGameInterface;
    import __AS3__.vec.Vector;
    import BuffSystem.cBuff;
    import nLib.cLog;

    public final class DeletePlayerBuffs extends Effect 
    {

        public static const XML_string:String = "deleteplayerbuffs";


        override public function init(_arg_1:EffectVO, _arg_2:cGameInterface):void
        {
            super.init(_arg_1, _arg_2);
        }

        override protected function action():void
        {
            var _local_1:Vector.<cBuff>;
            var _local_2:int;
            var _local_3:cBuff;
            cLog.info(("DeletePlayerBuffs.action() " + effect));
            if (((effect.id > 0) && (!(effect.name_string == ""))))
            {
                _local_1 = gi.mCurrentPlayer.mAvailableBuffs_vector;
                _local_2 = 0;
                while (_local_2 < _local_1.length)
                {
                    _local_3 = _local_1[_local_2];
                    if (((_local_3.GetId() == effect.id) && (_local_3.GetBuffDefinition().GetName_string() == effect.name_string)))
                    {
                        if (((effect.type_string == "") || (effect.type_string == _local_3.GetResourceName_string())))
                        {
                            gi.mCurrentPlayer.removeBuffFromVector(_local_3.GetUniqueId());
                            _local_3.setDeleted();
                            _local_2--;
                        };
                    };
                    _local_2++;
                };
            };
        }


    }
}
