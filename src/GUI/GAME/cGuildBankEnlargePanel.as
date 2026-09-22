package GUI.GAME
{
    import Interface.cGameInterface;
    import GuildSystem.cGuildBankTab;
    import GUI.Components.GuildBankEnlargeTabPanel;
    import Communication.VO.Guild.dGuildBankEnlargeVO;
    import Enums.COMMAND;
    import flash.events.Event;
    import GUI.Components.ItemRenderer.ResourceItemRenderer;
    import Communication.VO.dResourceVO;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import mx.events.FlexEvent;
    import flash.events.MouseEvent;
    import GUI.Components.CustomAlert;
    import mx.controls.Alert;
    import mx.events.CloseEvent;

    public class cGuildBankEnlargePanel extends cBasicInfoPanel 
    {

        private var mGI:cGameInterface;
        private var mGuildBankTab:cGuildBankTab;
        protected var mPanel:GuildBankEnlargeTabPanel;


        private function EnlargeCoin(_arg_1:Event):void
        {
            var _local_2:dGuildBankEnlargeVO = new dGuildBankEnlargeVO();
            _local_2.tabID = this.mGuildBankTab.id;
            _local_2.costCoins = global.guildBankEnlargeCostCoin[(this.mGuildBankTab.currMaxSizeUpdate + 1)];
            this.mGI.mClientMessages.SendMessagetoServer(COMMAND.GUILD_BANK_ENLARGE, this.mGI.mCurrentViewedZoneID, _local_2);
            this.Hide();
            globalFlash.gui.mGuildBankWindow.Show();
            globalFlash.gui.mGuildBankWindow.SetBusy(true);
        }

        override public function Show():void
        {
            var _local_2:ResourceItemRenderer;
            var _local_3:dResourceVO;
            var _local_4:ResourceItemRenderer;
            var _local_5:dResourceVO;
            var _local_1:int = (this.mGuildBankTab.currMaxSizeUpdate + 1);
            if ((_local_1 in global.guildBankEnlargeCostCoin))
            {
                _local_2 = new ResourceItemRenderer();
                _local_3 = new dResourceVO();
                _local_3.name_string = defines.GUILDCOIN_RESOURCE_NAME_string;
                _local_3.amount = global.guildBankEnlargeCostCoin[_local_1];
                this.mPanel.costListItemRenderer.data = _local_3;
                if (this.mGI.GetCurrentPlayerGuildBank().GetPaymentTab().hasAccess)
                {
                    this.mPanel.btnBuyTabCoin.enabled = this.mGI.GetCurrentPlayerGuildBank().GetPaymentTab().HasPlayerResource(defines.GUILDCOIN_RESOURCE_NAME_string, global.guildBankEnlargeCostCoin[_local_1]);
                }
                else
                {
                    this.mPanel.btnBuyTabCoin.enabled = false;
                    this.mPanel.btnBuyTabCoin.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "GuildBankNoAccessToPayTab");
                };
            }
            else
            {
                this.mPanel.btnBuyTabCoin.enabled = false;
            };
            if ((_local_1 in global.guildBankEnlargeCostGem))
            {
                this.mPanel.btnBuyTabGem.enabled = true;
                _local_4 = new ResourceItemRenderer();
                _local_5 = new dResourceVO();
                _local_5.name_string = defines.HARD_CURRENCY_RESOURCE_NAME_string;
                _local_5.amount = global.guildBankEnlargeCostGem[_local_1];
                this.mPanel.gemCostItemRenderer.data = _local_5;
            }
            else
            {
                this.mPanel.btnBuyTabGem.enabled = false;
            };
            this.mPanel.enlargeDescription.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "GuildBankEnlargeDescription", [global.guildBankEnlargeAmount[_local_1], global.guildBankEnlargeBuffAmount[_local_1], this.mGuildBankTab.name]);
            super.Show();
        }

        private function ClosePanel(_arg_1:Event):void
        {
            this.Hide();
            globalFlash.gui.mGuildBankWindow.Show();
        }

        public function Init(_arg_1:GuildBankEnlargeTabPanel):void
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
            this.mPanel.btnCancel.addEventListener(MouseEvent.CLICK, this.ClosePanel);
            this.mPanel.btnBuyTabCoin.addEventListener(MouseEvent.CLICK, this.EnlargeCoin);
            this.mPanel.btnBuyTabGem.addEventListener(MouseEvent.CLICK, this.EnlargeGem);
        }

        private function EnlargeGem(_arg_1:Event):void
        {
            var _local_2:dGuildBankEnlargeVO = new dGuildBankEnlargeVO();
            _local_2.tabID = this.mGuildBankTab.id;
            _local_2.costGems = global.guildBankEnlargeCostGem[(this.mGuildBankTab.currMaxSizeUpdate + 1)];
            if (!this.mGI.mCurrentPlayerZone.GetResources(global.ui.mCurrentPlayer).HasPlayerResource(defines.HARD_CURRENCY_RESOURCE_NAME_string, _local_2.costGems))
            {
                CustomAlert.show("ItemPurchaseSwitchToBuyGems", "", (Alert.OK | Alert.CANCEL), null, this.ConfirmAddHardCurrency, null, Alert.OK, true, CustomAlert.STYLE_PAYMENT);
                return;
            };
            this.mGI.mClientMessages.SendMessagetoServer(COMMAND.GUILD_BANK_ENLARGE, this.mGI.mCurrentViewedZoneID, _local_2);
            this.Hide();
            globalFlash.gui.mGuildBankWindow.Show();
            globalFlash.gui.mGuildBankWindow.SetBusy(true);
        }

        public function SetTab(_arg_1:cGuildBankTab):void
        {
            this.mGuildBankTab = _arg_1;
        }

        private function ConfirmAddHardCurrency(_arg_1:CloseEvent):void
        {
            if (_arg_1.detail == Alert.OK)
            {
                globalFlash.gui.mShopWindow.AddHardCurrency(null);
            };
        }


    }
}
