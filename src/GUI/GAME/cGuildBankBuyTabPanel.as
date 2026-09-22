package GUI.GAME
{
    import Interface.cGameInterface;
    import GUI.Components.GuildBankBuyTabPanel;
    import Communication.VO.Guild.dGuildBankBuyTabVO;
    import GUI.Components.CustomAlert;
    import mx.controls.Alert;
    import Enums.COMMAND;
    import flash.events.Event;
    import mx.events.CloseEvent;
    import mx.events.FlexEvent;
    import flash.events.MouseEvent;
    import Communication.VO.dResourceVO;
    import GUI.Components.ItemRenderer.ResourceItemRenderer;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;

    public class cGuildBankBuyTabPanel extends cBasicInfoPanel 
    {

        protected var mGI:cGameInterface;
        protected var mPanel:GuildBankBuyTabPanel;


        private function BuyTabGem(_arg_1:Event):void
        {
            var _local_2:dGuildBankBuyTabVO = new dGuildBankBuyTabVO();
            _local_2.costGems = global.guildBankAditionalTabCostGem[(this.mGI.GetCurrentPlayerGuildBank().currUpdateGem + 1)];
            if (!this.mGI.mCurrentPlayerZone.GetResources(global.ui.mCurrentPlayer).HasPlayerResource(defines.HARD_CURRENCY_RESOURCE_NAME_string, _local_2.costGems))
            {
                CustomAlert.show("ItemPurchaseSwitchToBuyGems", "", (Alert.OK | Alert.CANCEL), null, this.ConfirmAddHardCurrency, null, Alert.OK, true, CustomAlert.STYLE_PAYMENT);
                return;
            };
            this.mGI.mClientMessages.SendMessagetoServer(COMMAND.GUILD_BANK_BUY_TAB, this.mGI.mCurrentViewedZoneID, _local_2);
            this.Hide();
            globalFlash.gui.mGuildBankWindow.Show();
            globalFlash.gui.mGuildBankWindow.SetBusy(true);
        }

        private function ConfirmAddHardCurrency(_arg_1:CloseEvent):void
        {
            if (_arg_1.detail == Alert.OK)
            {
                globalFlash.gui.mShopWindow.AddHardCurrency(null);
            };
        }

        private function BuyTabCoin(_arg_1:Event):void
        {
            var _local_2:dGuildBankBuyTabVO = new dGuildBankBuyTabVO();
            _local_2.costCoins = global.guildBankAditionalTabCostCoin[(this.mGI.GetCurrentPlayerGuildBank().currUpdateCoin + 1)];
            this.mGI.mClientMessages.SendMessagetoServer(COMMAND.GUILD_BANK_BUY_TAB, this.mGI.mCurrentViewedZoneID, _local_2);
            this.Hide();
            globalFlash.gui.mGuildBankWindow.Show();
            globalFlash.gui.mGuildBankWindow.SetBusy(true);
        }

        private function ClosePanel(_arg_1:Event):void
        {
            this.Hide();
            globalFlash.gui.mGuildBankWindow.Show();
        }

        public function Init(_arg_1:GuildBankBuyTabPanel):void
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
            this.mPanel.btnBuyTabCoin.addEventListener(MouseEvent.CLICK, this.BuyTabCoin);
            this.mPanel.btnBuyTabGem.addEventListener(MouseEvent.CLICK, this.BuyTabGem);
        }

        override public function Show():void
        {
            var _local_1:int;
            var _local_3:dResourceVO;
            var _local_4:ResourceItemRenderer;
            var _local_5:dResourceVO;
            _local_1 = (this.mGI.GetCurrentPlayerGuildBank().currUpdateCoin + 1);
            this.mPanel.btnBuyTabCoin.toolTip = null;
            if ((_local_1 in global.guildBankAditionalTabCostCoin))
            {
                _local_3 = new dResourceVO();
                _local_3.name_string = defines.GUILDCOIN_RESOURCE_NAME_string;
                _local_3.amount = global.guildBankAditionalTabCostCoin[_local_1];
                this.mPanel.costListItemRenderer.data = _local_3;
                if (this.mGI.GetCurrentPlayerGuildBank().GetPaymentTab().hasAccess)
                {
                    this.mPanel.btnBuyTabCoin.enabled = this.mGI.GetCurrentPlayerGuildBank().GetPaymentTab().HasPlayerResource(defines.GUILDCOIN_RESOURCE_NAME_string, global.guildBankAditionalTabCostCoin[_local_1]);
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
            var _local_2:int = (this.mGI.GetCurrentPlayerGuildBank().currUpdateGem + 1);
            if ((_local_2 in global.guildBankAditionalTabCostGem))
            {
                this.mPanel.btnBuyTabGem.enabled = true;
                _local_4 = new ResourceItemRenderer();
                _local_5 = new dResourceVO();
                _local_5.name_string = defines.HARD_CURRENCY_RESOURCE_NAME_string;
                _local_5.amount = global.guildBankAditionalTabCostGem[_local_2];
                this.mPanel.gemCostItemRenderer.data = _local_5;
            }
            else
            {
                this.mPanel.btnBuyTabGem.enabled = false;
            };
            super.Show();
        }


    }
}
