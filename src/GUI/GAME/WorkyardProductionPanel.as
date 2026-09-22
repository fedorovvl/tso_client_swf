package GUI.GAME
{
    import flash.events.EventDispatcher;
    import flash.filters.GlowFilter;
    import GO.cBuilding;
    import GUI.Components.ItemRenderer.WorkyardProductionChainRenderer;
    import Interface.cGeneralInterface;
    import flash.events.MouseEvent;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import GUI.Components.ToolTips.cToolTipUtil;
    import GUI.event.CreateInGameTooltipEvent;
    import ServerState.dResource;
    import GUI.Components.ItemRenderer.ResourceIconRenderer;
    import ServerState.cResources;
    import ServerState.gEconomics;
    import ServerState.dResourceCreationDefinition;
    import ServerState.cResourceCreation;
    import flash.events.Event;
    import mx.events.ToolTipEvent;
    import GO.cDeposit;
    import Skill.cSkill;
    import Modifier.ModifierVO;
    import ServerState.cComputeResourceCreation;
    import SettlerKI.cSettlerKI;
    import GUI.Assets.gAssetManager;

    public class WorkyardProductionPanel extends EventDispatcher 
    {

        private static const GLOW:GlowFilter = new GlowFilter(16441444, 1, 10, 10, 4);

        protected const UPDATE_THRESHOLD:Number = 0.01;

        protected var overallTime:Number = 0;
        protected var building:cBuilding;
        protected var panel:WorkyardProductionChainRenderer;
        protected var generalInterface:cGeneralInterface;
        protected var cycleOverallTime:Number = 0;

        public function WorkyardProductionPanel(_arg_1:cGeneralInterface, _arg_2:cBuilding, _arg_3:WorkyardProductionChainRenderer)
        {
            super();
            this.generalInterface = _arg_1;
            this.building = _arg_2;
            this.panel = _arg_3;
        }

        protected function setRemainingTooltipsOverallTimeAvailable():void
        {
            this.panel.remaining.toolTip = "";
        }

        public function setProductionDetails():void
        {
            this.panel.inputList.removeAllChildren();
            this.panel.outputIcon.clear();
            this.setProductionCycleDetails();
            if (this.building.GetResourceCreation())
            {
                this.panel.workerIcon.active = true;
                this.panel.workerIcon.missing = (!(this.building.GetResourceCreation().GetAssignedSettler()));
            }
            else
            {
                this.panel.workerIcon.active = false;
            };
            if (this.building.GetResourceCreation().isModified())
            {
                this.panel.productionCycleStatus.filters = [GLOW];
            }
            else
            {
                this.panel.productionCycleStatus.filters = [];
            };
            this.displayProductionState();
            this.overallTime = this.building.CalculateWays();
            this.setRemainingTextsAndTooltips();
            this.panel.outputIcon.active = true;
            this.addListeners();
        }

        protected function changeProduction(_arg_1:MouseEvent):void
        {
            _arg_1.stopImmediatePropagation();
            this.dispatchEvent(_arg_1.clone());
        }

        public function getOverallTime():Number
        {
            return (this.overallTime);
        }

        protected function setRemainingTooltipsOverallTimeNotAvailable():void
        {
            if (this.building.IsUpgradeInProgress())
            {
                this.panel.remaining.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "UpgradeInProgress");
            }
            else
            {
                if (this.building.getWorkyardToDepositTime() < 0)
                {
                    this.panel.remaining.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "DepositMissing");
                }
                else
                {
                    this.panel.remaining.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "WarehouseMissing");
                };
            };
        }

        protected function handleRemainingTooltipCreate(_arg_1:CreateInGameTooltipEvent):void
        {
            cToolTipUtil.createToolTip(cToolTipUtil.SIMPLE_string, _arg_1.toolTipEvent);
        }

        protected function setRemainingTexts():void
        {
            if (this.overallTime < 0)
            {
                this.panel.remainingTime.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "NotAvailable");
            }
            else
            {
                this.panel.remainingTime.text = cLocaManager.GetInstance().FormatDuration(this.overallTime, cLocaManager.DURATION_FORMAT_NUMERIC_SHORT);
            };
        }

        protected function setProductionCycleDetails():void
        {
            var _local_3:dResource;
            var _local_4:ResourceIconRenderer;
            var _local_1:cResources = this.generalInterface.mCurrentPlayerZone.GetResources(this.generalInterface.mCurrentPlayer);
            var _local_2:dResourceCreationDefinition = gEconomics.GetResourcesCreationDefinitionForBuilding(this.building.GetBuildingName_string());
            if (_local_2)
            {
                if (_local_2.amountRemoved >= 0)
                {
                    this.panel.outputIcon.resourceName = _local_2.defaultSetting.resourceName_string;
                    if (_local_2.externalResource_string == "")
                    {
                        for each (_local_3 in _local_2.necessaryResources_vector)
                        {
                            _local_4 = new ResourceIconRenderer();
                            _local_4.missing = (((this.building.IsBuildingInfoIconDelayPassed()) && (this.building.GetResourceCreation().GetProductionState() == cResourceCreation.PRODUCTIONSTATE_ERROR_NECESSARY_RESOURCE_MISSING)) && (!(_local_1.HasPlayerResource(_local_3.name_string, (_local_3.amount * this.building.GetResourceInputFactor())))));
                            _local_4.resourceName = _local_3.name_string;
                            this.panel.inputList.addChild(_local_4);
                        };
                    }
                    else
                    {
                        _local_4 = new ResourceIconRenderer();
                        _local_4.missing = ((this.building.IsBuildingInfoIconDelayPassed()) && (this.building.GetResourceCreation().GetProductionState() == cResourceCreation.PRODUCTIONSTATE_ERROR_NECESSARY_RESOURCE_MISSING));
                        _local_4.resourceName = _local_2.externalResourceDeposit_string;
                        this.panel.inputList.addChild(_local_4);
                    };
                }
                else
                {
                    this.panel.outputIcon.resourceName = _local_2.externalResourceDeposit_string;
                    if ((((this.building.GetBuildingName_string().indexOf("Forester") > -1) || (this.building.GetBuildingName_string().indexOf("silo") > -1)) || (this.building.GetBuildingName_string().indexOf("ImprovedSilo") > -1)))
                    {
                        _local_4 = new ResourceIconRenderer();
                        _local_4.resourceName = "Seed";
                        this.panel.inputList.addChild(_local_4);
                    };
                };
            };
        }

        public function removeListeners():void
        {
            if (this.panel != null)
            {
                this.panel.removeEventListener(Event.ENTER_FRAME, this.updateProductionProgress);
                this.panel.productionCycleStatus.removeEventListener(ToolTipEvent.TOOL_TIP_CREATE, this.createProductionTooltipHandler);
                this.panel.btnStartStop.removeEventListener(MouseEvent.CLICK, this.toggleProductionState);
                this.panel.btnChangeProduction.removeEventListener(MouseEvent.CLICK, this.changeProduction);
                this.panel.removeEventListener(CreateInGameTooltipEvent.CREATE_TOOLTIP, this.handleRemainingTooltipCreate);
            };
        }

        protected function setRemainingTextsAndTooltips():void
        {
            this.setRemainingTexts();
            this.setRemainingTooltips();
        }

        public function addListeners():void
        {
            if (this.panel != null)
            {
                this.panel.addEventListener(Event.ENTER_FRAME, this.updateProductionProgress, false, 0, true);
                this.panel.productionCycleStatus.addEventListener(ToolTipEvent.TOOL_TIP_CREATE, this.createProductionTooltipHandler, false, 0, true);
                this.panel.btnStartStop.addEventListener(MouseEvent.CLICK, this.toggleProductionState, false, 0, true);
                this.panel.btnChangeProduction.addEventListener(MouseEvent.CLICK, this.changeProduction, false, 0, true);
                this.panel.addEventListener(CreateInGameTooltipEvent.CREATE_TOOLTIP, this.handleRemainingTooltipCreate, false, 0, true);
            };
        }

        protected function toggleProductionState(_arg_1:MouseEvent):void
        {
            this.building.SetProductionActiveCommand((!(this.building.IsProductionActive())));
            this.displayProductionState();
        }

        protected function setRemainingTooltips():void
        {
            if (this.overallTime < 0)
            {
                this.setRemainingTooltipsOverallTimeNotAvailable();
            }
            else
            {
                this.setRemainingTooltipsOverallTimeAvailable();
            };
        }

        protected function updateProductionProgress(_arg_1:Event):void
        {
            var _local_5:dResourceCreationDefinition;
            var _local_6:Number;
            var _local_7:cDeposit;
            var _local_8:cSkill;
            var _local_9:ModifierVO;
            var _local_10:String;
            var _local_2:Number = -1;
            var _local_3:cResourceCreation = this.building.GetResourceCreation();
            if (_local_3 != null)
            {
                if (!this.building.IsInConstructionMode())
                {
                    _local_5 = _local_3.GetResourceCreationDefinition();
                    if (_local_5 != null)
                    {
                        this.cycleOverallTime = 0;
                        if (_local_3.GetPath() != null)
                        {
                            if (_local_5.externalResource_string != "")
                            {
                                if (_local_3.GetDepositPath() != null)
                                {
                                    this.cycleOverallTime = (this.cycleOverallTime + (_local_3.GetPath().pathLenX10000 / cComputeResourceCreation.SETTLER_WALK_SPEED_INT));
                                    this.cycleOverallTime = (this.cycleOverallTime + (_local_3.GetDepositPath().pathLenX10000 / cComputeResourceCreation.SETTLER_WALK_SPEED_INT));
                                    _local_6 = _local_3.GetWorkTime();
                                    if (_local_3.GetDepositBuildingGridPos() != -1)
                                    {
                                        _local_7 = this.generalInterface.mCurrentPlayerZone.mStreetDataMap.mDepositContainer.get(_local_3.GetDepositBuildingGridPos());
                                        if (_local_7 != null)
                                        {
                                            for each (_local_8 in _local_7.skills.getItems_vector())
                                            {
                                                if (_local_8.getLevel() > 0)
                                                {
                                                    for each (_local_9 in _local_8.getDefinition().level_vector[(_local_8.getLevel() - 1)])
                                                    {
                                                        _local_10 = _local_9.modifier_string.toLowerCase();
                                                        if (_local_10 == "depositspeedup")
                                                        {
                                                            if (_local_9.multiplier == 0)
                                                            {
                                                                _local_6 = 0;
                                                            }
                                                            else
                                                            {
                                                                _local_6 = (_local_6 / _local_9.multiplier);
                                                            };
                                                            _local_6 = (_local_6 + _local_9.adder);
                                                        };
                                                    };
                                                };
                                            };
                                        };
                                    };
                                    _local_6 = (_local_6 * 1000);
                                    this.cycleOverallTime = (this.cycleOverallTime + _local_6);
                                    this.cycleOverallTime = (this.cycleOverallTime + (_local_3.GetDepositPath().pathLenX10000 / cComputeResourceCreation.SETTLER_WALK_SPEED_INT));
                                    this.cycleOverallTime = (this.cycleOverallTime + (_local_3.GetPath().pathLenX10000 / cComputeResourceCreation.SETTLER_WALK_SPEED_INT));
                                    switch (this.building.GetBuildingMode())
                                    {
                                        case cBuilding.BUILDING_MODE_SETTLER_WALKS_FROM_STOREHOUSE_TO_RESOURCECREATIONHOUSE:
                                            _local_2 = (_local_3.pathPos / cComputeResourceCreation.SETTLER_WALK_SPEED_INT);
                                            break;
                                        case cBuilding.BUILDING_MODE_WORKANIM_IS_WORKING_AT_WORKYARD_EXTERNAL_WORKYARD_SYSTEM_ACTIVE:
                                            _local_2 = (_local_3.GetPath().pathLenX10000 / cComputeResourceCreation.SETTLER_WALK_SPEED_INT);
                                            break;
                                        case cBuilding.BUILDING_MODE_SETTLER_WALKS_FROM_RESOURCECREATIONHOUSE_TO_EXTERNAL_RESOURCE:
                                            _local_2 = (_local_3.GetPath().pathLenX10000 / cComputeResourceCreation.SETTLER_WALK_SPEED_INT);
                                            _local_2 = (_local_2 + (_local_3.pathPos / cComputeResourceCreation.SETTLER_WALK_SPEED_INT));
                                            break;
                                        case cBuilding.BUILDING_MODE_WORKANIM_IS_WORKING_AT_EXTERNAL_DEPOSIT:
                                            _local_2 = (_local_3.GetPath().pathLenX10000 / cComputeResourceCreation.SETTLER_WALK_SPEED_INT);
                                            _local_2 = (_local_2 + (_local_3.GetDepositPath().pathLenX10000 / cComputeResourceCreation.SETTLER_WALK_SPEED_INT));
                                            _local_2 = (_local_2 + (this.building.mStartWorkCounter - ((_local_3.GetWorkTime() * 1000) - _local_6)));
                                            break;
                                        case cBuilding.BUILDING_MODE_SETTLER_WALKS_FROM_EXTERNAL_RESOURCE_TO_RESOURCECREATIONHOUSE:
                                            _local_2 = (_local_3.GetPath().pathLenX10000 / cComputeResourceCreation.SETTLER_WALK_SPEED_INT);
                                            _local_2 = (_local_2 + (_local_3.GetDepositPath().pathLenX10000 / cComputeResourceCreation.SETTLER_WALK_SPEED_INT));
                                            _local_2 = (_local_2 + _local_6);
                                            _local_2 = (_local_2 + ((_local_3.pathPos - _local_3.GetDepositPath().pathLenX10000) / cComputeResourceCreation.SETTLER_WALK_SPEED_INT));
                                            break;
                                        case cBuilding.BUILDING_MODE_SETTLER_WALKS_FROM_RESOURCECREATIONHOUSE_TO_STOREHOUSE:
                                            _local_2 = (_local_3.GetPath().pathLenX10000 / cComputeResourceCreation.SETTLER_WALK_SPEED_INT);
                                            _local_2 = (_local_2 + (_local_3.GetDepositPath().pathLenX10000 / cComputeResourceCreation.SETTLER_WALK_SPEED_INT));
                                            _local_2 = (_local_2 + _local_6);
                                            _local_2 = (_local_2 + (_local_3.GetDepositPath().pathLenX10000 / cComputeResourceCreation.SETTLER_WALK_SPEED_INT));
                                            _local_2 = (_local_2 + ((_local_3.pathPos - _local_3.GetPath().pathLenX10000) / cComputeResourceCreation.SETTLER_WALK_SPEED_INT));
                                            break;
                                        default:
                                            _local_2 = -1;
                                    };
                                };
                            }
                            else
                            {
                                this.cycleOverallTime = (this.cycleOverallTime + (_local_3.GetPath().pathLenX10000 / cComputeResourceCreation.SETTLER_WALK_SPEED_INT));
                                this.cycleOverallTime = (this.cycleOverallTime + (_local_3.GetPath().pathLenX10000 / cComputeResourceCreation.SETTLER_WALK_SPEED_INT));
                                this.cycleOverallTime = (this.cycleOverallTime + (_local_3.GetWorkTime() * 1000));
                                this.cycleOverallTime = (this.cycleOverallTime + (_local_3.GetPath().pathLenX10000 / cComputeResourceCreation.SETTLER_WALK_SPEED_INT));
                                this.cycleOverallTime = (this.cycleOverallTime + (_local_3.GetPath().pathLenX10000 / cComputeResourceCreation.SETTLER_WALK_SPEED_INT));
                                switch (this.building.GetBuildingMode())
                                {
                                    case cBuilding.BUILDING_MODE_SETTLER_WALKS_FROM_STOREHOUSE_TO_RESOURCECREATIONHOUSE:
                                        _local_2 = (_local_3.pathPos / cComputeResourceCreation.SETTLER_WALK_SPEED_INT);
                                        break;
                                    case cBuilding.BUILDING_MODE_WORKANIM_IS_WORKING_AT_WORKYARD_LOCAL_WORKYARD_SYSTEM:
                                        _local_2 = (_local_3.GetPath().pathLenX10000 / cComputeResourceCreation.SETTLER_WALK_SPEED_INT);
                                        _local_2 = (_local_2 + this.building.mStartWorkCounter);
                                        break;
                                    case cBuilding.BUILDING_MODE_SETTLER_WALKS_FROM_RESOURCECREATIONHOUSE_TO_STOREHOUSE:
                                        _local_2 = (_local_3.GetPath().pathLenX10000 / cComputeResourceCreation.SETTLER_WALK_SPEED_INT);
                                        _local_2 = (_local_2 + ((_local_3.GetPath().pathLenX20000 / cComputeResourceCreation.SETTLER_WALK_SPEED_INT) + (_local_3.GetWorkTime() * 1000)));
                                        _local_2 = (_local_2 + ((_local_3.pathPos - _local_3.GetPath().pathLenX10000) / cComputeResourceCreation.SETTLER_WALK_SPEED_INT));
                                        break;
                                    default:
                                        _local_2 = -1;
                                };
                            };
                        };
                    };
                };
            };
            this.panel.bonusStar.visible = this.building.GetResourceCreation().isModified();
            if (this.panel.bonusStar.visible)
            {
                this.panel.remainingTimeText.setStyle("color", "#4cf002");
                this.panel.remainingTime.setStyle("color", "#4cf002");
                this.panel.bonusStar.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.TOOLTIP, "BuildingDetailTabProductionWeek", [this.building.GetResourceCreation().GetProductionMultiplierInPercentage().toString()]);
            }
            else
            {
                this.panel.remainingTimeText.setStyle("color", "#ffffff");
                this.panel.remainingTime.setStyle("color", "#ffffff");
            };
            if (((((((((_local_3 == null) || (_local_2 == -1)) || (this.cycleOverallTime == 0)) || (!(this.building.IsProductionActive()))) || (!(_local_3.GetProductionState() == cResourceCreation.PRODUCTIONSTATE_WORKING))) || (!(_local_3.GetAssignedSettler()))) || (_local_3.GetSettlerKIState() == cSettlerKI.SETTLER_STATE_WAITS_BECAUSE_WAREHOUSE_IS_FULL)) || (_local_3.GetSettlerKIState() == cSettlerKI.SETTLER_STATE_WAITS_FOR_POPULATION)))
            {
                this.panel.productionCycleStatus.visible = false;
                this.panel.bonusStar.visible = false;
                return;
            };
            var _local_4:Number = (_local_2 / this.cycleOverallTime);
            if (_local_4 < 0)
            {
                _local_4 = 0;
            };
            if (_local_4 > 1)
            {
                _local_4 = 1;
            };
            if (Math.abs((_local_4 - this.panel.productionCycleStatus.value)) > this.UPDATE_THRESHOLD)
            {
                this.panel.productionCycleStatus.value = _local_4;
            };
            this.panel.productionCycleStatus.visible = true;
        }

        public function destroy():void
        {
            this.removeListeners();
            this.panel = null;
            this.generalInterface = null;
            this.building = null;
        }

        protected function createProductionTooltipHandler(_arg_1:ToolTipEvent):void
        {
            var _local_2:Number = ((this.cycleOverallTime * (1 - this.panel.productionCycleStatus.value)) / this.generalInterface.mGlobalTimeScale);
            cToolTipUtil.createToolTip(cToolTipUtil.PRODUCTION_DURATION, _arg_1, _local_2);
        }

        public function displayProductionState():void
        {
            if (this.building == null)
            {
                return;
            };
            if (((this.building.IsProductionLevelTooLow()) || (this.building.IsProductionActive())))
            {
                this.panel.btnStartStop.setStyle("icon", gAssetManager.GetClass("ButtonIconStop"));
                this.panel.btnStartStop.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "StopProduction");
                this.panel.statusLabel.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "StatusWorking");
                this.panel.statusLabel.setStyle("color", 0xFFFFFF);
            }
            else
            {
                this.panel.btnStartStop.setStyle("icon", gAssetManager.GetClass("ArrowRight"));
                this.panel.btnStartStop.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "RestartProduction");
                this.panel.statusLabel.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "StatusStopped");
                this.panel.statusLabel.setStyle("color", 0xFF0000);
            };
            if (this.building.IsProductionLevelTooLow())
            {
                this.panel.productionPanel.focusEnabled = (this.panel.productionPanel.mouseEnabled = (this.panel.productionPanel.mouseChildren = false));
                this.panel.productionPanel.visible = false;
                this.panel.productionLockLabel.visible = true;
                this.panel.productionLockLabel.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "ProductionStoppedLevelTooLow", [this.building.GetGOContainer().minProductionLevel]);
            }
            else
            {
                this.panel.productionPanel.focusEnabled = (this.panel.productionPanel.mouseEnabled = (this.panel.productionPanel.mouseChildren = true));
                this.panel.productionPanel.visible = true;
                this.panel.productionLockLabel.visible = false;
            };
            if (this.building.IsWaitForCommand())
            {
                this.panel.btnStartStop.enabled = false;
                this.panel.statusLabel.text = "...";
            }
            else
            {
                this.panel.btnStartStop.enabled = true;
            };
        }


    }
}
