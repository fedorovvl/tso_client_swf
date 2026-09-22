package Specialists
{
    import PathFinding.cPathObject;
    import Enums.SPECIALIST_TASK_TYPES;
    import Interface.cGeneralInterface;
    import GO.cBuilding;
    import nLib.cLog;
    import PathFinding.PFAdditionalData;
    import __AS3__.vec.Vector;
    import Map.GridPosition;
    import GO.cBlockingData;
    import Communication.VO.dSpecialistTask_MoveVO;
    import Modifier.Modifier;
    import PathFinding.dPathObjectItem;
    import Enums.SPECIALIST_TYPE;
    import Enums.AVATAR_MESSAGE_TYPE;
    import ServerState.cPlayerData;
    import Enums.OBJECTTYPE;
    import nLib.gMisc;
    import Communication.VO.dUniqueID;
    import Enums.DIRTY_INDICATOR;
    import Interface.cGameInterface;
    import Enums.COMMAND;
    import Enums.TASK_PHASES_MOVE;
    import Modifier.ModifierVO;
    import Communication.VO.dSpecialistTaskVO;
    import __AS3__.vec.*;

    public class cSpecialistTask_Move extends cSpecialistTask_WithSettler 
    {

        private var mNewGarrisonGridIdx:int;
        private var mCurrentGarrisonGridIdx:int;
        private var modified:Boolean;
        private var pathFromWarehouse:cPathObject;

        public function cSpecialistTask_Move(_arg_1:cGeneralInterface, _arg_2:cSpecialist, _arg_3:int, _arg_4:int, _arg_5:int)
        {
            super(_arg_1, SPECIALIST_TASK_TYPES.MOVE, _arg_2, _arg_4, _arg_5);
            this.mNewGarrisonGridIdx = _arg_3;
        }

        public static function CreateTaskFromVO(_arg_1:cGeneralInterface, _arg_2:dSpecialistTask_MoveVO, _arg_3:cSpecialist):cSpecialistTask_Move
        {
            var _local_4:cSpecialistTask_Move = new cSpecialistTask_Move(_arg_1, _arg_3, _arg_2.newGarrisonGridIdx, _arg_2.collectedTime, _arg_2.phase);
            _local_4.SetPathPos(_arg_2.pathPos);
            _local_4.mCurrentGarrisonGridIdx = _arg_2.currentGarrisonGridIdx;
            _local_4.mNewGarrisonGridIdx = _arg_2.newGarrisonGridIdx;
            var _local_5:cBuilding = _local_4.GetNewGarrison();
            if (_local_5 == null)
            {
                cLog.error(("Error while creating task from VO: new garrison does not exists. newGarrisonGridIdx: " + _local_4.mNewGarrisonGridIdx));
                return (null);
            };
            var _local_6:Vector.<PFAdditionalData> = new Vector.<PFAdditionalData>();
            _local_6.push(new PFAdditionalData(new GridPosition(_local_4.mCurrentGarrisonGridIdx), cBlockingData.BLOCK_TYPE_ALLOW_NOTHING));
            _local_4.SetDestinationPath(_arg_1.mPathFinder.CalculatePath(_local_5.GetStreetGridEntry(), gCalculations.MoveStreetGridToDir8(_arg_1.mCurrentPlayerZone, _local_4.mCurrentGarrisonGridIdx, defines.DIR8_SOUTH_EAST), _local_6, true));
            _local_4.CheckSettler();
            return (_local_4);
        }


        override public function setModified(_arg_1:Modifier):void
        {
            this.modified = true;
        }

        override public function StartTask():void
        {
            var _local_6:dPathObjectItem;
            var _local_7:cPathObject;
            super.StartTask();
            if (mOwner.GetBaseType() == SPECIALIST_TYPE.ADMIRAL)
            {
                globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.ADMIRAL_STARTET_TRANSFER, mOwner);
            }
            else
            {
                if (mGeneralInterface.mCurrentPlayer.GetPlayerId() == mOwner.getPlayerID())
                {
                    globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.GENERAL_STARTET_TRANSFER, mOwner);
                }
                else
                {
                    globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.GENERAL_STARTET_TRANSFER_VIEWER, mOwner);
                };
            };
            var _local_1:cPlayerData = mGeneralInterface.FindPlayerFromId(mOwner.getPlayerID());
            var _local_2:cBuilding = (mGeneralInterface.mCurrentPlayerZone.SetAtGridPosition(_local_1, OBJECTTYPE.BUILDING, mOwner.GetSpecialistDescription().getGarrisonName_string(), this.mNewGarrisonGridIdx) as cBuilding);
            if (_local_2 == null)
            {
                cLog.error((((("Z:" + mGeneralInterface.mCurrentViewedZoneID) + " P:") + mOwner.getPlayerID()) + " failed to start move task because new building for garrison is null"));
                mOwner.ResetTaskNoSideEffect();
                return;
            };
            gMisc.Assert((!(_local_2.IsMovable())), "Garrison buildigns can't be movable");
            var _local_3:GridPosition = new GridPosition(this.mNewGarrisonGridIdx, mGeneralInterface.mCurrentPlayerZone.mMapWidth);
            _local_2.SetUniqueId(new dUniqueID().Init(_local_3.X(), _local_3.Y()));
            _local_2.SetBuildingMode(cBuilding.BUILDING_MODE_SET_BUILDING_GROUND_PLACE);
            _local_2.GetResourceCreation().SetSettlerKIStateDeactivate();
            _local_2.mDirtyIndicator.created();
            if (_local_2.GetResourceCreation() != null)
            {
                _local_2.GetResourceCreation().mDirtyIndicator = (_local_2.GetResourceCreation().mDirtyIndicator | DIRTY_INDICATOR.CREATED_BIT);
            };
            (mGeneralInterface as cGameInterface).forceZonePersistence(COMMAND.MOVE_GARISSON);
            var _local_4:int = _local_2.GetStreetGridEntry();
            var _local_5:cBuilding = mOwner.GetGarrison();
            if (_local_5 == null)
            {
                if (mGeneralInterface.IsAdventureZoneID(mGeneralInterface.mHomePlayer.GetPlayerId()))
                {
                    SetDestinationPath(mGeneralInterface.mPathFinder.CalculatePath(_local_4, _local_4, null, false));
                }
                else
                {
                    SetDestinationPath(mGeneralInterface.mPathFinder.CalculatePathForWarehouse(_local_4, mOwner.getPlayerID()));
                };
                if (((!(GetDestinationPath() == null)) && (GetDestinationPath().dest_vector.length > 0)))
                {
                    _local_6 = (GetDestinationPath().dest_vector[0] as dPathObjectItem);
                    this.mCurrentGarrisonGridIdx = _local_6.streetGridIdx;
                    SpawnSettler(_local_6.x, _local_6.y);
                    SetTaskPhase(TASK_PHASES_MOVE.MOVE);
                }
                else
                {
                    if (!mGeneralInterface.IsAdventureZoneID(mGeneralInterface.mHomePlayer.GetPlayerId()))
                    {
                        _local_2.SetBuildingMode(cBuilding.BUILDING_MODE_CONSTRUCTION);
                        mOwner.SetGarrison(_local_2);
                        SetTaskPhase(TASK_PHASES_MOVE.BUILD_GARRISON);
                    }
                    else
                    {
                        cLog.error("Can't find a path while trying to place specialist.");
                        SetTaskPhase(TASK_PHASES_MOVE.WAIT_FOR_ORDERS);
                    };
                };
            }
            else
            {
                this.mCurrentGarrisonGridIdx = _local_5.GetGrid();
                SetDestinationPath(mGeneralInterface.mPathFinder.CalculatePath(_local_2.GetStreetGridEntry(), _local_5.GetStreetGridEntry(), null, true));
                if (GetDestinationPath().dest_vector.length == 0)
                {
                    _local_7 = mGeneralInterface.mPathFinder.CalculatePathForWarehouse(_local_5.GetStreetGridEntry(), mOwner.getPlayerID());
                    if (_local_7 != null)
                    {
                        SetDestinationPath(_local_7);
                        GetDestinationPath().dest_vector.reverse();
                        this.pathFromWarehouse = mGeneralInterface.mPathFinder.CalculatePathForWarehouse(_local_2.GetStreetGridEntry(), mOwner.getPlayerID());
                    };
                };
                mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.DeconstructBuildingGridPos(this.mCurrentGarrisonGridIdx);
                SetTaskPhase(TASK_PHASES_MOVE.STRIKE_GARRISON);
            };
        }

        public function GetNewGarrisonGridIdx():int
        {
            return (this.mNewGarrisonGridIdx);
        }

        override public function isModified():Boolean
        {
            return (this.modified);
        }

        private function GetNewGarrison():cBuilding
        {
            return (mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mBuildingContainer.get(this.mNewGarrisonGridIdx));
        }

        override public function isModifierApplyable(_arg_1:ModifierVO):Boolean
        {
            var _local_2:String = (mTaskDefinition.mainTask.taskName_string + mTaskDefinition.taskType_string);
            if (((_arg_1.type_string.length > 0) && (!(_arg_1.type_string == _local_2))))
            {
                return (false);
            };
            return (true);
        }

        public function GetCurrentGarrisonGridIdx():int
        {
            return (this.mCurrentGarrisonGridIdx);
        }

        override protected function PerformTaskPhase(_arg_1:int, _arg_2:int):void
        {
            var _local_3:cBuilding;
            switch (GetTaskPhase())
            {
                case TASK_PHASES_MOVE.STRIKE_GARRISON:
                    if (((mOwner.GetGarrison() == null) || (mOwner.GetGarrison().GetBuildingMode() == cBuilding.BUILDING_MODE_DESTRUCTED)))
                    {
                        mCollectedTime = 0;
                        mOwner.SetGarrison(null);
                        SetPathPos(0);
                        NextPhase();
                    };
                    return;
                case TASK_PHASES_MOVE.MOVE:
                    speed = nonAttackSpeed;
                    IncPathPos(_arg_1);
                    if (GetPathPos() >= GetDestinationPath().pathLenX10000)
                    {
                        mCollectedTime = 0;
                        RemoveSettler();
                        if (this.pathFromWarehouse != null)
                        {
                            SetDestinationPath(this.pathFromWarehouse);
                            SpawnSettler(0, 0);
                            SetPathPos(0);
                            this.pathFromWarehouse = null;
                        }
                        else
                        {
                            NextPhase();
                            _local_3 = this.GetNewGarrison();
                            if (_local_3 != null)
                            {
                                _local_3.SetBuildingMode(cBuilding.BUILDING_MODE_CONSTRUCTION);
                                mOwner.SetGarrison(_local_3);
                            };
                        };
                    };
                    return;
                case TASK_PHASES_MOVE.BUILD_GARRISON:
                    if (mOwner.GetGarrison() == null)
                    {
                        NextPhase();
                        cLog.error("Specialist Task Move on state BUILD_GARRISON without an assigned Garrison. Skipping to WAIT_FOR_ORDERS");
                    }
                    else
                    {
                        if (mOwner.GetGarrison().GetBuildingMode() == cBuilding.BUILDING_MODE_PRODUCES_NO_RESOURCES)
                        {
                            NextPhase();
                        };
                    };
                    return;
                case TASK_PHASES_MOVE.WAIT_FOR_ORDERS:
                    mOwner.SetTask(null);
                    globalFlash.gui.mSpecialistPanel.Refresh(mOwner);
                    return;
                default:
                    gMisc.Assert(false, (("Could not interpret task phase " + GetTaskPhase()) + "!"));
            };
        }

        override public function CreateTaskVOFromSpecialistTask():dSpecialistTaskVO
        {
            var _local_1:dSpecialistTask_MoveVO = new dSpecialistTask_MoveVO();
            _local_1.type = GetType();
            _local_1.phase = GetTaskPhase();
            _local_1.collectedTime = GetCollectedTime();
            _local_1.currentGarrisonGridIdx = this.mCurrentGarrisonGridIdx;
            _local_1.newGarrisonGridIdx = this.mNewGarrisonGridIdx;
            _local_1.pathPos = GetPathPos();
            return (_local_1);
        }

        override protected function CheckSettler():void
        {
            switch (GetTaskPhase())
            {
                case TASK_PHASES_MOVE.STRIKE_GARRISON:
                case TASK_PHASES_MOVE.BUILD_GARRISON:
                case TASK_PHASES_MOVE.WAIT_FOR_ORDERS:
                    if (GetSettler() != null)
                    {
                        RemoveSettler();
                    };
                    return;
                case TASK_PHASES_MOVE.MOVE:
                    if (GetSettler() == null)
                    {
                        SpawnSettler(0, 0);
                    };
                    return;
                default:
                    if (cLog.isInfoEnabled())
                    {
                        cLog.info(("Could not interpret task phase " + GetTaskPhase()));
                    };
            };
        }


    }
}
