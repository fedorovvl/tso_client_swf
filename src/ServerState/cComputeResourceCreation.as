package ServerState
{
    import __AS3__.vec.Vector;
    import nLib.cPosInt;
    import Interface.cGeneralInterface;
    import GO.cBuilding;
    import BuffSystem.BuffAppliance;
    import BuffSystem.cBuffDefinition;
    import Enums.BUFF_TYPE;
    import nLib.gMisc;
    import SettlerKI.cSettlerKIWalkToDestination;
    import Enums.RESOURCE_TYPE;
    import SettlerKI.cSettlerKI;
    import PathFinding.cPathObject;
    import GO.cDeposit;
    import PathFinding.dPathObjectItem;
    import PathFinding.cPathFinder;
    import BuffSystem.cBuff;
    import Communication.VO.dPersistedBuffApplianceVO;
    import nLib.cLog;
    import Enums.OBJECTTYPE;
    import Map.AdditionalDataTSO;
    import Enums.AVATAR_MESSAGE_TYPE;
    import Sound.cSoundManager;
    import Enums.DEPOSIT_ACCESSIBLE_TYPES;
    import Utils.StringUtils;
    import Tracks.TrackManager;
    import Enums.ModifyReason;
    import Collections.CollectionsManager;
    import Enums.DIRTY_INDICATOR;
    import Communication.VO.dResourceCreationVO;
    import __AS3__.vec.*;

    public class cComputeResourceCreation 
    {

        public static const SETTLER_WALK_SPEED_INT:int = 5;
        public static const DEPOSIT_WORK_BEGIN:String = "DEPOSIT_WORK_BEGIN";
        public static const SETTLER_NAME_WOOD_CUTTER:String = "WoodCutter";
        public static const SETTLER_NAME_FORESTER:String = "Forester";
        public static const SETTLER_NAME_MASON_WORKER:String = "MasonWorker";
        public static const SETTLER_NAME_FISHER:String = "Fisher";
        public static const SETTLER_NAME_FARMER:String = "Farmer";
        public static const SETTLER_NAME_TOOLMAKER:String = "Toolmaker";
        public static const SETTLER_NAME_WATERWORKER:String = "WaterWorker";
        public static const PRODUCTION_TIMES_CHANGED:String = "PRODUCTION_TIMES_CHANGED";
        public static const PRODUCTION_VALUES:String = "PRODUCTION_VALUES";
        private static const INCREASE_RESOURCE_RESULT_OK:int = 0;
        private static const INCREASE_RESOURCE_SET_SETTLER_TO_IDLE:int = 1;
        private static const DEPOSIT_CREATION_INFO:Boolean = false;
        private static var mComputeResourceCreationLogZone:Boolean = false;

        private var mCurrentTime:Number;
        public var mResourceCreation_vector:Vector.<cResourceCreation> = new Vector.<cResourceCreation>();
        private var mResourceCreationPlayer:cPlayerData;
        private var mCurrentResourceNr:int;
        private var mResourceCreationResources:cResources;
        private var mTempPoint:cPosInt = new cPosInt();
        private var mGeneralInterface:cGeneralInterface;

        public function cComputeResourceCreation(_arg_1:cGeneralInterface)
        {
            super();
            this.mGeneralInterface = _arg_1;
        }

        private function ComputeBuildingProcesses():void
        {
            var _local_2:cBuilding;
            var _local_3:Number;
            var _local_4:int;
            var _local_5:Number;
            var _local_1:Vector.<cBuilding> = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.GetBuildings_vector();
            for each (_local_2 in _local_1)
            {
                if (null != _local_2)
                {
                    if (_local_2.IsUpgradeInProgress())
                    {
                        _local_2.mBuildingUpgradeProgress = int((((this.mGeneralInterface.GetClientTime() - _local_2.GetUpgradeStartTime()) * 100) / _local_2.GetUpgradeDuration()));
                        if (_local_2.mBuildingUpgradeProgress >= 100)
                        {
                            _local_3 = (this.mCurrentTime - _local_2.GetUpgradeStartTime());
                            _local_4 = _local_2.GetUpgradeDuration();
                            _local_5 = ((_local_3 * 100) / _local_4);
                            _local_2.mBuildingUpgradeProgress = int(_local_5);
                            if (_local_2.mBuildingUpgradeProgress >= 100)
                            {
                                this.UpgradeBuilding(_local_2);
                            };
                        };
                        if ((((_local_2.IsBuildingActive()) && (_local_2.GetRecoveringHitPoints() > 0)) && (!(_local_2.IsEngagedInCombat()))))
                        {
                            if (_local_2.CheckForRepairRound())
                            {
                                _local_2.RepairBuilding(_local_2.GetRecoveringHitPoints());
                                if (_local_2.GetCurrentHitPoints() >= _local_2.GetMaxHitPoints())
                                {
                                    _local_2.SetRecoveringHitPoints(0);
                                };
                            };
                        };
                    };
                };
            };
        }

        private function CreateResourceCreation(_arg_1:cPlayerData, _arg_2:dResourceCreationDefinition, _arg_3:cBuilding):void
        {
            var _local_4:cResourceCreation = new cResourceCreation(_arg_1.GetPlayerId(), _arg_2, _arg_3);
            _local_4.SetProductionState(cResourceCreation.PRODUCTIONSTATE_WORKING);
            if (_arg_3 != null)
            {
                this.AssignSettlerGfx(_local_4);
            };
            _arg_3.SetResourceCreation(_local_4);
            this.mResourceCreation_vector.push(_local_4);
            this.SpawnSettler(_arg_1, _local_4, defines.SETTLER_BUILDER_string);
        }

        private function HasBlockingProductivityInputBuff(_arg_1:cBuilding):Boolean
        {
            var _local_4:BuffAppliance;
            var _local_2:cBuffDefinition = _arg_1.GetUpgradeLevelBonuses();
            if (((!(_local_2 == null)) && (_local_2.getProductivityInputPercent() == 0)))
            {
                return (true);
            };
            var _local_3:int;
            while (_local_3 < _arg_1.mBuffs_vector.length)
            {
                _local_4 = _arg_1.mBuffs_vector[_local_3];
                if (((_local_4.GetBuffDefinition().GetBuffType() == BUFF_TYPE.TIMED) || (_local_4.GetBuffDefinition().GetBuffType() == BUFF_TYPE.ZONE)))
                {
                    if (((!(_local_2 == null)) && (_local_2.getProductivityInputPercent() == 0)))
                    {
                        return (true);
                    };
                };
                _local_3++;
            };
            return (false);
        }

        public function CalculateProductionPaths(_arg_1:cBuilding, _arg_2:Boolean):void
        {
            var _local_3:cResourceCreation;
            if (_arg_1 == null)
            {
                for each (_local_3 in this.mResourceCreation_vector)
                {
                    if (!this.CalculateProductionPath(_local_3, _arg_2))
                    {
                        if ((((!(_local_3.GetRemove())) && (!(_local_3.GetResourceCreationHouse() == null))) && (!(_local_3.GetResourceCreationHouse().IsBuildOnWater()))))
                        {
                            if (!_local_3.GetResourceCreationHouse().isGarrison())
                            {
                                _local_3.GetResourceCreationHouse().SetBuildingMode(cBuilding.BUILDING_MODE_PRODUCES_NO_RESOURCES);
                            };
                        };
                    }
                    else
                    {
                        if ((((!(_local_3.GetResourceCreationDefinition() == null)) && (!(_local_3.GetResourceCreationHouse() == null))) && (_local_3.GetResourceCreationHouse().GetBuildingMode() == cBuilding.BUILDING_MODE_PRODUCES_NO_RESOURCES)))
                        {
                            _local_3.GetResourceCreationHouse().SetBuildingMode(cBuilding.BUILDING_MODE_SETTLER_WALKS_FROM_STOREHOUSE_TO_RESOURCECREATIONHOUSE);
                        };
                    };
                };
            }
            else
            {
                this.CalculateProductionPath(_arg_1.GetResourceCreation(), _arg_2);
            };
        }

        public function CreateResourceCreationForBuilding(_arg_1:cBuilding):void
        {
            if (((_arg_1.getPlayerID() == -1) || (_arg_1.getPlayerID() == 0)))
            {
                return;
            };
            var _local_2:cPlayerData = this.mGeneralInterface.mCurrentPlayer;
            if (_local_2.GetPlayerId() != _arg_1.getPlayerID())
            {
                _local_2 = this.mGeneralInterface.FindPlayerFromId(_arg_1.getPlayerID());
            };
            gMisc.Assert((!(_local_2 == null)), ("Could not find player for " + _arg_1));
            var _local_3:dResourceCreationDefinition = gEconomics.GetResourcesCreationDefinitionForBuilding(_arg_1.GetBuildingName_string());
            this.CreateResourceCreation(_local_2, _local_3, _arg_1);
        }

        public function Compute():void
        {
            var _local_1:cSettlerKIWalkToDestination;
            var _local_3:cResourceCreation;
            var _local_4:int;
            var _local_5:dResourceCreationDefinition;
            var _local_6:cBuilding;
            var _local_7:int;
            var _local_8:String;
            var _local_9:cResourceCreation;
            this.mCurrentTime = this.mGeneralInterface.GetClientTime();
            this.ComputeBuildingProcesses();
            var _local_2:int;
            while (_local_2 < this.mResourceCreation_vector.length)
            {
                _local_3 = this.mResourceCreation_vector[_local_2];
                this.mCurrentResourceNr = _local_2;
                if (_local_3.GetPlayerID() == this.mGeneralInterface.mCurrentPlayer.GetPlayerId())
                {
                    this.mResourceCreationPlayer = this.mGeneralInterface.mCurrentPlayer;
                }
                else
                {
                    this.mResourceCreationPlayer = this.mGeneralInterface.FindPlayerFromId(_local_3.GetPlayerID());
                };
                if (this.mResourceCreationPlayer != null)
                {
                    this.mResourceCreationResources = this.mGeneralInterface.mCurrentPlayerZone.GetResources(this.mResourceCreationPlayer);
                    if (_local_3.GetRemove())
                    {
                        _local_3.SetSettlerKIStateDeactivate();
                        if (((_local_3.GetAssignedSettler()) && (!(this.mResourceCreationResources == null))))
                        {
                            this.mResourceCreationResources.FreeWorkers(1);
                        };
                        this.mResourceCreation_vector.splice(_local_2, 1);
                        _local_2--;
                    }
                    else
                    {
                        if (_local_3.GetResourceCreationDefinition() != null)
                        {
                            if (_local_3.GetResourceCreationDefinition().typeEnumResourceType == RESOURCE_TYPE.CREATED_BY_BUILDING)
                            {
                                if (_local_3.HasInvalidatedPaths())
                                {
                                    this.CalculateProductionPaths(_local_3.GetResourceCreationHouse(), true);
                                    _local_3.SetInvalidatePaths(false);
                                };
                                if (_local_3.GetStoreHouse() == null)
                                {
                                    _local_3.SetProductionState(cResourceCreation.PRODUCTIONSTATE_STOPPED_PRODUCTION);
                                };
                            };
                        };
                        _local_4 = this.IncreaseResource(_local_3, this.mGeneralInterface.mClientDeltaTime);
                        if (_local_4 != INCREASE_RESOURCE_RESULT_OK)
                        {
                            if (_local_4 == INCREASE_RESOURCE_SET_SETTLER_TO_IDLE)
                            {
                                _local_3.SetSettlerKIState(cSettlerKI.SETTLER_STATE_WAIT_FOR_STORE_HOUSE);
                                if (_local_3.GetSettler() != null)
                                {
                                    (_local_3.GetSettler().mSettlerKi as cSettlerKIWalkToDestination).mVisible = false;
                                };
                            };
                        };
                        _local_5 = _local_3.GetResourceCreationDefinition();
                        if (_local_5 != null)
                        {
                            if (_local_5.typeEnumResourceType == RESOURCE_TYPE.CREATED_BY_BUILDING)
                            {
                                _local_6 = _local_3.GetResourceCreationHouse();
                                if (((!(_local_3.GetRemove())) && (!(_local_6 == null))))
                                {
                                    if (_local_6.GetGOContainer().mDepositAnimName_string != null)
                                    {
                                        if (_local_3.GetDepositBuildingGridPos() != -1)
                                        {
                                            _local_7 = _local_3.GetDepositBuildingGridPos();
                                            if (((_local_6.GetBuildingMode() == cBuilding.BUILDING_MODE_WORKANIM_IS_WORKING_AT_EXTERNAL_DEPOSIT) && (_local_3.GetProductionState() == cResourceCreation.PRODUCTIONSTATE_WORKING)))
                                            {
                                                _local_8 = _local_6.GetGOContainer().mDepositAnimName_string;
                                                if (!this.mGeneralInterface.mCurrentPlayerZone.mGoSetListAnimationManager.IsAnimationAtGridPos(_local_7))
                                                {
                                                    this.mGeneralInterface.mCurrentPlayerZone.mGoSetListAnimationManager.AddAnimation(_local_7, _local_8, 0, global.streetGridYHalf, _local_3);
                                                };
                                            }
                                            else
                                            {
                                                if (this.mGeneralInterface.mCurrentPlayerZone.mGoSetListAnimationManager.IsAnimationAtGridPos(_local_7))
                                                {
                                                    _local_9 = (this.mGeneralInterface.mCurrentPlayerZone.mGoSetListAnimationManager.GetAnimAtPos(_local_7).object as cResourceCreation);
                                                    if (_local_9 == _local_3)
                                                    {
                                                        this.mGeneralInterface.mCurrentPlayerZone.mGoSetListAnimationManager.Remove(_local_7);
                                                    };
                                                };
                                            };
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
                _local_2++;
            };
        }

        public function ResetResourceCreation():void
        {
            this.mResourceCreation_vector = new Vector.<cResourceCreation>();
        }

        public function SearchForNearestDepositFast(_arg_1:cResourceCreation):Boolean
        {
            var _local_3:cPathObject;
            var _local_6:int;
            var _local_7:cDeposit;
            var _local_8:dPathObjectItem;
            var _local_2:String = _arg_1.GetResourceCreationDefinition().externalResource_string;
            var _local_4:int = defines.NO_PLAYERID;
            if (((!(_arg_1.GetRemove())) && (!(_arg_1.GetResourceCreationHouse() == null))))
            {
                _local_7 = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mDepositContainer.get(_arg_1.GetResourceCreationHouse().GetGrid());
                if (((!(_local_7 == null)) && (_local_7.GetName_string() == _local_2)))
                {
                    _local_3 = new cPathObject();
                    _arg_1.SetDepositBuildingGridPos(_arg_1.GetResourceCreationHouse().GetGrid());
                    _arg_1.SetDepositPath(_local_3);
                    _arg_1.pathPos = 0;
                    return (true);
                };
                _local_4 = _arg_1.GetResourceCreationHouse().getPlayerID();
            };
            var _local_5:int = _arg_1.GetResourceCreationHouse().GetStreetGridEntry();
            if (_arg_1.GetResourceCreationDefinition().amountRemoved >= 0)
            {
                _local_6 = cPathFinder.AMOUNT_TYPE_ABOVE_ZERO;
            }
            else
            {
                _local_6 = cPathFinder.AMOUNT_TYPE_BELOW_MAX;
            };
            _local_3 = this.mGeneralInterface.mPathFinder.CalculatePathForDeposit(_local_2, _local_5, _local_4, _local_6);
            if (((!(_local_3 == null)) && (_local_3.dest_vector.length > 0)))
            {
                _local_8 = _local_3.dest_vector[(_local_3.dest_vector.length - 1)];
                _arg_1.SetDepositBuildingGridPos(_local_8.streetGridIdx);
                _arg_1.SetDepositPath(_local_3);
                _arg_1.pathPos = 0;
                return (true);
            };
            _arg_1.SetDepositBuildingGridPos(-1);
            return (false);
        }

        private function IncreaseResource(_arg_1:cResourceCreation, _arg_2:int):int
        {
            var _local_3:cDeposit;
            var _local_4:int;
            var _local_5:int;
            var _local_6:cBuff;
            var _local_8:cBuilding;
            var _local_9:cBuilding;
            var _local_10:int;
            var _local_11:int;
            var _local_12:Boolean;
            var _local_13:int;
            var _local_14:cResourceCreation;
            var _local_15:int;
            var _local_16:String;
            var _local_17:cBuilding;
            var _local_18:cBuilding;
            var _local_19:cBuilding;
            var _local_20:cBuilding;
            var _local_21:int;
            var _local_22:int;
            var _local_23:int;
            var _local_24:int;
            var _local_25:Boolean;
            var _local_26:int;
            var _local_27:Boolean;
            var _local_28:cBuilding;
            var _local_29:Vector.<BuffAppliance>;
            var _local_30:BuffAppliance;
            var _local_31:dPersistedBuffApplianceVO;
            var _local_32:int;
            var _local_33:cBuffDefinition;
            var _local_7:dResourceCreationDefinition = _arg_1.GetResourceCreationDefinition();
            if (((_local_7 == null) || (_local_7.typeEnumResourceType == RESOURCE_TYPE.CREATED_BY_BUILDING)))
            {
                _local_8 = _arg_1.GetResourceCreationHouse();
                if (_local_8 == null)
                {
                    cLog.info(("Building is null " + _arg_1));
                    mComputeResourceCreationLogZone = true;
                    _arg_1.SetRemove(true);
                    return (INCREASE_RESOURCE_RESULT_OK);
                };
                switch (_local_8.GetBuildingMode())
                {
                    case cBuilding.BUILDING_MODE_SET_BUILDING_GROUND_PLACE:
                        if (!_local_8.GetGOContainer().mConstructBuildingWithoutSettler)
                        {
                            _local_4 = int((this.mCurrentTime - _local_8.mBuildingCreationTime));
                            _arg_1.pathPos = (_local_4 * SETTLER_WALK_SPEED_INT);
                            if (((_local_8.IsBuildOnWater()) || (_local_8.IgnoreWarehousePath())))
                            {
                                _local_8.SetBuildingMode(cBuilding.BUILDING_MODE_CONSTRUCTION);
                            }
                            else
                            {
                                _arg_1.SetSettlerKIState(cSettlerKI.SETTLER_STATE_WALKING_ON_RESOURCE_PATH);
                                _local_8.SetBuildingMode(cBuilding.BUILDING_MODE_SETTLER_WALKS_TO_BUILDING_GROUND_PLACE);
                            };
                        }
                        else
                        {
                            if (((_local_8.IsBuildOnWater()) || (_local_8.IgnoreWarehousePath())))
                            {
                                _local_8.SetBuildingMode(cBuilding.BUILDING_MODE_CONSTRUCTION);
                            }
                            else
                            {
                                if (_local_8.GetBuildingName_string() == defines.SPECIAL_WAREHOUSES_NAME_string)
                                {
                                    _local_8.SetBuildingMode(cBuilding.BUILDING_MODE_CONSTRUCTION);
                                };
                            };
                        };
                        break;
                    case cBuilding.BUILDING_MODE_SETTLER_WALKS_TO_BUILDING_GROUND_PLACE:
                        _arg_1.SetSettlerKIState(cSettlerKI.SETTLER_STATE_WALKING_ON_RESOURCE_PATH);
                        _arg_1.pathPos = (_arg_1.pathPos + (_arg_2 * SETTLER_WALK_SPEED_INT));
                        if (((null == _arg_1.GetPath()) || (_arg_1.pathPos >= _arg_1.GetPath().pathLenX10000)))
                        {
                            if (null != _arg_1.GetPath())
                            {
                                _local_4 = int(((_arg_1.pathPos - _arg_1.GetPath().pathLenX10000) / SETTLER_WALK_SPEED_INT));
                            }
                            else
                            {
                                _local_4 = 10;
                            };
                            _arg_1.SetSettlerKIState(cSettlerKI.SETTLER_STATE_IS_WORKING_IN_RESOURCE_CREATION_HOUSE);
                            _local_8.mBuildingProgress = ((_local_4 * 1000) / _local_8.GetGOContainer().mConstructionDuration);
                            _local_8.SetBuildingMode(cBuilding.BUILDING_MODE_CONSTRUCTION);
                        };
                        break;
                    case cBuilding.BUILDING_MODE_CONSTRUCTION:
                        _arg_1.SetSettlerKIState(cSettlerKI.SETTLER_STATE_IS_WORKING_IN_RESOURCE_CREATION_HOUSE);
                        _local_8.mBuildingProgress = (_local_8.mBuildingProgress + ((_arg_2 * 1000) / _local_8.GetGOContainer().mConstructionDuration));
                        if (_local_8.mBuildingProgress >= (100 * defines.BUILDING_PROGRESS_SCALE_FACTOR))
                        {
                            _local_4 = int((int(((_local_8.mBuildingProgress - (100 * defines.BUILDING_PROGRESS_SCALE_FACTOR)) * _local_8.GetGOContainer().mConstructionDuration)) / 1000));
                            _local_8.mBuildingProgress = (100 * defines.BUILDING_PROGRESS_SCALE_FACTOR);
                            if (!this.mGeneralInterface.mRefreshZoneIsActive)
                            {
                                this.mGeneralInterface.mCurrentPlayerZone.SetWatchArea(OBJECTTYPE.BUILDING, _local_8.GetBuildingName_string(), _local_8);
                            };
                            if (_local_8.IsWarehouseType())
                            {
                                _local_10 = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mAdditionalData.get(_local_8.GetGrid(), AdditionalDataTSO.Sector);
                                if (this.mGeneralInterface.mCurrentPlayerZone.GetSectorOwnerPlayerID(_local_10) == 0)
                                {
                                    this.mGeneralInterface.mCurrentPlayerZone.SetPlayerForSector(_local_10, _local_8.getPlayerID());
                                    this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.CalculateBorders();
                                    globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.CLAIMED_SECTOR);
                                };
                            };
                            if (_local_8.GetBuildingName_string() == defines.LOGISTICS_NAME_string)
                            {
                                this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.SetLogisticsHouse(_local_8);
                            }
                            else
                            {
                                if (_local_8.GetBuildingName_string() == defines.GUILDHOUSE_NAME_string)
                                {
                                    this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.SetGuildHouse(_local_8);
                                }
                                else
                                {
                                    if (_local_8.GetBuildingName_string() == defines.GUILDBANK_NAME_string)
                                    {
                                        this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.SetGuildBankHouse(_local_8);
                                    };
                                };
                            };
                            if (_local_8.GetGOContainer().mAddDepositAmount != -1)
                            {
                                _local_3 = this.mGeneralInterface.mSetBuildings.SetDepositMode(this.mGeneralInterface, this.mGeneralInterface.mCurrentPlayerZone, this.mResourceCreationPlayer, null, null, _local_8.GetGOContainer().mAddDepositName, OBJECTTYPE.DEPOSIT, _local_8.GetGOContainer().mAddDepositAmount, _local_8.GetGrid(), _local_8.GetGOContainer().mAddDepositRefillable);
                                this.mGeneralInterface.mPathFinder.InvalidateDepositMatrix(_local_8.getPlayerID(), _local_3.GetName_string(), cPathFinder.AMOUNT_TYPE_ABOVE_ZERO);
                            };
                            this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.CalculateBorders();
                            if (((!(_local_8.GetGOContainer().mConstructBuildingWithoutSettler)) && (!(_local_8.IsBuildOnWater()))))
                            {
                                _local_8.SetBuildingMode(cBuilding.BUILDING_MODE_BUILDER_WALKS_FROM_RESOURCECREATIONHOUSE_TO_STOREHOUSE);
                                _arg_1.SetSettlerKIState(cSettlerKI.SETTLER_STATE_WALKING_ON_RESOURCE_PATH);
                                if (null != _arg_1.GetPath())
                                {
                                    _arg_1.pathPos = (_arg_1.GetPath().pathLenX10000 + (_local_4 * SETTLER_WALK_SPEED_INT));
                                };
                            }
                            else
                            {
                                if (_local_7 != null)
                                {
                                    _local_8.SetBuildingMode(cBuilding.BUILDING_MODE_SETTLER_WALKS_FROM_STOREHOUSE_TO_RESOURCECREATIONHOUSE);
                                    _arg_1.pathPos = (_local_4 * SETTLER_WALK_SPEED_INT);
                                }
                                else
                                {
                                    _local_8.SetBuildingMode(cBuilding.BUILDING_MODE_PRODUCES_NO_RESOURCES);
                                    _arg_1.SetRemove(true);
                                };
                            };
                            if (this.mResourceCreationResources != null)
                            {
                                this.mResourceCreationResources.CalculateMaxLimitsForResources(this.mResourceCreationPlayer.GetPlayerId());
                            };
                            _arg_1.SetProductionState(cResourceCreation.PRODUCTIONSTATE_WORKING);
                            this.mGeneralInterface.mPathFinder.InvalidateAll(this.mResourceCreationPlayer.GetPlayerId());
                            for each (_local_9 in this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.GetBuildings_vector())
                            {
                                if (((!(null == _local_9)) && (!(_local_9.GetResourceCreation() == null))))
                                {
                                    _local_9.GetResourceCreation().SetInvalidatePaths(true);
                                };
                            };
                            this.mResourceCreationPlayer.IncBuildingCount(_local_8);
                            this.mGeneralInterface.mDataTracking.AddTrackingValue(cDataTracking.DATA_TRACKING_BUILDING_BUILT, 1);
                            _local_8.mBuildingCreationTime = (this.mCurrentTime - _local_4);
                            this.mResourceCreationPlayer.AddXP(_local_8.GetGOContainer().mXP);
                            this.mGeneralInterface.mQuestClientCallbacks.BuildingCreated(_local_8.GetBuildingName_string());
                            cSoundManager.getInstance().playEffect("BuildingReady");
                        };
                        break;
                    case cBuilding.BUILDING_MODE_BUILDER_WALKS_FROM_RESOURCECREATIONHOUSE_TO_STOREHOUSE:
                        _arg_1.pathPos = (_arg_1.pathPos + (_arg_2 * SETTLER_WALK_SPEED_INT));
                        if (((null == _arg_1.GetPath()) || (_arg_1.pathPos >= _arg_1.GetPath().pathLenX20000)))
                        {
                            if (((null == _arg_1.GetPath()) || (_local_7 == null)))
                            {
                                _local_8.SetBuildingMode(cBuilding.BUILDING_MODE_PRODUCES_NO_RESOURCES);
                                _arg_1.SetRemove(true);
                                return (INCREASE_RESOURCE_RESULT_OK);
                            };
                            if (this.mResourceCreationResources.AssignWorkers(1))
                            {
                                this.mGeneralInterface.channels.PRODUCTION.send(PRODUCTION_TIMES_CHANGED, _local_8);
                                _arg_1.pathPos = (_arg_1.pathPos - _arg_1.GetPath().pathLenX20000);
                                _arg_1.SetWorkingSettler();
                                _arg_1.SetAssignedSettler(true);
                                _local_8.SetBuildingMode(cBuilding.BUILDING_MODE_SETTLER_WALKS_FROM_STOREHOUSE_TO_RESOURCECREATIONHOUSE);
                                _arg_1.SetSettlerKIState(cSettlerKI.SETTLER_STATE_WALKING_ON_RESOURCE_PATH);
                                _arg_1.SetProductionState(cResourceCreation.PRODUCTIONSTATE_WORKING);
                            }
                            else
                            {
                                _arg_1.pathPos = (_arg_1.GetPath().pathLenX20000 - defines.POPULATION_WAIT_TIME);
                                _arg_1.SetSettlerKIState(cSettlerKI.SETTLER_STATE_WAITS_FOR_POPULATION);
                                _arg_1.SetProductionState(cResourceCreation.PRODUCTIONSTATE_ERROR_WAITING_FOR_SETTLER);
                            };
                        };
                        break;
                    case cBuilding.BUILDING_MODE_QUEUED:
                        break;
                    case cBuilding.BUILDING_MODE_SETTLER_WALKS_FROM_STOREHOUSE_TO_RESOURCECREATIONHOUSE:
                        this.mGeneralInterface.mCurrentPlayer.notifyPropertyObserver(cResourceCreation.RESOURCE_CREATION, _arg_1);
                        this.mGeneralInterface.mCurrentPlayer.notifyPropertyObserver(cResourceCreation.RESOURCE_CREATION_APPLY_MODIFIERS, _arg_1);
                        this.mGeneralInterface.channels.PRODUCTION.send(PRODUCTION_VALUES, _arg_1.GetResourceCreationHouse());
                        if (_local_7 == null)
                        {
                            return (INCREASE_RESOURCE_RESULT_OK);
                        };
                        _arg_1.SetSettlerKIState(cSettlerKI.SETTLER_STATE_WALKING_ON_RESOURCE_PATH);
                        _arg_1.pathPos = (_arg_1.pathPos + (_arg_2 * SETTLER_WALK_SPEED_INT));
                        if (_arg_1.pathPos >= _arg_1.GetPath().pathLenX10000)
                        {
                            if (_arg_1.GetStoreHouse() == null)
                            {
                                return (INCREASE_RESOURCE_SET_SETTLER_TO_IDLE);
                            };
                            _local_4 = int(((_arg_1.pathPos - _arg_1.GetPath().pathLenX10000) / SETTLER_WALK_SPEED_INT));
                            _local_11 = _arg_1.pathPos;
                            _arg_1.pathPos = _arg_1.GetPath().pathLenX10000;
                            _arg_1.SetSettlerKIState(cSettlerKI.SETTLER_STATE_IS_WORKING_IN_RESOURCE_CREATION_HOUSE);
                            _local_8.mStartWorkCounter = _local_4;
                            _local_8.notifyPropertyObserver(DEPOSIT_WORK_BEGIN, _local_8);
                            if (_local_7.externalResource_string != "")
                            {
                                _local_8.SetBuildingMode(cBuilding.BUILDING_MODE_WORKANIM_IS_WORKING_AT_WORKYARD_EXTERNAL_WORKYARD_SYSTEM_ACTIVE);
                            }
                            else
                            {
                                _local_8.SetBuildingMode(cBuilding.BUILDING_MODE_WORKANIM_IS_WORKING_AT_WORKYARD_LOCAL_WORKYARD_SYSTEM);
                            };
                        };
                        break;
                    case cBuilding.BUILDING_MODE_WORKANIM_IS_WORKING_AT_WORKYARD_LOCAL_WORKYARD_SYSTEM:
                        _arg_1.SetSettlerKIState(cSettlerKI.SETTLER_STATE_IS_WORKING_IN_RESOURCE_CREATION_HOUSE);
                        _local_8.mStartWorkCounter = (_local_8.mStartWorkCounter + _arg_2);
                        _local_5 = int(((_arg_1.GetPath().pathLenX20000 / SETTLER_WALK_SPEED_INT) + (_arg_1.GetWorkTime() * 1000)));
                        if (_local_8.mStartWorkCounter >= _local_5)
                        {
                            if (((!(_local_8.IsProductionActive())) || (_local_8.IsProductionLevelTooLow())))
                            {
                                _local_8.mStartWorkCounter = (_local_5 - defines.PRODUCTION_STOP_WAITTIME);
                                if (_local_8.IsProductionLevelTooLow())
                                {
                                    _arg_1.SetProductionState(cResourceCreation.PRODUCTIONSTATE_UPGRADELEVEL_TOO_LOW);
                                }
                                else
                                {
                                    _arg_1.SetProductionState(cResourceCreation.PRODUCTIONSTATE_STOPPED_PRODUCTION);
                                };
                                break;
                            };
                            if (_local_8.IsUpgradeInProgress())
                            {
                                _local_8.mStartWorkCounter = (_local_5 - defines.PRODUCTION_STOP_WAITTIME);
                                break;
                            };
                            _local_4 = (_local_8.mStartWorkCounter - _local_5);
                            _arg_1.pathPos = (_arg_1.GetPath().pathLenX10000 + (_local_4 * SETTLER_WALK_SPEED_INT));
                            _arg_1.SetSettlerKIState(cSettlerKI.SETTLER_STATE_WALKING_ON_RESOURCE_PATH);
                            _arg_1.SetGatheredResource(_local_7.amountRemoved);
                            _arg_1.SetWorkingSettlerCarries();
                            _local_8.SetBuildingMode(cBuilding.BUILDING_MODE_SETTLER_WALKS_FROM_RESOURCECREATIONHOUSE_TO_STOREHOUSE);
                        };
                        break;
                    case cBuilding.BUILDING_MODE_WORKANIM_IS_WORKING_AT_WORKYARD_EXTERNAL_WORKYARD_SYSTEM_ACTIVE:
                        _arg_1.SetSettlerKIState(cSettlerKI.SETTLER_STATE_IS_WORKING_IN_RESOURCE_CREATION_HOUSE);
                        _local_8.mStartWorkCounter = (_local_8.mStartWorkCounter + _arg_2);
                        if (_local_8.mStartWorkCounter >= 0)
                        {
                            if (((!(_local_8.IsProductionActive())) || (_local_8.IsProductionLevelTooLow())))
                            {
                                _local_8.mStartWorkCounter = -(defines.PRODUCTION_STOP_WAITTIME);
                                if (_local_8.IsProductionLevelTooLow())
                                {
                                    _arg_1.SetProductionState(cResourceCreation.PRODUCTIONSTATE_UPGRADELEVEL_TOO_LOW);
                                }
                                else
                                {
                                    _arg_1.SetProductionState(cResourceCreation.PRODUCTIONSTATE_STOPPED_PRODUCTION);
                                };
                                break;
                            };
                            if (_local_8.IsUpgradeInProgress())
                            {
                                _local_8.mStartWorkCounter = -(defines.PRODUCTION_STOP_WAITTIME);
                                break;
                            };
                            _local_4 = _local_8.mStartWorkCounter;
                            if (this.SearchForNearestDepositFast(_arg_1))
                            {
                                _arg_1.SetProductionState(cResourceCreation.PRODUCTIONSTATE_WORKING);
                                _local_8.SetBuildingMode(cBuilding.BUILDING_MODE_SETTLER_WALKS_FROM_RESOURCECREATIONHOUSE_TO_EXTERNAL_RESOURCE);
                                _arg_1.SetSettlerKIState(cSettlerKI.SETTLER_STATE_WALKING_ON_DEPOSIT_PATH);
                                _arg_1.pathPos = (_local_4 * SETTLER_WALK_SPEED_INT);
                            }
                            else
                            {
                                _local_8.mStartWorkCounter = -(defines.PRODUCTION_STOP_WAITTIME);
                                if (_local_8.GetGOContainer().mShowMissingResources)
                                {
                                    this.TrackMissingResources(_arg_1, 0);
                                    _arg_1.SetProductionState(cResourceCreation.PRODUCTIONSTATE_ERROR_NECESSARY_RESOURCE_MISSING);
                                };
                                break;
                            };
                        };
                        break;
                    case cBuilding.BUILDING_MODE_SETTLER_WALKS_FROM_RESOURCECREATIONHOUSE_TO_EXTERNAL_RESOURCE:
                        if (_local_7 == null)
                        {
                            return (INCREASE_RESOURCE_RESULT_OK);
                        };
                        _arg_1.SetSettlerKIState(cSettlerKI.SETTLER_STATE_WALKING_ON_DEPOSIT_PATH);
                        _arg_1.pathPos = (_arg_1.pathPos + (_arg_2 * SETTLER_WALK_SPEED_INT));
                        if (_arg_1.GetDepositPath() == null)
                        {
                            cLog.warning(("Deposit path is null ! " + _arg_1));
                            mComputeResourceCreationLogZone = true;
                            this.ErrorResetResourceCreation(_arg_1);
                            break;
                        };
                        if (_arg_1.pathPos >= _arg_1.GetDepositPath().pathLenX10000)
                        {
                            if (_arg_1.GetStoreHouse() == null)
                            {
                                return (INCREASE_RESOURCE_SET_SETTLER_TO_IDLE);
                            };
                            _local_4 = int(((_arg_1.pathPos - _arg_1.GetDepositPath().pathLenX10000) / SETTLER_WALK_SPEED_INT));
                            _local_8.SetBuildingMode(cBuilding.BUILDING_MODE_WORKANIM_IS_WORKING_AT_EXTERNAL_DEPOSIT);
                            _arg_1.SetSettlerKIState(cSettlerKI.SETTLER_STATE_IS_WORKING_IN_EXTERNAL_WORKYARD);
                            _local_8.mStartWorkCounter = _local_4;
                            _local_3 = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mDepositContainer.get(_arg_1.GetDepositBuildingGridPos());
                            if (_local_3 != null)
                            {
                                _local_3.notifyPropertyObserver(DEPOSIT_WORK_BEGIN, _local_8);
                            };
                        };
                        break;
                    case cBuilding.BUILDING_MODE_WORKANIM_IS_WORKING_AT_EXTERNAL_DEPOSIT:
                        _arg_1.SetSettlerKIState(cSettlerKI.SETTLER_STATE_IS_WORKING_IN_EXTERNAL_WORKYARD);
                        _local_8.mStartWorkCounter = (_local_8.mStartWorkCounter + _arg_2);
                        _local_5 = (_arg_1.GetWorkTime() * 1000);
                        if (_local_8.mStartWorkCounter >= _local_5)
                        {
                            if (((!(_local_8.IsProductionActive())) || (_local_8.IsProductionLevelTooLow())))
                            {
                                _local_8.mStartWorkCounter = (_local_5 - defines.PRODUCTION_STOP_WAITTIME);
                                if (_local_8.IsProductionLevelTooLow())
                                {
                                    _arg_1.SetProductionState(cResourceCreation.PRODUCTIONSTATE_UPGRADELEVEL_TOO_LOW);
                                }
                                else
                                {
                                    _arg_1.SetProductionState(cResourceCreation.PRODUCTIONSTATE_STOPPED_PRODUCTION);
                                };
                                break;
                            };
                            if (_local_8.IsUpgradeInProgress())
                            {
                                _local_8.mStartWorkCounter = (_local_5 - defines.PRODUCTION_STOP_WAITTIME);
                                break;
                            };
                            _local_4 = (_local_8.mStartWorkCounter - _local_5);
                            if (_arg_1.GetDepositBuildingGridPos() != -1)
                            {
                                if (_arg_1.GetDepositPath() == null)
                                {
                                    cLog.warning(("Deposit path is null ! " + _arg_1));
                                    mComputeResourceCreationLogZone = true;
                                    this.ErrorResetResourceCreation(_arg_1);
                                    break;
                                };
                                _arg_1.pathPos = (_arg_1.GetDepositPath().pathLenX10000 + (_local_4 * SETTLER_WALK_SPEED_INT));
                                _local_3 = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mDepositContainer.get(_arg_1.GetDepositBuildingGridPos());
                                _arg_1.SetGatheredResource(0);
                                if (_local_3 != null)
                                {
                                    if (((_local_3.GetAmount() > 0) || (_arg_1.GetResourceCreationDefinition().amountRemoved < 0)))
                                    {
                                        if (_local_3.mDepositGfx != null)
                                        {
                                            _local_3.mDepositGfx.SetValue(_local_3.GetAmount());
                                        };
                                        _local_12 = this.HasBlockingProductivityInputBuff(_local_8);
                                        if (((_local_8.GetResourceOutputFactor() == 0) || ((_local_8.GetResourceInputFactor() == 0) && (_local_12))))
                                        {
                                            _local_8.mStartWorkCounter = (_local_5 - defines.PRODUCTION_STOP_WAITTIME);
                                            _arg_1.SetProductionState(cResourceCreation.PRODUCTIONSTATE_BUFF_STOPPED_PRODUCTION);
                                            break;
                                        };
                                        _local_13 = _local_7.amountRemoved;
                                        if (_local_13 < 0)
                                        {
                                            _local_13 = (_local_13 * _local_8.GetResourceOutputFactor());
                                        }
                                        else
                                        {
                                            _local_13 = (_local_13 * _local_8.GetResourceInputFactor());
                                        };
                                        if (DEPOSIT_CREATION_INFO)
                                        {
                                            cLog.info(((((((this.mCurrentResourceNr + "Reached deposit: ") + _local_3.GetName_string()) + " Amount: ") + _local_3.GetAmount()) + " removed: ") + _local_7.amountRemoved));
                                        };
                                        if (((_local_3.GetAmount() >= _local_3.GetMaxAmount()) && ((_local_3.GetAmount() - _local_13) < _local_3.GetMaxAmount())))
                                        {
                                            this.mGeneralInterface.mPathFinder.InvalidateDepositMatrix(_local_8.getPlayerID(), _local_3.GetName_string(), cPathFinder.AMOUNT_TYPE_BELOW_MAX);
                                        };
                                        if (((_local_3.GetAmount() <= 0) && ((_local_3.GetAmount() - _local_13) > 0)))
                                        {
                                            this.mGeneralInterface.mPathFinder.InvalidateDepositMatrix(_local_8.getPlayerID(), _local_3.GetName_string(), cPathFinder.AMOUNT_TYPE_ABOVE_ZERO);
                                        };
                                        if (((_local_3.GetAmount() < _local_3.GetMaxAmount()) && ((_local_3.GetAmount() - _local_13) >= _local_3.GetMaxAmount())))
                                        {
                                            this.mGeneralInterface.mPathFinder.InvalidateDepositMatrix(_local_8.getPlayerID(), _local_3.GetName_string(), cPathFinder.AMOUNT_TYPE_BELOW_MAX);
                                        };
                                        _local_3.ChangeAmount(-(_local_13));
                                        _arg_1.SetGatheredResource(_local_7.amountRemoved);
                                        if (_local_3.GetAmount() <= 0)
                                        {
                                            if (((_local_3.GetName_string().indexOf("Wood") == -1) && (!(_local_3.GetName_string() == "Fish"))))
                                            {
                                                globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.DEPOSIT_DEPLETED, _local_3);
                                            };
                                            _arg_1.SetGatheredResource((_arg_1.GetGatheredResource() + _local_3.GetAmount()));
                                            _local_3.EmptyDeposit();
                                            if (_local_3.GetDepositGroupID() != -1)
                                            {
                                                _local_3.IncEmptied();
                                                _local_3.SetAccessibleType(DEPOSIT_ACCESSIBLE_TYPES.NOT_ACCESSIBLE);
                                            };
                                            this.mGeneralInterface.mPathFinder.InvalidateDepositMatrix(_local_8.getPlayerID(), _local_3.GetName_string(), cPathFinder.AMOUNT_TYPE_ABOVE_ZERO);
                                            for each (_local_14 in this.mResourceCreation_vector)
                                            {
                                                if (_local_14.GetDepositBuildingGridPos() == _arg_1.GetDepositBuildingGridPos())
                                                {
                                                    if (_local_14 != _arg_1)
                                                    {
                                                        _local_17 = _local_14.GetResourceCreationHouse();
                                                        if (((!(_local_14.GetRemove())) && (!(_local_17 == null))))
                                                        {
                                                            if (((!(_local_14.GetResourceCreationDefinition() == null)) && (_local_14.GetResourceCreationDefinition().amountRemoved > 0)))
                                                            {
                                                                if (_local_17.GetBuildingMode() == cBuilding.BUILDING_MODE_WORKANIM_IS_WORKING_AT_EXTERNAL_DEPOSIT)
                                                                {
                                                                    _local_17.SetBuildingMode(cBuilding.BUILDING_MODE_SETTLER_WALKS_FROM_EXTERNAL_RESOURCE_TO_RESOURCECREATIONHOUSE);
                                                                    _local_14.pathPos = _arg_1.GetDepositPath().pathLenX10000;
                                                                    _local_14.SetWorkingSettler();
                                                                    _local_14.SetSettlerKIState(cSettlerKI.SETTLER_STATE_WALKING_ON_DEPOSIT_PATH);
                                                                }
                                                                else
                                                                {
                                                                    if (_local_17.GetBuildingMode() == cBuilding.BUILDING_MODE_SETTLER_WALKS_FROM_RESOURCECREATIONHOUSE_TO_EXTERNAL_RESOURCE)
                                                                    {
                                                                        _local_17.SetBuildingMode(cBuilding.BUILDING_MODE_SETTLER_WALKS_FROM_EXTERNAL_RESOURCE_TO_RESOURCECREATIONHOUSE);
                                                                        _local_14.pathPos = (_arg_1.GetDepositPath().pathLenX20000 - _local_14.pathPos);
                                                                        _local_14.SetWorkingSettler();
                                                                        _local_14.SetSettlerKIState(cSettlerKI.SETTLER_STATE_WALKING_ON_DEPOSIT_PATH);
                                                                    };
                                                                };
                                                            };
                                                        };
                                                    };
                                                };
                                            };
                                            _local_16 = _local_3.GetContainerName_string();
                                            if (_local_3.GetDepositGroupID() != -1)
                                            {
                                                _local_15 = _local_3.GetGrid();
                                                this.mGeneralInterface.mCurrentPlayerZone.RemoveDepositIcon(_local_15);
                                                _local_18 = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mBuildingContainer.get(_local_15);
                                                if (_local_18 != null)
                                                {
                                                    this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.RemoveBuildingGridPos(_local_18.GetGrid(), true);
                                                    this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.RemoveBuildingFromGameLogicKeepResourceCreation(_local_18);
                                                    if (!StringUtils.isEmpty(_local_18.depletedMineExtension))
                                                    {
                                                        _local_16 = _local_18.depletedMineExtension;
                                                    };
                                                };
                                                TrackManager.getInstance().trackDepositDepleted(this.mGeneralInterface.mCurrentPlayer, _local_3, _local_18);
                                                this.mGeneralInterface.mCurrentPlayerZone.DepositWasDepleted(this.mGeneralInterface.mCurrentPlayer, _local_15, _local_16);
                                                this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mDepositContainer.remove(_arg_1.GetDepositBuildingGridPos());
                                                this.mGeneralInterface.mDataTracking.AddTrackingValue(cDataTracking.DATA_TRACKING_MINES_EMPTIED, 1);
                                            }
                                            else
                                            {
                                                if (_local_3 != null)
                                                {
                                                    _local_15 = _local_3.GetGrid();
                                                    this.mGeneralInterface.mCurrentPlayerZone.RemoveDepositIcon(_local_15);
                                                    _local_19 = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mBuildingContainer.get(_local_15);
                                                    if (_local_19 != null)
                                                    {
                                                        if (_local_19.GetGOContainer().mAddDepositAmount != -1)
                                                        {
                                                            this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.RemoveDepositGridPos(_local_15, true);
                                                            _local_20 = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mBuildingContainer.get(_local_15);
                                                            if (_local_20 != null)
                                                            {
                                                                this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.RemoveBuildingGridPos(_local_20.GetGrid(), true);
                                                                this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.RemoveBuildingFromGameLogicKeepResourceCreation(_local_20);
                                                                if (!StringUtils.isEmpty(_local_20.depletedMineExtension))
                                                                {
                                                                    _local_16 = _local_20.depletedMineExtension;
                                                                };
                                                            };
                                                            TrackManager.getInstance().trackDepositDepleted(this.mGeneralInterface.mCurrentPlayer, _local_3, _local_20);
                                                            this.mGeneralInterface.mCurrentPlayerZone.DepositWasDepleted(this.mResourceCreationPlayer, _local_15, _local_16);
                                                        };
                                                    };
                                                };
                                            };
                                        };
                                    };
                                };
                            }
                            else
                            {
                                cLog.warning(("Deposit path! " + _arg_1));
                                mComputeResourceCreationLogZone = true;
                                this.ErrorResetResourceCreation(_arg_1);
                                break;
                            };
                            _local_8.SetBuildingMode(cBuilding.BUILDING_MODE_SETTLER_WALKS_FROM_EXTERNAL_RESOURCE_TO_RESOURCECREATIONHOUSE);
                            _arg_1.SetWorkingSettlerCarries();
                            _arg_1.SetSettlerKIState(cSettlerKI.SETTLER_STATE_WALKING_ON_DEPOSIT_PATH);
                        };
                        break;
                    case cBuilding.BUILDING_MODE_SETTLER_WALKS_FROM_EXTERNAL_RESOURCE_TO_RESOURCECREATIONHOUSE:
                        _arg_1.SetSettlerKIState(cSettlerKI.SETTLER_STATE_WALKING_ON_DEPOSIT_PATH);
                        _arg_1.pathPos = (_arg_1.pathPos + (_arg_2 * SETTLER_WALK_SPEED_INT));
                        _local_21 = 0;
                        if (_arg_1.GetDepositPath() != null)
                        {
                            _local_21 = _arg_1.GetDepositPath().pathLenX20000;
                        };
                        if (_arg_1.pathPos >= _local_21)
                        {
                            _local_4 = int(((_arg_1.pathPos - _local_21) / SETTLER_WALK_SPEED_INT));
                            _arg_1.pathPos = (_arg_1.GetPath().pathLenX10000 + (_local_4 * SETTLER_WALK_SPEED_INT));
                            _arg_1.SetWorkingSettlerCarries();
                            _local_8.SetBuildingMode(cBuilding.BUILDING_MODE_SETTLER_WALKS_FROM_RESOURCECREATIONHOUSE_TO_STOREHOUSE);
                            _arg_1.SetSettlerKIState(cSettlerKI.SETTLER_STATE_WALKING_ON_RESOURCE_PATH);
                        };
                        break;
                    case cBuilding.BUILDING_MODE_SETTLER_WALKS_FROM_RESOURCECREATIONHOUSE_TO_STOREHOUSE:
                        if (_local_7 == null)
                        {
                            return (INCREASE_RESOURCE_RESULT_OK);
                        };
                        _arg_1.pathPos = (_arg_1.pathPos + (_arg_2 * SETTLER_WALK_SPEED_INT));
                        if (_arg_1.pathPos >= _arg_1.GetPath().pathLenX20000)
                        {
                            _local_22 = 0;
                            _local_23 = 0;
                            _local_24 = 0;
                            if (((_arg_1.GetGatheredResource() > 0) || (_local_7.amountRemoved == 0)))
                            {
                                _local_22 = ((_local_7.amountRemoved == 0) ? 1 : _local_7.amountRemoved);
                                _local_23 = _local_8.GetResourceInputFactor();
                                _local_24 = _local_8.GetResourceOutputFactor();
                            }
                            else
                            {
                                if (_arg_1.GetGatheredResource() == 0)
                                {
                                    if (!((!(_arg_1.GetResourceCreationDefinition().externalResource_string == null)) && (_arg_1.GetResourceCreationDefinition().externalResource_string.length > 0)))
                                    {
                                        _arg_1.SetGatheredResource(1);
                                        _local_22 = _local_7.amountRemoved;
                                        _local_23 = _local_8.GetResourceInputFactor();
                                        _local_24 = _local_8.GetResourceOutputFactor();
                                    };
                                };
                            };
                            _local_22 = (_local_22 * _local_24);
                            if (_local_7.necessaryResources_vector.length > 0)
                            {
                                if (this.mResourceCreationResources.HasPlayerResourcesInList(_local_7.necessaryResources_vector, _local_23))
                                {
                                    _arg_1.SetProductionState(cResourceCreation.PRODUCTIONSTATE_WORKING);
                                    _local_25 = this.mResourceCreationResources.AddResource(_local_7.defaultSetting.resourceName_string, _local_22, ModifyReason.RESOURCE_CREATION, null);
                                    if (_local_25)
                                    {
                                        this.mResourceCreationResources.RemovePlayerResourcesFromResourcesInList(_local_7.necessaryResources_vector, _local_23, ModifyReason.RESOURCE_CREATION);
                                    }
                                    else
                                    {
                                        _arg_1.SetSettlerKIState(cSettlerKI.SETTLER_STATE_WAITS_BECAUSE_WAREHOUSE_IS_FULL);
                                        _arg_1.pathPos = (_arg_1.GetPath().pathLenX20000 - defines.WAREHOUSE_FULL_WAIT_TIME);
                                        _arg_1.SetProductionState(cResourceCreation.PRODUCTIONSTATE_ERROR_WAREHOUSE_FULL);
                                        break;
                                    };
                                }
                                else
                                {
                                    if (_local_8.GetGOContainer().mShowMissingResources)
                                    {
                                        this.TrackMissingResources(_arg_1, _local_23);
                                        _arg_1.SetProductionState(cResourceCreation.PRODUCTIONSTATE_ERROR_NECESSARY_RESOURCE_MISSING);
                                    };
                                    _arg_1.SetSettlerKIState(cSettlerKI.SETTLER_STATE_WAITS_BECAUSE_WAREHOUSE_IS_FULL);
                                    _arg_1.pathPos = (_arg_1.GetPath().pathLenX20000 - defines.WAREHOUSE_FULL_WAIT_TIME);
                                    break;
                                };
                            }
                            else
                            {
                                if (_local_22 > 0)
                                {
                                    _arg_1.SetProductionState(cResourceCreation.PRODUCTIONSTATE_WORKING);
                                    if (!this.mResourceCreationResources.AddResource(_local_7.defaultSetting.resourceName_string, _local_22, ModifyReason.RESOURCE_CREATION, null))
                                    {
                                        _arg_1.SetSettlerKIState(cSettlerKI.SETTLER_STATE_WAITS_BECAUSE_WAREHOUSE_IS_FULL);
                                        _arg_1.pathPos = (_arg_1.GetPath().pathLenX20000 - defines.WAREHOUSE_FULL_WAIT_TIME);
                                        _arg_1.SetProductionState(cResourceCreation.PRODUCTIONSTATE_ERROR_WAREHOUSE_FULL);
                                        break;
                                    };
                                    if (_arg_1.GetResourceCreationDefinition().defaultSetting.resourceName_string == defines.HARD_CURRENCY_RESOURCE_NAME_string)
                                    {
                                        TrackManager.getInstance().trackGemsProduction(this.mResourceCreationPlayer, defines.CURRENCY_GEMS_GEMPIT, _local_22, this.mGeneralInterface.mCurrentPlayerZone.GetResources(this.mResourceCreationPlayer).GetPlayerResource(defines.HARD_CURRENCY_RESOURCE_NAME_string).amount, "GemPit");
                                    };
                                };
                            };
                            _arg_1.pathPos = (_arg_1.pathPos - _arg_1.GetPath().pathLenX20000);
                            if (this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mBuildingContainer.get(_arg_1.GetResourceCreationHouse().GetGrid()) != _arg_1.GetResourceCreationHouse())
                            {
                                _arg_1.SetRemove(true);
                            };
                            if (_local_8 == null)
                            {
                                return (INCREASE_RESOURCE_SET_SETTLER_TO_IDLE);
                            };
                            _arg_1.SetSettlerKIState(cSettlerKI.SETTLER_STATE_WALKING_ON_RESOURCE_PATH);
                            _arg_1.SetWorkingSettler();
                            _local_8.SetBuildingMode(cBuilding.BUILDING_MODE_SETTLER_WALKS_FROM_STOREHOUSE_TO_RESOURCECREATIONHOUSE);
                        };
                        break;
                };
            }
            else
            {
                if (this.mGeneralInterface.mCurrentViewedZoneID > 0)
                {
                    _local_26 = 1;
                    _local_27 = false;
                    _local_28 = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.GetMayorHouse();
                    if (_local_28 != null)
                    {
                        _local_29 = _local_28.mBuffs_vector;
                        for each (_local_30 in _local_29)
                        {
                            if (CollectionsManager.getInstance().getBuffIsCollectibleLootBuff(_local_30.GetBuffDefinition().GetName_string()))
                            {
                                _local_26 = 1;
                            }
                            else
                            {
                                _local_26 = int((_local_26 * (_local_30.GetBuffDefinition().getRecruitingTime() / 100)));
                                _local_27 = true;
                            };
                        };
                        for each (_local_31 in this.mGeneralInterface.mZoneBuffManager.getBuffAppliancesForBuilding(_local_28.GetBuildingName_string()))
                        {
                            _local_33 = cBuffDefinition.GetById(_local_31.buffID);
                            if (_local_33 != null)
                            {
                                _local_26 = int((_local_26 + ((_local_33.getRecruitingTime() - 100) / 100)));
                            };
                        };
                        _local_26 = Math.max(_local_26, 1);
                        _arg_1.pathPos = (_arg_1.pathPos + (_arg_2 * _local_26));
                        _local_32 = (_local_7.amountRemoved * 1000);
                        if (_arg_1.pathPos >= _local_32)
                        {
                            _arg_1.pathPos = (_arg_1.pathPos - _local_32);
                            this.mResourceCreationResources.AddResource(_local_7.defaultSetting.resourceName_string, 1, ModifyReason.RESOURCE_CREATION, null);
                            _arg_1.mDirtyIndicator = (_arg_1.mDirtyIndicator | DIRTY_INDICATOR.MODIFIED_BIT);
                        };
                    };
                };
            };
            return (INCREASE_RESOURCE_RESULT_OK);
        }

        public function AssignSettlerGfx(_arg_1:cResourceCreation):void
        {
            var _local_2:String = _arg_1.GetResourceCreationHouse().GetGOContainer().mGfxResourceSettlerName_string;
            var _local_3:* = "Default_carries";
            var _local_4:* = "Default";
            switch (_local_2)
            {
                case SETTLER_NAME_WOOD_CUTTER:
                    _local_3 = "Wood_carries";
                    _local_4 = "Wood";
                    break;
                case SETTLER_NAME_MASON_WORKER:
                    _local_3 = "Stone_carries";
                    _local_4 = "Stone";
                    break;
                case SETTLER_NAME_FORESTER:
                    _local_3 = "Wood";
                    _local_4 = "Wood";
                    break;
                case SETTLER_NAME_FISHER:
                    _local_3 = "Fish_carries";
                    _local_4 = "Fish";
                    break;
                case SETTLER_NAME_FARMER:
                    _local_3 = "Corn_carries";
                    _local_4 = "Corn";
                    break;
                case SETTLER_NAME_TOOLMAKER:
                    _local_3 = "Tool_carries";
                    _local_4 = "Tool";
                    break;
                case SETTLER_NAME_WATERWORKER:
                    _local_3 = "Water_carries";
                    _local_4 = "Water";
                    break;
            };
            _arg_1.settlerWithGoods = (defines.SETTLER_DEFAULT_WORKER_string + _local_3);
            _arg_1.settlerWithoutGoods = (defines.SETTLER_DEFAULT_WORKER_string + _local_4);
        }

        private function CalculateProductionPath(_arg_1:cResourceCreation, _arg_2:Boolean):Boolean
        {
            if (_arg_1 == null)
            {
                return (false);
            };
            var _local_3:cBuilding = _arg_1.GetResourceCreationHouse();
            if (((_arg_1.GetRemove()) || (_local_3 == null)))
            {
                return (false);
            };
            if (((!(_arg_1.GetResourceCreationDefinition() == null)) && (_arg_1.GetResourceCreationDefinition().typeEnumResourceType == RESOURCE_TYPE.CREATED_ALWAYS)))
            {
                return (false);
            };
            var _local_4:int = _local_3.getPlayerID();
            var _local_5:cPathObject = this.mGeneralInterface.mPathFinder.CalculatePathForWarehouse(_local_3.GetStreetGridEntry(), _local_4);
            if (((_local_5 == null) || (_local_5.dest_vector.length < 1)))
            {
                _arg_1.SetStoreHouse(null);
                return (false);
            };
            var _local_6:int = (_local_5.dest_vector[0] as dPathObjectItem).streetGridIdx;
            var _local_7:int = gCalculations.MoveStreetGridToDir8(this.mGeneralInterface.mCurrentPlayerZone, _local_6, defines.DIR8_NORTH_WEST);
            var _local_8:cBuilding = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mBuildingContainer.get(_local_7);
            _arg_1.SetStoreHouse(_local_8);
            _arg_1.SetPath(_local_5);
            if (!_arg_2)
            {
                _arg_1.pathPos = 0;
            };
            if (_arg_1.GetPath().dest_vector.length == 0)
            {
                gMisc.Assert(false, "Path to warehouse has length 0!");
                _arg_1.SetStoreHouse(null);
                _arg_1.SetPath(null);
            };
            this.mGeneralInterface.channels.PRODUCTION.send(PRODUCTION_TIMES_CHANGED, _local_3);
            return (true);
        }

        public function UpgradeBuilding(_arg_1:cBuilding):void
        {
            _arg_1.Upgrade();
            var _local_2:cResources = this.mGeneralInterface.mCurrentPlayerZone.GetResourcesForPlayerID(_arg_1.getPlayerID());
            _local_2.CalculateMaxLimitsForResources(_arg_1.getPlayerID());
        }

        private function TrackMissingResources(_arg_1:cResourceCreation, _arg_2:int):void
        {
            var _local_4:dResource;
            var _local_3:dResourceCreationDefinition = _arg_1.GetResourceCreationDefinition();
            if (_arg_1.GetProductionState() != cResourceCreation.PRODUCTIONSTATE_ERROR_NECESSARY_RESOURCE_MISSING)
            {
                for each (_local_4 in _local_3.necessaryResources_vector)
                {
                    if (!this.mResourceCreationResources.HasPlayerResource(_local_4.name_string, _arg_2))
                    {
                        TrackManager.getInstance().trackResourceMissing(this.mResourceCreationPlayer, _arg_1.GetResourceCreationHouse(), _local_4);
                    };
                };
            };
        }

        public function SpawnSettler(_arg_1:cPlayerData, _arg_2:cResourceCreation, _arg_3:String):Boolean
        {
            gMisc.Assert((!(_arg_2 == null)), "");
            if (((_arg_2.GetRemove()) || (_arg_2.GetResourceCreationHouse() == null)))
            {
                return (false);
            };
            if (_arg_2.GetStoreHouse() == null)
            {
                _arg_2.SetPath(null);
            };
            this.mGeneralInterface.mCurrentPlayerZone.mSettlerKIManager.SpawnSettlerOnResourcePath(_arg_1, _arg_2, _arg_3);
            return (true);
        }

        public function Init():void
        {
            this.ResetResourceCreation();
        }

        public function ErrorResetResourceCreation(_arg_1:cResourceCreation):void
        {
            var _local_2:cBuilding = _arg_1.GetResourceCreationHouse();
            if (_local_2 == null)
            {
                if (cLog.isInfoEnabled())
                {
                    cLog.info(("ResetResourceCreation building is null! " + _arg_1));
                };
                _arg_1.SetRemove(true);
                return;
            };
            _local_2.SetBuildingMode(cBuilding.BUILDING_MODE_SETTLER_WALKS_FROM_STOREHOUSE_TO_RESOURCECREATIONHOUSE);
            _arg_1.SetSettlerKIState(cSettlerKI.SETTLER_STATE_WALKING_ON_RESOURCE_PATH);
            _arg_1.SetProductionState(cResourceCreation.PRODUCTIONSTATE_WORKING);
            _arg_1.SetDepositPath(new cPathObject());
            _arg_1.pathPos = 0;
            _arg_1.SetAssignedSettler(true);
            if (_arg_1.GetSettler() != null)
            {
                _arg_1.SetWorkingSettler();
            };
        }

        public function CreateResourceCreationFromResourceCreationVO(_arg_1:dResourceCreationVO):void
        {
            var _local_7:cPathObject;
            var _local_8:int;
            var _local_9:dPathObjectItem;
            var _local_10:cPosInt;
            var _local_11:cPathObject;
            var _local_12:int;
            var _local_13:cBuilding;
            var _local_2:cBuilding;
            var _local_3:cPlayerData = this.mGeneralInterface.mCurrentPlayer;
            if (((!(_local_3.GetPlayerId() == _arg_1.playerId)) && (!(_arg_1.playerId == cGeneralInterface.BUILDING_OWNERSHIP_PLAYER))))
            {
                _local_3 = this.mGeneralInterface.FindPlayerFromId(_arg_1.playerId);
                if (_local_3 == null)
                {
                    return;
                };
            };
            var _local_4:dResourceCreationDefinition;
            var _local_5:int = _arg_1.resourceDefinitionID;
            if (_arg_1.uniqueID.uniqueID1 > 0)
            {
                _local_2 = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.GetBuildingByUniqueId(_arg_1.uniqueID);
                if (_local_2 != null)
                {
                    _local_4 = gEconomics.GetResourcesCreationDefinitionForBuilding(_local_2.GetBuildingName_string());
                };
            }
            else
            {
                if (_local_5 != -1)
                {
                    _local_4 = gEconomics.mResourceCreationDefinition_vector[_local_5];
                };
            };
            var _local_6:cResourceCreation = new cResourceCreation(_local_3.GetPlayerId(), _local_4, _local_2);
            _local_6.SetAssignedSettler(_arg_1.assignedSettler);
            _local_6.SetGatheredResource(_arg_1.gatheredResource);
            _local_6.SetProductionState(_arg_1.productionState);
            _local_6.SetDepositBuildingGridPos(_arg_1.depositBuildingGridPos);
            _local_6.SetRemove(_arg_1.remove);
            _local_6.SetUniqueID(_arg_1.uniqueID);
            if (_local_2 != null)
            {
                _local_2.SetResourceCreation(_local_6);
                this.AssignSettlerGfx(_local_6);
                if (_local_4 != null)
                {
                    if (((!(_local_4.externalResource_string == null)) && (!(_local_4.externalResource_string == ""))))
                    {
                        if (_arg_1.pathVO != null)
                        {
                            _local_7 = new cPathObject();
                            _local_7.Reset();
                            for each (_local_8 in _arg_1.pathVO.mPath)
                            {
                                _local_9 = new dPathObjectItem();
                                _local_9.streetGridIdx = _local_8;
                                _local_10 = new cPosInt();
                                gCalculations.ConvertStreetGridToPixelPos(this.mGeneralInterface.mCurrentPlayerZone, _local_8, _local_10);
                                _local_9.x = _local_10.x;
                                _local_9.y = _local_10.y;
                                _local_7.dest_vector.push(_local_9);
                            };
                            _local_7.RefreshLength();
                            _local_6.SetDepositPath(_local_7);
                        }
                        else
                        {
                            if (_arg_1.depositBuildingGridPos != -1)
                            {
                                _local_11 = null;
                                if (_local_6.GetResourceCreationHouse().GetGrid() != _arg_1.depositBuildingGridPos)
                                {
                                    _local_11 = this.mGeneralInterface.mPathFinder.CalculatePath(_local_6.GetResourceCreationHouse().GetStreetGridEntry(), _arg_1.depositBuildingGridPos, null, false);
                                }
                                else
                                {
                                    _local_11 = new cPathObject();
                                };
                                _local_6.SetDepositPath(_local_11);
                            }
                            else
                            {
                                _local_12 = _local_2.GetBuildingMode();
                                if (((((_local_2.IsBuildingActive()) && (!(_local_12 == cBuilding.BUILDING_MODE_BUILDER_WALKS_FROM_RESOURCECREATIONHOUSE_TO_STOREHOUSE))) && (!(_local_12 == cBuilding.BUILDING_MODE_SETTLER_WALKS_FROM_STOREHOUSE_TO_RESOURCECREATIONHOUSE))) && (!(_local_12 == cBuilding.BUILDING_MODE_WORKANIM_IS_WORKING_AT_WORKYARD_EXTERNAL_WORKYARD_SYSTEM_ACTIVE))))
                                {
                                    cLog.info((((("No deposit found (" + _local_4.externalResource_string) + " for ") + _local_2.GetBuildingName_string()) + ")"));
                                    this.ErrorResetResourceCreation(_local_6);
                                };
                            };
                        };
                    };
                };
            };
            _local_6.pathPos = _arg_1.pathPos;
            this.mResourceCreation_vector.push(_local_6);
            this.SpawnSettler(_local_3, _local_6, defines.SETTLER_BUILDER_string);
            _local_6.SetSettlerKIState(_arg_1.settlerKIState);
            if (_local_6.GetAssignedSettler())
            {
                if (_local_6.GetSettler() != null)
                {
                    _local_13 = _local_6.GetResourceCreationHouse();
                    if (_local_13 != null)
                    {
                        switch (_local_13.GetBuildingMode())
                        {
                            case cBuilding.BUILDING_MODE_SETTLER_WALKS_FROM_EXTERNAL_RESOURCE_TO_RESOURCECREATIONHOUSE:
                                _local_6.SetWorkingSettlerCarries();
                                break;
                            default:
                                _local_6.SetWorkingSettler();
                        };
                    };
                };
            };
            _local_6.mDirtyIndicator = DIRTY_INDICATOR.CLEAN;
        }


    }
}
