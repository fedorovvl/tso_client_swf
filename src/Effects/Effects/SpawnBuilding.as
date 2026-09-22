package Effects.Effects
{
    import Effects.Effect;
    import Communication.VO.EffectVO;
    import Interface.cGameInterface;
    import MilitarySystem.cArmy;
    import Specialists.cSpecialist;
    import Specialists.cSpecialistTask_AttackBuilding;
    import ServerState.cPlayerData;
    import GO.cBuilding;
    import nLib.cLog;
    import Enums.SPECIALIST_TASK_TYPES;
    import Enums.SPECIALIST_TYPE;
    import nLib.gMisc;
    import Enums.ERROR_CODES;
    import Enums.OBJECTTYPE;
    import Communication.VO.dUniqueID;
    import Enums.DIRTY_INDICATOR;

    public final class SpawnBuilding extends Effect 
    {


        override public function init(_arg_1:EffectVO, _arg_2:cGameInterface):void
        {
            super.init(_arg_1, _arg_2);
        }

        override protected function action():void
        {
            var _local_10:cArmy;
            var _local_11:cSpecialist;
            var _local_12:cSpecialistTask_AttackBuilding;
            var _local_13:Array;
            var _local_14:String;
            var _local_15:Array;
            var _local_1:Boolean;
            var _local_2:Boolean;
            var _local_3:Boolean;
            var _local_4:Boolean;
            var _local_5:Boolean;
            var _local_6:cPlayerData = gi.mHomePlayer;
            var _local_7:int = cBuilding.BUILDING_MODE_SET_BUILDING_GROUND_PLACE;
            _local_4 = ((!(effect.action_string == null)) && (!(effect.action_string.indexOf("replace") == -1)));
            if (effect.mode_string == "enemy")
            {
                _local_6 = null;
            }
            else
            {
                if (effect.mode_string == "free")
                {
                    _local_6 = new cPlayerData(null);
                    _local_6.SetPlayerId(0);
                };
            };
            if (effect.action_string.indexOf("ignoreBlocking") != -1)
            {
                _local_1 = true;
                _local_2 = true;
                _local_3 = true;
                _local_5 = true;
            };
            if (effect.action_string.indexOf("spawnInstant") != -1)
            {
                _local_7 = cBuilding.BUILDING_MODE_PRODUCES_NO_RESOURCES;
            }
            else
            {
                if (effect.action_string.indexOf("spawnConstructing") != -1)
                {
                    _local_7 = cBuilding.BUILDING_MODE_CONSTRUCTION;
                };
            };
            effect.calculateGridPosFromXY(gi.mCurrentPlayerZone.mMapWidth);
            if (effect.targetGridPos <= 0)
            {
                cLog.warning((((((((("Error can not spawn " + effect.name_string) + " at x:") + effect.targetX) + " y:") + effect.targetY) + " calculated grid invalid: (") + effect.targetGridPos) + ")!"));
                return;
            };
            cLog.info(((("Will spawn building " + effect.name_string) + " at gridPos ") + effect.targetGridPos));
            var _local_8:cBuilding = gi.mCurrentPlayerZone.GetBuildingFromGridPosition(effect.targetGridPos);
            if (_local_8 != null)
            {
                if (_local_4)
                {
                    _local_10 = _local_8.GetArmy();
                    if (_local_10 != null)
                    {
                        _local_10.DisbandArmy(null);
                    };
                    for each (_local_11 in gi.mCurrentPlayerZone.GetSpecialists_vector())
                    {
                        if ((((SPECIALIST_TYPE.IsGeneral(_local_11.GetType())) && (!(_local_11.GetTask() == null))) && (_local_11.GetTask().GetType() == SPECIALIST_TASK_TYPES.ATTACK_BUILDING)))
                        {
                            _local_12 = (_local_11.GetTask() as cSpecialistTask_AttackBuilding);
                            if (((!(_local_12.GetTargetBuilding() == null)) && (_local_12.GetTargetBuilding().GetGrid() == effect.targetGridPos)))
                            {
                                _local_12.HandleRetreat(true);
                            };
                        };
                    };
                    _local_8.removeBuilding(false);
                    _local_8.handleBuildingDeconstructed();
                    _local_8 = null;
                }
                else
                {
                    cLog.warning((((((("Error can not spawn " + effect.name_string) + " at ") + effect.targetGridPos) + " position blocked: (") + _local_8.GetBuildingName_string()) + ")!"));
                    return;
                };
            };
            _local_8 = cBuilding.CreateFromString(_local_6, global.buildingGroup, effect.name_string, gi);
            if (_local_8 == null)
            {
                cLog.warning((((("Error can not spawn " + effect.name_string) + " at ") + effect.targetGridPos) + " (building not found)!"));
                return;
            };
            gMisc.Assert((!(_local_8.IsMovable())), ("Spawned buildings can't be movable: " + effect.name_string));
            var _local_9:int = gi.mCurrentPlayerZone.IsBuildingPlacableGridPositionWithExlusions(_local_8, gi.mHomePlayer, effect.targetGridPos, _local_1, _local_2, _local_3, _local_5);
            if (_local_9 != 0)
            {
                cLog.warning((((((("Error can not spawn " + effect.name_string) + " on position ") + effect.targetGridPos) + " with error code ") + ERROR_CODES.toString(_local_9)) + "!"));
                return;
            };
            _local_8 = (gi.mCurrentPlayerZone.SetGoAtGridPosition(gi.mHomePlayer, _local_8, OBJECTTYPE.BUILDING, effect.targetGridPos) as cBuilding);
            if (_local_8 == null)
            {
                cLog.warning((((("Error can not spawn " + effect.name_string) + " on position ") + effect.targetGridPos) + "!"));
                return;
            };
            _local_8.SetUniqueId(new dUniqueID().Init(effect.targetX, effect.targetY));
            _local_8.SetBuildingMode(_local_7);
            _local_8.mOrigin = cBuilding.BUILDING_ORIGIN_FROM_GAME;
            if (((!(effect.units == null)) && (!(effect.units == ""))))
            {
                _local_13 = effect.units.split(",");
                for each (_local_14 in _local_13)
                {
                    _local_15 = _local_14.split("|");
                    _local_8.GetArmy().AddUnits(_local_15[0], gMisc.ParseInt(_local_15[1]), 0, true);
                };
            };
            gi.mCurrentPlayerZone.SetWatchArea(OBJECTTYPE.BUILDING, _local_8.GetBuildingName_string(), _local_8);
            gi.mCurrentPlayer.RefreshBuildingList();
            _local_8.mDirtyIndicator.created();
            if (_local_8.GetResourceCreation() != null)
            {
                _local_8.GetResourceCreation().mDirtyIndicator = (_local_8.GetResourceCreation().mDirtyIndicator | DIRTY_INDICATOR.CREATED_BIT);
            };
        }


    }
}
