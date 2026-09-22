package GUI.GAME
{
    import Model.Observer;
    import __AS3__.vec.Vector;
    import GUI.Components.ItemRenderer.CollectionItemRenderer;
    import Communication.VO.collectibles.CollectionVO;
    import Collections.CollectionsManager;
    import GUI.Components.CreateCollectionAlert;
    import Collections.CollectionsConsts;
    import mx.controls.Alert;
    import GUI.Components.CustomAlert;
    import Collections.CollectionEvent;
    import TimedProduction.cTimedProductionQueue;
    import TimedProduction.cTimedProduction;
    import Enums.ONE_CLICK_SHOPITEM;
    import ServerState.cResources;
    import GUI.FloatingItemsManager;
    import Enums.COMMAND;
    import Communication.VO.dBuyOneClickShopItemVO;
    import flash.events.Event;
    import Enums.RESOURCE_GROUP;
    import GUI.Components.WarehouseInfoPanel;
    import Model.Notifier;
    import Communication.VO.collectibles.CollectionResourceVO;
    import ServerState.dResource;
    import Communication.VO.dContextItemVO;
    import mx.events.ListEvent;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import ServerState.cPlayerData;
    import mx.collections.ArrayCollection;
    import mx.events.ItemClickEvent;
    import Communication.VO.dServerAction;
    import Communication.VO.collectibles.CreateCollectionRequestVO;
    import mx.events.CloseEvent;
    import Communication.VO.dTimedProductionVO;
    import __AS3__.vec.*;

    public class cMayorhouseInfoPanel extends cWarehouseInfoPanel implements Observer 
    {

        private const PANEL_WIDTH:int = 515;
        private const UPDATE_COLLECTIONS_FRAMES:int = 20;

        private var collections:Array = [];
        private var collectionMinimumRequiredPlayerLevel:int = 2147483647;
        private var collectionsUpdateCounter:int;
        private var inactiveCollections:Vector.<CollectionItemRenderer>;
        private var currentSelectedCollection:CollectionVO;


        private function retrieveCollections():Array
        {
            return (CollectionsManager.getInstance().getCollectionsAsArray(mGI));
        }

        private function handleCreateCollection(_arg_1:CollectionEvent):void
        {
            this.currentSelectedCollection = (_arg_1.getData() as CollectionItemRenderer).getCollectionVO();
            CreateCollectionAlert.show(CollectionsConsts.COMPLETE_COLLECTION, CollectionsConsts.COMPLETE_COLLECTION, (Alert.OK | Alert.CANCEL), null, this.handleCreateCollectionCommand, null, Alert.OK, true, CustomAlert.STYLE_DEFAULT, this.currentSelectedCollection.GetCosts_vector());
        }

        private function showPanel(_arg_1:int):void
        {
            this.computeCollectionTabVisibility();
            mBuilding.productionQueue.addPropertyObserver(cTimedProductionQueue.PRODUCTION_START, this);
            mBuilding.productionQueue.addPropertyObserver(cTimedProductionQueue.PRODUCTION_FINISH, this);
            super.Show();
            mPanel.mayorhouseButtonBar.visible = true;
            mPanel.warehouseButtonBar.visible = false;
            mPanel.mayorhouseButtonBar.selectedIndex = _arg_1;
        }

        private function handleInstantFinishCollection(_arg_1:Event):void
        {
            if (this.checkSpecifficShopItems())
            {
                _arg_1.preventDefault();
                return;
            };
            var _local_2:cTimedProduction = mBuilding.productionQueue.mTimedProductions_vector[0];
            var _local_3:int = ONE_CLICK_SHOPITEM.INSTANT_COLLECTION_TIMED_PRODUCTION;
            var _local_4:cResources = mGI.mCurrentPlayerZone.GetResources(mGI.mCurrentPlayer);
            if (_local_4.HasPlayerResource(defines.HARD_CURRENCY_RESOURCE_NAME_string, _local_2.GetInstantBuildCosts()))
            {
                FloatingItemsManager.createJumpFlyDestroy(mPanel.productionOverlay.getFrame(), CollectionsConsts.STAR_MENU_DISPLAY_LIST_IDENTIFIER);
                _local_2.SetWaitingForServer(true);
                global.ui.mClientMessages.SendMessagetoServer(COMMAND.BUY_ONE_CLICK_SHOP_ITEM, mGI.mCurrentViewedZoneID, new dBuyOneClickShopItemVO().InitWithBuildingGrid(_local_3, mBuilding.GetGrid()));
            }
            else
            {
                this.showBuyCurrencyPopup();
            };
        }

        private function cleanHide():void
        {
            mBuilding.productionQueue.removePropertyObserver(cTimedProductionQueue.PRODUCTION_START, this);
            mBuilding.productionQueue.removePropertyObserver(cTimedProductionQueue.PRODUCTION_FINISH, this);
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            var _local_4:cTimedProduction = (_arg_3 as cTimedProduction);
            var _local_5:* = mPanel.mayorhouseButtonBar.dataProvider;
            var _local_6:int = mPanel.mayorhouseButtonBar.selectedIndex;
            var _local_7:int = mPanel.productionOverlay.height;
            if (_arg_2 == cTimedProductionQueue.PRODUCTION_START)
            {
                if (_local_5.getItemAt(_local_6).group == RESOURCE_GROUP.COLLECTIONS)
                {
                    mPanel.productionOverlay.visible = true;
                    mPanel.collectionList.setStyle("bottom", ((WarehouseInfoPanel.COLLECTION_LIST_BOTTOM_SIZE + _local_7) + WarehouseInfoPanel.COLLECTION_BOTTOM_OFFSET));
                    mPanel.shadowBackgroundCanvas.setStyle("bottom", ((WarehouseInfoPanel.SHADOW_BACKGROUND_CANVAS_BOTTOM_SIZE + _local_7) + WarehouseInfoPanel.COLLECTION_BOTTOM_OFFSET));
                };
                mPanel.productionOverlay.setOrder(_local_4);
                mPanel.busy = false;
            }
            else
            {
                if (_arg_2 == cTimedProductionQueue.PRODUCTION_FINISH)
                {
                    mPanel.productionOverlay.visible = false;
                    mPanel.busy = false;
                    mPanel.collectionList.setStyle("bottom", WarehouseInfoPanel.COLLECTION_LIST_BOTTOM_SIZE);
                    mPanel.shadowBackgroundCanvas.setStyle("bottom", WarehouseInfoPanel.SHADOW_BACKGROUND_CANVAS_BOTTOM_SIZE);
                };
            };
        }

        private function checkSpecifficShopItems():Boolean
        {
            if (mGI.mSpecificShopItems)
            {
                CustomAlert.show("ShopItemDeactivated", "ShopItemDeactivated");
                return (true);
            };
            return (false);
        }

        private function removeInactiveCollectionAtIndex(_arg_1:int):void
        {
            this.inactiveCollections[_arg_1].setActive(true);
            this.inactiveCollections.splice(_arg_1, 1);
        }

        private function updateCollections(_arg_1:Boolean=false):void
        {
            var _local_2:CollectionResourceVO;
            var _local_3:CollectionVO;
            if (this.collections.length == 0)
            {
                return;
            };
            var _local_4:int = mBuilding.getPlayerID();
            var _local_5:cResources = mGI.mCurrentPlayerZone.GetResourcesForPlayerID(_local_4);
            this.collectionsUpdateCounter++;
            if ((((this.collectionsUpdateCounter >= this.UPDATE_COLLECTIONS_FRAMES) && (mPanel.collectionList.visible == true)) || (_arg_1)))
            {
                for each (_local_3 in this.collections)
                {
                    for each (_local_2 in _local_3.getCollectionResources())
                    {
                        _local_2.setPlayerAmount(_local_5.GetPlayerResource(_local_2.getName()).amount);
                        _local_2.setStorehouseCapacity(_local_5.GetPlayerResource(_local_2.getName()).maxLimit);
                    };
                    _local_3.setActualPlayerLevel(mGI.mCurrentPlayer.GetPlayerLevel());
                    _local_3.updateHardCurrencyPrice(_local_5, mGI);
                    _local_3.setPlayerHardCurrency(_local_5.GetPlayerResource(defines.HARD_CURRENCY_RESOURCE_NAME_string).amount);
                };
                this.collectionsUpdateCounter = 0;
                mPanel.collectionList.update.apply(this, this.collections);
            };
        }

        override protected function setButtonBarProvider():void
        {
            mPanel.mayorhouseButtonBar.dataProvider = this.getButtonBarProvider();
        }

        override public function ShowContextMenu(_arg_1:ListEvent):void
        {
            _arg_1.stopImmediatePropagation();
            var _local_2:dResource = (_arg_1.itemRenderer.data as CollectionResourceVO).getAsDResource();
            var _local_3:Vector.<dContextItemVO> = new Vector.<dContextItemVO>();
            addDonateMenuEntry(_local_3, _local_2);
            globalFlash.gui.ShowContextMenu(_local_3, _arg_1.itemRenderer.stage.mouseX, _arg_1.itemRenderer.stage.mouseY);
        }

        private function showBuyCurrencyPopup():void
        {
            CustomAlert.show("MissingHardCurrency", "", (Alert.OK | Alert.CANCEL), null, AddHardCurrencyHandler, null, Alert.OK, true, CustomAlert.STYLE_PAYMENT);
        }

        override protected function getButtonBarProvider():Array
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
            }, {
                "label":cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, CollectionsConsts.WAREHOUSE_COLLECTIONS_TAB_LOCA_NAME),
                "group":RESOURCE_GROUP.COLLECTIONS
            }]);
        }

        override public function Show():void
        {
            this.showPanel(0);
        }

        public function showCollectiblesTab():void
        {
            this.showPanel(6);
            this.showCollectionsList(RESOURCE_GROUP.COLLECTIONS);
        }

        override public function Hide():void
        {
            this.cleanHide();
            super.Hide();
        }

        private function addInactiveCollection(_arg_1:CollectionEvent):void
        {
            var _local_2:CollectionItemRenderer = (_arg_1.getData() as CollectionItemRenderer);
            var _local_3:CollectionVO = _local_2.getCollectionVO();
            _local_2.setActive(false);
            _local_2.building = mBuilding;
            this.inactiveCollections.push(_local_2);
            this.currentSelectedCollection = _local_3;
        }

        override protected function SetFilteredResourceList(_arg_1:ItemClickEvent=null):void
        {
            if (!checkThisIsCurentActivePanel())
            {
                return;
            };
            this.collections = [];
            mResources = [];
            var _local_2:cPlayerData = mGI.FindPlayerFromId(mBuilding.getPlayerID());
            var _local_3:int = ((_arg_1) ? _arg_1.index : 0);
            var _local_4:String = ((mPanel.mayorhouseButtonBar.dataProvider as ArrayCollection).getItemAt(_local_3).group as String);
            if (_local_2 != null)
            {
                if (_local_4 == RESOURCE_GROUP.COLLECTIONS)
                {
                    this.showCollectionsList(_local_4);
                }
                else
                {
                    showFilteredResourcesList(_local_2, _local_4);
                };
            };
            mResourceUpdateCounter = 0;
        }

        override protected function HideWithoutQueue():void
        {
            this.cleanHide();
            super.HideWithoutQueue();
        }

        private function initCollectionsRequirements():void
        {
            var _local_1:CollectionVO;
            if (this.collections.length == 0)
            {
                this.collections = this.retrieveCollections();
            };
            for each (_local_1 in this.collections)
            {
                if (_local_1.getRequiredPlayerLevel() < this.collectionMinimumRequiredPlayerLevel)
                {
                    this.collectionMinimumRequiredPlayerLevel = _local_1.getRequiredPlayerLevel();
                };
            };
        }

        private function showCollectionsList(_arg_1:String):void
        {
            var _local_3:cTimedProduction;
            this.collections = this.retrieveCollections();
            mPanel.collectionList.dataProvider = this.retrieveListDataProvider(this.collections);
            mPanel.collectionList.windowID = ((mPanel.id + ".") + _arg_1);
            mPanel.list.visible = false;
            mPanel.collectionList.visible = true;
            var _local_2:int = mPanel.productionOverlay.height;
            this.updateCollections(true);
            if (((!(mBuilding.productionQueue == null)) && (mBuilding.productionQueue.mTimedProductions_vector.length > 0)))
            {
                _local_3 = mBuilding.productionQueue.mTimedProductions_vector[0];
                mPanel.busy = false;
                mPanel.productionOverlay.visible = true;
                mPanel.collectionList.setStyle("bottom", ((WarehouseInfoPanel.COLLECTION_LIST_BOTTOM_SIZE + _local_2) + WarehouseInfoPanel.COLLECTION_BOTTOM_OFFSET));
                mPanel.shadowBackgroundCanvas.setStyle("bottom", ((WarehouseInfoPanel.SHADOW_BACKGROUND_CANVAS_BOTTOM_SIZE + _local_2) + WarehouseInfoPanel.COLLECTION_BOTTOM_OFFSET));
                mPanel.productionOverlay.setOrder(_local_3);
                mPanel.busyAnim.visible = false;
            }
            else
            {
                mPanel.busy = mBuilding.productionQueue.GetWaitingForServer();
                mPanel.productionOverlay.visible = false;
                mPanel.collectionList.setStyle("bottom", WarehouseInfoPanel.COLLECTION_LIST_BOTTOM_SIZE);
                mPanel.shadowBackgroundCanvas.setStyle("bottom", WarehouseInfoPanel.SHADOW_BACKGROUND_CANVAS_BOTTOM_SIZE);
            };
        }

        private function handleBuyCollectionCommand(_arg_1:CloseEvent):void
        {
            if (((!(_arg_1.detail == Alert.OK)) || (this.currentSelectedCollection == null)))
            {
                this.removeInactiveCollectionAtIndex((this.inactiveCollections.length - 1));
                return;
            };
            var _local_2:dServerAction = new dServerAction();
            var _local_3:CreateCollectionRequestVO = new CreateCollectionRequestVO();
            _local_3.collectionId = this.currentSelectedCollection.getName();
            _local_2.data = _local_3;
            mGI.mClientMessages.SendMessagetoServer(COMMAND.CREATE_COLLECTION, mGI.mCurrentViewedZoneID, _local_2);
            var _local_4:int;
            while (_local_4 < this.inactiveCollections.length)
            {
                if (this.inactiveCollections[_local_4].getCollectionVO().getName() == this.currentSelectedCollection.getName())
                {
                    FloatingItemsManager.createJumpFlyDestroy(this.inactiveCollections[_local_4].getFrame(), CollectionsConsts.STAR_MENU_DISPLAY_LIST_IDENTIFIER);
                    break;
                };
                _local_4++;
            };
            this.currentSelectedCollection = null;
        }

        override public function Init(_arg_1:WarehouseInfoPanel):void
        {
            super.Init(_arg_1);
            this.collections = [];
            this.inactiveCollections = new Vector.<CollectionItemRenderer>();
            this.initCollectionsRequirements();
            mPanel.mayorhouseButtonBar.addEventListener(ListEvent.ITEM_CLICK, this.SetFilteredResourceList, false, 0, true);
            mPanel.collectionList.addEventListener(CollectionEvent.COLLECTION_RESOURCE_CLICKED, this.ShowContextMenu, false, 0, true);
            mPanel.collectionList.addEventListener(CollectionEvent.CREATE_COLLECTION, this.handleCreateCollection, false, 0, true);
            mPanel.collectionList.addEventListener(CollectionEvent.BUY_COLLECTION, this.handleBuyCollection, false, 0, true);
            mPanel.productionOverlay.addEventListener(CollectionEvent.INSTANT_FINISH_COLLECTION, this.handleInstantFinishCollection, false, 0, true);
            mPanel.productionOverlay.addEventListener(CollectionEvent.PICK_UP_COLLECTION, this.handlePickUpCollection, false, 0, true);
        }

        public function activateCollection(_arg_1:String):void
        {
            var _local_2:int;
            var _local_3:int;
            var _local_4:CollectionItemRenderer;
            var _local_5:Boolean = true;
            while (_local_5)
            {
                _local_5 = false;
                _local_3 = this.inactiveCollections.length;
                _local_2 = 0;
                while (_local_2 < _local_3)
                {
                    if (this.inactiveCollections[_local_2].getCollectionVO().getName() == _arg_1)
                    {
                        _local_4 = this.inactiveCollections[_local_2];
                        _local_4.building = mBuilding;
                        this.removeInactiveCollectionAtIndex(_local_2);
                        _local_5 = true;
                        break;
                    };
                    _local_2++;
                };
            };
        }

        private function computeCollectionTabVisibility():void
        {
            var _local_5:int;
            var _local_1:* = (mGI.mCurrentPlayer.GetPlayerLevel() >= this.collectionMinimumRequiredPlayerLevel);
            var _local_2:ArrayCollection = ArrayCollection(mPanel.mayorhouseButtonBar.dataProvider);
            var _local_3:int = _local_2.length;
            var _local_4:int = (_local_3 - ((_local_1) ? 0 : 1));
            _local_5 = (_local_3 - 1);
            while (_local_5 >= 0)
            {
                if (_local_2[_local_5].group == RESOURCE_GROUP.COLLECTIONS)
                {
                    mPanel.mayorhouseButtonBar.getChildAt(_local_5).visible = _local_1;
                };
                _local_5--;
            };
            mPanel.mayorhouseButtonBar.setStyle("buttonWidth", (this.PANEL_WIDTH / _local_4));
        }

        private function handleBuyCollection(_arg_1:CollectionEvent):void
        {
            if (this.checkSpecifficShopItems())
            {
                return;
            };
            this.addInactiveCollection(_arg_1);
            var _local_2:cResources = mGI.mCurrentPlayerZone.GetResources(mGI.mCurrentPlayer);
            if (_local_2.HasPlayerResource(defines.HARD_CURRENCY_RESOURCE_NAME_string, this.currentSelectedCollection.getHardCurrency()))
            {
                CustomAlert.show(CollectionsConsts.BUY_COLLECTIBLE_COMPONENTS, CollectionsConsts.BUY_COLLECTIBLE_COMPONENTS, (Alert.OK | Alert.CANCEL), null, this.handleBuyCollectionCommand, null, Alert.OK, true, CustomAlert.STYLE_DEFAULT, CollectionVO.retrieveInstantCollectionCosts(this.currentSelectedCollection));
            }
            else
            {
                this.removeInactiveCollectionAtIndex((this.inactiveCollections.length - 1));
                this.showBuyCurrencyPopup();
            };
        }

        private function retrieveListDataProvider(_arg_1:Array):Array
        {
            var _local_3:CollectionVO;
            var _local_2:Array = [];
            for each (_local_3 in _arg_1)
            {
                _local_2.push([_local_3, mBuilding]);
            };
            return (_local_2);
        }

        private function handleCreateCollectionCommand(_arg_1:CloseEvent):void
        {
            if (((!(_arg_1.detail == Alert.OK)) || (this.currentSelectedCollection == null)))
            {
                this.currentSelectedCollection = null;
                return;
            };
            var _local_2:dTimedProductionVO = new dTimedProductionVO();
            _local_2.productionType = mBuilding.productionQueue.mProductionType;
            _local_2.type_string = this.currentSelectedCollection.getName();
            _local_2.amount = 1;
            _local_2.buildingGrid = mBuilding.GetGrid();
            mGI.mClientMessages.SendMessagetoServer(COMMAND.START_TIMED_PRODUCTION, mGI.mCurrentViewedZoneID, _local_2);
            mPanel.busy = true;
            mBuilding.productionQueue.SetWaitingForServer(true);
        }

        private function handlePickUpCollection(_arg_1:Event):void
        {
            FloatingItemsManager.createJumpFlyDestroy(mPanel.productionOverlay.getFrame(), CollectionsConsts.STAR_MENU_DISPLAY_LIST_IDENTIFIER);
            var _local_2:cTimedProduction = mBuilding.productionQueue.mTimedProductions_vector[0];
            _local_2.SetWaitingForServer(true);
            mGI.mClientMessages.SendMessagetoServer(COMMAND.DELIVER_PRODUCTION, mGI.mCurrentViewedZoneID, mBuilding.productionType);
        }

        override public function UpdateResources():void
        {
            if (!checkThisIsCurentActivePanel())
            {
                return;
            };
            super.UpdateResources();
            this.updateCollections();
        }


    }
}
