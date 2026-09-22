package GUI.GAME
{
    import Interface.cGameInterface;
    import GUI.Components.DonateResourcePanel;
    import ServerState.dResource;
    import mx.controls.Alert;
    import Communication.VO.dBuffVO;
    import Communication.VO.dBankDonationVO;
    import Enums.COMMAND;
    import mx.events.CloseEvent;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import flash.events.FocusEvent;
    import mx.events.FlexEvent;
    import mx.events.SliderEvent;
    import flash.events.Event;
    import GUI.Components.CustomAlert;

    public class cDonateResourcePanel extends cBasicPanel 
    {

        private static var waitingForServer:Boolean = false;

        private var gi:cGameInterface;
        protected var panel:DonateResourcePanel;
        public var resource:dResource;


        public function serverResponseReceived():void
        {
            this.panel.busyOverlay.visible = (waitingForServer = false);
        }

        private function donateResource(_arg_1:CloseEvent):void
        {
            if (_arg_1.detail != Alert.OK)
            {
                return;
            };
            this.panel.busyOverlay.visible = (waitingForServer = true);
            var _local_2:dBuffVO = new dBuffVO();
            _local_2.amount = Math.min(Math.max(1, this.selectedAmount), this.panel.amountSlider.maximum);
            _local_2.buffName_string = defines.DONATE_TEMP_BUFF;
            _local_2.uniqueId1 = -1;
            _local_2.resourceName_string = this.resource.name_string;
            var _local_3:dBankDonationVO = new dBankDonationVO();
            _local_3.buff = _local_2;
            this.gi.mClientMessages.SendMessagetoServer(COMMAND.EVENT_DONATE_RESOURCE, this.gi.mCurrentViewedZoneID, _local_3);
            this.Hide();
        }

        public function setData(_arg_1:dResource):void
        {
            this.resource = _arg_1;
            this.panel.amountSlider.maximum = _arg_1.amount;
            this.panel.amountSlider.minimum = 1;
            this.panel.amountSlider.value = 1;
            this.panel.selectedAmount.text = "1";
            this.panel.maximumCount.text = ("/ " + _arg_1.amount);
            this.panel.resourceRenderer.resourceName = _arg_1.name_string;
            this.panel.resourceName.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.RESOURCES, _arg_1.name_string);
            this.panel.label = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "DonateResource", [this.panel.resourceName.text]);
        }

        private function amountTextFocusOutHandler(_arg_1:FocusEvent):void
        {
            if (int(this.panel.selectedAmount.text) > this.panel.amountSlider.maximum)
            {
                this.panel.selectedAmount.text = String(this.panel.amountSlider.maximum);
            };
        }

        public function Init(_arg_1:DonateResourcePanel):void
        {
            this.gi = (global.ui as cGameInterface);
            globalFlash.gui.windowController.addWindow(_arg_1);
            this.panel = _arg_1;
            AddBaseElement(this.panel);
            this.panel.btnClose.addEventListener(FlexEvent.BUTTON_DOWN, this.closePanel);
            this.panel.btnCancel.addEventListener(FlexEvent.BUTTON_DOWN, this.closePanel);
            this.panel.btnDonate.addEventListener(FlexEvent.BUTTON_DOWN, this.confirmDonateResource);
            this.panel.amountSlider.addEventListener(SliderEvent.CHANGE, this.setAmountBySlider);
            this.panel.selectedAmount.addEventListener(SliderEvent.CHANGE, this.setAmountByText);
            this.panel.selectedAmount.addEventListener(FocusEvent.FOCUS_OUT, this.amountTextFocusOutHandler);
        }

        override public function Hide():void
        {
            this.panel.visible = false;
            globalFlash.gui.windowController.closeModal();
            notifyPropertyObserver("hide", this.panel.id);
        }

        private function setAmountBySlider(_arg_1:SliderEvent):void
        {
            this.panel.selectedAmount.text = String(_arg_1.value);
        }

        private function closePanel(_arg_1:Event):void
        {
            this.Hide();
        }

        override public function Show():void
        {
            this.panel.visible = true;
            this.panel.busyOverlay.visible = waitingForServer;
            notifyPropertyObserver("show", this.panel.id);
        }

        private function get selectedAmount():int
        {
            return (int(this.panel.selectedAmount.text));
        }

        private function setAmountByText(_arg_1:Event):void
        {
            this.panel.amountSlider.value = int(this.panel.selectedAmount.text);
        }

        private function confirmDonateResource(_arg_1:Event):void
        {
            CustomAlert.show("ConfirmDonateResource", "ConfirmDonateResource", (Alert.CANCEL | Alert.OK), this.panel, this.donateResource);
        }


    }
}
