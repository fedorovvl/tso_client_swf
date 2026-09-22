package GUI.GAME
{
    import GO.cBuilding;
    import Interface.cGameInterface;
    import GUI.Components.DecorationInfoPanel;
    import GUI.Components.ToolTips.cToolTipUtil;
    import mx.events.ToolTipEvent;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import GUI.Assets.gAssetManager;
    import Communication.VO.dPosVO;
    import Enums.COMMAND;
    import flash.events.MouseEvent;
    import mx.events.FlexEvent;
    import flash.events.Event;
    import GUI.Components.CustomAlert;
    import mx.controls.Alert;
    import mx.events.CloseEvent;

    public class cDecorationInfoPanel extends cBasicInfoPanel 
    {

        protected var mBuilding:cBuilding;
        private var mInitialOffsetX:int = 0;
        private var mInitialOffsetY:int = 0;
        private var mGI:cGameInterface;
        protected var mPanel:DecorationInfoPanel;
        private var mOffsetChanged:Boolean = false;


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
            if (this.mOffsetChanged)
            {
                this.ResetPosition();
            };
            var _local_2:String = _arg_1.GetBuildingName_string();
            this.mBuilding = _arg_1;
            this.mPanel.label = cLocaManager.GetInstance().GetText(LOCA_GROUP.BUILDINGS, _local_2);
            this.mPanel.buildingHeader.description.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.DESCRIPTIONS, _local_2);
            this.mPanel.buildingHeader.image.source = gAssetManager.GetBuildingIcon(_local_2);
            this.mPanel.btnKnockDown.enabled = ((_arg_1.IsKnockdownAllowed()) && (!(_arg_1.IsLastWarehouseInSector())));
            if (this.mBuilding.IsRecurringBuilding())
            {
                this.mPanel.buildingHeader.payshopItemIndicator.visible = true;
                this.mPanel.btnKnockDown.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "KnockDownRecurring");
            }
            else
            {
                this.mPanel.buildingHeader.payshopItemIndicator.visible = false;
                this.mPanel.btnKnockDown.toolTip = "KnockDown";
            };
            this.mInitialOffsetX = this.mBuilding.GetOffsetX();
            this.mInitialOffsetY = this.mBuilding.GetOffsetY();
            this.CheckMaximumReached();
        }

        private function SaveOffset(_arg_1:MouseEvent=null):void
        {
            var _local_2:dPosVO;
            if (this.mOffsetChanged)
            {
                this.mInitialOffsetX = this.mBuilding.GetOffsetX();
                this.mInitialOffsetY = this.mBuilding.GetOffsetY();
                this.mOffsetChanged = false;
                this.CheckMaximumReached();
                _local_2 = new dPosVO();
                _local_2.x = this.mBuilding.GetOffsetX();
                _local_2.y = this.mBuilding.GetOffsetY();
                this.mGI.SendServerAction(COMMAND.SET_BUILDING_OFFSETS, 0, this.mBuilding.GetGrid(), 0, _local_2);
            };
        }

        private function completeHandler(_arg_1:FlexEvent):void
        {
            this.mPanel.removeEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
            this.mPanel.btnClose.addEventListener(MouseEvent.CLICK, this.ClosePanel);
            this.mPanel.btnKnockDown.addEventListener(MouseEvent.CLICK, this.ConfirmRemoveBuilding);
            this.mPanel.btnKnockDown.addEventListener(ToolTipEvent.TOOL_TIP_CREATE, this.CreateKnockDownToolTip);
            this.mPanel.btnMoveUp.addEventListener(MouseEvent.CLICK, this.MoveUp);
            this.mPanel.btnMoveDown.addEventListener(MouseEvent.CLICK, this.MoveDown);
            this.mPanel.btnMoveLeft.addEventListener(MouseEvent.CLICK, this.MoveLeft);
            this.mPanel.btnMoveRight.addEventListener(MouseEvent.CLICK, this.MoveRight);
            this.mPanel.btnOK.addEventListener(MouseEvent.CLICK, this.SaveOffset);
            this.mPanel.btnCancel.addEventListener(MouseEvent.CLICK, this.ResetPosition);
        }

        private function ClosePanel(_arg_1:Event):void
        {
            this.ResetPosition();
            this.Hide();
        }

        private function MoveLeft(_arg_1:MouseEvent):void
        {
            this.mBuilding.ModifyOffsetX(-1);
            this.mBuilding.SetPosition(this.mBuilding.GetX(), this.mBuilding.GetY());
            this.mOffsetChanged = true;
            this.CheckMaximumReached();
        }

        private function CheckMaximumReached():void
        {
            this.mPanel.btnMoveUp.enabled = (this.mBuilding.GetOffsetY() > -(defines.MAX_BUILDING_OFFSET));
            this.mPanel.btnMoveDown.enabled = (this.mBuilding.GetOffsetY() < defines.MAX_BUILDING_OFFSET);
            this.mPanel.btnMoveLeft.enabled = (this.mBuilding.GetOffsetX() > -(defines.MAX_BUILDING_OFFSET));
            this.mPanel.btnMoveRight.enabled = (this.mBuilding.GetOffsetX() < defines.MAX_BUILDING_OFFSET);
            this.mPanel.btnOK.enabled = this.mOffsetChanged;
            this.mPanel.btnCancel.enabled = this.mOffsetChanged;
        }

        private function ConfirmRemoveBuilding(_arg_1:Event):void
        {
            var _local_2:CustomAlert = CustomAlert.show("ConfirmTeardownBuff", "ConfirmTeardown", (Alert.CANCEL | Alert.OK), this.mPanel, this.RemoveBuilding);
            _local_2.addEventListener(CloseEvent.CLOSE, this.RemoveBuilding);
        }

        override public function Hide():void
        {
            if (this.mOffsetChanged)
            {
                this.ResetPosition();
            };
            super.Hide();
        }

        override public function Show():void
        {
            this.mOffsetChanged = false;
            super.Show();
        }

        private function MoveRight(_arg_1:MouseEvent):void
        {
            this.mBuilding.ModifyOffsetX(1);
            this.mBuilding.SetPosition(this.mBuilding.GetX(), this.mBuilding.GetY());
            this.mOffsetChanged = true;
            this.CheckMaximumReached();
        }

        private function MoveUp(_arg_1:MouseEvent):void
        {
            this.mBuilding.ModifyOffsetY(-1);
            this.mBuilding.SetPosition(this.mBuilding.GetX(), this.mBuilding.GetY());
            this.mOffsetChanged = true;
            this.CheckMaximumReached();
        }

        public function Init(_arg_1:DecorationInfoPanel):void
        {
            globalFlash.gui.windowController.addWindow(_arg_1);
            this.mGI = (global.ui as cGameInterface);
            AddBaseElement(_arg_1);
            this.mPanel = _arg_1;
            this.mPanel.addEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
        }

        private function MoveDown(_arg_1:MouseEvent):void
        {
            this.mBuilding.ModifyOffsetY(1);
            this.mBuilding.SetPosition(this.mBuilding.GetX(), this.mBuilding.GetY());
            this.mOffsetChanged = true;
            this.CheckMaximumReached();
        }

        private function ResetPosition(_arg_1:MouseEvent=null):void
        {
            this.mBuilding.InitOffsets(this.mInitialOffsetX, this.mInitialOffsetY);
            this.mBuilding.SetPosition(this.mBuilding.GetX(), this.mBuilding.GetY());
            this.mOffsetChanged = false;
            this.CheckMaximumReached();
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
            this.mGI.mCurrentPlayerZone.SendDestructBuildingCommand(this.mBuilding, "cDecorationInfoPanel");
            this.Hide();
        }


    }
}
