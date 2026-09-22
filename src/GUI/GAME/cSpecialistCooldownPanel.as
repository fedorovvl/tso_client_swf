package GUI.GAME
{
    import Specialists.cSpecialistTask;
    import Specialists.cSpecialist;
    import Interface.cGameInterface;
    import GUI.Components.SpecialistCooldownPanel;
    import flash.events.Event;
    import GUI.Components.ToolTips.cToolTipUtil;
    import mx.events.ToolTipEvent;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import Enums.SPECIALIST_TYPE;
    import mx.events.FlexEvent;
    import flash.events.MouseEvent;
    import ServerState.cResources;
    import Enums.COMMAND;
    import Communication.VO.dBuyOneClickShopItemVO;
    import Enums.ONE_CLICK_SHOPITEM;
    import GUI.Components.CustomAlert;
    import mx.controls.Alert;
    import mx.events.CloseEvent;

    public class cSpecialistCooldownPanel extends cBasicPanel 
    {

        protected var task:cSpecialistTask;
        private var descriptionText:String;
        protected var mSpecialist:cSpecialist;
        private var mGI:cGameInterface;
        protected var mPanel:SpecialistCooldownPanel;


        private function ClosePanel(_arg_1:Event):void
        {
            this.Hide();
        }

        private function onCreateToolTip(_arg_1:ToolTipEvent):void
        {
            this.mPanel.btnPay.toolTip = "HalveTimeCost";
            cToolTipUtil.createToolTip(cToolTipUtil.INSTANT_BUILD_string, _arg_1, this.mSpecialist.GetTask().getSpeedUpCosts());
        }

        public function SetData(_arg_1:cSpecialist):void
        {
            var _local_2:cLocaManager = cLocaManager.GetInstance();
            this.mSpecialist = _arg_1;
            this.mPanel.specialistRenderer.data = _arg_1;
            this.mPanel.headline.htmlText = _arg_1.getName(false);
            var _local_3:String = _local_2.GetText(LOCA_GROUP.DESCRIPTIONS, SPECIALIST_TYPE.toString(_arg_1.GetType()));
            if (_local_3 != this.descriptionText)
            {
                this.descriptionText = _local_3;
                this.mPanel.description.text = this.descriptionText;
            };
            this.mPanel.timeRemain.text = ((_local_2.GetText(LOCA_GROUP.LABELS, "TimeRemaining") + " ") + _local_2.FormatDuration(this.mSpecialist.GetTask().GetRemainingTime()));
            this.mPanel.btnPay.enabled = true;
        }

        public function Init(_arg_1:SpecialistCooldownPanel):void
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
            this.mPanel.btnOK.addEventListener(MouseEvent.CLICK, this.ClosePanel);
            this.mPanel.btnPay.addEventListener(MouseEvent.CLICK, this.onAccelerateClick);
            this.mPanel.btnPay.addEventListener(ToolTipEvent.TOOL_TIP_CREATE, this.onCreateToolTip);
        }

        protected function onAccelerateClick(_arg_1:MouseEvent):void
        {
            var _local_2:cResources = this.mGI.mCurrentPlayerZone.GetResources(this.mGI.mCurrentPlayer);
            if ((((_local_2 == null) || (this.mSpecialist == null)) || (this.mSpecialist.GetTask() == null)))
            {
                return;
            };
            if (_local_2.HasPlayerResource(defines.HARD_CURRENCY_RESOURCE_NAME_string, this.mSpecialist.GetTask().getSpeedUpCosts()))
            {
                global.ui.mClientMessages.SendMessagetoServer(COMMAND.BUY_ONE_CLICK_SHOP_ITEM, this.mGI.mCurrentViewedZoneID, new dBuyOneClickShopItemVO().InitWithUniqueID(ONE_CLICK_SHOPITEM.HALF_SPECIALIST_TIME, this.mSpecialist.GetUniqueID()));
                this.mPanel.btnPay.enabled = false;
            }
            else
            {
                CustomAlert.show("MissingHardCurrency", "", (Alert.OK | Alert.CANCEL), null, this.AddHardCurrencyHandler, null, Alert.OK, true, CustomAlert.STYLE_PAYMENT);
            };
        }

        private function AddHardCurrencyHandler(_arg_1:CloseEvent):void
        {
            if (_arg_1.detail == Alert.OK)
            {
                globalFlash.gui.mShopWindow.AddHardCurrency(null);
            };
        }

        public function Refresh():void
        {
            if (this.mSpecialist)
            {
                this.SetData(this.mSpecialist);
            };
        }


    }
}
