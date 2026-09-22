package GUI.GAME
{
    import Interface.cGameInterface;
    import GUI.Components.DeleteBuffResourcePanel;
    import BuffSystem.cBuff;
    import flash.events.Event;
    import flash.events.FocusEvent;
    import mx.events.FlexEvent;
    import flash.events.MouseEvent;
    import mx.events.SliderEvent;
    import Enums.COMMAND;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;

    public class cDeleteBuffResourcePanel extends cBasicPanel 
    {

        private static var waitingForServer:Boolean = false;

        private var gi:cGameInterface;
        protected var panel:DeleteBuffResourcePanel;
        public var buff:cBuff;
        private var cursorGrid:int;


        override public function Hide():void
        {
            this.panel.visible = false;
            globalFlash.gui.windowController.closeModal();
            notifyPropertyObserver("hide", this.panel.id);
        }

        override public function Show():void
        {
            this.panel.visible = true;
            notifyPropertyObserver("show", this.panel.id);
            globalFlash.gui.windowController.setTop(this.panel, true);
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

        public function Init(_arg_1:DeleteBuffResourcePanel):void
        {
            this.gi = (global.ui as cGameInterface);
            globalFlash.gui.windowController.addWindow(_arg_1);
            this.panel = _arg_1;
            AddBaseElement(this.panel);
            this.panel.addEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
        }

        private function completeHandler(_arg_1:FlexEvent):void
        {
            this.panel.removeEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
            this.panel.btnClose.addEventListener(MouseEvent.CLICK, this.closePanel);
            this.panel.btnCancel.addEventListener(MouseEvent.CLICK, this.closePanel);
            this.panel.btnApply.addEventListener(MouseEvent.CLICK, this.removeBuff);
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

        private function removeBuff(_arg_1:MouseEvent):void
        {
            this.buff.SetWaitingForServerCount(this.selectedAmount, this.gi);
            globalFlash.gui.mStarMenu.Refresh();
            this.gi.SendServerAction(COMMAND.REMOVE_BUFF, 0, 0, this.selectedAmount, this.buff.GetUniqueId());
            this.Hide();
        }

        public function setData(_arg_1:cBuff):void
        {
            var _local_3:String;
            var _local_4:String;
            this.buff = _arg_1;
            var _local_2:Number = _arg_1.GetAmount();
            this.panel.amountSlider.maximum = _local_2;
            this.panel.amountSlider.minimum = 0;
            this.panel.amountSlider.value = _local_2;
            this.panel.selectedAmount.text = String(_local_2);
            this.panel.maximumCount.text = ("/ " + _local_2);
            if (_arg_1.GetBuffDefinition().GetName_string() == "Adventure")
            {
                _local_3 = _arg_1.GetResourceName_string();
                _local_4 = cLocaManager.GetInstance().GetText(LOCA_GROUP.ADVENTURE_NAME, _local_3);
            }
            else
            {
                if (_arg_1.GetBuffDefinition().GetName_string() == "BuildBuilding")
                {
                    _local_3 = _arg_1.GetResourceName_string();
                    _local_4 = cLocaManager.GetInstance().GetText(LOCA_GROUP.BUILDINGS, _local_3);
                }
                else
                {
                    if (_arg_1.GetBuffDefinition().GetName_string().indexOf("ProductivityBuff") >= 0)
                    {
                        _local_3 = _arg_1.GetBuffDefinition().GetName_string();
                        _local_4 = cLocaManager.GetInstance().GetText(LOCA_GROUP.RESOURCES, _local_3);
                    }
                    else
                    {
                        if (_arg_1.GetBuffDefinition().GetName_string() != "AddResource")
                        {
                            _local_3 = _arg_1.GetBuffDefinition().GetName_string();
                            _local_4 = cLocaManager.GetInstance().GetText(LOCA_GROUP.RESOURCES, _local_3);
                        }
                        else
                        {
                            _local_3 = _arg_1.GetResourceName_string();
                            _local_4 = cLocaManager.GetInstance().GetText(LOCA_GROUP.RESOURCES, _local_3);
                        };
                    };
                };
            };
            this.panel.starItem.data = _arg_1;
            this.panel.starItem.removeIcon.visible = false;
            this.panel.starItem.amountLabel.visible = false;
            this.panel.starItem.frame.visible = false;
            this.panel.resourceName.text = _local_4;
            this.panel.description.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.ALERT_MESSAGES, "ConfirmRemoveBuff", [_local_4]);
        }

        private function setAmountByText(_arg_1:Event):void
        {
            if (Number(this.panel.selectedAmount.text) > this.panel.amountSlider.maximum)
            {
                this.panel.selectedAmount.text = String(this.panel.amountSlider.maximum);
            };
            this.panel.amountSlider.value = Number(this.panel.selectedAmount.text);
        }


    }
}
