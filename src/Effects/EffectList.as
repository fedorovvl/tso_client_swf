package Effects
{
    import Communication.VO.EffectVO;
    import Interface.cGameInterface;
    import Communication.VO.EffectListVO;
    import Interface.cGeneralInterface;

    public class EffectList 
    {


        public static function applyWithGrid(_arg_1:EffectListVO, _arg_2:cGeneralInterface, _arg_3:int):void
        {
            var _local_5:EffectVO;
            var _local_6:EffectVO;
            if (_arg_1 == null)
            {
                return;
            };
            var _local_4:EffectFactory = (_arg_2 as cGameInterface).effectFactory;
            for each (_local_5 in _arg_1.list)
            {
                _local_6 = _local_5.clone();
                if (_local_5.targetGridPos == 0)
                {
                    _local_6.targetGridPos = _arg_3;
                };
                _local_4.createEffect(_local_6).apply();
            };
        }

        public static function applyWith(_arg_1:EffectListVO, _arg_2:cGeneralInterface, _arg_3:Function):void
        {
            var _local_5:EffectVO;
            var _local_6:EffectVO;
            if (_arg_1 == null)
            {
                return;
            };
            var _local_4:EffectFactory = (_arg_2 as cGameInterface).effectFactory;
            for each (_local_5 in _arg_1.list)
            {
                _local_6 = _local_5.clone();
                (_arg_3(_local_6));
                _local_4.createEffect(_local_6).apply();
            };
        }

        public static function applyWithXY(_arg_1:EffectListVO, _arg_2:cGeneralInterface, _arg_3:int, _arg_4:int):void
        {
            var _local_6:EffectVO;
            var _local_7:EffectVO;
            if (_arg_1 == null)
            {
                return;
            };
            var _local_5:EffectFactory = (_arg_2 as cGameInterface).effectFactory;
            for each (_local_6 in _arg_1.list)
            {
                _local_7 = _local_6.clone();
                if (((_local_6.targetX == -1) && (_local_6.targetY == -1)))
                {
                    _local_7.targetX = _arg_3;
                    _local_7.targetY = _arg_4;
                };
                _local_5.createEffect(_local_7).apply();
            };
        }

        public static function apply(_arg_1:EffectListVO, _arg_2:cGeneralInterface):void
        {
            if (_arg_1 == null)
            {
                return;
            };
            var _local_3:EffectFactory = (_arg_2 as cGameInterface).effectFactory;
            _local_3.applyAll(_arg_1.list);
        }


    }
}
