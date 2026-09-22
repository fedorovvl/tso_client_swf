package GUI.GAME
{
    import GO.cBuilding;
    import Interface.cGameInterface;
    import GUI.Components.MinimalInfoPanel;
    import GUI.Components.ToolTips.cToolTipUtil;
    import mx.events.ToolTipEvent;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import GUI.Assets.gAssetManager;
    import mx.events.FlexEvent;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import GUI.Components.CustomAlert;
    import mx.controls.Alert;
    import mx.events.CloseEvent;

    public class cMinimalInfoPanel extends cBasicInfoPanel 
    {

        protected var mBuilding:cBuilding;
        private var mGI:cGameInterface;
        protected var mPanel:MinimalInfoPanel;


        override public function Show():void
        {
            super.Show();
        }

        override public function Hide():void
        {
            super.Hide();
        }

        private function CreateKnockDownToolTip(_arg_1:ToolTipEvent):void
        {
            if (this.mBuilding.IsRecurringBuilding())
            {
                cToolTipUtil.createToolTip(cToolTipUtil.SIMPLE_string, _arg_1);
            }
            else
            {
                cToolTipUtil.createToolTip(cToolTipUtil.DEMOLISH_BUILDING_string, _arg_1, this.mBuilding);
            };
        }

        override public function SetData(_arg_1:cBuilding):void
        {
            var _local_2:String = _arg_1.GetBuildingName_string();
            this.mBuilding = _arg_1;
            this.mPanel.label = cLocaManager.GetInstance().GetText(LOCA_GROUP.BUILDINGS, _local_2);
            this.mPanel.buildingHeader.description.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.DESCRIPTIONS, _local_2);
            this.mPanel.buildingHeader.image.source = gAssetManager.GetBuildingIcon(_local_2);
            this.mPanel.btnKnockDown.enabled = _arg_1.IsKnockdownAllowed();
            if (this.mBuilding.IsRecurringBuilding())
            {
                this.mPanel.buildingHeader.payshopItemIndicator.visible = true;
                this.mPanel.btnKnockDown.toolTip = cLocaManager.GetInstance().getLabel("KnockDownRecurring");
            }
            else
            {
                this.mPanel.buildingHeader.payshopItemIndicator.visible = false;
                this.mPanel.btnKnockDown.toolTip = "KnockDown";
            };
        }

        public function Init(_arg_1:MinimalInfoPanel):void
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
            this.mPanel.btnKnockDown.addEventListener(MouseEvent.CLICK, this.ConfirmRemoveBuilding);
            this.mPanel.btnKnockDown.addEventListener(ToolTipEvent.TOOL_TIP_CREATE, this.CreateKnockDownToolTip);
        }

        private function ClosePanel(_arg_1:Event):void
        {
            this.Hide();
        }

        private function ConfirmRemoveBuilding(_arg_1:Event):void
        {
            var _local_2:CustomAlert = CustomAlert.show("ConfirmTeardown", "ConfirmTeardown", (Alert.CANCEL | Alert.OK), this.mPanel, this.RemoveBuilding);
            _local_2.addEventListener(CloseEvent.CLOSE, this.RemoveBuilding);
        }

        public function Refresh():void
        {
            if (this.mBuilding)
            {
                this.SetData(this.mBuilding);
            };
        }

        private function RemoveBuilding(_arg_1:CloseEvent):void
        {
            if (_arg_1.detail != Alert.OK)
            {
                return;
            };
            this.mGI.mCurrentPlayerZone.SendDestructBuildingCommand(this.mBuilding, "minimalInfoPanel");
            this.Hide();
        }


    }
}
