package ServerState
{
    import Model.Notifier;
    import Interface.cGeneralInterface;
    import nLib.gMisc;
    import Enums.DIRTY_INDICATOR;
    import __AS3__.vec.Vector;
    import GO.cBuilding;
    import BuffSystem.cBuffDefinition;
    import nLib.cLog;
    import Enums.ModifyReason;
    import Communication.VO.dResourceVO;
    import Communication.VO.dResourcesVO;
    import Communication.VO.dBuffVO;
    import Utils.TriggerUtils;
    import Enums.RESOURCE_GROUP;
    import __AS3__.vec.*;

    public class cResources extends Notifier implements IResourceContainer 
    {

        public static const RESOURCE_CHANGE:String = "RESOURCE_CHANGE";
        public static const POPULATION_CHANGE:String = "POPULATION_CHANGE";
        private static const WORKER:int = 0;
        private static const MILITARY:int = 1;

        private var mWorkers:int;
        private var mZoneID:int;
        private var mMilitary:int;
        public var mDirtyIndicator:int;
        private var mMap_ResourceName_Resource:Object = new Object();
        private var mPlayerID:int;
        private var mGeneralInterface:cGeneralInterface;
        private var mFree:int;

        public function cResources(_arg_1:cGeneralInterface, _arg_2:int, _arg_3:int)
        {
            super();
            this.mGeneralInterface = _arg_1;
            this.mZoneID = _arg_2;
            this.mPlayerID = _arg_3;
        }

        private function FreePopulation(_arg_1:int, _arg_2:int):void
        {
            switch (_arg_2)
            {
                case WORKER:
                    this.mWorkers = Math.max(0, (this.mWorkers - _arg_1));
                    break;
                case MILITARY:
                    this.mMilitary = Math.max(0, (this.mMilitary - _arg_1));
                    break;
                default:
                    gMisc.Assert(false, ("Could not interpret population type " + _arg_2));
            };
            var _local_3:dResource = this.GetPlayerResource(defines.POPULATION_RESOURCE_NAME_string);
            this.SetFree(((_local_3.amount - this.mWorkers) - this.mMilitary));
            globalFlash.gui.mInfoBar.SetPopulation(this);
            this.mDirtyIndicator = (this.mDirtyIndicator | DIRTY_INDICATOR.MODIFIED_BIT);
        }

        public function CalculateMaxLimitsForResources(_arg_1:int):void
        {
            var _local_4:dResourceDefaultDefinition;
            var _local_5:int;
            var _local_6:Vector.<cBuilding>;
            var _local_7:int;
            var _local_8:cBuilding;
            var _local_9:dExpandMaxLimit;
            var _local_10:cBuffDefinition;
            var _local_2:dResource;
            var _local_3:int;
            while (_local_3 < gEconomics.mResourceDefaultDefinition_vector.length)
            {
                _local_4 = gEconomics.mResourceDefaultDefinition_vector[_local_3];
                _local_5 = int(_local_4.maxLimit);
                _local_6 = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.GetBuildings_vector();
                _local_7 = 0;
                while (_local_7 < _local_6.length)
                {
                    _local_8 = _local_6[_local_7];
                    if (null != _local_8)
                    {
                        if (_local_8.getPlayerID() == _arg_1)
                        {
                            if (_local_8.IsInUpgradableBuildingMode())
                            {
                                for each (_local_9 in _local_4.expandMaxLimitList_vector)
                                {
                                    if (_local_9.name_string == _local_8.GetBuildingName_string())
                                    {
                                        _local_10 = _local_8.GetUpgradeLevelBonuses();
                                        if (_local_10 == null)
                                        {
                                            gMisc.Assert(false, ((((((("GetUpgradeLevelBonuses() not found for " + _local_8.GetBuildingName_string()) + " (") + _local_8.GetUpgradeLevel()) + ") at ") + _local_8.GetGrid()) + " with GetGOContainer().buildingUpgradeBonuses_vector: ") + _local_8.GetGOContainer().buildingUpgradeBonuses_vector));
                                        };
                                        _local_5 = (_local_5 + (_local_9.amount + _local_10.getGoodsCapacity()));
                                    };
                                };
                            };
                        };
                    };
                    _local_7++;
                };
                _local_2 = this.GetPlayerResource(_local_4.resourceName_string);
                if (_local_2 == null)
                {
                    cLog.warning(("Unable to get resource:" + _local_4.resourceName_string));
                }
                else
                {
                    _local_2.maxLimit = _local_5;
                    if (_local_2.name_string == defines.POPULATION_RESOURCE_NAME_string)
                    {
                        notifyPropertyObserver(POPULATION_CHANGE, null);
                    };
                };
                _local_3++;
            };
            this.mDirtyIndicator = (this.mDirtyIndicator | DIRTY_INDICATOR.MODIFIED_BIT);
        }

        public function RemoveBuildingResourcesFromPlayerResources(_arg_1:String):void
        {
            var _local_2:Vector.<dResource> = global.buildingGroup.GetCostListFromName_vector(_arg_1);
            gMisc.Assert((!(_local_2 == null)), (("Building '" + _arg_1) + "' has no build costs!"));
            this.RemovePlayerResourcesFromResourcesInList(_local_2, 1, ModifyReason.RESOURCE_CREATION);
        }

        public function FreeWorkers(_arg_1:int):void
        {
            this.FreePopulation(_arg_1, WORKER);
        }

        public function GetAssignedPopulation():int
        {
            return (this.mWorkers + this.mMilitary);
        }

        public function GetResources_Vector():Vector.<dResource>
        {
            var _local_2:dResource;
            var _local_1:Vector.<dResource> = new Vector.<dResource>();
            for each (_local_2 in this.mMap_ResourceName_Resource)
            {
                _local_1.push(_local_2.clone());
            };
            return (_local_1);
        }

        public function GetPlayerID():int
        {
            return (this.mPlayerID);
        }

        public function GetZoneID():int
        {
            return (this.mZoneID);
        }

        public function GetWorkers():int
        {
            return (this.mWorkers);
        }

        public function _RemovePlayerResourcesFromResourcesInList(_arg_1:Vector.<dResource>, _arg_2:int, _arg_3:int, _arg_4:Boolean):void
        {
            var _local_5:dResource;
            for each (_local_5 in _arg_1)
            {
                this._AddResource(_local_5.name_string, (-(_local_5.amount) * _arg_2), _arg_3, null, _arg_4);
            };
        }

        public function AssignWorkers(_arg_1:int):Boolean
        {
            return (this.AssignPopulation(_arg_1, WORKER));
        }

        public function HasPlayerResource(_arg_1:String, _arg_2:int):Boolean
        {
            var _local_3:dResource = this.mMap_ResourceName_Resource[_arg_1];
            if (((!(_local_3 == null)) && (_local_3.amount >= _arg_2)))
            {
                return (true);
            };
            return (false);
        }

        public function AddResource(_arg_1:String, _arg_2:int, _arg_3:int, _arg_4:String):Boolean
        {
            return (this._AddResource(_arg_1, _arg_2, _arg_3, _arg_4, false));
        }

        public function RefundBuildingResourcesToPlayerResources(_arg_1:String, _arg_2:cPlayerData):void
        {
            this.RefundPlayerResourcesFromResourcesInListInPercent(this.GetCostsList(_arg_1), global.returnRate, _arg_2, false);
        }

        public function FreeMilitary(_arg_1:int):void
        {
            this.FreePopulation(_arg_1, MILITARY);
        }

        public function AssignMilitary(_arg_1:int):Boolean
        {
            return (this.AssignPopulation(_arg_1, MILITARY));
        }

        public function RemovePlayerResourcesFromResourcesInList(_arg_1:Vector.<dResource>, _arg_2:int, _arg_3:int):void
        {
            this._RemovePlayerResourcesFromResourcesInList(_arg_1, _arg_2, _arg_3, false);
        }

        public function Init(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:Vector.<dResourceVO>):void
        {
            var _local_5:dResourceVO;
            var _local_6:dResource;
            this.mWorkers = _arg_1;
            this.mMilitary = _arg_2;
            this.SetFree(_arg_3);
            for each (_local_5 in _arg_4)
            {
                _local_6 = this.GetPlayerResource(_local_5.name_string);
                _local_6.amount = _local_5.amount;
                _local_6.producedAmount = _local_5.producedAmount;
                notifyPropertyObserver("mMap_ResourceName_Resource", _local_6);
            };
        }

        public function HasPlayerResourcesInListOne(_arg_1:Vector.<dResource>):Boolean
        {
            return (this.HasPlayerResourcesInList(_arg_1, 1));
        }

        public function RefundAllBuildingResourcesToPlayerResources(_arg_1:cBuilding):void
        {
            var _local_3:dResource;
            var _local_4:dResource;
            var _local_2:int = ((this.mGeneralInterface.mIsDefenseMode) ? 100 : global.returnRate);
            for each (_local_3 in this.GetCostsList(_arg_1.GetBuildingName_string()))
            {
                this.SetResource(_local_3.name_string, (this.GetResourceAmount(_local_3.name_string) + ((_local_3.amount * _local_2) / 100)));
            };
            for each (_local_4 in _arg_1.GetArmy().GetTotalUnitResourceCosts())
            {
                this.SetResource(_local_4.name_string, (this.GetResourceAmount(_local_4.name_string) + _local_4.amount));
            };
        }

        public function GetFree():int
        {
            return (this.mFree);
        }

        private function AssignPopulation(_arg_1:int, _arg_2:int):Boolean
        {
            if (this.mFree < _arg_1)
            {
                return (false);
            };
            switch (_arg_2)
            {
                case WORKER:
                    this.mWorkers = (this.mWorkers + _arg_1);
                    break;
                case MILITARY:
                    this.mMilitary = (this.mMilitary + _arg_1);
                    break;
                default:
                    gMisc.Assert(false, ("Could not interpret population type " + _arg_2));
            };
            this.SetFree((this.mFree - _arg_1));
            globalFlash.gui.mInfoBar.SetPopulation(this);
            this.mDirtyIndicator = (this.mDirtyIndicator | DIRTY_INDICATOR.MODIFIED_BIT);
            return (true);
        }

        public function CanPlayerAffordBuilding(_arg_1:String):Boolean
        {
            var _local_2:Vector.<dResource> = global.buildingGroup.GetCostListFromName_vector(_arg_1);
            gMisc.Assert((!(_local_2 == null)), (("Building '" + _arg_1) + "' has no build costs!"));
            return (this.HasPlayerResourcesInListOne(_local_2));
        }

        public function IsMaxLimitOfPopulationReached():Boolean
        {
            var _local_1:dResource = this.GetPlayerResource(defines.POPULATION_RESOURCE_NAME_string);
            return (((this.mWorkers + this.mMilitary) + this.mFree) >= _local_1.maxLimit);
        }

        public function SetFree(_arg_1:int):void
        {
            this.mFree = Math.max(0, _arg_1);
            notifyPropertyObserver(POPULATION_CHANGE, null);
        }

        public function RefundPlayerResourcesFromResourcesInListInPercent(_arg_1:Vector.<dResource>, _arg_2:int, _arg_3:cPlayerData, _arg_4:Boolean):void
        {
            if (_arg_1 == null)
            {
                return;
            };
        }

        public function GetResourceAmount(_arg_1:String):int
        {
            var _local_2:dResource = this.mMap_ResourceName_Resource[_arg_1];
            return (_local_2.amount);
        }

        public function CreateResourcesVO():dResourcesVO
        {
            var _local_2:dResource;
            var _local_3:dResourceVO;
            var _local_1:dResourcesVO = new dResourcesVO();
            _local_1.workers = this.mWorkers;
            _local_1.military = this.mMilitary;
            _local_1.free = this.mFree;
            for each (_local_2 in this.mMap_ResourceName_Resource)
            {
                _local_3 = new dResourceVO();
                _local_3.name_string = _local_2.name_string;
                _local_3.amount = _local_2.amount;
                _local_3.producedAmount = _local_2.producedAmount;
                _local_1.resources_vector.addItem(_local_3);
            };
            return (_local_1);
        }

        public function GetMilitary():int
        {
            return (this.mMilitary);
        }

        public function GetResource(_arg_1:String):dResource
        {
            return (this.mMap_ResourceName_Resource[_arg_1]);
        }

        public function GetPlayerResource(_arg_1:String):dResource
        {
            return (this.mMap_ResourceName_Resource[_arg_1]);
        }

        public function CreateResourceEntries():void
        {
            var _local_1:dResourceDefaultDefinition;
            var _local_2:dResource;
            if (this.mMap_ResourceName_Resource == null)
            {
                this.mMap_ResourceName_Resource = new Object();
            };
            for each (_local_1 in gEconomics.mResourceDefaultDefinition_vector)
            {
                _local_2 = null;
                if (this.mMap_ResourceName_Resource[_local_1.resourceName_string])
                {
                    _local_2 = (this.mMap_ResourceName_Resource[_local_1.resourceName_string] as dResource);
                    _local_2.amount = 0;
                }
                else
                {
                    _local_2 = new dResource();
                    _local_2.name_string = _local_1.resourceName_string;
                    _local_2.group_string = _local_1.group_string;
                    _local_2.amount = 0;
                    _local_2.maxLimit = gMisc.GetMaxIntValue();
                    this.mMap_ResourceName_Resource[_local_2.name_string] = _local_2;
                };
                notifyPropertyObserver("mMap_ResourceName_Resource", _local_2);
            };
        }

        public function GetWareHouseCapacity():int
        {
            var _local_2:dResource;
            var _local_1:int;
            for each (_local_2 in this.mMap_ResourceName_Resource)
            {
                if (((((!(_local_2.name_string == defines.HARD_CURRENCY_RESOURCE_NAME_string)) && (!(_local_2.name_string == defines.POPULATION_RESOURCE_NAME_string))) && (!(_local_2.name_string == defines.DEFENSE_POINT_NAME_string))) && (_local_1 < _local_2.maxLimit)))
                {
                    _local_1 = _local_2.maxLimit;
                };
            };
            return (_local_1);
        }

        public function ModifyMilitaryPopulationResource(_arg_1:int):void
        {
            var _local_2:dResource = this.GetPlayerResource(defines.POPULATION_RESOURCE_NAME_string);
            this.mMilitary = (this.mMilitary + _arg_1);
            if (this.mMilitary < 0)
            {
                this.mMilitary = 0;
            };
            _local_2.amount = ((this.mFree + this.mMilitary) + this.mWorkers);
            if (((_arg_1 > 0) && (_local_2.amount > _local_2.maxLimit)))
            {
                this.SetFree((this.mFree - (_local_2.amount - _local_2.maxLimit)));
                _local_2.amount = ((this.mFree + this.mMilitary) + this.mWorkers);
            };
            notifyPropertyObserver("mMap_ResourceName_Resource", _local_2);
            this.mDirtyIndicator = (this.mDirtyIndicator | DIRTY_INDICATOR.MODIFIED_BIT);
        }

        public function setResources(_arg_1:cResources):void
        {
            var _local_2:String;
            this.mZoneID = _arg_1.mZoneID;
            this.mPlayerID = _arg_1.mPlayerID;
            this.mWorkers = _arg_1.mWorkers;
            this.mMilitary = _arg_1.mMilitary;
            this.mFree = _arg_1.mFree;
            for (_local_2 in _arg_1.mMap_ResourceName_Resource)
            {
                this.mMap_ResourceName_Resource[_local_2] = _arg_1.mMap_ResourceName_Resource[_local_2];
                notifyPropertyObserver("mMap_ResourceName_Resource", _arg_1.mMap_ResourceName_Resource[_local_2]);
            };
        }

        public function AddHardCurrencyResource(_arg_1:dBuffVO):Boolean
        {
            if (((_arg_1.buffName_string == "AddResource") && (_arg_1.resourceName_string == defines.HARD_CURRENCY_RESOURCE_NAME_string)))
            {
                return (this.AddResource(defines.HARD_CURRENCY_RESOURCE_NAME_string, _arg_1.amount, ModifyReason.HARD_CURRENCY_ADD_RESOURCE, null));
            };
            return (false);
        }

        public function HasPlayerResourcesInList(_arg_1:Vector.<dResource>, _arg_2:int):Boolean
        {
            var _local_3:dResource;
            var _local_4:dResource;
            if (_arg_1 == null)
            {
                return (false);
            };
            for each (_local_3 in _arg_1)
            {
                _local_4 = this.mMap_ResourceName_Resource[_local_3.name_string];
                if (_local_4.amount < (_local_3.amount * _arg_2))
                {
                    return (false);
                };
            };
            return (true);
        }

        public function GetCostsList(_arg_1:String):Vector.<dResource>
        {
            var _local_2:Vector.<dResource> = global.buildingGroup.GetCostListFromName_vector(_arg_1);
            if (_local_2 == null)
            {
                return (null);
            };
            return (_local_2);
        }

        public function _AddResource(_arg_1:String, _arg_2:int, _arg_3:int, _arg_4:String, _arg_5:Boolean):Boolean
        {
            var _local_6:dResource = this.mMap_ResourceName_Resource[_arg_1];
            var _local_7:int = _local_6.amount;
            if (_arg_2 > 0)
            {
                if (_local_7 >= _local_6.maxLimit)
                {
                    return (false);
                };
                if ((_local_7 + _arg_2) > _local_6.maxLimit)
                {
                    _arg_2 = (_local_6.maxLimit - _local_7);
                };
                _local_7 = (_local_7 + _arg_2);
                this.mGeneralInterface.mDataTracking.IncTrackingDetail(cDataTracking.DATA_TRACKING_PRODUCED_RESOURCES_OF_TYPE_X, _arg_1, _arg_2);
            }
            else
            {
                if (((_arg_5) && (_local_6.name_string == defines.POPULATION_RESOURCE_NAME_string)))
                {
                    _local_7 = this.GetFree();
                };
                if (_local_7 <= 0)
                {
                    return (false);
                };
                _local_7 = (_local_7 + _arg_2);
                if (_local_7 < 0)
                {
                    _local_7 = 0;
                };
            };
            if (((_arg_5) && (_local_6.name_string == defines.POPULATION_RESOURCE_NAME_string)))
            {
                this.SetFree(_local_7);
            }
            else
            {
                _local_6.amount = _local_7;
                if (_local_6.name_string == defines.POPULATION_RESOURCE_NAME_string)
                {
                    this.SetFree(((_local_6.amount - this.mWorkers) - this.mMilitary));
                };
            };
            this.mDirtyIndicator = (this.mDirtyIndicator | DIRTY_INDICATOR.MODIFIED_BIT);
            notifyPropertyObserver(TriggerUtils.OWN_RESOURCE_PROPERTY_NAME, _local_6);
            var _local_8:dResourceVO = new dResourceVO();
            _local_8.name_string = _local_6.name_string;
            _local_8.amount = _arg_2;
            if (_arg_3 != ModifyReason.TRADE_DELETED)
            {
                notifyPropertyObserver(TriggerUtils.ADD_RESOURCE_NAME, _local_8);
            };
            return (true);
        }

        public function GetAllResourceAmount():int
        {
            var _local_2:dResource;
            var _local_1:int;
            for each (_local_2 in this.mMap_ResourceName_Resource)
            {
                _local_1 = (_local_1 + _local_2.amount);
            };
            return (_local_1);
        }

        public function ApplyResourceListForCheat(_arg_1:dResourcesVO):void
        {
            var _local_2:dResourceVO;
            var _local_3:dResource;
            for each (_local_2 in _arg_1.resources_vector)
            {
                _local_3 = this.GetPlayerResource(_local_2.name_string);
                if (_local_2.amount > _local_3.maxLimit)
                {
                    _local_3.maxLimit = ((_local_2.amount * 110) / 100);
                };
                this.SetResource(_local_3.name_string, _local_2.amount);
            };
            this.mDirtyIndicator = (this.mDirtyIndicator | DIRTY_INDICATOR.MODIFIED_BIT);
        }

        public function GetPlayerResources_vector(_arg_1:String):Vector.<dResource>
        {
            var _local_2:Vector.<dResource>;
            var _local_3:String;
            var _local_4:dResource;
            _local_2 = new Vector.<dResource>();
            for each (_local_3 in global.resourceDefinitions_vector)
            {
                _local_4 = this.mMap_ResourceName_Resource[_local_3];
                if (((_arg_1 == RESOURCE_GROUP.ALL) || (_local_4.group_string == _arg_1)))
                {
                    _local_2.push(_local_4);
                };
            };
            return (_local_2);
        }

        public function SetResource(_arg_1:String, _arg_2:int):Boolean
        {
            var _local_3:Boolean = true;
            var _local_4:dResource = this.mMap_ResourceName_Resource[_arg_1];
            _local_4.amount = _arg_2;
            if (_local_4.amount < 0)
            {
                _local_4.amount = 0;
                _local_3 = false;
            };
            if (_arg_1 == defines.POPULATION_RESOURCE_NAME_string)
            {
                this.SetFree(((_local_4.amount - this.mWorkers) - this.mMilitary));
            };
            this.mDirtyIndicator = (this.mDirtyIndicator | DIRTY_INDICATOR.MODIFIED_BIT);
            notifyPropertyObserver(TriggerUtils.OWN_RESOURCE_PROPERTY_NAME, _local_4);
            return (_local_3);
        }

        override public function toString():String
        {
            return (((((((((((("<cResources zoneID='" + this.mZoneID) + "' playerID='") + this.mPlayerID) + " workers='") + this.mWorkers) + "' military='") + this.mMilitary) + "' free='") + this.mFree) + "' resources='") + this.mMap_ResourceName_Resource) + "' />");
        }


    }
}
