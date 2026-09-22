package Effects.Effects
{
    import Effects.Effect;
    import Communication.VO.EffectVO;
    import Interface.cGameInterface;
    import BuffSystem.BuffAppliance;
    import GO.epicWorkyard.EpicWorkyardSubBuilding;
    import GO.cBuilding;
    import GO.epicWorkyard.EpicWorkyardMasterBuilding;

    public class RemoveBuff extends Effect 
    {

        public static const XML_string:String = "removebuff";


        override public function init(_arg_1:EffectVO, _arg_2:cGameInterface):void
        {
            super.init(_arg_1, _arg_2);
        }

        override protected function action():void
        {
            var _local_3:BuffAppliance;
            var _local_4:EpicWorkyardSubBuilding;
            effect.calculateGridPosFromXY(gi.mCurrentPlayerZone.mMapWidth);
            var _local_1:cBuilding = gi.mCurrentPlayerZone.GetBuildingFromGridPosition(effect.targetGridPos);
            var _local_2:BuffAppliance;
            if (_local_1 == null)
            {
                return;
            };
            if ((_local_1 is EpicWorkyardSubBuilding))
            {
                _local_1 = (_local_1 as EpicWorkyardSubBuilding).getMasterBuilding();
            };
            if (effect.id > 0)
            {
                for each (_local_3 in _local_1.mBuffs_vector)
                {
                    if (_local_3.GetBuffDefinition().GetId() == effect.id)
                    {
                        _local_2 = _local_3;
                        break;
                    };
                };
            }
            else
            {
                _local_2 = _local_1.productionBuff;
            };
            if (_local_2 != null)
            {
                _local_1.removeBuff(_local_2);
            };
            if ((_local_1 is EpicWorkyardMasterBuilding))
            {
                for each (_local_4 in (_local_1 as EpicWorkyardMasterBuilding).getSubBuildings())
                {
                    _local_2 = _local_4.productionBuff;
                    if (_local_2 != null)
                    {
                        _local_4.removeBuff(_local_2);
                    };
                };
            };
        }


    }
}
