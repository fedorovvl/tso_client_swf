package GUI.GAME
{
    import ServerState.dResource;
    import Interface.cGameInterface;
    import GUI.Components.EconomyOverview;
    import GO.cBuilding;
    import GUI.Loca.cLocaManager;
    import ServerState.dResourceDefaultDefinition;
    import __AS3__.vec.Vector;
    import GUI.Components.ItemRenderer.TreeNodeRenderer;
    import flash.utils.Dictionary;
    import ServerState.dEconomyOverviewDataResult;
    import ServerState.cEconomyOverviewData;
    import ServerState.gEconomics;
    import GUI.Effects.gHintManager;
    import flash.events.MouseEvent;
    import mx.events.FlexEvent;
    import Enums.COMMAND;
    import Enums.LOCA_GROUP;
    import mx.events.ListEvent;
    import mx.events.ItemClickEvent;
    import mx.controls.Image;
    import mx.containers.HBox;
    import GUI.Assets.gAssetManager;
    import ServerState.dResourceCreationDefinition;
    import __AS3__.vec.*;

    public class cEconomyOverview extends cBasicPanel 
    {

        private const ONE_HOUR_SEC:int = 3600;
        private const TREE_LEFT_SIDE_LIMIT:int = 90;
        private const TREE_RIGHT_SIDE_LIMIT:int = 488;

        public var mSelectedTreeNode:dResource;
        private var mGI:cGameInterface;
        private var mPanel:EconomyOverview;
        private var mSelectedConsumptionBuilding:cBuilding;
        private var mLM:cLocaManager = cLocaManager.GetInstance();
        private var mSelectedProductionBuilding:cBuilding;
        private var mSelectedResource:dResourceDefaultDefinition;
        private var mTreeNodes_vector:Vector.<TreeNodeRenderer>;
        public var mResourceProductionData:Dictionary;


        private function SetData():void
        {
            var _local_3:dResourceDefaultDefinition;
            var _local_4:Array;
            var _local_5:dEconomyOverviewDataResult;
            var _local_1:cEconomyOverviewData = new cEconomyOverviewData();
            if (this.mResourceProductionData)
            {
                this.mResourceProductionData = null;
            };
            this.mResourceProductionData = new Dictionary();
            var _local_2:Array = gEconomics.GetResourcesDefaultDefinition_vector("ALL");
            for each (_local_3 in _local_2)
            {
                if (_local_3.visibleInEconomy != false)
                {
                    _local_5 = _local_1.GetResourceProductionAndConsumptionValues(null, _local_3.resourceName_string);
                    this.mResourceProductionData[_local_3.resourceName_string] = (_local_5.mBuffedProductionValue - _local_5.mConsumptionValue);
                };
            };
            _local_4 = [];
            _local_4.push({
                "groupId":"BuildingMaterials",
                "data":gEconomics.GetResourcesDefaultDefinition_vector("BuildingMaterials")
            });
            _local_4.push({
                "groupId":"Food",
                "data":gEconomics.GetResourcesDefaultDefinition_vector("Food")
            });
            _local_4.push({
                "groupId":"Weapons",
                "data":gEconomics.GetResourcesDefaultDefinition_vector("Weapons")
            });
            _local_4.push({
                "groupId":"Science",
                "data":gEconomics.GetResourcesDefaultDefinition_vector("Science")
            });
            _local_4.push({
                "groupId":"Intermediates",
                "data":gEconomics.GetResourcesDefaultDefinition_vector("Intermediates", true)
            });
            this.mPanel.list.dataProvider = _local_4;
            gHintManager.TryRemainingHints();
        }

        private function CloseDetailView(_arg_1:MouseEvent):void
        {
            gHintManager.HideHintsForParent(this.mPanel.consumptionList, true);
            gHintManager.HideHintsForParent(this.mPanel.productionList, true);
            this.mPanel.currentState = "treeView";
            this.mPanel.productionSubListPanel.visible = false;
            this.mPanel.consumptionSubListPanel.visible = false;
        }

        private function ClosePanel(_arg_1:MouseEvent):void
        {
            this.Hide();
        }

        private function EnterTreeViewState(_arg_1:FlexEvent):void
        {
            this.RefreshTree();
            gHintManager.TryRemainingHints();
        }

        private function GetRightMostNodePosition(_arg_1:Vector.<TreeNodeRenderer>):int
        {
            var _local_2:int = _arg_1[0].x;
            var _local_3:int;
            while (_local_3 < _arg_1.length)
            {
                if (_arg_1[_local_3].x > _local_2)
                {
                    _local_2 = _arg_1[_local_3].x;
                };
                _local_3++;
            };
            return (_local_2);
        }

        override public function Show():void
        {
            this.mGI.mCurrentCursor.SetCursorEditMode(COMMAND.SELECT_BUILDING);
            this.SetData();
            super.Show();
            globalFlash.gui.windowController.setTop(this.mPanel, true);
        }

        private function TreeNodeClickHandler(_arg_1:MouseEvent):void
        {
            this.mSelectedTreeNode = (_arg_1.currentTarget.data.resource as dResource);
            gHintManager.HideHintsForParent(this.mPanel.treeSprite, true);
            this.mPanel.currentState = "detailView";
        }

        private function ProductionSubListHandler(_arg_1:ListEvent):void
        {
            var _local_2:cEconomyOverviewData;
            this.mSelectedProductionBuilding = (this.mPanel.productionList.selectedItem as cBuilding);
            this.mPanel.productionSubListPanel.visible = true;
            this.mPanel.productionSubListTitle.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.BUILDINGS, this.mSelectedProductionBuilding.getProductionBuildingName());
            _local_2 = new cEconomyOverviewData();
            var _local_3:int = _local_2.GetResourceProductionValue(this.mSelectedProductionBuilding.GetBuildingName_string(), null);
            this.mPanel.productionSubListTotal.text = ((_local_3 == 0) ? ("" + _local_3) : ("+" + this.FormatAmount(_local_3)));
            this.mPanel.productionSubListTotalBg.toolTip = (((((_local_3 == 0) ? ("" + _local_3) : ("+" + _local_3)) + "/") + (global.economyCalculationTime / this.ONE_HOUR_SEC)) + " h");
            this.mPanel.productionSubList.dataProvider = _local_2.GetBuildingList(this.mSelectedProductionBuilding.GetBuildingName_string());
            this.mPanel.productionSubList.windowID = ((((mUiElement.id + ".tree.") + this.mSelectedTreeNode.name_string) + ".") + this.mSelectedProductionBuilding.GetBuildingName_string());
            this.mPanel.productionSubList.addEventListener(ListEvent.ITEM_CLICK, this.ProductionSubListClickHandler);
        }

        override protected function HideWithoutQueue():void
        {
            super.HideWithoutQueue();
            this.Clear();
        }

        private function Clear():void
        {
            gHintManager.HideHintsForParent(this.mPanel, true);
            this.mPanel.list.selectedItem = null;
            this.mPanel.background.styleName = "basicPanel";
            if (this.mPanel.currentState == "detailView")
            {
                this.mPanel.productionSubListPanel.visible = false;
                this.mPanel.consumptionSubListPanel.visible = false;
            };
            if (this.mPanel.currentState != "select")
            {
                this.mPanel.currentState = "select";
            };
        }

        public function Init(_arg_1:EconomyOverview):void
        {
            globalFlash.gui.windowController.addWindow(_arg_1);
            this.mGI = (global.ui as cGameInterface);
            AddBaseElement(_arg_1);
            this.mPanel = _arg_1;
            this.mPanel.addEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
        }

        private function RefreshDetailView():void
        {
            var _local_4:int;
            this.mPanel.calculationTypeName.text = (((global.economyCalculationTime / this.ONE_HOUR_SEC) + " ") + cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "EconomyCalculationType"));
            this.mPanel.productionSubListPanel.visible = false;
            this.mPanel.consumptionSubListPanel.visible = false;
            this.mPanel.detailViewTitle.text = ((cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "BaseMaterialDetails") + " ") + cLocaManager.GetInstance().GetText(LOCA_GROUP.RESOURCES, this.mSelectedTreeNode.name_string));
            this.mPanel.detailViewTitleResource.data = this.mSelectedTreeNode;
            this.mPanel.detailViewBtnResource.resourceName = this.mSelectedTreeNode.name_string;
            var _local_1:cEconomyOverviewData = new cEconomyOverviewData();
            this.mPanel.consumptionList.dataProvider = _local_1.GetUniqueConsumptionBuildingList(null, this.mSelectedTreeNode.name_string);
            this.mPanel.consumptionList.windowID = ((mUiElement.id + ".tree.") + this.mSelectedTreeNode.name_string);
            this.mPanel.productionList.dataProvider = _local_1.GetUniqueProductionBuildingList(null, this.mSelectedTreeNode.name_string);
            var _local_2:* = (("/" + (global.economyCalculationTime / this.ONE_HOUR_SEC)) + " h");
            var _local_3:dEconomyOverviewDataResult = _local_1.GetResourceProductionAndConsumptionValues(null, this.mSelectedTreeNode.name_string);
            _local_4 = _local_3.mBuffedProductionValue;
            var _local_5:int = _local_3.mConsumptionValue;
            var _local_6:int = (_local_3.mBuffedProductionValue - _local_3.mConsumptionValue);
            if (_local_6 > 0)
            {
                this.mPanel.statusBgTotalProduction.styleName = "economyItemBgGreen";
                this.mPanel.totalProductionCount.text = ("+" + this.FormatAmount(_local_6));
            }
            else
            {
                if (_local_6 < 0)
                {
                    this.mPanel.statusBgTotalProduction.styleName = "economyItemBgRed";
                    this.mPanel.totalProductionCount.text = ("" + this.FormatAmount(_local_6));
                }
                else
                {
                    if (_local_6 == 0)
                    {
                        this.mPanel.statusBgTotalProduction.styleName = "economyItemBgGrey";
                        this.mPanel.totalProductionCount.text = ("" + this.FormatAmount(_local_6));
                    };
                };
            };
            this.mPanel.totalProductionCount.toolTip = (((_local_6 == 0) ? _local_6 : ((_local_6 > 0) ? ("+" + _local_6) : _local_6)) + _local_2);
            this.mPanel.productionListTotal.text = ((_local_4 == 0) ? ("" + _local_4) : ("+" + this.FormatAmount(_local_4)));
            this.mPanel.productionListTotalBg.toolTip = (((_local_4 == 0) ? ("" + _local_4) : ("+" + _local_4)) + _local_2);
            this.mPanel.consumptionListTotal.text = ((_local_5 == 0) ? ("" + _local_5) : ("-" + this.FormatAmount(_local_5)));
            this.mPanel.consumptionListTotalBg.toolTip = (((_local_5 == 0) ? ("" + _local_5) : ("-" + _local_5)) + _local_2);
        }

        private function GetSortedVectorByNumOfChild(_arg_1:Vector.<dResource>, _arg_2:Boolean):Vector.<dResource>
        {
            var _local_3:cEconomyOverviewData = new cEconomyOverviewData();
            var _local_4:dResource = _local_3.GetPlayerSpecificResource(_arg_1[0].name_string);
            var _local_5:dResource = _local_3.GetPlayerSpecificResource(_arg_1[1].name_string);
            if (((((_arg_2) && (!(gEconomics.HasResourceTwoInputs(_local_4.name_string)))) && (gEconomics.HasResourceTwoInputs(_local_5.name_string))) || (((!(_arg_2)) && (gEconomics.HasResourceTwoInputs(_local_4.name_string))) && (!(gEconomics.HasResourceTwoInputs(_local_5.name_string))))))
            {
                return (this.GetSwappedVector(_arg_1));
            };
            return (_arg_1);
        }

        private function ItemClickedHandler(_arg_1:ItemClickEvent):void
        {
            this.mSelectedResource = (_arg_1.item as dResourceDefaultDefinition);
            if (this.mPanel.currentState == "treeView")
            {
                gHintManager.HideHintsForParent(this.mPanel.treeSprite, true);
                this.RefreshTree();
                gHintManager.TryRemainingHints();
            }
            else
            {
                gHintManager.HideHintsForParent(this.mPanel.consumptionList, true);
                gHintManager.HideHintsForParent(this.mPanel.productionList, true);
                this.mPanel.currentState = "treeView";
            };
        }

        private function ProductionSubListClickHandler(_arg_1:ListEvent):void
        {
            this.Hide();
            global.ui.mCurrentPlayerZone.ScrollToGrid((this.mPanel.productionSubList.selectedItem as cBuilding).GetGrid());
            var _local_2:cBuilding = (this.mPanel.productionSubList.selectedItem as cBuilding);
            if (_local_2 != null)
            {
                this.mGI.SelectBuilding(_local_2.getBuildingSelection());
            };
        }

        private function EnterDetailViewState(_arg_1:FlexEvent):void
        {
            this.mPanel.detailViewClose.addEventListener(MouseEvent.CLICK, this.CloseDetailView);
            this.mPanel.detailViewCloseDetail.addEventListener(MouseEvent.CLICK, this.CloseDetailView);
            this.mPanel.productionList.addEventListener(ListEvent.ITEM_CLICK, this.ProductionSubListHandler);
            this.mPanel.consumptionList.addEventListener(ListEvent.ITEM_CLICK, this.ConsumptionSubListHandler);
            this.RefreshDetailView();
            gHintManager.TryRemainingHints();
        }

        private function ConsumptionSubListClickHandler(_arg_1:ListEvent):void
        {
            this.Hide();
            var _local_2:cBuilding = (this.mPanel.consumptionSubList.selectedItem as cBuilding);
            if (_local_2 != null)
            {
                global.ui.mCurrentPlayerZone.ScrollToGrid(_local_2.GetGrid());
                this.mGI.SelectBuilding(_local_2.getBuildingSelection());
            };
        }

        private function ConsumptionSubListHandler(_arg_1:ListEvent):void
        {
            var _local_2:cEconomyOverviewData;
            this.mSelectedConsumptionBuilding = (this.mPanel.consumptionList.selectedItem as cBuilding);
            this.mPanel.consumptionSubListPanel.visible = true;
            this.mPanel.consumptionSubListTitle.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.BUILDINGS, this.mSelectedConsumptionBuilding.getProductionBuildingName());
            _local_2 = new cEconomyOverviewData();
            var _local_3:int = _local_2.GetResourceConsumptionValue(this.mSelectedConsumptionBuilding.GetBuildingName_string(), this.mSelectedTreeNode.name_string);
            this.mPanel.consumptionSubListTotal.text = ((_local_3 == 0) ? ("" + _local_3) : ("-" + this.FormatAmount(_local_3)));
            this.mPanel.consumptionSubListTotalBg.toolTip = (((((_local_3 == 0) ? ("" + _local_3) : ("-" + _local_3)) + "/") + (global.economyCalculationTime / this.ONE_HOUR_SEC)) + " h");
            this.mPanel.consumptionSubList.dataProvider = _local_2.GetBuildingList(this.mSelectedConsumptionBuilding.GetBuildingName_string());
            this.mPanel.consumptionSubList.windowID = ((((mUiElement.id + ".tree.") + this.mSelectedTreeNode.name_string) + ".") + this.mSelectedConsumptionBuilding.GetBuildingName_string());
            this.mPanel.consumptionSubList.addEventListener(ListEvent.ITEM_CLICK, this.ConsumptionSubListClickHandler);
        }

        private function FormatAmount(_arg_1:Number):String
        {
            var _local_3:String;
            var _local_2:Boolean;
            if (String(_arg_1).indexOf("-") != -1)
            {
                _arg_1 = Math.abs(_arg_1);
                _local_2 = true;
            };
            if (_arg_1 > 999)
            {
                _local_3 = (Math.floor((_arg_1 / 1000)).toString() + "k");
            }
            else
            {
                _local_3 = _arg_1.toString();
            };
            if (_local_2)
            {
                _local_3 = ("-" + _local_3);
            };
            return (_local_3);
        }

        private function completeHandler(_arg_1:FlexEvent):void
        {
            this.mPanel.removeEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
            this.mPanel.btnClose.addEventListener(MouseEvent.CLICK, this.ClosePanel);
            this.mPanel.list.addEventListener(ItemClickEvent.ITEM_CLICK, this.ItemClickedHandler);
            this.mPanel.treeViewState.addEventListener(FlexEvent.ENTER_STATE, this.EnterTreeViewState);
            this.mPanel.detailViewState.addEventListener(FlexEvent.ENTER_STATE, this.EnterDetailViewState);
            this.mPanel.detailViewState.addEventListener(FlexEvent.EXIT_STATE, this.ExitDetailViewState);
        }

        private function RenderArrows(_arg_1:TreeNodeRenderer, _arg_2:int=0):void
        {
            var _local_3:Image;
            var _local_4:HBox;
            var _local_5:Image;
            var _local_6:Image;
            if (_arg_2 == 1)
            {
                _local_3 = new Image();
                _local_3.source = gAssetManager.GetBitmap("TreeArrow3");
                _local_3.x = ((_arg_1.x + (_arg_1.width / 2)) - 15);
                _local_3.y = (_arg_1.y + _arg_1.height);
                this.mPanel.treeSprite.addChild(_local_3);
            }
            else
            {
                _local_4 = new HBox();
                _local_4.x = (_arg_1.x - 10);
                _local_4.y = (_arg_1.y + _arg_1.height);
                this.mPanel.treeSprite.addChild(_local_4);
                _local_5 = new Image();
                _local_5.source = gAssetManager.GetBitmap("TreeArrow1");
                _local_4.addChild(_local_5);
                _local_6 = new Image();
                _local_6.source = gAssetManager.GetBitmap("TreeArrow2");
                _local_4.addChild(_local_6);
            };
        }

        private function GetSwappedVector(_arg_1:Vector.<dResource>):Vector.<dResource>
        {
            var _local_2:Vector.<dResource> = new Vector.<dResource>();
            _local_2.push(_arg_1[1]);
            _local_2.push(_arg_1[0]);
            return (_local_2);
        }

        public function SetSelection(_arg_1:dResourceDefaultDefinition):void
        {
            this.mSelectedResource = _arg_1;
            this.mPanel.currentState = "treeView";
            this.RefreshTree();
        }

        private function CheckNodePositionByParallelChild(_arg_1:Vector.<dResource>):int
        {
            var _local_2:cEconomyOverviewData = new cEconomyOverviewData();
            var _local_3:dResource = _local_2.GetPlayerSpecificResource(_arg_1[0].name_string);
            var _local_4:dResource = _local_2.GetPlayerSpecificResource(_arg_1[1].name_string);
            var _local_5:Boolean = gEconomics.HasResourceTwoInputs(_local_3.name_string);
            var _local_6:Boolean = gEconomics.HasResourceTwoInputs(_local_4.name_string);
            if (((_local_5) && (_local_6)))
            {
                return (3);
            };
            if (((_local_5) && (!(_local_6))))
            {
                return (1);
            };
            if (((!(_local_5)) && (_local_6)))
            {
                return (2);
            };
            return (0);
        }

        private function GetLeftMostNodePosition(_arg_1:Vector.<TreeNodeRenderer>):int
        {
            var _local_2:int = _arg_1[0].x;
            var _local_3:int;
            while (_local_3 < _arg_1.length)
            {
                if (_arg_1[_local_3].x < _local_2)
                {
                    _local_2 = _arg_1[_local_3].x;
                };
                _local_3++;
            };
            return (_local_2);
        }

        private function ExpandTreeNodeFromParentData(_arg_1:String, _arg_2:TreeNodeRenderer, _arg_3:Boolean):void
        {
            var _local_4:dResource;
            var _local_7:int;
            var _local_8:int;
            var _local_9:int;
            var _local_10:Vector.<dResource>;
            var _local_11:dResource;
            var _local_12:Vector.<dResourceCreationDefinition>;
            var _local_13:dResourceCreationDefinition;
            var _local_14:Boolean;
            var _local_15:dResource;
            var _local_16:TreeNodeRenderer;
            var _local_17:int;
            var _local_5:cEconomyOverviewData = new cEconomyOverviewData();
            var _local_6:dResourceCreationDefinition = gEconomics.GetResourcesCreationDefinitionForResource(_arg_1);
            if (((!(_local_6 == null)) && (_local_6.amountRemoved >= 0)))
            {
                if (_local_6.externalResource_string == "")
                {
                    _local_7 = 0;
                    _local_8 = 14;
                    _local_9 = 14;
                    if (_local_6.necessaryResourcesUI_vector.length > 1)
                    {
                        _arg_2.numOfChildrens = 2;
                        _local_10 = this.GetSortedVectorByNumOfChild(_local_6.necessaryResourcesUI_vector, _arg_3);
                    }
                    else
                    {
                        _local_12 = gEconomics.GetResourcesCreationDefinitionsForResource_vector(_arg_1);
                        _local_10 = new Vector.<dResource>();
                        for each (_local_13 in _local_12)
                        {
                            for each (_local_4 in _local_13.necessaryResourcesUI_vector)
                            {
                                _local_14 = false;
                                for each (_local_15 in _local_10)
                                {
                                    if (_local_15.name_string == _local_4.name_string)
                                    {
                                        _local_14 = true;
                                        break;
                                    };
                                };
                                if (!_local_14)
                                {
                                    _local_10.push(_local_4);
                                };
                            };
                        };
                        if (_local_10.length > 1)
                        {
                            _local_10 = this.GetSortedVectorByNumOfChild(_local_10, _arg_3);
                        };
                        _arg_2.numOfChildrens = _local_10.length;
                    };
                    for each (_local_11 in _local_10)
                    {
                        _local_16 = new TreeNodeRenderer();
                        _local_16.data = {
                            "resource":_local_5.GetPlayerSpecificResource(_local_11.name_string),
                            "parentInstance":_arg_2
                        };
                        if (_local_10.length > 1)
                        {
                            _local_17 = this.CheckNodePositionByParallelChild(_local_10);
                            if (_local_17 == 3)
                            {
                                if (_local_6.defaultSetting.resourceName_string == this.mSelectedResource.resourceName_string)
                                {
                                    _local_8 = 53;
                                    _local_9 = 53;
                                };
                            };
                            if (_local_7 == 0)
                            {
                                _local_16.x = ((_arg_2.x - _arg_2.width) - _local_9);
                                _local_16.y = ((_arg_2.y + _arg_2.height) + 20);
                            }
                            else
                            {
                                _local_16.x = ((_arg_2.x + _arg_2.width) + _local_8);
                                _local_16.y = ((_arg_2.y + _arg_2.height) + 20);
                            };
                        }
                        else
                        {
                            _local_16.x = _arg_2.x;
                            _local_16.y = ((_arg_2.y + _arg_2.height) + 20);
                        };
                        if (_local_7 == 0)
                        {
                            this.RenderArrows(_arg_2, ((_local_10.length > 1) ? 0 : 1));
                        };
                        _local_16.addEventListener(MouseEvent.CLICK, this.TreeNodeClickHandler);
                        this.mPanel.treeSprite.addChild(_local_16);
                        this.mTreeNodes_vector.push(_local_16);
                        this.ExpandTreeNodeFromParentData(_local_11.name_string, _local_16, (((_local_7 == 0) && (!(_arg_3))) ? true : _arg_3));
                        _local_7++;
                    };
                }
                else
                {
                    _local_4 = new dResource();
                    _local_4.name_string = _local_6.externalResourceDeposit_string;
                    _local_4.maxLimit = 1;
                    _local_16 = new TreeNodeRenderer();
                    _local_16.data = {
                        "resource":_local_4,
                        "parentInstance":_arg_2
                    };
                    _local_16.x = _arg_2.x;
                    _local_16.y = ((_arg_2.y + _arg_2.height) + 20);
                    _local_16.addEventListener(MouseEvent.CLICK, this.TreeNodeClickHandler);
                    this.mPanel.treeSprite.addChild(_local_16);
                    this.mTreeNodes_vector.push(_local_16);
                    this.RenderArrows(_arg_2, 1);
                };
            };
        }

        private function RefreshTree():void
        {
            var _local_5:Object;
            this.mTreeNodes_vector = new Vector.<TreeNodeRenderer>();
            this.mPanel.treeSprite.x = 0;
            this.mPanel.calculationTypeName.text = (((global.economyCalculationTime / this.ONE_HOUR_SEC) + " ") + cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "EconomyCalculationType"));
            var _local_1:cEconomyOverviewData = new cEconomyOverviewData();
            this.mPanel.selectedResourceIcon.resourceName = this.mSelectedResource.resourceName_string;
            this.mPanel.selectedResourceName.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "EcoResourceHeader", [cLocaManager.GetInstance().GetText(LOCA_GROUP.RESOURCES, this.mSelectedResource.resourceName_string), cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "Production")]);
            this.mPanel.treeSprite.removeAllChildren();
            var _local_2:TreeNodeRenderer = new TreeNodeRenderer();
            _local_2.data = {
                "resource":_local_1.GetPlayerSpecificResource(this.mSelectedResource.resourceName_string),
                "parentInstance":null
            };
            _local_2.x = ((this.mPanel.treeContainer.width / 2) - (_local_2.width / 2));
            _local_2.addEventListener(MouseEvent.CLICK, this.TreeNodeClickHandler);
            this.mPanel.treeSprite.addChild(_local_2);
            this.mTreeNodes_vector.push(_local_2);
            this.ExpandTreeNodeFromParentData(this.mSelectedResource.resourceName_string, _local_2, false);
            var _local_3:int = this.GetLeftMostNodePosition(this.mTreeNodes_vector);
            var _local_4:int = this.GetRightMostNodePosition(this.mTreeNodes_vector);
            if (_local_3 < this.TREE_LEFT_SIDE_LIMIT)
            {
                this.mPanel.treeSprite.x = _local_3;
                for each (_local_5 in this.mPanel.treeSprite.getChildren())
                {
                    _local_5.x = (_local_5.x + (this.TREE_LEFT_SIDE_LIMIT - _local_3));
                };
            }
            else
            {
                if (_local_4 >= this.TREE_RIGHT_SIDE_LIMIT)
                {
                    this.mPanel.treeSprite.x = ((this.mPanel.treeSprite.x - _local_3) + 20);
                };
            };
            global.ui.mQuestClientCallbacks.InitiateWindowOpen(((mUiElement.id + ".list.") + this.mSelectedResource.resourceName_string));
            global.getApplication().inputNotifier.notifyClick(((mUiElement.id + ".list.") + this.mSelectedResource.resourceName_string));
        }

        private function ExitDetailViewState(_arg_1:FlexEvent):void
        {
            this.mPanel.detailViewClose.removeEventListener(MouseEvent.CLICK, this.CloseDetailView);
            this.mPanel.detailViewCloseDetail.removeEventListener(MouseEvent.CLICK, this.CloseDetailView);
            this.mPanel.productionList.removeEventListener(ListEvent.ITEM_CLICK, this.ProductionSubListHandler);
            this.mPanel.consumptionList.removeEventListener(ListEvent.ITEM_CLICK, this.ConsumptionSubListHandler);
            this.mPanel.productionSubListPanel.visible = false;
            this.mPanel.consumptionSubListPanel.visible = false;
        }


    }
}
