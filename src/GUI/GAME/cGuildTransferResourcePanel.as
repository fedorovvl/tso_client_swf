package GUI.GAME
{
    import Communication.VO.dResourceVO;
    import Communication.VO.dBuffVO;
    import Interface.cGameInterface;
    import GUI.Components.GuildTransferResourcePanel;
    import flash.events.Event;
    import GuildSystem.cGuildBankTab;
    import GuildSystem.cGuildBank;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import ServerState.dResource;
    import GUI.Assets.gAssetManager;
    import BuffSystem.cBuff;
    import AdventureSystem.cAdventureDefinition;
    import Communication.VO.Guild.dGuildBankWithdrawVO;
    import Communication.VO.Guild.dGuildBankTransferVO;
    import Enums.COMMAND;
    import mx.events.FlexEvent;
    import flash.events.MouseEvent;
    import mx.events.SliderEvent;
    import mx.events.ListEvent;

    public class cGuildTransferResourcePanel extends cBasicPanel 
    {

        private var mSelectedResourceVO:dResourceVO = null;
        private var mSelectedBuffVO:dBuffVO = null;
        private var mGI:cGameInterface;
        protected var mPanel:GuildTransferResourcePanel;


        private function ChangeResourceInputAmount(_arg_1:Event):void
        {
            if (int(this.mPanel.selectedCount.text) == 0)
            {
                this.mPanel.selectedCount.text = "1";
                this.mPanel.selectedCount.setSelection(0, 1);
            };
            if (int(this.mPanel.selectedCount.text) > this.mPanel.amountSlider.maximum)
            {
                this.mPanel.selectedCount.text = String(this.mPanel.amountSlider.maximum);
            };
            this.mPanel.amountSlider.value = int(this.mPanel.selectedCount.text);
        }

        public function SetData(_arg_1:Object, _arg_2:int, _arg_3:String=""):void
        {
            var _local_6:cGuildBankTab;
            var _local_7:String;
            var _local_8:String;
            var _local_9:Boolean;
            var _local_10:int;
            var _local_11:String;
            this.mPanel.btnOK.enabled = false;
            this.mPanel.currentState = _arg_3;
            var _local_4:cGuildBank = this.mGI.GetCurrentPlayerGuildBank();
            var _local_5:Array = [];
            if (_arg_3 == "withdraw")
            {
                this.mPanel.label = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "WithdrawResource");
                this.mPanel.btnOK.enabled = true;
            }
            else
            {
                this.mPanel.label = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "TransferResource");
            };
            for each (_local_6 in _local_4.GetGuildBankTabs())
            {
                if (((!(_local_6.id == _arg_2)) && ((!(_local_6.isPaymentTab)) || ((_arg_1 is dResource) && (!(global.guildBankPayTabAllowedResources.indexOf(dResource(_arg_1).name_string) == -1))))))
                {
                    _local_5.push(_local_6);
                };
            };
            if (this.mPanel.guildTabsGrid)
            {
                this.mPanel.guildTabsGrid.dataProvider = _local_5;
            };
            if ((_arg_1 is dResource))
            {
                this.mSelectedResourceVO = new dResourceVO();
                this.mSelectedResourceVO.name_string = _arg_1.name_string;
                this.mSelectedBuffVO = null;
                this.mPanel.resourceIcon.source = gAssetManager.GetResourceIcon(this.mSelectedResourceVO.name_string);
                this.mPanel.resourceName.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.RESOURCES, this.mSelectedResourceVO.name_string);
                this.mPanel.selectedCount.visible = true;
                this.mPanel.maximumCount.visible = true;
                this.mPanel.amountSlider.visible = true;
                this.mPanel.amountSlider.maximum = Math.floor(_arg_1.amount);
                this.mPanel.amountSlider.enabled = (_arg_1.amount > 1);
                this.mPanel.amountSlider.value = 1;
            }
            else
            {
                this.mSelectedResourceVO = null;
                this.mSelectedBuffVO = (_arg_1 as dBuffVO);
                _local_7 = this.mSelectedBuffVO.buffName_string;
                _local_8 = this.mSelectedBuffVO.resourceName_string;
                _local_9 = true;
                _local_10 = this.mSelectedBuffVO.amount;
                this.mPanel.selectedCount.visible = false;
                this.mPanel.maximumCount.visible = false;
                this.mPanel.amountSlider.visible = false;
                this.mPanel.resourceName.text = cBuff.CreateBuffFromVO(this.mSelectedBuffVO).getLocalizedBuffName();
                if ((((_local_7.indexOf(defines.ADD_RESOURCE_BUFF) == 0) || (_local_7.indexOf(defines.FILL_DEPOSIT_BUFF) == 0)) || (_local_7 == defines.HIRED_MILITARY_BUFF)))
                {
                    if (_local_8 != "")
                    {
                        this.mPanel.foregroundIcon.visible = true;
                        this.mPanel.foregroundIcon.source = gAssetManager.GetResourceIcon(_local_8, _local_9);
                    }
                    else
                    {
                        this.mPanel.foregroundIcon.visible = false;
                    };
                    this.mPanel.resourceIcon.source = gAssetManager.GetBuffIcon(_local_7, _local_9);
                }
                else
                {
                    if (_local_7 == defines.BUILD_BUILDING_BUFF)
                    {
                        this.mPanel.foregroundIcon.visible = false;
                        this.mPanel.resourceIcon.source = gAssetManager.GetBuildingIcon(_local_8, _local_9);
                    }
                    else
                    {
                        if (_local_7 == defines.ADVENTURE_BUFF)
                        {
                            this.mPanel.foregroundIcon.visible = false;
                            _local_11 = cAdventureDefinition.FindAdventureDefinition(_local_8).GetType_string();
                            this.mPanel.resourceIcon.source = cAdventureDefinition.GetAdventureIcon(_local_8, _local_9);
                        }
                        else
                        {
                            if (_local_7.indexOf(defines.CHANGE_COLOR_SCHEME_BUFF) == 0)
                            {
                                this.mPanel.foregroundIcon.visible = false;
                                this.mPanel.resourceIcon.source = gAssetManager.GetBuffIcon(((defines.CHANGE_COLOR_SCHEME_BUFF + "_") + _local_8), _local_9);
                            }
                            else
                            {
                                this.mPanel.foregroundIcon.visible = false;
                                this.mPanel.resourceIcon.source = gAssetManager.GetBuffIcon(_local_7, _local_9);
                            };
                        };
                    };
                };
            };
            this.mPanel.resourceIcon.visible = true;
            this.SetAmount(null);
        }

        private function TransferOrWithdrawResources(_arg_1:Event):void
        {
            var _local_3:dGuildBankWithdrawVO;
            var _local_4:dGuildBankTransferVO;
            var _local_2:dBuffVO = new dBuffVO();
            if (this.mSelectedResourceVO != null)
            {
                _local_2.amount = this.mSelectedResourceVO.amount;
                if (this.mPanel.currentState == "withdraw")
                {
                    _local_2.buffName_string = defines.WITHDRAW_TEMP_BUFF;
                }
                else
                {
                    _local_2.buffName_string = defines.TRANSFER_TEMP_BUFF;
                };
                _local_2.resourceName_string = this.mSelectedResourceVO.name_string;
            }
            else
            {
                if (this.mSelectedBuffVO != null)
                {
                    _local_2 = this.mSelectedBuffVO;
                };
            };
            if (this.mPanel.currentState == "withdraw")
            {
                _local_3 = new dGuildBankWithdrawVO();
                _local_3.buff = _local_2;
                _local_3.tabId = globalFlash.gui.mGuildBankWindow.GetCurrentTabId();
                this.mGI.mClientMessages.SendMessagetoServer(COMMAND.GUILD_BANK_WITHDRAW, this.mGI.mCurrentViewedZoneID, _local_3);
            }
            else
            {
                _local_4 = new dGuildBankTransferVO();
                _local_4.buff = _local_2;
                _local_4.tabId = globalFlash.gui.mGuildBankWindow.GetCurrentTabId();
                _local_4.targetTabId = (this.mPanel.guildTabsGrid.selectedItem as cGuildBankTab).id;
                this.mGI.mClientMessages.SendMessagetoServer(COMMAND.GUILD_BANK_TRANSFER, this.mGI.mCurrentViewedZoneID, _local_4);
            };
            Hide();
            globalFlash.gui.mGuildBankWindow.Show();
            globalFlash.gui.mGuildBankWindow.SetBusy(true);
        }

        public function Init(_arg_1:GuildTransferResourcePanel):void
        {
            this.mGI = (global.ui as cGameInterface);
            AddBaseElement(_arg_1);
            this.mPanel = _arg_1;
            this.mPanel.addEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
        }

        private function completeHandler(_arg_1:FlexEvent):void
        {
            this.mPanel.removeEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
            this.mPanel.btnClose.addEventListener(MouseEvent.CLICK, this.ClosePanel);
            this.mPanel.btnCancel.addEventListener(MouseEvent.CLICK, this.ClosePanel);
            this.mPanel.btnOK.addEventListener(MouseEvent.CLICK, this.TransferOrWithdrawResources);
            this.mPanel.amountSlider.addEventListener(SliderEvent.CHANGE, this.SetAmount);
            this.mPanel.selectedCount.addEventListener(Event.CHANGE, this.ChangeResourceInputAmount);
            this.mPanel.label = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "TransferResource");
            this.mPanel.guildTabsGrid.addEventListener(ListEvent.CHANGE, this.EnableOkButton);
        }

        private function ClosePanel(_arg_1:Event):void
        {
            this.mSelectedBuffVO = null;
            this.mSelectedResourceVO = null;
            this.Hide();
            globalFlash.gui.mGuildBankWindow.Show();
        }

        private function EnableOkButton(_arg_1:Event):void
        {
            this.mPanel.btnOK.enabled = true;
        }

        private function SetAmount(_arg_1:SliderEvent):void
        {
            if (this.mSelectedResourceVO)
            {
                this.mSelectedResourceVO.amount = this.mPanel.amountSlider.value;
            };
            this.mPanel.selectedCount.text = this.mPanel.amountSlider.value.toString();
            this.mPanel.maximumCount.text = (" / " + this.mPanel.amountSlider.maximum);
            this.mPanel.selectedCount.maxChars = String(this.mPanel.amountSlider.maximum).length;
            this.mPanel.selectedCount.width = (12 + (8 * (String(this.mPanel.amountSlider.maximum).length - 1)));
        }

        override public function Show():void
        {
            super.Show();
            globalFlash.gui.windowController.setTop(this.mPanel, true);
        }


    }
}
