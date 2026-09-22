package GUI.GAME
{
    import GO.cBuilding;
    import Interface.cGameInterface;
    import GUI.Components.BuildingInfoPanel;
    import BuffSystem.BuffAppliance;
    import GUI.Effects.gHintManager;
    import ServerState.cResources;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import ServerState.gEconomics;
    import ServerState.dResourceCreationDefinition;
    import GUI.Components.ItemRenderer.ResourceIconRenderer;
    import mx.events.FlexEvent;
    import flash.events.MouseEvent;
    import mx.events.ItemClickEvent;
    import flash.events.Event;
    import mx.core.UIComponent;
    import ServerState.dResource;
    import GUI.Components.ItemRenderer.ResourceItemRenderer;

    public class cBuildingInfoPanel extends cBasicInfoPanel 
    {

        private var workyardProductionPanel:WorkyardProductionPanel;
        protected var mBuilding:cBuilding;
        private var mGI:cGameInterface;
        protected var mPanel:BuildingInfoPanel;


        override public function Hide():void
        {
            if (this.workyardProductionPanel)
            {
                this.workyardProductionPanel.removeListeners();
            };
            super.Hide();
        }

        override public function SetData(_arg_1:cBuilding):void
        {
            var _local_4:BuffAppliance;
            gHintManager.HideHintsForParent(this.mPanel.buttonBar, true);
            var _local_2:cResources = this.mGI.mCurrentPlayerZone.GetResources(this.mGI.mCurrentPlayer);
            var _local_3:String = _arg_1.GetBuildingName_string();
            this.mBuilding = _arg_1;
            this.mPanel.data = _local_3;
            this.mPanel.label = cLocaManager.GetInstance().GetText(LOCA_GROUP.BUILDINGS, _local_3);
            this.mPanel.buildingHeader.data = this.mBuilding;
            this.mPanel.upgradeColumn.SetData(_arg_1, this, this.mPanel);
            if (this.workyardProductionPanel != null)
            {
                this.workyardProductionPanel.destroy();
                this.workyardProductionPanel = null;
            };
            this.workyardProductionPanel = new WorkyardProductionPanel(this.mGI, this.mBuilding, this.mPanel.workyardProductionChain);
            this.workyardProductionPanel.setProductionDetails();
            var _local_5:dResourceCreationDefinition = gEconomics.GetResourcesCreationDefinitionForBuilding(_local_3);
            if (_local_5)
            {
                if (this.mBuilding.productionBuff != null)
                {
                    _local_4 = this.mBuilding.productionBuff;
                    this.mPanel.workyardProductionChain.outputIcon.buffed = ((_local_4.GetBuffDefinition().getProductivityOutputPercent() < 100) ? ResourceIconRenderer.BUFFED_NEGATIVE : ResourceIconRenderer.BUFFED_POSITIVE);
                }
                else
                {
                    this.mPanel.workyardProductionChain.outputIcon.buffed = ResourceIconRenderer.BUFFED_NONE;
                };
            };
            this.DisplayDetails();
            if (this.mBuilding.GetResourceCreation().isModified())
            {
                this.mPanel.detailsOverallTimeText.setStyle("color", "#4cf002");
                this.mPanel.productionTimeLabel.setStyle("color", "#4cf002");
                this.mPanel.productionTime.setStyle("color", "#4cf002");
                this.mPanel.overallTime.setStyle("color", "#4cf002");
                this.mPanel.bonusStar.visible = true;
                this.mPanel.bonusStar.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.TOOLTIP, "BuildingDetailTabProductionWeek", [this.mBuilding.GetResourceCreation().GetProductionMultiplierInPercentage().toString()]);
                this.mPanel.bonus = this.mBuilding.GetResourceCreation().GetProductionMultiplierInPercentage();
            }
            else
            {
                this.mPanel.detailsOverallTimeText.setStyle("color", "#ffffff");
                this.mPanel.overallTime.setStyle("color", "#ffffff");
                this.mPanel.productionTimeLabel.setStyle("color", "#ffffff");
                this.mPanel.productionTime.setStyle("color", "#ffffff");
                this.mPanel.bonusStar.visible = false;
            };
        }

        public function Init(_arg_1:BuildingInfoPanel):void
        {
            this.mGI = (global.ui as cGameInterface);
            globalFlash.gui.windowController.addWindow(_arg_1);
            AddBaseElement(_arg_1);
            this.mPanel = _arg_1;
            this.mPanel.buttonBar.dataProvider = [{
                "id":"Overview",
                "label":cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "Overview")
            }, {
                "id":"Details",
                "label":cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "Details")
            }];
            this.mPanel.addEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
        }

        private function completeHandler(_arg_1:FlexEvent):void
        {
            this.mPanel.removeEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
            this.mPanel.btnClose.addEventListener(MouseEvent.CLICK, this.ClosePanel);
            this.mPanel.buttonBar.addEventListener(ItemClickEvent.ITEM_CLICK, this.SelectTab);
        }

        private function ClosePanel(_arg_1:Event):void
        {
            this.Hide();
        }

        public function DisplayProductionState(_arg_1:cBuilding):void
        {
            if (((!(_arg_1 == this.mBuilding)) || (!(IsVisible()))))
            {
                return;
            };
            if (this.workyardProductionPanel)
            {
                this.workyardProductionPanel.displayProductionState();
            };
            if (this.mBuilding != null)
            {
                (this.mPanel.buttonBar.getChildAt(1) as UIComponent).visible = (!(this.mBuilding.IsProductionLevelTooLow()));
            };
        }

        private function DisplayDetails():void
        {
            var _local_3:dResource;
            var _local_4:dResource;
            var _local_5:dResource;
            var _local_6:ResourceItemRenderer;
            var _local_7:ResourceIconRenderer;
            var _local_1:Number = this.workyardProductionPanel.getOverallTime();
            this.mPanel.cycleInputList.removeAllChildren();
            this.mPanel.way1.text = ((this.mBuilding.getWarehouseToWorkyardTime() < 0) ? cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "NotAvailable") : cLocaManager.GetInstance().FormatDuration(this.mBuilding.getWarehouseToWorkyardTime()));
            this.mPanel.way2.text = ((this.mBuilding.getWorkyardToDepositTime() < 0) ? cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "NotAvailable") : cLocaManager.GetInstance().FormatDuration(this.mBuilding.getWorkyardToDepositTime()));
            this.mPanel.way3.text = ((this.mBuilding.getWorkyardToDepositTime() < 0) ? cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "NotAvailable") : cLocaManager.GetInstance().FormatDuration(this.mBuilding.getWorkyardToDepositTime()));
            this.mPanel.way4.text = ((this.mBuilding.getWarehouseToWorkyardTime() < 0) ? cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "NotAvailable") : cLocaManager.GetInstance().FormatDuration(this.mBuilding.getWarehouseToWorkyardTime()));
            this.mPanel.productionTime.text = ((this.mBuilding.getProdutionTime() < 0) ? cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "NotAvailable") : cLocaManager.GetInstance().FormatDuration(this.mBuilding.getProdutionTime()));
            this.mPanel.overallTime.text = ((_local_1 < 0) ? cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "NotAvailable") : cLocaManager.GetInstance().FormatDuration(_local_1));
            var _local_2:dResourceCreationDefinition = gEconomics.GetResourcesCreationDefinitionForBuilding(this.mBuilding.GetBuildingName_string());
            if (!_local_2)
            {
                return;
            };
            if (_local_2.externalResource_string == "")
            {
                this.mPanel.arrowWay2.visible = false;
                this.mPanel.arrowWay3.visible = false;
                this.mPanel.labelWay2b.visible = false;
                this.mPanel.labelWay3b.visible = false;
                this.mPanel.labelWay2a.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "DetailsWay2Internal");
                this.mPanel.labelWay3a.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "DetailsWay3Internal");
            }
            else
            {
                this.mPanel.arrowWay2.visible = true;
                this.mPanel.arrowWay3.visible = true;
                this.mPanel.labelWay2b.visible = true;
                this.mPanel.labelWay3b.visible = true;
                this.mPanel.labelWay2a.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "Workyard");
                this.mPanel.labelWay3a.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "DetailsDeposit");
            };
            if (_local_2.amountRemoved >= 0)
            {
                if (_local_2.externalResource_string == "")
                {
                    for each (_local_4 in _local_2.necessaryResources_vector)
                    {
                        _local_5 = new dResource();
                        _local_5.name_string = _local_4.name_string;
                        _local_5.amount = (_local_4.amount * this.mBuilding.GetResourceInputFactor());
                        _local_6 = new ResourceItemRenderer();
                        _local_6.data = _local_5;
                        this.mPanel.cycleInputList.addChild(_local_6);
                    };
                }
                else
                {
                    _local_5 = new dResource();
                    _local_5.name_string = _local_2.externalResourceDeposit_string;
                    _local_5.amount = (_local_2.amountRemoved * this.mBuilding.GetResourceInputFactor());
                    _local_6 = new ResourceItemRenderer();
                    _local_6.data = _local_5;
                    this.mPanel.cycleInputList.addChild(_local_6);
                };
                _local_3 = new dResource();
                _local_3.name_string = _local_2.defaultSetting.resourceName_string;
                _local_3.amount = Math.abs((((_local_2.amountRemoved == 0) ? 1 : _local_2.amountRemoved) * this.mBuilding.GetResourceOutputFactor()));
                this.mPanel.cycleOutput.data = _local_3;
            }
            else
            {
                if ((((this.mBuilding.GetBuildingName_string().indexOf("Forester") > -1) || (this.mBuilding.GetBuildingName_string().indexOf("silo") > -1)) || (this.mBuilding.GetBuildingName_string().indexOf("ImprovedSilo") > -1)))
                {
                    _local_7 = new ResourceIconRenderer();
                    _local_7.resourceName = "Seed";
                    this.mPanel.cycleInputList.addChild(_local_7);
                };
                _local_3 = new dResource();
                _local_3.name_string = _local_2.externalResourceDeposit_string;
                _local_3.amount = Math.abs((_local_2.amountRemoved * this.mBuilding.GetResourceOutputFactor()));
                this.mPanel.cycleOutput.data = _local_3;
            };
        }

        private function SelectTab(_arg_1:ItemClickEvent):void
        {
            this.mPanel.detailsStack.selectedIndex = this.mPanel.buttonBar.selectedIndex;
            if (this.mPanel.buttonBar.selectedIndex == 1)
            {
                this.mGI.mQuestClientCallbacks.InitiateWindowOpen((("GAMESTATE_ID_BUILDING_INFO_PANEL." + this.mBuilding.GetBuildingName_string()) + ".Details"));
                global.getApplication().inputNotifier.notifyClick((("GAMESTATE_ID_BUILDING_INFO_PANEL." + this.mBuilding.GetBuildingName_string()) + ".Details"));
            };
        }

        public function Refresh():void
        {
            if (this.mBuilding)
            {
                this.SetData(this.mBuilding);
            };
        }

        override public function Show():void
        {
            this.mPanel.detailsStack.selectedIndex = 0;
            this.mPanel.buttonBar.selectedIndex = 0;
            super.Show();
            gHintManager.TryRemainingHints();
            this.DisplayProductionState(this.mBuilding);
        }


    }
}
