package Effects.Effects
{
    import Effects.Effect;
    import Communication.VO.EffectVO;
    import Interface.cGameInterface;
    import Specialists.cSpecialist;
    import Specialists.cSpecialistTask_AttackBuilding;
    import nLib.cLog;
    import GO.cBuilding;
    import Utils.StringUtils;
    import MilitarySystem.cArmy;
    import Enums.SPECIALIST_TASK_TYPES;
    import Enums.SPECIALIST_TYPE;

    public final class RemoveBuilding extends Effect 
    {


        override public function init(_arg_1:EffectVO, _arg_2:cGameInterface):void
        {
            super.init(_arg_1, _arg_2);
        }

        override protected function action():void
        {
            var _local_3:cSpecialist;
            var _local_4:Boolean;
            var _local_5:Boolean;
            var _local_6:cSpecialistTask_AttackBuilding;
            effect.calculateGridPosFromXY(gi.mCurrentPlayerZone.mMapWidth);
            if (effect.targetGridPos <= 0)
            {
                cLog.warning((((((("Can not remove building at x:" + effect.targetX) + " y:") + effect.targetY) + ". Calculated grid invalid: (") + effect.targetGridPos) + ")!"));
                return;
            };
            if (cLog.isInfoEnabled())
            {
                cLog.info(("Will remove building at gridPos " + effect.targetGridPos));
            };
            var _local_1:cBuilding = gi.mCurrentPlayerZone.mStreetDataMap.mBuildingContainer.get(effect.targetGridPos);
            if (_local_1 == null)
            {
                cLog.info(("Effect.RemoveBuilding: No building found at gridPos " + effect.targetGridPos));
                return;
            };
            if (!StringUtils.isEmpty(effect.name_string))
            {
                _local_5 = StringUtils.contains("exactNameMatch", effect.action_string);
                if ((((_local_5) && (!(effect.name_string == _local_1.GetBuildingName_string()))) || ((!(_local_5)) && (!(StringUtils.startsWith(_local_1.GetBuildingName_string(), effect.name_string))))))
                {
                    cLog.info((("Building at gridPos " + effect.targetGridPos) + " ignored for removal, name does not match"));
                    return;
                };
            };
            var _local_2:cArmy = _local_1.GetArmy();
            if (_local_2 != null)
            {
                _local_2.DisbandArmy(null);
            };
            for each (_local_3 in gi.mCurrentPlayerZone.GetSpecialists_vector())
            {
                if ((((SPECIALIST_TYPE.IsGeneral(_local_3.GetType())) && (!(_local_3.GetTask() == null))) && (_local_3.GetTask().GetType() == SPECIALIST_TASK_TYPES.ATTACK_BUILDING)))
                {
                    _local_6 = (_local_3.GetTask() as cSpecialistTask_AttackBuilding);
                    if (((!(_local_6.GetTargetBuilding() == null)) && (_local_6.GetTargetBuilding().GetGrid() == effect.targetGridPos)))
                    {
                        _local_6.HandleRetreat(true);
                    };
                };
            };
            _local_4 = StringUtils.contains("applyDestroyEffects", effect.action_string);
            if (null != gi.mCurrentPlayerZone.mStreetDataMap.mLandscapeContainer.get(effect.targetGridPos))
            {
                gi.mCurrentPlayerZone.mStreetDataMap.mLandscapeContainer.get(effect.targetGridPos).setVisible(true);
            };
            _local_1.removeBuilding(_local_4);
            _local_1.handleBuildingDeconstructed();
        }


    }
}
