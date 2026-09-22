package GUI.GAME
{
    import GO.cBuilding;
    import Interface.cGameInterface;
    import GUI.Components.GenericLinkBuildingInfoPanel;
    import ServerState.dExpandMaxLimit;
    import BuffSystem.cBuffDefinition;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import GUI.Assets.gAssetManager;
    import flash.events.MouseEvent;
    import ServerState.dResource;
    import ServerState.gEconomics;
    import ServerState.dResourceDefaultDefinition;
    import nLib.gMisc;
    import mx.events.FlexEvent;
    import flash.events.Event;

    public class cGenericLinkBuildingInfoPanel extends cBasicInfoPanel 
    {

        protected var mBuilding:cBuilding;
        private var mGI:cGameInterface;
        protected var mPanel:GenericLinkBuildingInfoPanel;


        override public function Show():void
        {
            super.Show();
        }

        override public function Hide():void
        {
            super.Hide();
        }

        override public function SetData(_arg_1:cBuilding):void
        {
            var _local_5:dExpandMaxLimit;
            var _local_6:cBuffDefinition;
            var _local_2:String = _arg_1.GetBuildingName_string();
            this.mBuilding = _arg_1;
            this.mPanel.label = cLocaManager.GetInstance().GetText(LOCA_GROUP.BUILDINGS, _local_2);
            this.mPanel.buildingHeader.description.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.DESCRIPTIONS, _local_2);
            this.mPanel.buildingHeader.image.source = gAssetManager.GetBuildingIcon(_local_2);
            this.mPanel.upgradeColumn.SetData(_arg_1, this, this.mPanel);
            if (this.mBuilding.IsRecurringBuilding())
            {
                this.mPanel.buildingHeader.payshopItemIndicator.visible = true;
            }
            else
            {
                this.mPanel.buildingHeader.payshopItemIndicator.visible = false;
            };
            this.mPanel.linkLabel.text = cLocaManager.GetInstance().getLabel(((this.mBuilding.GetInfoPanelShortcut() + "_") + this.mBuilding.GetInfoPanelShortcutItem()));
            this.mPanel.btnLink.addEventListener(MouseEvent.CLICK, this.linkClickHandler);
            var _local_3:dResource = new dResource();
            _local_3.name_string = defines.POPULATION_RESOURCE_NAME_string;
            var _local_4:dResourceDefaultDefinition = gEconomics.GetResourcesDefaultDefinition(defines.POPULATION_RESOURCE_NAME_string);
            for each (_local_5 in _local_4.expandMaxLimitList_vector)
            {
                if (_local_5.name_string == this.mBuilding.GetBuildingName_string())
                {
                    _local_3.amount = (_local_3.amount + _local_5.amount);
                };
            };
            _local_6 = this.mBuilding.GetUpgradeLevelBonuses();
            if (_local_6 == null)
            {
                gMisc.Assert(false, ((((((("GetUpgradeLevelBonuses() not found for " + this.mBuilding.GetBuildingName_string()) + " (") + this.mBuilding.GetUpgradeLevel()) + ") at ") + this.mBuilding.GetGrid()) + " with GetGOContainer().buildingUpgradeBonuses_vector: ") + this.mBuilding.GetGOContainer().buildingUpgradeBonuses_vector));
            };
            _local_3.amount = (_local_3.amount + _local_6.getGoodsCapacity());
            this.mPanel.population.data = _local_3;
            this.mPanel.population.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "PopulationIncreased");
            if (this.mBuilding.IsBuildingOfType(cBuilding.PVP_PROGRESSION_BUILDING_string))
            {
                this.mPanel.btnLink.setStyle("icon", gAssetManager.GetClass("IconValorPoints"));
            }
            else
            {
                this.mPanel.btnLink.setStyle("icon", gAssetManager.GetClass("StripedEgg"));
            };
        }

        public function Init(_arg_1:GenericLinkBuildingInfoPanel):void
        {
            this.mGI = (global.ui as cGameInterface);
            globalFlash.gui.windowController.addWindow(_arg_1);
            AddBaseElement(_arg_1);
            this.mPanel = _arg_1;
            this.mPanel.addEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
        }

        private function completeHandler(_arg_1:FlexEvent):void
        {
            this.mPanel.removeEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
            this.mPanel.btnClose.addEventListener(MouseEvent.CLICK, this.ClosePanel);
        }

        private function ClosePanel(_arg_1:Event):void
        {
            this.Hide();
        }

        public function Refresh():void
        {
            if (this.mBuilding)
            {
                this.SetData(this.mBuilding);
            };
        }

        protected function linkClickHandler(_arg_1:MouseEvent):void
        {
            globalFlash.gui.OpenWindow(this.mBuilding.GetInfoPanelShortcut(), this.mBuilding.GetInfoPanelShortcutItem());
        }


    }
}
