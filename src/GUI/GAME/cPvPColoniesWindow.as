package GUI.GAME
{
    import mx.collections.ArrayCollection;
    import Interface.cGameInterface;
    import GUI.Components.PvPColoniesWindow;
    import GUI.Components.CustomAlert;
    import mx.controls.Alert;
    import mx.events.CloseEvent;
    import flash.events.MouseEvent;
    import Enums.COMMAND;
    import GUI.Components.ItemRenderer.PvPColonySearchResultRenderData;
    import Enums.ERROR_CODES;
    import mx.events.ListEvent;
    import mx.collections.Sort;
    import mx.collections.SortField;
    import Communication.VO.ColonyVO;
    import com.bluebyte.tso.adventure.logic.AdventureManager;
    import Communication.VO.ColoniesListVO;
    import GUI.Loca.cLocaManager;

    public class cPvPColoniesWindow extends cBasicPanel 
    {

        private var mPvPColonies:ArrayCollection = new ArrayCollection();
        private var mGI:cGameInterface;
        private var mPanel:PvPColoniesWindow;
        private var mSelectedItem:Object = null;


        private function DiscardAll(_arg_1:MouseEvent):void
        {
            var _local_2:CustomAlert = CustomAlert.show("DiscardAllPvPTargets", "DiscardAllPvPTargets", (Alert.CANCEL | Alert.OK), this.mPanel, this.DiscardAllConfirm);
            _local_2.addEventListener(CloseEvent.CLOSE, this.DiscardAllConfirm);
        }

        private function DiscardAllConfirm(_arg_1:CloseEvent):void
        {
            if (_arg_1.detail != Alert.OK)
            {
                return;
            };
            globalFlash.gui.windowController.closeModal();
            this.Hide();
        }

        public function handleConquerSuccessful(_arg_1:int):void
        {
            this.mPanel.busyOverlay.visible = false;
            globalFlash.gui.windowController.closeModal();
            this.Hide();
        }

        private function ClosePanel(_arg_1:MouseEvent):void
        {
            globalFlash.gui.windowController.closeModal();
            this.Hide();
        }

        private function StartConquerConfirm(_arg_1:CloseEvent):void
        {
            if (_arg_1.detail != Alert.OK)
            {
                return;
            };
            this.mPanel.busyOverlay.visible = true;
            this.mPanel.btnDiscardAll.enabled = false;
            this.mPanel.btnStartConquering.enabled = false;
            global.services.colony.startConquer(this.mSelectedItem.colonyVO.colonyId);
        }

        override public function Show():void
        {
            this.mGI.mCurrentCursor.SetCursorEditMode(COMMAND.SELECT_BUILDING);
            super.Show();
            globalFlash.gui.windowController.showModal();
            globalFlash.gui.windowController.setTop(this.mPanel, true);
            this.Refresh();
        }

        public function handleConquerFailed(_arg_1:int, _arg_2:int):void
        {
            var _local_3:PvPColonySearchResultRenderData;
            this.mPanel.busyOverlay.visible = false;
            if (_arg_2 == ERROR_CODES.COLONY_ATTACK_TOO_LATE)
            {
                CustomAlert.show("ColonyChosenToolate", "ColonyChosenToolate!", Alert.OK, this.mPanel, null);
                globalFlash.gui.windowController.closeModal();
                this.Hide();
            }
            else
            {
                CustomAlert.show("ColonyUnderAttackChooseAnother", "ColonyUnderAttackChooseAnother!", Alert.OK, this.mPanel, null);
                _local_3 = this.getColonyProviderById(_arg_1);
                _local_3.selected = false;
                _local_3.enabled = false;
                this.mSelectedItem = null;
                this.mPanel.btnDiscardAll.enabled = true;
            };
        }

        override protected function HideWithoutQueue():void
        {
            super.HideWithoutQueue();
            this.Clear();
        }

        private function Clear():void
        {
        }

        public function Init(_arg_1:PvPColoniesWindow):void
        {
            globalFlash.gui.windowController.addWindow(_arg_1);
            this.mGI = (global.ui as cGameInterface);
            AddBaseElement(_arg_1);
            this.mPanel = _arg_1;
            this.mPanel.coloniesList.addEventListener(ListEvent.ITEM_CLICK, this.ItemClickedHandler);
            this.mPanel.btnStartConquering.addEventListener(MouseEvent.CLICK, this.StartConquer);
            this.mPanel.btnDiscardAll.addEventListener(MouseEvent.CLICK, this.DiscardAll);
            this.mPanel.coloniesList.selectedIndex = -1;
            var _local_2:Sort = new Sort();
            _local_2.fields = [new SortField("sortIndex", false, false, true), new SortField("zoneId", false, false, true)];
            this.mPvPColonies.sort = _local_2;
            this.mPvPColonies.refresh();
            this.mPanel.coloniesList.dataProvider = this.mPvPColonies;
        }

        private function StartConquer(_arg_1:MouseEvent):void
        {
            var _local_2:CustomAlert = CustomAlert.show("StartConquering", "StartConquering", (Alert.CANCEL | Alert.OK), this.mPanel, this.StartConquerConfirm);
            _local_2.addEventListener(CloseEvent.CLOSE, this.StartConquerConfirm);
        }

        public function getColonyProviderById(_arg_1:int):PvPColonySearchResultRenderData
        {
            var _local_2:PvPColonySearchResultRenderData;
            for each (_local_2 in this.mPvPColonies)
            {
                if ((_local_2.colonyVO as ColonyVO).colonyId == _arg_1)
                {
                    return (_local_2);
                };
            };
            return (null);
        }

        public function setColoniesListResponse(_arg_1:ColoniesListVO):void
        {
            var _local_2:ColonyVO;
            this.mPvPColonies.removeAll();
            this.mPanel.busyOverlay.visible = false;
            this.mPanel.btnDiscardAll.enabled = true;
            this.mPanel.btnStartConquering.enabled = false;
            this.mPanel.btnDiscardAll.visible = true;
            this.mPanel.btnStartConquering.visible = true;
            for each (_local_2 in _arg_1.colonies)
            {
                this.mPvPColonies.addItem(new PvPColonySearchResultRenderData(_local_2));
            };
            AdventureManager.getInstance().SetScoutingForPvP(false);
        }

        public function Refresh():void
        {
            if (!this.mPanel.visible)
            {
                return;
            };
            this.mPanel.busyOverlay.visible = true;
            this.mPanel.headline.text = cLocaManager.GetInstance().getLabel("PvP");
            this.mPanel.btnStartConquering.enabled = false;
            this.mPanel.btnDiscardAll.enabled = false;
        }

        private function ItemClickedHandler(_arg_1:ListEvent):void
        {
            var _local_2:PvPColonySearchResultRenderData;
            if (_arg_1.itemRenderer.data.enabled)
            {
                this.mPvPColonies.disableAutoUpdate();
                for each (_local_2 in this.mPvPColonies)
                {
                    _local_2.selected = false;
                };
                _arg_1.itemRenderer.data.selected = true;
                this.mPvPColonies.enableAutoUpdate();
                this.mPanel.btnStartConquering.enabled = true;
                this.mSelectedItem = _arg_1.itemRenderer.data;
            };
        }


    }
}
