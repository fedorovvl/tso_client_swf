package GUI.GAME
{
    import GUI.Components.ApplyBuffResourcePanel;
    import BuffSystem.cBuff;
    import Interface.cGameInterface;
    import mx.events.FlexEvent;
    import flash.events.MouseEvent;
    import mx.events.SliderEvent;
    import flash.events.FocusEvent;
    import Enums.COMMAND;
    import flash.events.Event;
    import com.bluebyte.tso.util.HotkeyManager;
    import GO.cDeposit;
    import Specialists.cSpecialist;
    import Utils.StringUtils;
    import Enums.BUFF_UI;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;

    public class cApplyBuffResourcePanel extends cBasicPanel 
    {

        private var lastQuantity:int;
        protected var panel:ApplyBuffResourcePanel;
        private var lastBuff:cBuff;
        public var buff:cBuff;
        private var gi:cGameInterface;
        private var cursorGrid:int;


        private function completeHandler(_arg_1:FlexEvent):void
        {
            this.panel.removeEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
            this.panel.btnClose.addEventListener(MouseEvent.CLICK, this.closePanel);
            this.panel.btnCancel.addEventListener(MouseEvent.CLICK, this.closePanel);
            this.panel.btnApply.addEventListener(MouseEvent.CLICK, this.applyResource);
            this.panel.amountSlider.addEventListener(SliderEvent.CHANGE, this.setAmountBySlider);
            this.panel.selectedAmount.addEventListener(SliderEvent.CHANGE, this.setAmountByText);
            this.panel.selectedAmount.addEventListener(FocusEvent.FOCUS_OUT, this.amountTextFocusOutHandler);
        }

        private function setAmountBySlider(_arg_1:SliderEvent):void
        {
            this.panel.selectedAmount.text = String(_arg_1.value);
        }

        private function get selectedAmount():int
        {
            return (int(this.panel.selectedAmount.text));
        }

        private function applyResource(_arg_1:MouseEvent=null):void
        {
            this.gi.SendServerAction(COMMAND.APPLY_BUFF, 0, this.cursorGrid, this.selectedAmount, this.buff.GetUniqueId());
            this.buff.IncWaitingForServerCountBy(this.gi, this.selectedAmount);
            this.lastBuff = this.buff;
            this.lastQuantity = this.selectedAmount;
            this.Hide();
        }

        private function setAmountByText(_arg_1:Event):void
        {
            if (Number(this.panel.selectedAmount.text) > this.panel.amountSlider.maximum)
            {
                this.panel.selectedAmount.text = String(this.panel.amountSlider.maximum);
            };
            this.panel.amountSlider.value = Number(this.panel.selectedAmount.text);
        }

        override public function Show():void
        {
            this.panel.visible = true;
            notifyPropertyObserver("show", this.panel.id);
            globalFlash.gui.mCancelActionPanel.Hide();
            globalFlash.gui.windowController.setTop(this.panel, true);
            HotkeyManager.getInstance().setConfirmActions(this.applyResource, this.Hide);
        }

        private function closePanel(_arg_1:Event):void
        {
            this.Hide();
        }

        private function amountTextFocusOutHandler(_arg_1:FocusEvent):void
        {
            if (Number(this.panel.selectedAmount.text) > this.panel.amountSlider.maximum)
            {
                this.panel.selectedAmount.text = String(this.panel.amountSlider.maximum);
            };
        }

        public function Init(_arg_1:ApplyBuffResourcePanel):void
        {
            this.gi = (global.ui as cGameInterface);
            globalFlash.gui.windowController.addWindow(_arg_1);
            this.panel = _arg_1;
            AddBaseElement(this.panel);
            this.panel.addEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
        }

        override public function Hide():void
        {
            this.panel.visible = false;
            globalFlash.gui.windowController.closeModal();
            notifyPropertyObserver("hide", this.panel.id);
            HotkeyManager.getInstance().clearConfirmActions();
            globalFlash.gui.mCancelActionPanel.Show();
        }

        public function setData(_arg_1:cBuff, _arg_2:int):void
        {
            var _local_4:String;
            var _local_5:cDeposit;
            var _local_6:cSpecialist;
            var _local_7:int;
            this.buff = _arg_1;
            this.cursorGrid = _arg_2;
            var _local_3:Number = _arg_1.GetInstantAmount();
            if (this.lastBuff == _arg_1)
            {
                _local_3 = Math.min(_arg_1.amount, this.lastQuantity);
            }
            else
            {
                this.lastBuff = null;
            };
            if (StringUtils.contains(",", _arg_1.GetBuffDefinition().GetResourceName_string()))
            {
                _local_5 = global.ui.mCurrentPlayerZone.mStreetDataMap.mDepositContainer.get(_arg_2);
                if (_local_5 != null)
                {
                    _local_4 = _local_5.GetName_string();
                };
            }
            else
            {
                if (_arg_1.GetBuffDefinition().getBuffUI() == BUFF_UI.STACK_RESOURCE)
                {
                    _local_4 = _arg_1.GetBuffDefinition().GetName_string();
                }
                else
                {
                    _local_4 = _arg_1.GetResourceName_string();
                };
            };
            this.panel.amountSlider.maximum = _arg_1.GetInstantAmount();
            if (_arg_1.GetBuffDefinition().GetId() == defines.HIRED_MILITARY_BUFF_ID)
            {
                _local_6 = global.ui.mCurrentPlayerZone.getSpecialistByGarrison(_arg_2);
                if (_local_6)
                {
                    _local_7 = (_local_6.GetMaxMilitaryUnits() - _local_6.GetArmy().GetUnitsCount());
                    this.panel.amountSlider.maximum = Math.min(_local_7, this.panel.amountSlider.maximum);
                    _local_3 = Math.min(_local_3, _local_7);
                };
            };
            this.panel.amountSlider.minimum = 1;
            this.panel.amountSlider.value = _local_3;
            this.panel.selectedAmount.text = _local_3.toString();
            this.panel.maximumCount.text = ("/ " + this.panel.amountSlider.maximum);
            this.panel.resourceRenderer.resourceName = _local_4;
            this.panel.resourceName.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.RESOURCES, _local_4);
            this.panel.selectedAmount.setFocus();
            this.panel.selectedAmount.setSelection(0, this.panel.selectedAmount.length);
        }


    }
}
