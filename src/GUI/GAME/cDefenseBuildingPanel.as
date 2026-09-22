package GUI.GAME
{
    import Interface.cGameInterface;
    import MilitarySystem.iMilitaryUnitHolder;
    import GUI.Components.DefenseBuildingPanel;
    import flash.events.MouseEvent;
    import MilitarySystem.cMilitaryUtil;
    import com.bluebyte.tso.util.ClientLogger;
    import Enums.UNIT_COST_SOURCE;
    import GO.cBuilding;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import GUI.Assets.gAssetManager;
    import mx.events.FlexEvent;
    import GUI.Components.Combat3UnitManager;
    import flash.events.Event;
    import Enums.COMMAND;

    public class cDefenseBuildingPanel extends cBasicPanel 
    {

        private static const NUM_DEFENCE_UNITS:int = 6;

        private var mTroopPrimaryResource:String;
        private var mGI:cGameInterface;
        private var mContainer:iMilitaryUnitHolder;
        protected var mPanel:DefenseBuildingPanel;


        private function closePanelHandler(_arg_1:MouseEvent):void
        {
            this.Hide();
        }

        protected function btnDefenseCommitHandler(event:MouseEvent):void
        {
            this.SetBusyModeOn();
            try
            {
                cMilitaryUtil.SendRaiseArmyToServer(this.mGI, this.mContainer, this.mPanel.unitManager.GetUnitAllocation());
            }
            catch(e:Error)
            {
                ClientLogger.error(e);
            };
            Hide();
        }

        public function SetData(_arg_1:iMilitaryUnitHolder, _arg_2:String):void
        {
            this.mTroopPrimaryResource = _arg_2;
            this.mContainer = _arg_1;
            var _local_3:cBasicResourceCollection = new cBasicResourceCollection();
            _local_3.SetResources(this.mGI.mCurrentPlayerZone.GetResources(this.mGI.mCurrentPlayer).GetResources_Vector());
            this.mPanel.unitManager.SetData(this.mContainer, this.mTroopPrimaryResource, _local_3, 3, UNIT_COST_SOURCE.COST);
            var _local_4:cBuilding = (this.mContainer as cBuilding);
            if (_local_4 != null)
            {
                this.mPanel.buildingHeader.description.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.DESCRIPTIONS, _local_4.GetBuildingName_string());
                this.mPanel.buildingHeader.image.source = gAssetManager.GetBuildingIcon(_local_4.GetBuildingName_string());
            };
        }

        public function Init(_arg_1:DefenseBuildingPanel):void
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
            this.mPanel.btnDefenseCommit.addEventListener(MouseEvent.CLICK, this.btnDefenseCommitHandler);
            this.mPanel.btnClose.addEventListener(MouseEvent.CLICK, this.closePanelHandler);
            this.mPanel.btnDefenseCancel.addEventListener(MouseEvent.CLICK, this.closePanelHandler);
            this.mPanel.addEventListener(Combat3UnitManager.ENABLE_COMMIT, this.enableCommit);
            this.mPanel.addEventListener(Combat3UnitManager.DISABLE_COMMIT, this.disableCommit);
        }

        public function SetBusyModeOn():void
        {
            this.mPanel.busyOverlay.visible = true;
        }

        public function SetBusyModeOff():void
        {
            this.mPanel.busyOverlay.visible = false;
        }

        protected function enableCommit(_arg_1:Event):void
        {
            this.mPanel.btnDefenseCommit.enabled = true;
        }

        override public function Show():void
        {
            this.mGI.mCurrentCursor.SetCursorEditMode(COMMAND.SELECT_BUILDING);
            if (!this.mGI.mIsDefenseMode)
            {
                return;
            };
            super.Show();
        }

        protected function disableCommit(_arg_1:Event):void
        {
            this.mPanel.btnDefenseCommit.enabled = false;
            this.mPanel.btnDefenseCommit.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.TOOLTIP, "NotEnoughDefensePoints");
        }


    }
}
