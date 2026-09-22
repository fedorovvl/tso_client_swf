package GUI.GAME
{
    import GO.cBuilding;
    import Interface.cGameInterface;
    import GUI.Components.WarehouseInfoPanel;
    import mx.controls.Alert;
    import mx.events.CloseEvent;
    import mx.events.FlexEvent;
    import GuildSystem.cGuildBank;
    import Communication.VO.dContextItemVO;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import __AS3__.vec.Vector;
    import ServerState.dResource;
    import flash.events.MouseEvent;
    import mx.events.ListEvent;
    import flash.events.Event;
    import ServerState.dResourceDefaultDefinition;
    import ServerState.cResources;
    import ServerState.gEconomics;
    import ServerState.cPlayerData;
    import Enums.RESOURCE_GROUP;
    import GUI.Components.CustomAlert;
    import ServerState.dResourceCreationDefinition;
    import mx.collections.ArrayCollection;
    import mx.events.ItemClickEvent;
    import __AS3__.vec.*;

    public class cWarehouseInfoPanel extends cBasicInfoPanel 
    {

        protected var mBuilding:cBuilding;
        protected var mGI:cGameInterface;
        protected var mPanel:WarehouseInfoPanel;
        protected var mResourceUpdateCounter:int;
        public var mResources:Array = [];


        protected function checkThisIsCurentActivePanel():Boolean
        {
            return (mCurrentActivePanel == this);
        }

        private function RemoveBuilding(_arg_1:CloseEvent):void
        {
            if (_arg_1.detail != Alert.OK)
            {
                return;
            };
            this.mGI.mCurrentPlayerZone.SendDestructBuildingCommand(this.mBuilding, "cWarehouseInfoPanel");
            this.Hide();
        }

        public function Init(_arg_1:WarehouseInfoPanel):void
        {
            this.mGI = (global.ui as cGameInterface);
            globalFlash.gui.windowController.addWindow(_arg_1);
            AddBaseElement(_arg_1);
            this.mPanel = _arg_1;
            this.mResources = [];
            this.mResourceUpdateCounter = 0;
            this.mPanel.addEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
        }

        protected function addDonateMenuEntry(items:Vector.<dContextItemVO>, resource:dResource):void
        {
            if (((cGuildBank.ACTIVATED) || (global.eventDonations.enabledEventDonations[resource.name_string] === true)))
            {
                items.push(new dContextItemVO("DonateResource", function ():void
                {
                    showDonateResourcePanel(resource);
                }, ((global.ui.mEventManager.isEventStarted(global.eventDonations.requiredEventName)) && (resource.amount > 0)), "", [cLocaManager.GetInstance().GetText(LOCA_GROUP.RESOURCES, resource.name_string)]));
            };
        }

        override public function SetData(_arg_1:cBuilding):void
        {
            var _local_2:String = _arg_1.GetBuildingName_string();
            this.mBuilding = _arg_1;
            this.mPanel.label = cLocaManager.GetInstance().GetText(LOCA_GROUP.BUILDINGS, _local_2);
            this.mPanel.buildingHeader.data = this.mBuilding;
            this.mPanel.upgradeColumn.SetData(_arg_1, this, this.mPanel);
            this.mPanel.list.selectedIndex = 0;
            this.SetFilteredResourceList();
        }

        protected function AddHardCurrencyHandler(_arg_1:CloseEvent):void
        {
            if (_arg_1.detail == Alert.OK)
            {
                globalFlash.gui.mShopWindow.AddHardCurrency(null);
            };
        }

        protected function setButtonBarProvider():void
        {
            this.mPanel.warehouseButtonBar.dataProvider = this.getButtonBarProvider();
        }

        private function completeHandler(event:FlexEvent):void
        {
            this.mPanel.removeEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
            this.setButtonBarProvider();
            this.mPanel.btnClose.addEventListener(MouseEvent.CLICK, this.ClosePanel);
            this.mPanel.warehouseButtonBar.addEventListener(ListEvent.ITEM_CLICK, this.SetFilteredResourceList);
            this.mPanel.list.addEventListener(MouseEvent.CLICK, function (_arg_1:MouseEvent):void
            {
                _arg_1.stopImmediatePropagation();
            });
            this.mPanel.list.addEventListener(ListEvent.ITEM_CLICK, this.ShowContextMenu);
        }

        private function ClosePanel(_arg_1:Event):void
        {
            if (!this.checkThisIsCurentActivePanel())
            {
                return;
            };
            this.Hide();
        }

        protected function showFilteredResourcesList(_arg_1:cPlayerData, _arg_2:String):void
        {
            var _local_5:dResourceDefaultDefinition;
            var _local_6:dResource;
            var _local_3:cResources = this.mGI.mCurrentPlayerZone.GetResources(_arg_1);
            var _local_4:Vector.<dResource> = _local_3.GetPlayerResources_vector(_arg_2);
            for each (_local_6 in _local_4)
            {
                _local_5 = gEconomics.mMap_EventResourceDefaultDefinition[_local_6.name_string];
                if (((_local_5 == null) || (global.getApplication().mGameInterface.mEventManager.isEventStarted(_local_5.requiredEventName_string))))
                {
                    this.mResources.push(_local_6.clone());
                };
            };
            this.mPanel.collectionList.visible = false;
            this.mPanel.list.visible = true;
            this.mPanel.list.dataProvider = this.mResources;
            this.mPanel.list.windowID = ((mUiElement.id + ".") + _arg_2);
            this.mPanel.busy = false;
            this.mPanel.productionOverlay.visible = false;
            this.mPanel.collectionList.setStyle("bottom", WarehouseInfoPanel.COLLECTION_LIST_BOTTOM_SIZE);
            this.mPanel.shadowBackgroundCanvas.setStyle("bottom", WarehouseInfoPanel.SHADOW_BACKGROUND_CANVAS_BOTTOM_SIZE);
        }

        protected function getButtonBarProvider():Array
        {
            return ([{
                "label":cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "WarehouseTab1"),
                "group":RESOURCE_GROUP.CL1
            }, {
                "label":cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "WarehouseTab2"),
                "group":RESOURCE_GROUP.CL2
            }, {
                "label":cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "WarehouseTab3"),
                "group":RESOURCE_GROUP.CL3
            }, {
                "label":cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "WarehouseTab4"),
                "group":RESOURCE_GROUP.CL4
            }, {
                "label":cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "WarehouseTab8"),
                "group":RESOURCE_GROUP.CL5
            }, {
                "label":cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "WarehouseTab6"),
                "group":RESOURCE_GROUP.EVENT
            }]);
        }

        private function ConfirmRemoveBuilding(_arg_1:Event):void
        {
            var _local_2:CustomAlert = CustomAlert.show("ConfirmTeardown", "ConfirmTeardown", (Alert.CANCEL | Alert.OK), this.mPanel, this.RemoveBuilding);
            _local_2.addEventListener(CloseEvent.CLOSE, this.RemoveBuilding);
        }

        public function ShowContextMenu(event:ListEvent):void
        {
            var definition:dResourceDefaultDefinition;
            var resourceDefinition:dResourceCreationDefinition;
            var items:Vector.<dContextItemVO>;
            event.stopImmediatePropagation();
            var resource:dResource = (event.itemRenderer.data as dResource);
            definition = gEconomics.GetResourcesDefaultDefinition(resource.name_string);
            if (definition != null)
            {
                resourceDefinition = gEconomics.GetResourcesCreationDefinitionForResource(resource.name_string);
                items = new Vector.<dContextItemVO>();
                if (definition.resourceName_string != defines.POPULATION_RESOURCE_NAME_string)
                {
                    items.push(new dContextItemVO("ProductionOverview", function ():void
                    {
                        globalFlash.gui.ShowEconomy(definition);
                    }, definition.visibleInEconomy));
                };
                this.addDonateMenuEntry(items, resource);
                globalFlash.gui.ShowContextMenu(items, event.itemRenderer.stage.mouseX, event.itemRenderer.stage.mouseY);
            };
        }

        override public function Hide():void
        {
            super.Hide();
        }

        public function get donateResourcePanelController():cDonateResourcePanel
        {
            return (this.mPanel.donateResourcePanel.controller);
        }

        override public function Show():void
        {
            this.mPanel.mayorhouseButtonBar.visible = false;
            this.mPanel.warehouseButtonBar.visible = true;
            this.mPanel.warehouseButtonBar.selectedIndex = 0;
            this.donateResourcePanelController.Hide();
            super.Show();
            this.SetFilteredResourceList(null);
        }

        protected function SetFilteredResourceList(_arg_1:ItemClickEvent=null):void
        {
            if (!this.checkThisIsCurentActivePanel())
            {
                return;
            };
            this.mResources = [];
            var _local_2:cPlayerData = this.mGI.FindPlayerFromId(this.mBuilding.getPlayerID());
            var _local_3:int = ((_arg_1) ? _arg_1.index : 0);
            var _local_4:String = ((this.mPanel.warehouseButtonBar.dataProvider as ArrayCollection).getItemAt(_local_3).group as String);
            if (_local_2 != null)
            {
                this.showFilteredResourcesList(_local_2, _local_4);
            };
            this.mResourceUpdateCounter = 0;
        }

        private function showDonateResourcePanel(_arg_1:dResource):void
        {
            this.mPanel.donateResourcePanel.controller.setData(_arg_1);
            this.mPanel.donateResourcePanel.controller.Show();
        }

        private function updateNormalResources():void
        {
            if (this.mResources.length == 0)
            {
                return;
            };
            if (this.mResourceUpdateCounter >= this.mResources.length)
            {
                this.mResourceUpdateCounter = 0;
            };
            var _local_1:dResource = this.mResources[this.mResourceUpdateCounter];
            var _local_2:cResources = this.mGI.mCurrentPlayerZone.GetResourcesForPlayerID(this.mBuilding.getPlayerID());
            var _local_3:dResource = _local_2.GetPlayerResource(_local_1.name_string);
            if (_local_3 != null)
            {
                _local_1.amount = _local_3.amount;
                _local_1.maxLimit = _local_3.maxLimit;
            };
            this.mResourceUpdateCounter++;
        }

        protected function DisplayShop(_arg_1:Event):void
        {
            if (!this.checkThisIsCurentActivePanel())
            {
                return;
            };
            globalFlash.gui.mShopWindow.ShowDeepLink("Warehouse", -1, 1);
        }

        public function Refresh():void
        {
            if (this.mBuilding)
            {
                this.SetData(this.mBuilding);
            };
        }

        public function UpdateResources():void
        {
            if (!this.checkThisIsCurentActivePanel())
            {
                return;
            };
            this.updateNormalResources();
        }


    }
}
