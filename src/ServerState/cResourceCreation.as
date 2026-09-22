package ServerState
{
    import Modifier.Modifieable;
    import GO.cSettler;
    import GO.cBuilding;
    import PathFinding.cPathObject;
    import Communication.VO.dUniqueID;
    import PathFinding.dPathObjectItem;
    import Communication.VO.dResourceCreationVO;
    import Communication.VO.dPathVO;
    import Modifier.ModifierVO;
    import Enums.DIRTY_INDICATOR;
    import Modifier.Modifier;
    import SettlerKI.cSettlerKI;
    import Enums.RESOURCE_TYPE;

    public class cResourceCreation implements Modifieable 
    {

        public static const RESOURCE_CREATION:String = "RESOURCE_CREATION";
        public static const RESOURCE_CREATION_APPLY_MODIFIERS:String = "RESOURCE_CREATION_APPLY_MODIFIERS";
        public static const PRODUCTIONSTATE_WORKING:int = 0;
        public static const PRODUCTIONSTATE_ERROR_NECESSARY_RESOURCE_MISSING:int = 1;
        public static const PRODUCTIONSTATE_ERROR_WAREHOUSE_FULL:int = 2;
        public static const PRODUCTIONSTATE_ERROR_WAITING_FOR_SETTLER:int = 3;
        public static const PRODUCTIONSTATE_ERROR_WAITING_FOR_TOOL:int = 4;
        public static const PRODUCTIONSTATE_STOPPED_PRODUCTION:int = 5;
        public static const PRODUCTIONSTATE_MISSING_STREET:int = 6;
        public static const BUILDINGUPGRADE_PRODUCTIONSTATE_UPDATE_IN_PROGRESS:int = 7;
        public static const PRODUCTIONSTATE_BUFF_STOPPED_PRODUCTION:int = 8;
        public static const DIFFICULT_BANDIT_STATE:int = 9;
        public static const LEADER_BANDIT_STATE:int = 10;
        public static const DIFFICULT_LEADER_BANDIT_STATE:int = 11;
        public static const SKILLED_OBJECT:int = 12;
        public static const SKILLPOINT_FINISHED:int = 13;
        public static const PRODUCTIONSTATE_UPGRADELEVEL_TOO_LOW:int = 14;
        public static const MOUNTAIN_DESTRUCTION_PREPARATION:int = 15;
        public static const BUILDINGUPGRADE_TRIGGERS_FULFILLED:int = 16;

        private var settler:cSettler;
        private var gatheredResource:int;
        private var resourceCreationHouse:cBuilding;
        public var settlerWithoutGoods:String = "";
        private var removeFlag:Boolean;
        private var path:cPathObject;
        public var mDirtyIndicator:int;
        private var playerID:int;
        private var storeHouse:cBuilding;
        private var resourceCreationDefinition:dResourceCreationDefinition;
        private var modifiedProductionMultiplier:Number = 1;
        private var mUniqueID:dUniqueID;
        private var modified:Boolean;
        private var modifiedProductionAdder:int = 0;
        private var assignedSettler:Boolean;
        private var depositBuildingGridPos:int = -1;
        private var productionState:int;
        private var depositPath:cPathObject;
        public var settlerWithGoods:String = "";
        private var settlerKIState:int;
        public var pathPos:int;
        private var invalidatePaths:Boolean = false;

        public function cResourceCreation(_arg_1:int, _arg_2:dResourceCreationDefinition, _arg_3:cBuilding)
        {
            super();
            this.resourceCreationDefinition = _arg_2;
            this.playerID = _arg_1;
            this.resourceCreationHouse = _arg_3;
            if (this.resourceCreationHouse != null)
            {
                this.depositBuildingGridPos = this.resourceCreationHouse.GetGrid();
                this.resourceCreationHouse.mGeneralInterface.mCurrentPlayer.notifyPropertyObserver(cResourceCreation.RESOURCE_CREATION, this);
                this.resourceCreationHouse.mGeneralInterface.mCurrentPlayer.notifyPropertyObserver(cResourceCreation.RESOURCE_CREATION_APPLY_MODIFIERS, this);
            };
        }

        public function GetWorkTime():int
        {
            return (int(((this.GetResourceCreationDefinition().workTime * this.modifiedProductionMultiplier) + this.modifiedProductionAdder)));
        }

        public function GetUniqueID():dUniqueID
        {
            return (this.mUniqueID);
        }

        public function toString():String
        {
            return ((((((((((((((((((((((((((((((((((("<ResourceCreation " + " depositBuildingGridPos=") + this.depositBuildingGridPos) + " depositPath=") + this.depositPath) + " resourceCreationDefinition=") + this.resourceCreationDefinition) + " path=") + this.path) + " invalidatePaths=") + this.invalidatePaths) + " pathPos=") + this.pathPos) + " gatheredResource=") + this.gatheredResource) + " storeHouse=") + this.storeHouse) + " resourceCreationHouse=") + this.resourceCreationHouse) + " settler=") + this.settler) + " playerID=") + this.playerID) + " removeFlag=") + this.removeFlag) + " assignedSettler=") + this.assignedSettler) + " settlerKIState=") + this.settlerKIState) + " productionState=") + this.productionState) + " mDirtyIndicator=") + this.mDirtyIndicator) + " definition=") + this.resourceCreationDefinition) + " >");
        }

        public function CreateResourceCreationVOFromResourceCreation():dResourceCreationVO
        {
            var _local_2:dPathObjectItem;
            var _local_1:dResourceCreationVO = new dResourceCreationVO();
            if (this.GetResourceCreationDefinition() != null)
            {
                _local_1.resourceDefinitionID = this.GetResourceCreationDefinition().id;
            }
            else
            {
                _local_1.resourceDefinitionID = -1;
            };
            _local_1.depositBuildingGridPos = this.GetDepositBuildingGridPos();
            _local_1.pathPos = this.pathPos;
            _local_1.playerId = this.GetPlayerID();
            _local_1.assignedSettler = this.GetAssignedSettler();
            _local_1.settlerKIState = this.GetSettlerKIState();
            _local_1.gatheredResource = this.GetGatheredResource();
            _local_1.productionState = this.GetProductionState();
            _local_1.remove = this.GetRemove();
            if (this.GetDepositPath() != null)
            {
                _local_1.pathVO = new dPathVO();
                for each (_local_2 in this.GetDepositPath().dest_vector)
                {
                    _local_1.pathVO.mPath.addItem(_local_2.streetGridIdx);
                };
            }
            else
            {
                _local_1.pathVO = null;
            };
            if (this.GetResourceCreationHouse() != null)
            {
                _local_1.uniqueID = this.GetResourceCreationHouse().GetUniqueId();
            }
            else
            {
                _local_1.uniqueID = new dUniqueID();
            };
            return (_local_1);
        }

        public function GetResourceCreationDefinition():dResourceCreationDefinition
        {
            return (this.resourceCreationDefinition);
        }

        public function GetPlayerID():int
        {
            return (this.playerID);
        }

        public function isModified():Boolean
        {
            return (this.modified);
        }

        public function GetStoreHouse():cBuilding
        {
            return (this.storeHouse);
        }

        public function SetUniqueID(_arg_1:dUniqueID):void
        {
            this.mUniqueID = _arg_1;
        }

        public function SetPlayerID(_arg_1:int):void
        {
            this.playerID = _arg_1;
        }

        public function SetPath(_arg_1:cPathObject):Boolean
        {
            this.path = _arg_1;
            return (true);
        }

        public function SetStoreHouse(_arg_1:cBuilding):Boolean
        {
            this.storeHouse = _arg_1;
            return (true);
        }

        public function isModifierApplyable(_arg_1:ModifierVO):Boolean
        {
            if (this.resourceCreationDefinition != null)
            {
                return ((this.resourceCreationDefinition.defaultSetting.resourceName_string.length == _arg_1.type_string.length) && (this.resourceCreationDefinition.defaultSetting.resourceName_string.indexOf(_arg_1.type_string) > -1));
            };
            return (false);
        }

        public function SetProductionTimeModifiers(_arg_1:Number, _arg_2:int):void
        {
            this.modifiedProductionMultiplier = _arg_1;
            this.modifiedProductionAdder = _arg_2;
        }

        public function SetKIStateMoving():void
        {
            if (((!(this.settler == null)) && (!(this.settler.mSettlerKi == null))))
            {
                this.settler.mSettlerKi.SetKIStateMoving();
            };
        }

        public function GetProductionMultiplierInPercentage():int
        {
            return (int((100 / this.modifiedProductionMultiplier)) - 100);
        }

        public function SetProductionState(_arg_1:int):void
        {
            if (this.productionState == _arg_1)
            {
                return;
            };
            this.productionState = _arg_1;
            if (this.resourceCreationHouse != null)
            {
                this.resourceCreationHouse.mGeneralInterface.channels.PRODUCTION.send(cComputeResourceCreation.PRODUCTION_TIMES_CHANGED, this.resourceCreationHouse);
                this.resourceCreationHouse.UpdatedProductionState();
            };
            if ((((!(this.productionState == PRODUCTIONSTATE_STOPPED_PRODUCTION)) && (!(this.resourceCreationHouse == null))) && (this.resourceCreationHouse.IsBuildingInProduction())))
            {
                this.mDirtyIndicator = (this.mDirtyIndicator | DIRTY_INDICATOR.WEAK_MODIFICATION_BIT);
            }
            else
            {
                this.mDirtyIndicator = (this.mDirtyIndicator | DIRTY_INDICATOR.MODIFIED_BIT);
            };
        }

        public function SetAssignedSettler(_arg_1:Boolean):void
        {
            if (_arg_1 == this.assignedSettler)
            {
                return;
            };
            this.assignedSettler = _arg_1;
            if (this.resourceCreationHouse != null)
            {
                this.resourceCreationHouse.UpdatedProductionState();
            };
            this.mDirtyIndicator = (this.mDirtyIndicator | DIRTY_INDICATOR.MODIFIED_BIT);
        }

        public function GetDepositBuildingGridPos():int
        {
            return (this.depositBuildingGridPos);
        }

        public function SetDepositBuildingGridPos(_arg_1:int):Boolean
        {
            if (_arg_1 == this.depositBuildingGridPos)
            {
                return (true);
            };
            this.depositBuildingGridPos = _arg_1;
            this.mDirtyIndicator = (this.mDirtyIndicator | DIRTY_INDICATOR.MODIFIED_BIT);
            return (true);
        }

        public function SetDepositPath(_arg_1:cPathObject):Boolean
        {
            this.depositPath = _arg_1;
            return (true);
        }

        public function GetSettlerKIState():int
        {
            return (this.settlerKIState);
        }

        public function HasInvalidatedPaths():Boolean
        {
            return (this.invalidatePaths);
        }

        public function setModified(_arg_1:Modifier):void
        {
            this.modified = true;
        }

        public function GetDepositPath():cPathObject
        {
            return (this.depositPath);
        }

        public function SetSettlerKIState(_arg_1:int):void
        {
            this.settlerKIState = _arg_1;
            if (((!(this.resourceCreationHouse == null)) && (this.resourceCreationHouse.IsBuildingInProduction())))
            {
                this.mDirtyIndicator = (this.mDirtyIndicator | DIRTY_INDICATOR.WEAK_MODIFICATION_BIT);
            }
            else
            {
                this.mDirtyIndicator = (this.mDirtyIndicator | DIRTY_INDICATOR.MODIFIED_BIT);
            };
            if (this.settler != null)
            {
                this.settler.mSettlerKi.SetKIState(_arg_1);
            };
        }

        public function GetProductionStateIconIndex():int
        {
            if (((this.productionState == PRODUCTIONSTATE_WORKING) || (this.productionState >= PRODUCTIONSTATE_UPGRADELEVEL_TOO_LOW)))
            {
                return (-1);
            };
            return (this.productionState);
        }

        public function GetProductionState():int
        {
            return (this.productionState);
        }

        public function GetRemove():Boolean
        {
            return (this.removeFlag);
        }

        public function GetAssignedSettler():Boolean
        {
            return (this.assignedSettler);
        }

        public function SetInvalidatePaths(_arg_1:Boolean):void
        {
            this.invalidatePaths = _arg_1;
        }

        public function SetWorkingSettlerCarries():void
        {
            if (this.settler != null)
            {
                this.settler.SetSpriteImage(this.settlerWithGoods);
            };
        }

        public function SetSettlerKIStateDeactivate():void
        {
            this.SetSettlerKIState(cSettlerKI.SETTLER_STATE_REMOVE_SETTLER);
        }

        public function GetGatheredResource():int
        {
            return (this.gatheredResource);
        }

        public function SetGatheredResource(_arg_1:int):Boolean
        {
            this.gatheredResource = _arg_1;
            if (((!(this.resourceCreationHouse == null)) && (this.resourceCreationHouse.IsBuildingInProduction())))
            {
                this.mDirtyIndicator = (this.mDirtyIndicator | DIRTY_INDICATOR.WEAK_MODIFICATION_BIT);
            }
            else
            {
                this.mDirtyIndicator = (this.mDirtyIndicator | DIRTY_INDICATOR.MODIFIED_BIT);
            };
            return (true);
        }

        public function GetNecessaryResourceTypeString():String
        {
            var _local_2:dResource;
            var _local_1:* = "";
            for each (_local_2 in this.GetResourceCreationDefinition().necessaryResources_vector)
            {
                if (_local_1 != "")
                {
                    _local_1 = (_local_1 + "|");
                };
                _local_1 = (_local_1 + ((_local_2.name_string + ",") + _local_2.amount));
            };
            return (_local_1);
        }

        public function SetRemove(_arg_1:Boolean):void
        {
            if (this.removeFlag == _arg_1)
            {
                return;
            };
            this.removeFlag = _arg_1;
            this.mDirtyIndicator = (this.mDirtyIndicator | DIRTY_INDICATOR.MODIFIED_BIT);
        }

        public function GetSettler():cSettler
        {
            return (this.settler);
        }

        public function SetSettler(_arg_1:cSettler):void
        {
            this.settler = _arg_1;
        }

        public function GetResourceTypeString():String
        {
            switch (this.GetResourceCreationDefinition().typeEnumResourceType)
            {
                case RESOURCE_TYPE.CREATED_BY_BUILDING:
                    return ("Created By Building");
                case RESOURCE_TYPE.CREATED_ALWAYS:
                    return ("Created always");
            };
            return ("unknown");
        }

        public function RestoreKIStateBeforeMoving():void
        {
            if (((!(this.settler == null)) && (!(this.settler.mSettlerKi == null))))
            {
                this.settler.mSettlerKi.RestoreKIStateBeforeMoving();
            };
        }

        public function GetPath():cPathObject
        {
            return (this.path);
        }

        public function GetResourceCreationHouse():cBuilding
        {
            return (this.resourceCreationHouse);
        }

        public function SetWorkingSettler():void
        {
            if (this.settler != null)
            {
                this.settler.SetSpriteImage(this.settlerWithoutGoods);
            };
        }


    }
}
