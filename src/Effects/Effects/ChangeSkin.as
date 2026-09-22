package Effects.Effects
{
    import Effects.Effect;
    import Communication.VO.EffectVO;
    import Interface.cGameInterface;
    import __AS3__.vec.Vector;
    import GO.cBuilding;
    import GO.buildings.AirshipBuilding;

    public final class ChangeSkin extends Effect 
    {

        public static const XML_string:String = "changeskin";


        override public function init(_arg_1:EffectVO, _arg_2:cGameInterface):void
        {
            super.init(_arg_1, _arg_2);
            applyAsGameTick = true;
        }

        override protected function action():void
        {
            var _local_2:Vector.<cBuilding>;
            var _local_3:int;
            var _local_1:cBuilding;
            effect.calculateGridPosFromXY(gi.mCurrentPlayerZone.mMapWidth);
            if (effect.targetGridPos > 0)
            {
                _local_1 = gi.mCurrentPlayerZone.GetBuildingFromGridPosition(effect.targetGridPos);
                if (_local_1 != null)
                {
                    this.setSkin(_local_1);
                };
            }
            else
            {
                if (((!(effect.item_string == null)) && (!(effect.item_string == ""))))
                {
                    _local_2 = gi.mCurrentPlayerZone.mStreetDataMap.GetBuildings_vector();
                    _local_3 = 0;
                    while (_local_3 < _local_2.length)
                    {
                        _local_1 = _local_2[_local_3];
                        if (((!(_local_1 == null)) && (_local_1.GetBuildingName_string() == effect.item_string)))
                        {
                            this.setSkin(_local_1);
                        };
                        _local_3++;
                    };
                };
            };
        }

        private function setSkin(_arg_1:cBuilding):void
        {
            var _local_2:String = effect.name_string;
            if (((effect.name_string == null) || (effect.name_string == "")))
            {
                _local_2 = _arg_1.GetBuildingName_string();
            };
            _arg_1.setSkin(_local_2);
            if ((_arg_1 is AirshipBuilding))
            {
                cSettingsManager.getInstance().airshipSkin = _arg_1.GetGoGroup().GetNrFromName(_local_2);
            };
        }


    }
}
