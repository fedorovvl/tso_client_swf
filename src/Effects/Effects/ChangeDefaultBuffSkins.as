package Effects.Effects
{
    import Effects.Effect;
    import Communication.VO.EffectVO;
    import Interface.cGameInterface;
    import GO.cBuilding;
    import __AS3__.vec.Vector;

    public final class ChangeDefaultBuffSkins extends Effect 
    {

        public static const XML_string:String = "changedefaultbuffskins";


        override public function init(_arg_1:EffectVO, _arg_2:cGameInterface):void
        {
            super.init(_arg_1, _arg_2);
            applyAsGameTick = true;
        }

        override protected function action():void
        {
            var _local_6:Array;
            var _local_1:Boolean;
            if (((!(effect.name_string == null)) && (!(effect.name_string == ""))))
            {
                _local_1 = true;
                _local_6 = effect.name_string.split(",");
                global.customGosetBuffTwinkleName = _local_6[0];
                global.customGosetFriendBuffTwinkleName = _local_6[(_local_6.length - 1)];
            };
            var _local_2:cBuilding;
            var _local_3:Vector.<cBuilding> = gi.mCurrentPlayerZone.mStreetDataMap.GetBuildings_vector();
            var _local_4:int;
            var _local_5:int = _local_3.length;
            while (_local_4 < _local_5)
            {
                _local_2 = _local_3[_local_4];
                if (_local_2 != null)
                {
                    _local_2.updateDefaultBuffSkins(_local_1);
                };
                _local_4++;
            };
        }


    }
}
