package Specialists
{
    import __AS3__.vec.Vector;
    import Modifier.ModifierVO;
    import Enums.SPECIALIST_TASK_TYPES;
    import Tracks.TrackManager;
    import Interface.cGeneralInterface;
    import Communication.VO.dSpecialistTask_TravelToZoneVO;
    import MilitarySystem.cArmy;
    import MilitarySystem.cSquad;
    import Enums.SPECIALIST_TYPE;
    import Interface.cGameInterface;
    import Enums.COMMAND;
    import Modifier.Modifier;
    import Utils.TriggerUtils;
    import Trigger.vo.GeneralTravelTriggerVO;
    import nLib.cPosInt;
    import PathFinding.PFAdditionalData;
    import GO.cBlockingData;
    import PathFinding.cPathObject;
    import GO.cBuilding;
    import Enums.ERROR_CODES;
    import Map.GridPosition;
    import nLib.cLog;
    import Enums.AVATAR_MESSAGE_TYPE;
    import Enums.TASK_PHASES_TRAVEL_TO_ZONE;
    import ServerState.cPlayerData;
    import Communication.VO.dPlayerVO;
    import Enums.OBJECTTYPE;
    import nLib.gMisc;
    import Communication.VO.dUniqueID;
    import Enums.DIRTY_INDICATOR;
    import Communication.VO.dSpecialistTaskVO;
    import GO.cLandingField;
    import GO.cGOSpriteLibContainer;
    import Map.AdditionalDataTSO;
    import __AS3__.vec.*;

    public class cSpecialistTask_TravelToZone extends cSpecialistTask_WithSettler 
    {

        public static const TASK_TRAVEL_TO_ZONE_START:String = "tasktraveltozonestart";
        public static const TASK_PERFORM_TRAVEL:String = "TASK_PERFORM_TRAVEL";

        private var mGarrisonGridIdx:int;
        private var mDestinationZoneID:int;
        private var landingFieldId:int;
        private var recoveryExtraTime:int;
        private var modified_vector:Vector.<ModifierVO>;

        public function cSpecialistTask_TravelToZone(_arg_1:cGeneralInterface, _arg_2:cSpecialist, _arg_3:int, _arg_4:int, _arg_5:int, _arg_6:int)
        {
            super(_arg_1, SPECIALIST_TASK_TYPES.TRAVEL_TO_ZONE, _arg_2, _arg_5, _arg_6);
            if (_arg_3 == _arg_2.getPlayerID())
            {
                mNeededTime = GetOwner().GetSpecialistDescription().GetTimeOverwriteTravelFromZone();
            }
            else
            {
                mNeededTime = GetOwner().GetSpecialistDescription().GetTimeOverwriteTravelToZone();
            };
            if (mNeededTime <= 0)
            {
                mNeededTime = mTaskDefinition.duration;
            };
            this.mDestinationZoneID = _arg_3;
            this.mGarrisonGridIdx = _arg_2.GetGarrisonGridIdx();
            this.landingFieldId = _arg_4;
            if (((_arg_5 == 0) && (_arg_6 == 0)))
            {
                TrackManager.getInstance().trackGeneralTravel(_arg_2, this.mDestinationZoneID);
            };
            _arg_2.notifyPropertyObserver(TASK_START, this);
            _arg_2.notifyPropertyObserver(TASK_TRAVEL_TO_ZONE_START, this);
        }

        public static function CreateTaskFromVO(_arg_1:cGeneralInterface, _arg_2:dSpecialistTask_TravelToZoneVO, _arg_3:cSpecialist):cSpecialistTask_TravelToZone
        {
            var _local_4:cSpecialistTask_TravelToZone = new cSpecialistTask_TravelToZone(_arg_1, _arg_3, _arg_2.destinationZoneID, _arg_2.landingFieldId, _arg_2.collectedTime, _arg_2.phase);
            _local_4.SetPathPos(_arg_2.pathPos);
            _local_4.mGarrisonGridIdx = _arg_2.garrisonGridIdx;
            _local_4.recoveryExtraTime = _arg_2.recoveryExtraTime;
            if (_local_4.GetGarrisonGridIdx() > -1)
            {
                _local_4.SetDestinationPath(_arg_1.mPathFinder.CalculatePathForWarehouse(_local_4.GetGarrisonGridIdx(), _arg_3.getPlayerID()));
            };
            return (_local_4);
        }


        override public function Perform(_arg_1:int):void
        {
            mOwner.notifyPropertyObserver(TASK_PERFORM_TRAVEL, this);
            super.Perform(_arg_1);
        }

        public function BeginTravel():void
        {
            var _local_3:cArmy;
            var _local_4:cArmy;
            var _local_5:cSquad;
            var _local_6:String;
            var _local_7:int;
            var _local_8:int;
            var _local_9:int;
            var _local_10:cSpecialist;
            var _local_11:int;
            var _local_12:cArmy;
            var _local_1:Boolean = true;
            if (mOwner.GetZoneID() <= defines.ADVENTUREZONEID)
            {
                _local_3 = mOwner.GetArmy();
                _local_4 = mGeneralInterface.mCurrentPlayerZone.GetArmy(mOwner.getPlayerID());
                for each (_local_5 in _local_3.GetSquads_vector())
                {
                    _local_6 = _local_5.GetType();
                    if ((_local_6 in mGeneralInterface.mCurrentPlayerZone.mHiredTroopsPool))
                    {
                        _local_7 = mGeneralInterface.mCurrentPlayerZone.mHiredTroopsPool[_local_6];
                        _local_8 = 0;
                        _local_9 = 0;
                        for each (_local_10 in mGeneralInterface.mCurrentPlayerZone.GetSpecialists_vector())
                        {
                            if (((!(_local_10 == mOwner)) && (_local_10.getPlayerID() == mOwner.getPlayerID())))
                            {
                                _local_12 = _local_10.GetArmy();
                                if (((!(_local_12 == null)) && (!(_local_12.GetSquad(_local_6) == null))))
                                {
                                    _local_8 = (_local_8 + _local_12.GetSquad(_local_6).GetAmount());
                                };
                            };
                        };
                        if (((!(_local_4 == null)) && (!(_local_4.GetSquad(_local_6) == null))))
                        {
                            _local_9 = _local_4.GetSquad(_local_6).GetAmount();
                        };
                        _local_11 = (_local_7 - (_local_8 + _local_9));
                        if (_local_11 > 0)
                        {
                            _local_3.RemoveUnits(_local_6, _local_11);
                            _local_4.AddUnits(_local_6, _local_11, 0, true);
                        };
                    };
                };
            };
            if (((mOwner.GetType() == SPECIALIST_TYPE.TMP_ARMY_TRANSPORTER) && (mOwner.GetArmy().GetUnitsCount() == 0)))
            {
                return;
            };
            if (!_local_1)
            {
                mOwner.GetArmy().DisbandArmy(mGeneralInterface.mCurrentPlayerZone.GetArmy(mOwner.getPlayerID()));
                mOwner.SetTask(null);
                return;
            };
            var _local_2:int = mGeneralInterface.mCurrentPlayerZone.GetSpecialists_vector().indexOf(mOwner);
            if (_local_2 == -1)
            {
                return;
            };
            mGeneralInterface.mCurrentPlayerZone.GetSpecialists_vector().splice(_local_2, 1);
            mOwner.SetTask(null);
            (mGeneralInterface as cGameInterface).forceZonePersistence(COMMAND.START_TRAVEL_TO_ZONE);
        }

        public function getRecoveryExtraTime():int
        {
            return (this.recoveryExtraTime);
        }

        override public function setModified(_arg_1:Modifier):void
        {
            if (this.modified_vector == null)
            {
                this.modified_vector = new Vector.<ModifierVO>();
            };
            this.modified_vector.push(_arg_1.modifierVO);
        }

        public function sendTravelNotification():void
        {
            var _local_1:int = int((this.GetNeededTime() / 1000));
            var _local_2:Number = mOwner.GetSpecialistDescription().GetTimeBonus();
            var _local_3:Number = ((_local_2 != 0) ? (_local_2 / 100) : 1);
            var _local_4:int = int(int((_local_1 / _local_3)));
            var _local_5:String = SPECIALIST_TYPE.toString(mOwner.GetType());
            if (_local_5 == SPECIALIST_TYPE.toString(SPECIALIST_TYPE.ADMIRAL))
            {
                mGeneralInterface.channels.SPECIALIST.notify(TriggerUtils.ADMIRAL_TRAVEL_PROPERTY_NAME, 1);
            }
            else
            {
                mGeneralInterface.channels.SPECIALIST.notify(TriggerUtils.GENERAL_TRAVEL_PROPERTY_NAME, new GeneralTravelTriggerVO(_local_5, this.mDestinationZoneID, _local_4));
            };
        }

        override public function isModified():Boolean
        {
            return ((!(this.modified_vector == null)) && (this.modified_vector.length > 0));
        }

        private function getFreeBuildingGrid():int
        {
            var _local_4:int;
            var _local_5:int;
            var _local_6:cPosInt;
            var _local_7:Vector.<PFAdditionalData>;
            var _local_8:Boolean;
            var _local_9:cBlockingData;
            var _local_10:int;
            var _local_11:int;
            var _local_12:int;
            var _local_13:Vector.<int>;
            var _local_14:cPathObject;
            var _local_1:int = -1;
            var _local_2:cBuilding = cBuilding.CreateFromString(mGeneralInterface.mCurrentPlayer, global.buildingGroup, mOwner.GetSpecialistDescription().getGarrisonName_string(), mGeneralInterface);
            var _local_3:int = mGeneralInterface.mCurrentPlayerZone.mStreetMapMaxUsableY;
            while (_local_3 >= mGeneralInterface.mCurrentPlayerZone.mStreetMapMinUsableY)
            {
                _local_4 = mGeneralInterface.mCurrentPlayerZone.mStreetMapMinUsableX;
                while (_local_4 <= mGeneralInterface.mCurrentPlayerZone.mStreetMapMaxUsableX)
                {
                    _local_5 = ((_local_3 * mGeneralInterface.mCurrentPlayerZone.mMapWidth) + _local_4);
                    if (mGeneralInterface.mCurrentPlayerZone.IsBuildingPlacableGridPosition(_local_2, mGeneralInterface.mCurrentPlayer, _local_5) == ERROR_CODES.NO_ERROR)
                    {
                        _local_6 = new cPosInt();
                        gCalculations.ConvertStreetGridToPixelPos(mGeneralInterface.mCurrentPlayerZone, _local_5, _local_6);
                        _local_7 = new Vector.<PFAdditionalData>();
                        _local_8 = true;
                        for each (_local_9 in _local_2.GetGOContainer().mBlocking_vector)
                        {
                            _local_10 = int((_local_6.x + ((_local_9.getXPixelOffset() * global.streetGridX) / 100)));
                            _local_11 = int((_local_6.y + ((_local_9.getYPixelOffset() * global.streetGridY) / 100)));
                            _local_12 = gCalculations.ConvertPixelPosToStreetGridPos(mGeneralInterface.mCurrentPlayerZone, _local_10, _local_11);
                            if (_local_9.getBlockingType() == cBlockingData.BLOCK_TYPE_ALLOW_NOTHING)
                            {
                                _local_7.push(new PFAdditionalData(new GridPosition(_local_12), cBlockingData.BLOCK_TYPE_ALLOW_NOTHING));
                            };
                            if (((!(mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.GetBuildingByGridPos(_local_12) == null)) || (!(mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mDepositContainer.get(_local_12) == null))))
                            {
                                _local_8 = false;
                                break;
                            };
                        };
                        if (_local_8)
                        {
                            _local_13 = mGeneralInterface.mPathFinder.GetWarehouseDestinations(mOwner.getPlayerID());
                            _local_14 = mGeneralInterface.mPathFinder.CalculatePathForDestinations(gCalculations.MoveStreetGridToDir8(mGeneralInterface.mCurrentPlayerZone, _local_5, defines.DIR8_SOUTH_EAST), _local_13, _local_7);
                            if (_local_14.pathLenX10000 != 0)
                            {
                                _local_1 = _local_5;
                                break;
                            };
                        };
                    };
                    _local_4++;
                };
                if (_local_1 > -1) break;
                _local_3--;
            };
            return (_local_1);
        }

        override public function GetSortValue():Number
        {
            return (mOwner.GetUniqueID().uniqueID1);
        }

        public function GetGarrisonGridIdx():int
        {
            return (this.mGarrisonGridIdx);
        }

        public function GetDestinationZoneID():int
        {
            return (this.mDestinationZoneID);
        }

        public function setRecoveryExtraTime(_arg_1:int):void
        {
            this.recoveryExtraTime = _arg_1;
        }

        override public function StartTask():void
        {
            if (cLog.isInfoEnabled())
            {
                cLog.info(("Starting " + this));
            };
            super.StartTask();
            if (mOwner.getPlayerID() == mGeneralInterface.mCurrentPlayer.getPlayerID())
            {
                globalFlash.gui.mAvatarMessageList.AddMessage(((mOwner.GetBaseType() == SPECIALIST_TYPE.ADMIRAL) ? AVATAR_MESSAGE_TYPE.ADMIRAL_TRAVELS_TO_ZONE : AVATAR_MESSAGE_TYPE.GENERAL_TRAVELS_TO_ZONE), mOwner);
                globalFlash.gui.mSpecialistTravelPanel.SetBusyOff();
            };
            var _local_1:cBuilding = mOwner.GetGarrison();
            if (_local_1 == null)
            {
                this.BeginTravel();
                SetTaskPhase(TASK_PHASES_TRAVEL_TO_ZONE.TRAVEL_TO_ZONE);
            }
            else
            {
                SetTaskPhase(TASK_PHASES_TRAVEL_TO_ZONE.STRIKE_GARRISON);
            };
        }

        public function toString():String
        {
            return (((("<cSpecialistTask_TravelToZone destinationZoneID='" + this.mDestinationZoneID) + "' garrisonGridIdx='") + this.mGarrisonGridIdx) + "' />");
        }

        override protected function PerformTaskPhase(_arg_1:int, _arg_2:int):void
        {
            var _local_3:int;
            var _local_4:int;
            var _local_5:cPlayerData;
            var _local_6:cBuilding;
            var _local_7:GridPosition;
            switch (GetTaskPhase())
            {
                case TASK_PHASES_TRAVEL_TO_ZONE.STRIKE_GARRISON:
                    if (((mOwner.GetGarrison() == null) || (mOwner.GetGarrison().GetBuildingMode() == cBuilding.BUILDING_MODE_DESTRUCTED)))
                    {
                        mCollectedTime = 0;
                        mOwner.SetGarrison(null);
                        if (((!(GetDestinationPath() == null)) && (GetDestinationPath().dest_vector.length > 0)))
                        {
                            SetPathPos(GetDestinationPath().pathLenX10000);
                            SpawnSettler(0, 0);
                            NextPhase();
                            if (cLog.isInfoEnabled())
                            {
                                cLog.info((("Finished phase 'Strike Garrison' of specialist " + mOwner.GetUniqueID()) + " -> TASK_PHASES_TRAVEL_TO_ZONE.MOVE_TO_WAREHOUSE"));
                            };
                        }
                        else
                        {
                            SetTaskPhase(TASK_PHASES_TRAVEL_TO_ZONE.TRAVEL_TO_ZONE);
                            if (cLog.isInfoEnabled())
                            {
                                cLog.info((("Finished phase 'Strike Garrison' of specialist " + mOwner.GetUniqueID()) + " -> TASK_PHASES_TRAVEL_TO_ZONE.TRAVEL_TO_ZONE"));
                            };
                            this.BeginTravel();
                        };
                    }
                    else
                    {
                        if (mOwner.GetGarrison().GetBuildingMode() == cBuilding.BUILDING_MODE_PRODUCES_NO_RESOURCES)
                        {
                            SetDestinationPath(mGeneralInterface.mPathFinder.CalculatePathForWarehouse(mOwner.GetGarrison().GetStreetGridEntry(), mOwner.getPlayerID()));
                            mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.DeconstructBuildingGridPos(mOwner.GetGarrison().GetGrid());
                        };
                    };
                    return;
                case TASK_PHASES_TRAVEL_TO_ZONE.MOVE_TO_WAREHOUSE:
                    speed = nonAttackSpeed;
                    IncPathPos(int(_arg_1));
                    if (GetPathPos() >= GetDestinationPath().pathLenX20000)
                    {
                        if (cLog.isInfoEnabled())
                        {
                            cLog.info((("Finished phase 'Move to Warehouse' of specialist " + mOwner.GetUniqueID()) + " -> BeginTravel()"));
                        };
                        mCollectedTime = 0;
                        RemoveSettler();
                        this.BeginTravel();
                    };
                    return;
                case TASK_PHASES_TRAVEL_TO_ZONE.TRAVEL_TO_ZONE:
                    if (mCollectedTime >= this.GetNeededTime())
                    {
                        if (cLog.isInfoEnabled())
                        {
                            cLog.info(("Finished phase 'Travel to Zone' of specialist " + mOwner.GetUniqueID()));
                        };
                        this.sendTravelNotification();
                        _local_3 = -1;
                        if ((((mOwner.GetBaseType() == SPECIALIST_TYPE.GENERAL) || (mOwner.GetBaseType() == SPECIALIST_TYPE.ADMIRAL)) || (mOwner.GetBaseType() == SPECIALIST_TYPE.TRANSPORTER_GENERAL)))
                        {
                            _local_3 = this.getFreeLandingGrid();
                            if (((_local_3 == -1) && (this.mDestinationZoneID > 0)))
                            {
                                _local_3 = this.getFreeBuildingGrid();
                            };
                        };
                        if (_local_3 == -1)
                        {
                            if (cLog.isInfoEnabled())
                            {
                                cLog.info((("Could not find free landing field for specialists " + mOwner.GetUniqueID()) + " -> transfer to star menu, units to warehouse."));
                            };
                            mOwner.SetGarrison(null);
                            mOwner.GetArmy().DisbandArmy(mGeneralInterface.mCurrentPlayerZone.GetArmy(mOwner.getPlayerID()));
                            SetTaskPhase(TASK_PHASES_TRAVEL_TO_ZONE.WAIT_FOR_ORDERS);
                            if (mOwner.GetType() == SPECIALIST_TYPE.TMP_ARMY_TRANSPORTER)
                            {
                                _local_4 = mGeneralInterface.mCurrentPlayerZone.GetSpecialists_vector().indexOf(mOwner);
                                if (_local_4 != -1)
                                {
                                    mOwner.SetTask(null);
                                    mGeneralInterface.mCurrentPlayerZone.GetSpecialists_vector().splice(_local_4, 1);
                                };
                            }
                            else
                            {
                                globalFlash.gui.mAvatarMessageList.AddMessage(((mOwner.GetBaseType() == SPECIALIST_TYPE.ADMIRAL) ? AVATAR_MESSAGE_TYPE.ADMIRAL_DID_NOT_FIND_LANDINGGRID : AVATAR_MESSAGE_TYPE.GENERAL_DID_NOT_FIND_LANDINGGRID), mOwner);
                            };
                        }
                        else
                        {
                            if (cLog.isInfoEnabled())
                            {
                                cLog.info(((("Setting garrison of specialist " + mOwner.GetUniqueID()) + " to ") + _local_3));
                            };
                            if (mOwner.GetGarrison() != null)
                            {
                                if (cLog.isInfoEnabled())
                                {
                                    cLog.info(((((("Assigning new garrison to general " + mOwner.GetUniqueID()) + " with garrison ") + mOwner.GetGarrison()) + " at grid ") + mOwner.GetGarrisonGridIdx()));
                                };
                            };
                            _local_5 = mGeneralInterface.FindPlayerFromId(mOwner.getPlayerID());
                            if (_local_5 == null)
                            {
                                _local_5 = new cPlayerData(mGeneralInterface);
                                mGeneralInterface.mServer.CreatePlayerFromPlayerVO(_local_5, dPlayerVO.CreateVisitorPlayer(mGeneralInterface, mOwner.getPlayerID()), true);
                                mGeneralInterface.GetPlayerList_vector().push(_local_5);
                            };
                            _local_6 = (mGeneralInterface.mCurrentPlayerZone.SetAtGridPosition(_local_5, OBJECTTYPE.BUILDING, mOwner.GetSpecialistDescription().getGarrisonName_string(), _local_3) as cBuilding);
                            if (_local_6 != null)
                            {
                                gMisc.Assert((!(_local_6.IsMovable())), "Garrison buildigns can't be movable");
                                _local_7 = new GridPosition(_local_3, mGeneralInterface.mCurrentPlayerZone.mMapWidth);
                                _local_6.SetUniqueId(new dUniqueID().Init(_local_7.X(), _local_7.Y()));
                                _local_6.SetBuildingMode(cBuilding.BUILDING_MODE_CONSTRUCTION);
                                _local_6.GetResourceCreation().SetSettlerKIStateDeactivate();
                                _local_6.mDirtyIndicator.created();
                                _local_6.GetResourceCreation().mDirtyIndicator = (_local_6.GetResourceCreation().mDirtyIndicator | DIRTY_INDICATOR.CREATED_BIT);
                            }
                            else
                            {
                                cLog.error((((("Z:" + mGeneralInterface.mCurrentViewedZoneID) + " P:") + mOwner.getPlayerID()) + " failed to create garrison for task travel to zone"));
                            };
                            mOwner.SetGarrison(_local_6);
                            NextPhase();
                        };
                    };
                    return;
                case TASK_PHASES_TRAVEL_TO_ZONE.BUILD_GARRISON:
                    if (mOwner.GetGarrison() == null)
                    {
                        if (cLog.isInfoEnabled())
                        {
                            cLog.error(((" General " + mOwner.GetUniqueID()) + "on phase BUILD_GARRISON is missing garrison. Skipping to WAIT_FOR_ORDERS"));
                        };
                        NextPhase();
                    }
                    else
                    {
                        if (mOwner.GetGarrison().GetBuildingMode() == cBuilding.BUILDING_MODE_PRODUCES_NO_RESOURCES)
                        {
                            if (cLog.isInfoEnabled())
                            {
                                cLog.info(("Finished phase 'Build Garrison' of specialist " + mOwner.GetUniqueID()));
                            };
                            mGeneralInterface.channels.ZONE.notifyPropertyObserver(TriggerUtils.ON_MAP_NOTIFICATION_PROPERTY_NAME, mOwner.GetGarrison().GetBuildingName_string());
                            NextPhase();
                        };
                    };
                    return;
                case TASK_PHASES_TRAVEL_TO_ZONE.WAIT_FOR_ORDERS:
                    if (mOwner == null)
                    {
                        if (cLog.isInfoEnabled())
                        {
                            cLog.error("There is no Owner of the TravelToZone Task. Possibly Zone run async.");
                        };
                        return;
                    };
                    if (cLog.isInfoEnabled())
                    {
                        cLog.info(("Finished phase 'Wait for Orders' phase of specialist " + mOwner.GetUniqueID()));
                    };
                    mOwner.SetTask(null);
                    return;
                default:
                    gMisc.Assert(false, (("Could not interpret task phase " + GetTaskPhase()) + "!"));
            };
        }

        override public function isModifierApplyable(_arg_1:ModifierVO):Boolean
        {
            var _local_2:String = (mTaskDefinition.mainTask.taskName_string + mTaskDefinition.taskType_string);
            if (((_arg_1.type_string.length > 0) && (!(_arg_1.type_string == _local_2))))
            {
                return (false);
            };
            return ((this.modified_vector == null) || (this.modified_vector.indexOf(_arg_1) == -1));
        }

        override public function GetNeededTime():int
        {
            return (super.GetNeededTime() + this.recoveryExtraTime);
        }

        override public function CreateTaskVOFromSpecialistTask():dSpecialistTaskVO
        {
            var _local_1:dSpecialistTask_TravelToZoneVO = new dSpecialistTask_TravelToZoneVO();
            _local_1.type = GetType();
            _local_1.phase = GetTaskPhase();
            _local_1.collectedTime = GetCollectedTime();
            _local_1.destinationZoneID = this.mDestinationZoneID;
            _local_1.landingFieldId = this.landingFieldId;
            _local_1.pathPos = GetPathPos();
            _local_1.recoveryExtraTime = this.recoveryExtraTime;
            return (_local_1);
        }

        private function getFreeLandingGrid():int
        {
            var _local_3:cLandingField;
            var _local_4:cPosInt;
            var _local_5:Vector.<PFAdditionalData>;
            var _local_6:cBlockingData;
            var _local_7:int;
            var _local_8:int;
            var _local_9:int;
            var _local_10:int;
            var _local_11:int;
            var _local_12:Vector.<int>;
            var _local_13:cPathObject;
            var _local_1:int = -1;
            var _local_2:Vector.<cBlockingData> = (global.buildingGroup.mGOListDictionary[mOwner.GetSpecialistDescription().getGarrisonName_string()] as cGOSpriteLibContainer).mBlocking_vector;
            for each (_local_3 in mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mLandingFields_vector)
            {
                if (this.landingFieldId == _local_3.mId)
                {
                    if (mGeneralInterface.mCurrentPlayerZone.GetBuildingFromGridPosition(_local_3.GetGrid()) == null)
                    {
                        _local_1 = _local_3.GetGrid();
                        _local_4 = new cPosInt();
                        gCalculations.ConvertStreetGridToPixelPos(mGeneralInterface.mCurrentPlayerZone, _local_1, _local_4);
                        _local_5 = new Vector.<PFAdditionalData>();
                        for each (_local_6 in _local_2)
                        {
                            _local_7 = int((_local_4.x + ((_local_6.getXPixelOffset() * global.streetGridX) / 100)));
                            _local_8 = int((_local_4.y + ((_local_6.getYPixelOffset() * global.streetGridY) / 100)));
                            _local_9 = gCalculations.ConvertPixelPosToStreetGridPos(mGeneralInterface.mCurrentPlayerZone, _local_7, _local_8);
                            if (_local_9 != defines.ILLEGAL_INT_POS)
                            {
                                _local_10 = mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.GetBlocked(_local_9);
                                _local_11 = mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mBlockingSourceData.get(_local_9, AdditionalDataTSO.BlockingSource);
                                if (((_local_10 == cBlockingData.BLOCK_TYPE_ALLOW_NOTHING) && ((!(mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mBuildingContainer.get(_local_9) == null)) || ((!(_local_11 == -1)) && (!(mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mBuildingContainer.get(_local_11) == null))))))
                                {
                                    _local_1 = -1;
                                    break;
                                };
                                if (_local_6.getBlockingType() == cBlockingData.BLOCK_TYPE_ALLOW_NOTHING)
                                {
                                    _local_5.push(new PFAdditionalData(new GridPosition(_local_9), cBlockingData.BLOCK_TYPE_ALLOW_NOTHING));
                                };
                            };
                        };
                        if (_local_1 != -1)
                        {
                            _local_12 = mGeneralInterface.mPathFinder.GetWarehouseDestinations(mOwner.getPlayerID());
                            if (_local_12.length == 0) break;
                            _local_13 = mGeneralInterface.mPathFinder.CalculatePathForDestinations(gCalculations.MoveStreetGridToDir8(mGeneralInterface.mCurrentPlayerZone, _local_1, defines.DIR8_SOUTH_EAST), _local_12, _local_5);
                            if (_local_13.pathLenX10000 != 0) break;
                            _local_1 = -1;
                        };
                    };
                };
            };
            return (_local_1);
        }

        override protected function CheckSettler():void
        {
            switch (GetTaskPhase())
            {
                case TASK_PHASES_TRAVEL_TO_ZONE.STRIKE_GARRISON:
                case TASK_PHASES_TRAVEL_TO_ZONE.TRAVEL_TO_ZONE:
                case TASK_PHASES_TRAVEL_TO_ZONE.BUILD_GARRISON:
                case TASK_PHASES_TRAVEL_TO_ZONE.WAIT_FOR_ORDERS:
                    if (GetSettler() != null)
                    {
                        RemoveSettler();
                    };
                    return;
                case TASK_PHASES_TRAVEL_TO_ZONE.MOVE_TO_WAREHOUSE:
                    if ((((GetSettler() == null) && (!(GetDestinationPath() == null))) && (GetDestinationPath().dest_vector.length > 0)))
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
