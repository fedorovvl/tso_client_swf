package GUI.GAME
{
    import GUI.Components.ItemRenderer.EpicWorkyardResourceItemRenderer;
    import Interface.cGeneralInterface;
    import GO.cBuilding;
    import GUI.Components.ItemRenderer.WorkyardProductionChainRenderer;
    import GUI.Components.ToolTips.cToolTipUtil;
    import GUI.event.CreateInGameTooltipEvent;
    import GUI.helpers.MovieClipHelpers;
    import ServerState.dResourceCreationDefinition;
    import GUI.Components.ItemRenderer.ResourceIconRenderer;
    import mx.controls.Label;
    import ServerState.dResource;
    import ServerState.cResources;
    import ServerState.gEconomics;
    import ServerState.cResourceCreation;
    import flash.events.Event;

    public class EpicWorkyardProductionPanel extends WorkyardProductionPanel 
    {

        private var outputResourceItem:EpicWorkyardResourceItemRenderer;

        public function EpicWorkyardProductionPanel(_arg_1:cGeneralInterface, _arg_2:cBuilding, _arg_3:WorkyardProductionChainRenderer)
        {
            super(_arg_1, _arg_2, _arg_3);
        }

        override protected function handleRemainingTooltipCreate(_arg_1:CreateInGameTooltipEvent):void
        {
            cToolTipUtil.createToolTip(cToolTipUtil.EPIC_WORKYARD_DETAILS_string, _arg_1.toolTipEvent, building);
        }

        override protected function setRemainingTooltipsOverallTimeAvailable():void
        {
            panel.remaining.toolTip = "EpicWorkyardDetails";
        }

        override public function setProductionDetails():void
        {
            super.setProductionDetails();
            panel.workerIcon.missing = false;
        }

        override public function destroy():void
        {
            super.destroy();
            MovieClipHelpers.removeFromParent(this.outputResourceItem);
        }

        public function setBuffed(_arg_1:int):void
        {
            if (this.outputResourceItem != null)
            {
                this.outputResourceItem.setBuffed(_arg_1);
            };
        }

        override protected function setProductionCycleDetails():void
        {
            var _local_2:dResourceCreationDefinition;
            var _local_4:ResourceIconRenderer;
            var _local_5:Label;
            var _local_6:dResource;
            var _local_1:cResources = generalInterface.mCurrentPlayerZone.GetResources(generalInterface.mCurrentPlayer);
            _local_2 = gEconomics.GetResourcesCreationDefinitionForBuilding(building.GetBuildingName_string());
            var _local_3:dResource = new dResource();
            MovieClipHelpers.removeFromParent(panel.outputIcon);
            if (this.outputResourceItem == null)
            {
                this.outputResourceItem = new EpicWorkyardResourceItemRenderer();
                panel.productionCycleListBox.addChild(this.outputResourceItem);
            };
            if (_local_2)
            {
                if (_local_2.amountRemoved >= 0)
                {
                    _local_3 = new dResource();
                    _local_3.name_string = _local_2.defaultSetting.resourceName_string;
                    _local_3.amount = Math.abs((((_local_2.amountRemoved == 0) ? 1 : _local_2.amountRemoved) * building.GetResourceOutputFactor()));
                    this.outputResourceItem.data = _local_3;
                    if (_local_2.externalResource_string == "")
                    {
                        for each (_local_6 in _local_2.necessaryResources_vector)
                        {
                            _local_4 = new ResourceIconRenderer();
                            _local_4.missing = (((building.IsBuildingInfoIconDelayPassed()) && (building.GetResourceCreation().GetProductionState() == cResourceCreation.PRODUCTIONSTATE_ERROR_NECESSARY_RESOURCE_MISSING)) && (!(_local_1.HasPlayerResource(_local_6.name_string, (_local_6.amount * building.GetResourceInputFactor())))));
                            _local_4.resourceName = _local_6.name_string;
                            panel.inputList.addChild(_local_4);
                            _local_5 = new Label();
                            _local_5.text = (_local_6.amount * building.GetResourceInputFactor()).toFixed();
                            panel.inputList.addChild(_local_5);
                        };
                    }
                    else
                    {
                        _local_4 = new ResourceIconRenderer();
                        _local_4.missing = ((building.IsBuildingInfoIconDelayPassed()) && (building.GetResourceCreation().GetProductionState() == cResourceCreation.PRODUCTIONSTATE_ERROR_NECESSARY_RESOURCE_MISSING));
                        _local_4.resourceName = ("Deposit" + _local_2.externalResource_string);
                        panel.inputList.addChild(_local_4);
                    };
                }
                else
                {
                    _local_3 = new dResource();
                    _local_3.name_string = ("Deposit" + _local_2.externalResource_string);
                    _local_3.amount = Math.abs((_local_2.amountRemoved * building.GetResourceOutputFactor()));
                    this.outputResourceItem.data = _local_3;
                    _local_4 = new ResourceIconRenderer();
                    _local_4.resourceName = "Seed";
                    panel.inputList.addChild(_local_4);
                };
            };
        }

        override protected function updateProductionProgress(_arg_1:Event):void
        {
            super.updateProductionProgress(_arg_1);
            panel.workerIcon.missing = (!(building.GetResourceCreation().GetAssignedSettler()));
        }


    }
}
