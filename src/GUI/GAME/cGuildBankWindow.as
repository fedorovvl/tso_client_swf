package GUI.GAME
{
    import Interface.cGeneralInterface;
    import GuildSystem.cGuildBankTab;
    import GUI.Components.GuildBank;
    import GuildSystem.cGuildBank;
    import mx.events.PropertyChangeEvent;
    import flash.events.Event;
    import Communication.VO.Guild.dGuildRankListItemVO;
    import Communication.VO.Guild.dGuildPlayerListItemVO;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import GUI.Assets.gAssetManager;
    import Communication.VO.Guild.dGuildVO;
    import GUI.Components.CustomAlert;
    import GO.cBuilding;
    import mx.events.FlexEvent;
    import flash.events.MouseEvent;
    import mx.events.ListEvent;
    import ServerState.dResource;
    import __AS3__.vec.Vector;
    import Communication.VO.dContextItemVO;
    import Communication.VO.dBuffVO;
    import BuffSystem.cBuff;
    import Communication.VO.Guild.dGuildBankTabRenameVO;
    import Interface.cGameInterface;
    import mx.core.ClassFactory;
    import GUI.Components.ItemRenderer.BankTabItemRenderer;
    import mx.collections.ArrayCollection;
    import __AS3__.vec.*;

    public class cGuildBankWindow extends cBasicInfoPanel 
    {

        private var mGI:cGeneralInterface;
        private var mGuildBankTab:cGuildBankTab;
        protected var mPanel:GuildBank;
        private var mGuildBank:cGuildBank;
        private var _187883104mIsLeader:Boolean;
        private var mCurrentDisplayed:int;
        private var mLeftMost:int;


        public function set mIsLeader(_arg_1:Boolean):void
        {
            var _local_2:Object = this._187883104mIsLeader;
            if (_local_2 !== _arg_1)
            {
                this._187883104mIsLeader = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "mIsLeader", _local_2, _arg_1));
            };
        }

        private function ButtonLeftPressed(_arg_1:Event):void
        {
            this.SetupTabs((this.mLeftMost - 1));
        }

        private function TransactionHistory(_arg_1:Event):void
        {
            this.Hide();
            globalFlash.gui.mGuildBankTransactionHistory.SetData(this.mGuildBank.GetGuildTransactionHistory());
            globalFlash.gui.mGuildBankTransactionHistory.Show();
        }

        public function closeGuildBankWindow(_arg_1:Event):void
        {
            this.Hide();
        }

        public function ResetAfterError():void
        {
            this.mPanel.busy = false;
            globalFlash.gui.mGuildPayResourcePanel.ResetAfterError();
            this.mGI.RefreshGuildBank();
        }

        override public function SetData(_arg_1:cBuilding):void
        {
            var _local_5:int;
            var _local_6:dGuildRankListItemVO;
            var _local_7:dGuildPlayerListItemVO;
            var _local_8:int;
            var _local_2:String = _arg_1.GetBuildingName_string();
            this.mPanel.description.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.DESCRIPTIONS, _local_2);
            this.mPanel.image.source = gAssetManager.GetBuildingIcon(_local_2);
            var _local_3:cGuildBank = this.mGI.GetCurrentPlayerGuildBank();
            var _local_4:dGuildVO = this.mGI.GetCurrentPlayerGuild();
            if (((!(_local_3)) || (!(_local_4))))
            {
                CustomAlert.show("GuildNoGuild", "GuildNoGuild", 4, null, this.closeGuildBankWindow);
                return;
            };
            for each (_local_7 in _local_4.members)
            {
                if (_local_7.id == this.mGI.mCurrentPlayer.GetPlayerId())
                {
                    _local_5 = _local_7.rankID;
                    break;
                };
            };
            _local_8 = 0;
            while (_local_8 < _local_4.ranks.length)
            {
                _local_6 = (_local_4.ranks.getItemAt(_local_8) as dGuildRankListItemVO);
                if (_local_6.id == _local_5)
                {
                    this.mIsLeader = (_local_8 == 0);
                    break;
                };
                _local_8++;
            };
            this.mGuildBank = _local_3;
            this.mCurrentDisplayed = 1;
            this.mPanel.btnPay.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "GuildBankPayDescription");
            this.mPanel.btnBuyTab.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "GuildBankBuyTabDescription");
            this.mPanel.btnTransactionHistory.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "GuildBankHistoryDescription");
            this.mPanel.btnRefresh.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "GuildBankRefreshDescription");
            this.SetupTabs(0);
            this.ShowTab(1);
        }

        private function completeHandler(event:FlexEvent):void
        {
            this.mPanel.removeEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
            this.mPanel.btnPay.addEventListener(MouseEvent.CLICK, this.PayResource);
            this.mPanel.btnEnlarge.addEventListener(MouseEvent.CLICK, this.Enlarge);
            this.mPanel.btnBuyTab.addEventListener(MouseEvent.CLICK, this.BuyTab);
            this.mPanel.btnTransactionHistory.addEventListener(MouseEvent.CLICK, this.TransactionHistory);
            this.mPanel.btnRefresh.addEventListener(MouseEvent.CLICK, this.RefreshTab);
            this.mPanel.btnClose.addEventListener(MouseEvent.CLICK, this.ClosePanel);
            this.mPanel.buttonBar.addEventListener(ListEvent.ITEM_CLICK, this.SwitchTabViewstack);
            this.mPanel.buttonLeft.addEventListener(MouseEvent.CLICK, this.ButtonLeftPressed);
            this.mPanel.buttonRight.addEventListener(MouseEvent.CLICK, this.ButtonRightPressed);
            this.mPanel.questionmark.addEventListener(MouseEvent.CLICK, this.ShowHelp);
            this.mPanel.resourceList.addEventListener(MouseEvent.CLICK, function (_arg_1:MouseEvent):void
            {
                _arg_1.stopImmediatePropagation();
            });
            this.mPanel.resourceList.addEventListener(ListEvent.ITEM_CLICK, this.ShowContextMenu);
        }

        private function Enlarge(_arg_1:Event):void
        {
            this.Hide();
            globalFlash.gui.mGuildBankEnlargePanel.SetTab(this.mGuildBankTab);
            globalFlash.gui.mGuildBankEnlargePanel.Show();
        }

        private function BuyTab(_arg_1:Event):void
        {
            this.Hide();
            globalFlash.gui.mGuildBankBuyTabPanel.Show();
        }

        public function ReconfigureTabs():void
        {
            this.SetupTabs(this.mLeftMost);
        }

        private function RefreshTab(_arg_1:Event):void
        {
            this.mGI.RefreshGuildBank();
        }

        private function ClosePanel(_arg_1:Event):void
        {
            this.Hide();
        }

        private function ButtonRightPressed(_arg_1:Event):void
        {
            this.SetupTabs((this.mLeftMost + 1));
        }

        public function ShowContextMenu(event:ListEvent):void
        {
            var resource:dResource;
            var items:Vector.<dContextItemVO>;
            var buff:dBuffVO;
            var items2:Vector.<dContextItemVO>;
            event.stopImmediatePropagation();
            if ((event.itemRenderer.data is dResource))
            {
                resource = (event.itemRenderer.data as dResource);
                items = new Vector.<dContextItemVO>();
                items.push(new dContextItemVO("GuildBankWithdraw", function ():void
                {
                    var _local_1:* = new dResource();
                    _local_1.Init(resource.name_string, resource.amount);
                    globalFlash.gui.mGuildTransferResourcePanel.SetData(_local_1, mGuildBankTab.id, "withdraw");
                    globalFlash.gui.mGuildTransferResourcePanel.Show();
                }));
                items.push(new dContextItemVO("GuildBankTransferResources", function ():void
                {
                    var _local_1:* = new dResource();
                    _local_1.Init(resource.name_string, resource.amount);
                    globalFlash.gui.mGuildTransferResourcePanel.SetData(_local_1, mGuildBankTab.id);
                    globalFlash.gui.mGuildTransferResourcePanel.Show();
                }, this.mIsLeader));
                globalFlash.gui.ShowContextMenu(items, event.itemRenderer.stage.mouseX, event.itemRenderer.stage.mouseY);
            }
            else
            {
                if ((event.itemRenderer.data is cBuff))
                {
                    buff = (event.itemRenderer.data as cBuff).CreateBuffVOFromBuff();
                    items2 = new Vector.<dContextItemVO>();
                    items2.push(new dContextItemVO("GuildBankWithdraw", function ():void
                    {
                        globalFlash.gui.mGuildTransferResourcePanel.SetData(buff, mGuildBankTab.id, "withdraw");
                        globalFlash.gui.mGuildTransferResourcePanel.Show();
                    }));
                    items2.push(new dContextItemVO("GuildBankTransferResources", function ():void
                    {
                        globalFlash.gui.mGuildTransferResourcePanel.SetData(buff, mGuildBankTab.id);
                        globalFlash.gui.mGuildTransferResourcePanel.Show();
                    }, this.mIsLeader));
                    globalFlash.gui.ShowContextMenu(items2, event.itemRenderer.stage.mouseX, event.itemRenderer.stage.mouseY);
                };
            };
        }

        [Bindable(event="propertyChange")]
        public function get mIsLeader():Boolean
        {
            return (this._187883104mIsLeader);
        }

        public function RefreshResourcesList():void
        {
            this.ShowTab((this.mPanel.buttonBar.selectedIndex + this.mLeftMost));
        }

        private function SwitchTabViewstack(_arg_1:ListEvent):void
        {
            this.RefreshResourcesList();
        }

        public function RenameTab(_arg_1:int, _arg_2:String):void
        {
            var _local_3:dGuildBankTabRenameVO = new dGuildBankTabRenameVO();
            _local_3.name = _arg_2;
            _local_3.tabID = _arg_1;
        }

        public function Init(_arg_1:GuildBank):void
        {
            AddBaseElement(_arg_1);
            this.mGI = (global.ui as cGameInterface);
            this.mPanel = _arg_1;
            this.mPanel.addEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
        }

        public function SetBusy(_arg_1:Boolean):void
        {
            this.mPanel.busy = _arg_1;
        }

        public function GetCurrentTabId():int
        {
            return (this.mGuildBankTab.id);
        }

        private function PayResource(_arg_1:Event):void
        {
            this.Hide();
            globalFlash.gui.mGuildPayResourcePanel.SetGuildBankTab(this.mGuildBankTab);
            globalFlash.gui.mGuildPayResourcePanel.Show();
        }

        private function ShowTab(_arg_1:int):void
        {
            var _local_4:dResource;
            var _local_5:cBuff;
            this.mCurrentDisplayed = _arg_1;
            if (_arg_1 < this.mGuildBank.GetGuildBankTabs().length)
            {
                this.mGuildBankTab = this.mGuildBank.GetGuildBankTabs()[_arg_1];
            }
            else
            {
                this.mGuildBankTab = this.mGuildBank.GetGuildBankTabs()[0];
            };
            var _local_2:ClassFactory = new ClassFactory(BankTabItemRenderer);
            _local_2.properties = {
                "maxLimit":this.mGuildBankTab.maxResource,
                "maxBuffLimit":this.mGuildBankTab.maxBuff
            };
            this.mPanel.resourceList.itemRenderer = _local_2;
            var _local_3:ArrayCollection = new ArrayCollection();
            for each (_local_4 in this.mGuildBankTab.GetSortedResources())
            {
                if (_local_4.amount > 0)
                {
                    _local_3.addItem(_local_4);
                };
            };
            for each (_local_5 in this.mGuildBankTab.GetSortedBuffs())
            {
                _local_3.addItem(_local_5);
            };
            this.mPanel.resourceList.dataProvider = _local_3;
            if (((!((this.mGuildBankTab.currMaxSizeUpdate + 1) in global.guildBankEnlargeAmount)) || (this.mGuildBankTab.isPaymentTab)))
            {
                this.mPanel.btnEnlarge.enabled = false;
                this.mPanel.btnEnlarge.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "GuildBankEnlargeEnded");
            }
            else
            {
                this.mPanel.btnEnlarge.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "GuildBankEnlargeDescription", [global.guildBankEnlargeAmount[(this.mGuildBankTab.currMaxSizeUpdate + 1)], global.guildBankEnlargeBuffAmount[(this.mGuildBankTab.currMaxSizeUpdate + 1)], this.mGuildBankTab.name]);
                this.mPanel.btnEnlarge.enabled = true;
            };
        }

        public function SetupTabs(_arg_1:int):void
        {
            this.mLeftMost = _arg_1;
            var _local_2:Array = [];
            var _local_3:cGuildBankTab;
            var _local_4:int = _arg_1;
            while (((_local_4 < (_arg_1 + 3)) && (_local_4 < this.mGuildBank.GetGuildBankTabs().length)))
            {
                _local_2.push(this.mGuildBank.GetGuildBankTabs()[_local_4]);
                _local_4++;
            };
            this.mPanel.buttonLeft.enabled = true;
            this.mPanel.buttonRight.enabled = false;
            if (_arg_1 == 0)
            {
                this.mPanel.buttonLeft.enabled = false;
            };
            if (this.mGuildBank.GetGuildBankTabs().length > (3 + _arg_1))
            {
                this.mPanel.buttonRight.enabled = true;
            };
            if (this.mCurrentDisplayed < this.mLeftMost)
            {
                this.ShowTab(this.mLeftMost);
            };
            if (this.mCurrentDisplayed > (this.mLeftMost + 2))
            {
                this.ShowTab((this.mLeftMost + 2));
            };
            var _local_5:dGuildVO = this.mGI.GetCurrentPlayerGuild();
            if (((!((this.mGuildBank.currUpdateCoin + 1) in global.guildBankAditionalTabCostCoin)) && (!((this.mGuildBank.currUpdateGem + 1) in global.guildBankAditionalTabCostGem))))
            {
                this.mPanel.btnBuyTab.enabled = false;
                this.mPanel.btnBuyTab.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "GuildBankMaxTabsReached");
            };
            this.mPanel.buttonBar.dataProvider = _local_2;
            this.mPanel.buttonBar.validateNow();
            this.mPanel.buttonBar.selectedIndex = (this.mCurrentDisplayed - this.mLeftMost);
        }

        private function ShowHelp(_arg_1:MouseEvent):void
        {
            globalFlash.gui.mHelpOverview.ShowItem(global.map_HelpName_HelpDefinition["Help_window_guild_bank_0"], 1);
            globalFlash.gui.mHelpOverview.Show();
        }


    }
}
