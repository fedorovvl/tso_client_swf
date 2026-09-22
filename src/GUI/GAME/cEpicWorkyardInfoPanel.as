package GUI.GAME
{
    import GUI.Components.EpicWorkyardInfoPanel;
    import __AS3__.vec.Vector;
    import GO.epicWorkyard.EpicWorkyardSubBuilding;
    import GO.epicWorkyard.EpicWorkyardMasterBuilding;
    import Interface.cGameInterface;
    import GUI.Components.ItemRenderer.EpicWorkyardChainItemRenderer;
    import flash.display.Stage;
    import EpicWorkyard.ChainItemSelectedEvent;
    import mx.containers.VBox;
    import flash.display.DisplayObject;
    import GUI.helpers.MovieClipHelpers;
    import flash.events.MouseEvent;
    import Communication.VO.epicWorkyard.ChainVO;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import GO.cBuilding;
    import flash.geom.Point;
    import EpicWorkyard.EpicWorkyardsManager;
    import EpicWorkyard.EpicWorkyardChangeProductionEvent;
    import Communication.VO.dServerAction;
    import Communication.VO.epicWorkyard.EpicWorkyardCreateProductionChainVO;
    import Enums.COMMAND;
    import EpicWorkyard.EpicWorkyardConsts;
    import Communication.VO.epicWorkyard.EpicWorkyardStopProductionChainVO;
    import Communication.VO.epicWorkyard.EpicWorkyardChangeProductionVO;
    import __AS3__.vec.*;

    public class cEpicWorkyardInfoPanel extends cBasicInfoPanel 
    {

        private const MAX_ITEMS_PER_CHAIN_COLUMN:int = 16;
        private const SAFETY_OFFSET_X:int = 15;

        private var panel:EpicWorkyardInfoPanel;
        private var chainPanels:Vector.<EpicWorkyardProductionChainPanel>;
        private var currentChangingSubBuilding:EpicWorkyardSubBuilding;
        private var epicWorkyard:EpicWorkyardMasterBuilding;
        private var generalInterface:cGameInterface;
        private var activeSelectionChain:EpicWorkyardChainItemRenderer;
        private var stage:Stage;


        private function setBusy(_arg_1:Boolean):void
        {
            this.panel.busyOverlay.visible = _arg_1;
            this.panel.busyAnim.visible = _arg_1;
        }

        private function handleChainSelected(_arg_1:ChainItemSelectedEvent):void
        {
            var _local_2:EpicWorkyardChainItemRenderer = _arg_1.getChainRenderer();
            if (_local_2 == null)
            {
                return;
            };
            this.epicWorkyard.setWaitingForServerResponse(true);
            this.setBusy(this.epicWorkyard.getWaitingForServerResponse());
            if (this.currentChangingSubBuilding == null)
            {
                this.sendStartProductionMessage(_local_2.getChain());
            }
            else
            {
                if (_local_2.getChain() == null)
                {
                    this.sendDestroyProductionMessage(this.currentChangingSubBuilding);
                }
                else
                {
                    this.sendChangeProductionMessage(this.currentChangingSubBuilding, _local_2.getChain());
                };
            };
        }

        private function removeChainSelectList():void
        {
            var _local_1:EpicWorkyardChainItemRenderer;
            var _local_2:VBox;
            var _local_3:DisplayObject;
            for each (_local_2 in this.panel.chainSelectList.getChildren())
            {
                for each (_local_3 in _local_2.getChildren())
                {
                    _local_1 = (_local_3 as EpicWorkyardChainItemRenderer);
                    if (_local_1 != null)
                    {
                        MovieClipHelpers.removeFromParent(_local_1);
                        _local_1.removeEventListener(ChainItemSelectedEvent.ITEM_SELECTED, this.handleChainSelected);
                        _local_1.removeEventListener(MouseEvent.ROLL_OVER, this.handleChainRollOver);
                        _local_1.removeEventListener(MouseEvent.ROLL_OUT, this.handleChainRollOut);
                        _local_1.destroy();
                    };
                };
            };
            this.panel.chainSelectListSub2.visible = false;
            this.panel.chainSelectListSub3.visible = false;
            if (this.activeSelectionChain != null)
            {
                this.activeSelectionChain.setSelected(false);
            };
            this.activeSelectionChain = null;
            this.panel.chainSelectList.visible = false;
            this.panel.checkButton.visible = false;
        }

        private function handleChainRollOver(_arg_1:MouseEvent):void
        {
            var _local_2:EpicWorkyardChainItemRenderer = (_arg_1.currentTarget as EpicWorkyardChainItemRenderer);
            var _local_3:ChainVO = _local_2.getChain();
            if (((!(_local_3 == null)) && (_local_2.enabled)))
            {
                this.generalInterface.mSetBuildings.setForceRenderTransportDuration(true);
                this.generalInterface.mSetBuildings.ShowPreviewPath(this.generalInterface.mCurrentPlayer.GetPlayerId(), true, _local_3.getName(), false);
            };
        }

        override public function SetData(_arg_1:cBuilding):void
        {
            this.epicWorkyard = (_arg_1 as EpicWorkyardMasterBuilding);
            var _local_2:String = this.epicWorkyard.GetBuildingName_string();
            this.panel.data = _local_2;
            this.panel.label = cLocaManager.GetInstance().GetText(LOCA_GROUP.BUILDINGS, _local_2);
            this.panel.buildingHeader.data = _arg_1;
            this.initProductionChains();
            this.setBusy(this.epicWorkyard.getWaitingForServerResponse());
        }

        public function refreshChains():void
        {
            this.initProductionChains();
            this.setBusy(this.epicWorkyard.getWaitingForServerResponse());
        }

        private function handleChangeProduction(_arg_1:EpicWorkyardChangeProductionEvent):void
        {
            var _local_2:Point;
            var _local_3:Vector.<ChainVO>;
            var _local_5:ChainVO;
            var _local_6:Point;
            var _local_7:int;
            this.panel.chainSelectListSub1.removeAllChildren();
            this.panel.chainSelectListSub2.removeAllChildren();
            this.panel.chainSelectListSub3.removeAllChildren();
            this.panel.chainSelectListSub2.visible = false;
            this.panel.chainSelectListSub3.visible = false;
            this.currentChangingSubBuilding = _arg_1.getSubBuilding();
            if (this.currentChangingSubBuilding)
            {
                this.addChainItem(null, null, 1);
            };
            _local_3 = EpicWorkyardsManager.getInstance().getRankedProductionChainsForBuilding(this.epicWorkyard.GetBuildingName_string(), this.generalInterface, this.currentChangingSubBuilding);
            var _local_4:int = _local_3.length;
            for each (_local_5 in _local_3)
            {
                this.addChainItem(_local_5, _arg_1.getSubBuilding(), _local_4);
            };
            this.panel.chainSelectList.x = this.panel.mouseX;
            _local_6 = this.panel.globalToLocal(new Point(0, -20));
            this.panel.chainSelectList.y = Math.max(_local_6.y, (this.panel.mouseY - ((((_local_4 >= this.MAX_ITEMS_PER_CHAIN_COLUMN) ? this.MAX_ITEMS_PER_CHAIN_COLUMN : _local_4) + 1) * EpicWorkyardChainItemRenderer.HEIGHT)));
            this.panel.chainSelectList.visible = true;
            if (((!(this.activeSelectionChain == null)) && (this.activeSelectionChain.parent == this.panel.chainSelectList)))
            {
                _local_7 = this.panel.chainSelectList.getChildIndex(this.activeSelectionChain);
                this.panel.checkButton.x = this.panel.chainSelectList.x;
                this.panel.checkButton.y = ((this.panel.chainSelectList.y + (_local_7 * EpicWorkyardChainItemRenderer.PADDED_HEIGHT)) + ((EpicWorkyardChainItemRenderer.HEIGHT - this.panel.checkButton.height) / 2));
                this.panel.checkButton.visible = true;
            }
            else
            {
                this.panel.checkButton.visible = false;
            };
            if (!this.stage)
            {
                this.stage = this.panel.stage;
            };
            this.stage.addEventListener(MouseEvent.CLICK, this.handleGlobalClick, false, 0, true);
        }

        private function addChainItem(_arg_1:ChainVO, _arg_2:EpicWorkyardSubBuilding, _arg_3:int):void
        {
            var _local_4:EpicWorkyardChainItemRenderer = new EpicWorkyardChainItemRenderer();
            _local_4.setData(_arg_1, this.generalInterface, _arg_2);
            if (this.panel.chainSelectListSub1.numChildren < this.MAX_ITEMS_PER_CHAIN_COLUMN)
            {
                this.panel.chainSelectListSub1.addChild(_local_4);
            }
            else
            {
                if (this.panel.chainSelectListSub2.numChildren < this.MAX_ITEMS_PER_CHAIN_COLUMN)
                {
                    this.panel.chainSelectListSub2.addChild(_local_4);
                    this.panel.chainSelectListSub2.visible = true;
                }
                else
                {
                    this.panel.chainSelectListSub3.addChild(_local_4);
                    this.panel.chainSelectListSub3.visible = true;
                };
            };
            _local_4.addEventListener(ChainItemSelectedEvent.ITEM_SELECTED, this.handleChainSelected, false, 0, true);
            _local_4.addEventListener(MouseEvent.ROLL_OVER, this.handleChainRollOver, false, 0, true);
            _local_4.addEventListener(MouseEvent.ROLL_OUT, this.handleChainRollOut, false, 0, true);
            if ((((_arg_2) && (_arg_1)) && (_arg_1.getChainIsEquivalentToBuilding(_arg_2))))
            {
                this.activeSelectionChain = _local_4;
                this.activeSelectionChain.setSelected(true);
            };
        }

        private function sendStartProductionMessage(_arg_1:ChainVO):void
        {
            var _local_2:dServerAction = new dServerAction();
            var _local_3:EpicWorkyardCreateProductionChainVO = new EpicWorkyardCreateProductionChainVO();
            _local_3.masterBuildingGridPosition = this.epicWorkyard.GetGrid();
            _local_3.productionChainSubBuildingName = _arg_1.getName();
            _local_3.productionChainSubBuildingRank = _arg_1.getRank();
            _local_2.data = _local_3;
            this.generalInterface.mClientMessages.SendMessagetoServer(COMMAND.EPIC_WORKYARD_CREATE_PRODUCTION_CHAIN, this.generalInterface.mCurrentViewedZoneID, _local_2);
        }

        private function handleChainRollOut(_arg_1:MouseEvent):void
        {
            this.generalInterface.mSetBuildings.setForceRenderTransportDuration(false);
            this.generalInterface.mSetBuildings.ShowPreviewPath(this.generalInterface.mCurrentPlayer.GetPlayerId(), true, "", false);
        }

        private function initProductionChains():void
        {
            var _local_2:EpicWorkyardSubBuilding;
            var _local_1:Vector.<EpicWorkyardSubBuilding> = this.epicWorkyard.getSubBuildings();
            var _local_3:Boolean;
            var _local_4:int;
            while (_local_4 < this.chainPanels.length)
            {
                _local_2 = ((_local_1.length > _local_4) ? _local_1[_local_4] : null);
                this.chainPanels[_local_4].init(_local_2, this.panel.productionList, _local_4, (!(_local_3)));
                if (((!(_local_3)) && (_local_2 == null)))
                {
                    _local_3 = true;
                };
                this.chainPanels[_local_4].updateBuffActive();
                _local_4++;
            };
        }

        private function addListeners():void
        {
            var _local_1:EpicWorkyardProductionChainPanel;
            this.panel.btnClose.addEventListener(MouseEvent.CLICK, this.handleClosePanel, false, 0, true);
            for each (_local_1 in this.chainPanels)
            {
                _local_1.addEventListener(EpicWorkyardConsts.CHANGE_PRODUCTION, this.handleChangeProduction, false, 0, true);
            };
        }

        private function sendDestroyProductionMessage(_arg_1:EpicWorkyardSubBuilding):void
        {
            var _local_2:dServerAction = new dServerAction();
            var _local_3:EpicWorkyardStopProductionChainVO = new EpicWorkyardStopProductionChainVO();
            _local_3.masterBuildingGridPosition = this.epicWorkyard.GetGrid();
            _local_3.subBuildingGridPosition = _arg_1.GetGrid();
            _local_2.data = _local_3;
            this.generalInterface.mClientMessages.SendMessagetoServer(COMMAND.EPIC_WORKYARD_DESTROY_PRODUCTION_CHAIN, this.generalInterface.mCurrentViewedZoneID, _local_2);
        }

        override public function Show():void
        {
            this.addListeners();
            super.Show();
        }

        private function sendChangeProductionMessage(_arg_1:EpicWorkyardSubBuilding, _arg_2:ChainVO):void
        {
            var _local_3:dServerAction = new dServerAction();
            var _local_4:EpicWorkyardChangeProductionVO = new EpicWorkyardChangeProductionVO();
            _local_4.masterBuildingGridPosition = this.epicWorkyard.GetGrid();
            _local_4.subBuildingGridPosition = _arg_1.GetGrid();
            _local_4.productionChainSubBuildingName = _arg_2.getName();
            _local_4.productionChainSubBuildingRank = _arg_2.getRank();
            _local_3.data = _local_4;
            this.generalInterface.mClientMessages.SendMessagetoServer(COMMAND.EPIC_WORKYARD_CHANGE_PRODUCTION_CHAIN, this.generalInterface.mCurrentViewedZoneID, _local_3);
        }

        override public function Hide():void
        {
            this.removeListeners();
            MovieClipHelpers.removeAllChildren(this.panel.productionList);
            this.removeChainSelectList();
            super.Hide();
        }

        private function removeListeners():void
        {
            var _local_1:EpicWorkyardProductionChainPanel;
            this.panel.btnClose.removeEventListener(MouseEvent.CLICK, this.handleClosePanel);
            for each (_local_1 in this.chainPanels)
            {
                _local_1.removeEventListener(EpicWorkyardConsts.CHANGE_PRODUCTION, this.handleChangeProduction);
            };
        }

        private function handleGlobalClick(_arg_1:MouseEvent):void
        {
            if (this.stage)
            {
                this.stage.removeEventListener(MouseEvent.CLICK, this.handleGlobalClick);
            };
            this.currentChangingSubBuilding = null;
            this.removeChainSelectList();
            this.handleChainRollOut(null);
        }

        private function handleClosePanel(_arg_1:MouseEvent):void
        {
            this.Hide();
        }

        public function Init(_arg_1:EpicWorkyardInfoPanel):void
        {
            var _local_3:EpicWorkyardProductionChainPanel;
            this.generalInterface = (global.ui as cGameInterface);
            globalFlash.gui.windowController.addWindow(_arg_1);
            AddBaseElement(_arg_1);
            this.panel = _arg_1;
            this.chainPanels = new Vector.<EpicWorkyardProductionChainPanel>();
            var _local_2:int;
            while (_local_2 < EpicWorkyardConsts.MAX_SUB_BUILDINGS)
            {
                _local_3 = new EpicWorkyardProductionChainPanel(this.generalInterface);
                this.chainPanels.push(_local_3);
                _local_2++;
            };
        }

        public function refreshProductionState():void
        {
            var _local_1:EpicWorkyardProductionChainPanel;
            for each (_local_1 in this.chainPanels)
            {
                _local_1.refreshProductionState();
            };
        }


    }
}
