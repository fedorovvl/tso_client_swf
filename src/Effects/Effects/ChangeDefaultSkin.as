package Effects.Effects
{
    import Effects.Effect;
    import Communication.VO.EffectVO;
    import Interface.cGameInterface;
    import BuffSystem.BuffAppliance;
    import GO.cBuilding;
    import Utils.StringUtils;
    import GUI.Components.CustomAlert;
    import GO.buildings.AirshipBuilding;

    public final class ChangeDefaultSkin extends Effect 
    {

        public static const XML_string:String = "changedefaultskin";


        override public function init(_arg_1:EffectVO, _arg_2:cGameInterface):void
        {
            super.init(_arg_1, _arg_2);
            applyAsGameTick = true;
        }

        private function cancelRunningChangeDefaultSkinBuff(_arg_1:cBuilding):void
        {
            var _local_5:BuffAppliance;
            var _local_6:EffectVO;
            var _local_2:BuffAppliance;
            var _local_3:Boolean;
            var _local_4:Boolean;
            for each (_local_5 in _arg_1.GetBuffs())
            {
                _local_6 = _local_5.GetBuffDefinition().GetEffectByName(ChangeDefaultSkin.XML_string);
                if (_local_6 != null)
                {
                    _local_4 = (_arg_1.getSkin() == _local_6.name_string);
                    _local_2 = _local_5;
                };
                _local_6 = _local_5.GetBuffDefinition().GetEffectByName(ChangeSkin.XML_string);
                if (_local_6 != null)
                {
                    _local_3 = true;
                };
            };
            if (_local_2 != null)
            {
                _arg_1.removeBuff(_local_2);
                if (((_local_4) && (!(_local_3))))
                {
                    _arg_1.setSkin(_arg_1.GetBuildingName_string());
                };
            };
        }

        override protected function action():void
        {
            var _local_1:cBuilding;
            effect.calculateGridPosFromXY(gi.mCurrentPlayerZone.mMapWidth);
            if (effect.targetGridPos > 0)
            {
                _local_1 = gi.mCurrentPlayerZone.GetBuildingFromGridPosition(effect.targetGridPos);
                if (_local_1 != null)
                {
                    if (StringUtils.isEmpty(effect.name_string))
                    {
                        this.cancelRunningChangeDefaultSkinBuff(_local_1);
                    }
                    else
                    {
                        if (_local_1.getSkin() == _local_1.GetBuildingName_string())
                        {
                            _local_1.setSkin(_local_1.GetBuildingName_string());
                        }
                        else
                        {
                            CustomAlert.show("TemporarySkinActive", "TemporarySkinActive");
                        };
                    };
                    if ((_local_1 is AirshipBuilding))
                    {
                        cSettingsManager.getInstance().airshipSkin = _local_1.GetGoGroup().GetNrFromName(_local_1.getSkin());
                    };
                };
            };
        }


    }
}
