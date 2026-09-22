package GO.epicWorkyard
{
    import GO.cBuilding;
    import Communication.VO.epicWorkyard.PositionVO;
    import Interface.cGeneralInterface;
    import ServerState.cResourceCreation;
    import Enums.BUFF_TYPE;
    import BuffSystem.BuffAppliance;
    import Enums.DIRTY_INDICATOR;
    import BuffSystem.cBuff;

    public class EpicWorkyardSubBuilding extends cBuilding 
    {

        private var mEpicWorkyardPosition:PositionVO = null;
        private var masterBuilding:EpicWorkyardMasterBuilding;

        public function EpicWorkyardSubBuilding(_arg_1:cGeneralInterface, _arg_2:int)
        {
            super(_arg_1, _arg_2);
        }

        override public function SetProductionActive(_arg_1:Boolean):void
        {
            SetIsProductionActive(_arg_1);
            mDirtyIndicator.strongModified();
            SetIsWaitForCommand(false);
            if (GetResourceCreation() != null)
            {
                if (!_arg_1)
                {
                    GetResourceCreation().SetProductionState(cResourceCreation.PRODUCTIONSTATE_STOPPED_PRODUCTION);
                }
                else
                {
                    GetResourceCreation().SetProductionState(cResourceCreation.PRODUCTIONSTATE_WORKING);
                };
            };
            if (this.masterBuilding != null)
            {
                this.masterBuilding.updateProductionActive();
            };
            globalFlash.gui.mEpicWorkyardInfoPanel.refreshProductionState();
        }

        override public function getBuildingSelection():cBuilding
        {
            if (this.masterBuilding != null)
            {
                return (this.masterBuilding);
            };
            return (this);
        }

        override public function UpdatedProductionState():void
        {
            if (this.masterBuilding != null)
            {
                this.masterBuilding.UpdatedProductionState();
            };
        }

        public function getMasterBuilding():EpicWorkyardMasterBuilding
        {
            return (this.masterBuilding);
        }

        public function setEpicWorkyardPosition(_arg_1:PositionVO):void
        {
            this.mEpicWorkyardPosition = _arg_1;
        }

        override public function getProductionBuildingName():String
        {
            if (this.masterBuilding != null)
            {
                return (this.masterBuilding.GetBuildingName_string());
            };
            return (super.getProductionBuildingName());
        }

        override public function SetResourceCreation(_arg_1:cResourceCreation):void
        {
            super.SetResourceCreation(_arg_1);
            this.UpdatedProductionState();
        }

        override public function GetStreetGridEntry():int
        {
            if (this.masterBuilding != null)
            {
                return (this.masterBuilding.GetStreetGridEntry());
            };
            return (super.GetStreetGridEntry());
        }

        override public function AddBuff(_arg_1:cBuff, _arg_2:int, _arg_3:int, _arg_4:int):void
        {
            if (_arg_1.GetBuffDefinition().GetBuffType() == BUFF_TYPE.INSTANT)
            {
                return;
            };
            var _local_5:BuffAppliance = new BuffAppliance(this, GetUniqueId(), _arg_1.GetBuffDefinition(), _arg_2, _arg_1.GetResourceName_string(), _arg_4, _arg_1.GetNextTickTime());
            _local_5.SetStartTime(((this.masterBuilding.productionBuff == null) ? mGeneralInterface.GetClientTime() : this.masterBuilding.productionBuff.GetStartTime()));
            if (((productionBuff == null) && ((_local_5.GetBuffDefinition().GetBuffType() == BUFF_TYPE.TIMED) || (_local_5.GetBuffDefinition().GetBuffType() == BUFF_TYPE.ZONE))))
            {
                mBuffs_vector.push(_local_5);
                productionBuff = _local_5;
                _local_5.mDirtyIndicator = (_local_5.mDirtyIndicator | DIRTY_INDICATOR.CREATED_BIT);
            };
        }

        override public function Render():void
        {
            var _local_1:int;
            var _local_2:int;
            var _local_3:int;
            switch (GetBuildingMode())
            {
                case BUILDING_MODE_PLACED:
                case BUILDING_MODE_QUEUED:
                case BUILDING_MODE_SETTLER_WALKS_TO_BUILDING_GROUND_PLACE:
                case BUILDING_MODE_SET_BUILDING_GROUND_PLACE:
                case BUILDING_MODE_CONSTRUCTION:
                case BUILDING_MODE_DESTRUCTION:
                case BUILDING_MODE_EPIC_MONSTER_DYING_EFFECT:
                case BUILDING_DESTRUCTION_READY:
                    return;
                default:
                    _local_1 = -1;
                    if ((((((!(IsUpgradeInProgress())) && (!(GetResourceCreation() == null))) && (!(IsProductionLevelTooLow()))) && (!(IsProductionActive()))) && (cSettingsManager.getInstance().showStoppedProduction)))
                    {
                        _local_1 = cResourceCreation.PRODUCTIONSTATE_STOPPED_PRODUCTION;
                    }
                    else
                    {
                        if (((!(GetResourceCreation() == null)) && (IsProductionActive())))
                        {
                            _local_1 = GetResourceCreation().GetProductionStateIconIndex();
                            switch (_local_1)
                            {
                                case cResourceCreation.PRODUCTIONSTATE_ERROR_WAREHOUSE_FULL:
                                    if (!cSettingsManager.getInstance().showFullWarehouse)
                                    {
                                        _local_1 = -1;
                                    };
                                    break;
                                case cResourceCreation.PRODUCTIONSTATE_ERROR_WAITING_FOR_SETTLER:
                                    if (!cSettingsManager.getInstance().showMissingSettler)
                                    {
                                        _local_1 = -1;
                                    };
                                    break;
                                case cResourceCreation.PRODUCTIONSTATE_ERROR_NECESSARY_RESOURCE_MISSING:
                                    if (!cSettingsManager.getInstance().showMissingResources)
                                    {
                                        _local_1 = -1;
                                    };
                                    break;
                            };
                        };
                    };
                    if (_local_1 > -1)
                    {
                        _local_2 = int((mXNotScaled + mOffsetX));
                        _local_3 = int((mYNotScaled + mOffsetY));
                        if (this.mEpicWorkyardPosition != null)
                        {
                            _local_2 = (_local_2 + this.mEpicWorkyardPosition.getIconX());
                            _local_3 = (_local_3 + this.mEpicWorkyardPosition.getIconY());
                        };
                        gGfxResource.mBuildingInfoIcons.SetSubType(_local_1);
                        gGfxResource.mBuildingInfoIcons.RenderPos(_local_2, ((_local_3 - (global.streetGridY + global.streetGridY)) - mGeneralInterface.mWobblingInt));
                    };
            };
        }

        override public function IsBuffable():Boolean
        {
            return (false);
        }

        public function setMasterBuilding(_arg_1:EpicWorkyardMasterBuilding):void
        {
            this.masterBuilding = _arg_1;
        }

        override public function SetBuildingMode(_arg_1:int):Boolean
        {
            super.SetBuildingMode(_arg_1);
            if (this.masterBuilding != null)
            {
                this.masterBuilding.forceUpdateRenderSmoke();
            };
            return (true);
        }

        public function AddBuff2(_arg_1:BuffAppliance, _arg_2:int, _arg_3:int, _arg_4:int):void
        {
            if (_arg_1.GetBuffDefinition().GetBuffType() == BUFF_TYPE.INSTANT)
            {
                return;
            };
            var _local_5:BuffAppliance = new BuffAppliance(this, GetUniqueId(), _arg_1.GetBuffDefinition(), _arg_2, _arg_1.GetResourceName_string(), _arg_4, _arg_1.GetNextTickTime());
            _local_5.SetStartTime(((this.masterBuilding.productionBuff == null) ? mGeneralInterface.GetClientTime() : this.masterBuilding.productionBuff.GetStartTime()));
            if (((productionBuff == null) && ((_local_5.GetBuffDefinition().GetBuffType() == BUFF_TYPE.TIMED) || (_local_5.GetBuffDefinition().GetBuffType() == BUFF_TYPE.ZONE))))
            {
                mBuffs_vector.push(_local_5);
                productionBuff = _local_5;
                _local_5.mDirtyIndicator = (_local_5.mDirtyIndicator | DIRTY_INDICATOR.CREATED_BIT);
            };
        }


    }
}
